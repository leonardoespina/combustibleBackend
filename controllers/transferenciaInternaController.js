const { sequelize } = require("../config/database");
const TransferenciaInterna = require("../models/TransferenciaInterna");
const Tanque = require("../models/Tanque");
const Almacenista = require("../models/Almacenista");
const Usuario = require("../models/Usuario");
const MedicionTanque = require("../models/MedicionTanque");
const { paginate } = require("../helpers/paginationHelper");

// =====================================================================
// CREAR TRANSFERENCIA INTERNA (Solo ADMIN)
// =====================================================================
exports.crearTransferencia = async (req, res) => {
  // 1. Validar Permisos
  if (
    req.usuario.tipo_usuario !== "ADMIN" ||
    req.usuario.tipo_usuario === "INSPECTOR" ||
    req.usuario.tipo_usuario === "SUPERVISOR"
  ) {
    return res
      .status(403)
      .json({ msg: "Acceso denegado. Solo administradores." });
  }

  const {
    id_tanque_origen,
    id_tanque_destino,
    id_almacenista,
    fecha,
    hora,
    medida_vara_destino,
    litros_destino_manual,
    observacion,
    litros_editados_manualmente,
  } = req.body;

  const t = await sequelize.transaction();

  try {
    // 2. Validar Datos Básicos
    if (!id_tanque_origen || !id_tanque_destino || !id_almacenista) {
      throw new Error("Faltan datos obligatorios (tanques, almacenista).");
    }

    if (id_tanque_origen === id_tanque_destino) {
      throw new Error("El tanque origen y destino deben ser diferentes.");
    }

    // 3. Obtener Entidades
    const tanqueOrigen = await Tanque.findByPk(id_tanque_origen, {
      transaction: t,
    });
    const tanqueDestino = await Tanque.findByPk(id_tanque_destino, {
      transaction: t,
    });
    const almacenista = await Almacenista.findByPk(id_almacenista);

    if (!tanqueOrigen || !tanqueDestino) {
      throw new Error("Uno o ambos tanques no existen.");
    }
    if (!almacenista) {
      throw new Error("El almacenista no existe.");
    }

    // 4. Validar Tipo de Combustible
    if (tanqueOrigen.tipo_combustible !== tanqueDestino.tipo_combustible) {
      throw new Error(
        `Tipos de combustible incompatibles: ${tanqueOrigen.tipo_combustible} vs ${tanqueDestino.tipo_combustible}`
      );
    }

    // 5. Determinar Litros Finales Destino (Cálculo)
    // Lógica similar a CargaCisterna
    let aforoDestino = tanqueDestino.tabla_aforo;
    if (typeof aforoDestino === "string") {
      try {
        aforoDestino = JSON.parse(aforoDestino);
      } catch (e) {
        aforoDestino = null;
      }
    }
    const tieneAforo =
      aforoDestino &&
      typeof aforoDestino === "object" &&
      Object.keys(aforoDestino).length > 0;

    let l_destino_final;
    let vara_destino = parseFloat(medida_vara_destino);

    // Permitir vara opcional si es edición manual pura (aunque usualmente se pide vara para registro)
    if (!isNaN(vara_destino)) {
      // OK
    } else if (
      litros_editados_manualmente === true ||
      litros_editados_manualmente === "true"
    ) {
      // Si es manual, la vara podría ser null si el usuario así lo quiere, pero mantendremos la validación básica
      // o permitiremos que sea null si solo importan los litros.
      // Pero para mantener consistencia con CargaCisterna:
      vara_destino = null;
    } else {
      throw new Error("La medida de vara debe ser un número válido.");
    }

    // Verificar si se forzó la edición manual
    const esEdicionManual =
      litros_editados_manualmente === true ||
      litros_editados_manualmente === "true";

    if (esEdicionManual) {
      // ===== MODO SOBRESCRITURA MANUAL =====
      if (
        litros_destino_manual === undefined ||
        litros_destino_manual === null
      ) {
        throw new Error(
          "Se indicó edición manual pero faltan los litros finales manuales."
        );
      }
      l_destino_final = parseFloat(litros_destino_manual);

      if (isNaN(l_destino_final)) {
        throw new Error("Los litros manuales deben ser un número válido.");
      }

      // La vara ya se parseó arriba, si venía.
    } else if (tieneAforo) {
      // ===== MODO AFORO =====
      if (isNaN(vara_destino)) {
        throw new Error(
          "Para cálculo por aforo se requiere una medida de vara válida."
        );
      }
      const keyVara = vara_destino.toString();
      const vol = aforoDestino[keyVara];

      if (vol === undefined) {
        throw new Error(
          `La medida de vara ${vara_destino} no existe en la tabla de aforo del tanque destino.`
        );
      }
      l_destino_final = parseFloat(vol);
    } else {
      // ===== MODO MANUAL (Sin tabla aforo) =====
      if (
        litros_destino_manual === undefined ||
        litros_destino_manual === null
      ) {
        throw new Error(
          "Para tanques sin tabla de aforo (Manual), debe ingresar los litros finales calculados."
        );
      }
      l_destino_final = parseFloat(litros_destino_manual);
      if (isNaN(l_destino_final)) {
        throw new Error("Los litros manuales deben ser un número válido.");
      }
    }

    // 6. Calcular Litros Transferidos
    const litros_origen_antes = parseFloat(tanqueOrigen.nivel_actual);
    const litros_destino_antes = parseFloat(tanqueDestino.nivel_actual);

    // Validar coherencia: El nivel final debe ser mayor al inicial en el destino (asumiendo que se transfiere HACIA el destino)
    if (l_destino_final <= litros_destino_antes) {
      throw new Error(
        `El nivel final del tanque destino (${l_destino_final}) debe ser mayor al nivel actual (${litros_destino_antes}).`
      );
    }

    const litros_transferidos = l_destino_final - litros_destino_antes;

    // 7. Validar Disponibilidad en Origen
    if (litros_origen_antes < litros_transferidos) {
      throw new Error(
        `El tanque origen no tiene suficiente combustible. Disponible: ${litros_origen_antes}, Requerido: ${litros_transferidos}`
      );
    }

    const litros_origen_despues = litros_origen_antes - litros_transferidos;

    // 8. Actualizar Tanques
    // Origen
    await tanqueOrigen.update(
      {
        nivel_actual: litros_origen_despues,
        fecha_modificacion: new Date(),
      },
      { transaction: t }
    );

    // Destino
    await tanqueDestino.update(
      {
        nivel_actual: l_destino_final,
        fecha_modificacion: new Date(),
      },
      { transaction: t }
    );

    // 9. Crear Registro de Transferencia
    const fechaHora = new Date(`${fecha}T${hora}:00`);

    const nuevaTransferencia = await TransferenciaInterna.create(
      {
        id_tanque_origen,
        id_tanque_destino,
        id_almacenista,
        id_usuario: req.usuario.id_usuario,
        hora_inicio: fechaHora,
        litros_antes_origen: litros_origen_antes,
        litros_despues_destino: l_destino_final,
        litros_transferidos: litros_transferidos,
        medida_vara_destino: vara_destino,
        observacion,
      },
      { transaction: t }
    );

    // 10. Generar Medición Automática para Tanque Destino
    // "Al completar la transferencia, el sistema debe generar automáticamente una nueva medición del tanque destino"
    await MedicionTanque.create(
      {
        id_tanque: id_tanque_destino,
        id_usuario: req.usuario.id_usuario,
        fecha_hora_medicion: fechaHora, // Usamos la misma hora de la transferencia
        tipo_medicion: tieneAforo ? "AFORO" : "MANUAL",
        nivel_sistema_anterior: litros_destino_antes,

        // Estado FINAL
        medida_vara: vara_destino,
        litros_reales_aforo: l_destino_final,
        litros_manuales_ingresados: !tieneAforo ? l_destino_final : null,

        litros_evaporacion: 0,
        diferencia_neta: 0, // En transferencia interna asumimos que cuadra por definición de la operación, o podríamos poner el delta.
        // En CargaCisterna la diferencia_neta era vs Guía o vs Sistema anterior.
        // Aquí, al ser una "medición post transferencia", la diferencia con el sistema anterior ES la transferencia.
        // Pero normalmente diferencia_neta en mediciones se usa para ajustes de inventario (pérdidas/ganancias).
        // Si ponemos diferencia_neta = litros_transferidos, parecería una ganancia "inexplicable" si no se asocia al contexto.
        // Sin embargo, la medición actualiza el stock físico.
        // Dejaremos 0 y explicaremos en observación.

        observacion: `Medición Automática por Transferencia Interna #${
          nuevaTransferencia.id_transferencia
        } desde ${
          tanqueOrigen.nombre
        }. Transferidos: ${litros_transferidos.toFixed(2)} L. ${
          observacion || ""
        }`,
        estado: "PROCESADO",
      },
      { transaction: t }
    );

    // Opcional: ¿Deberíamos generar medición para el tanque origen también?
    // El requerimiento solo menciona explícitamente "Generación Automática de Medición: Al completar la transferencia... tanque destino".
    // Pero para mantener la coherencia del inventario, sería ideal registrar la bajada en el origen también.
    // Sin embargo, me ceñiré estrictamente a lo pedido para no complicar: "del tanque destino".
    // El tanque origen se actualizó vía `update`, pero no tendrá registro en `mediciones_tanques`.
    // Esto podría causar saltos en gráficas de historial de mediciones, pero es lo solicitado.

    await t.commit();

    res.status(201).json({
      msg: "Transferencia interna registrada exitosamente.",
      transferencia: nuevaTransferencia,
    });
  } catch (error) {
    await t.rollback();
    console.error(error);
    res
      .status(400)
      .json({ msg: error.message || "Error al registrar transferencia." });
  }
};

// =====================================================================
// OBTENER TRANSFERENCIAS (Solo ADMIN)
// =====================================================================
exports.obtenerTransferencias = async (req, res) => {
  if (
    req.usuario.tipo_usuario !== "ADMIN" &&
    req.usuario.tipo_usuario !== "INSPECTOR" && // Aunque dice "Excluidos", a veces para reportes se abren. Pero el prompt dice: "Solo los usuarios con tipo ADMIN pueden crear y consultar".
    req.usuario.tipo_usuario !== "SUPERVISOR"
  ) {
    // Re-leemos: "Solo los usuarios con tipo 'ADMIN' pueden crear y consultar ... INSPECTOR y SUPERVISOR están excluidos"
    // Entonces:
    if (req.usuario.tipo_usuario !== "ADMIN") {
      return res
        .status(403)
        .json({ msg: "Acceso denegado. Solo administradores." });
    }
  } else {
    // Si entra aquí es ADMIN, INSPECTOR o SUPERVISOR, pero el if de arriba ya filtra si no es ADMIN en el bloque estricto.
    // Simplificación:
    if (req.usuario.tipo_usuario !== "ADMIN") {
      return res
        .status(403)
        .json({ msg: "Acceso denegado. Solo administradores." });
    }
  }

  try {
    const result = await paginate(TransferenciaInterna, req.query, {
      order: [["hora_inicio", "DESC"]],
      include: [
        { model: Tanque, as: "TanqueOrigen", attributes: ["codigo", "nombre"] },
        {
          model: Tanque,
          as: "TanqueDestino",
          attributes: ["codigo", "nombre"],
        },
        { model: Almacenista, attributes: ["nombre", "apellido"] },
        { model: Usuario, attributes: ["nombre", "apellido"] },
      ],
    });
    res.json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al obtener transferencias." });
  }
};
