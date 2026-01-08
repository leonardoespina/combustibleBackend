const { sequelize } = require("../config/database");
const MedicionTanque = require("../models/MedicionTanque");
const Tanque = require("../models/Tanque");
const Usuario = require("../models/Usuario");
const { paginate } = require("../helpers/paginationHelper");
const { calcularVolumenTanque } = require("../helpers/formula");

// =====================================================================
// 1. REGISTRAR MEDICIÓN (Admin, Inspector, Supervisor)
// =====================================================================
exports.registrarMedicion = async (req, res) => {
  // 1. Validar Permisos
  console.log("=== DEBUG: Body recibido ===");
  console.log(JSON.stringify(req.body, null, 2));
  console.log("===========================");

  const rol = req.usuario.tipo_usuario;
  if (!["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(rol)) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const {
    id_tanque,
    fecha,
    hora,
    medida_vara,
    litros_manuales_ingresados, // Nuevo campo para medición manual
    litros_evaporacion,
    observacion,
    // Nuevos campos para edición manual
    es_edicion_manual,
    litros_real,
    litros_diferencia,
  } = req.body;

  const t = await sequelize.transaction();

  try {
    // 2. Obtener Tanque y determinar el modo de medición
    const tanque = await Tanque.findByPk(id_tanque, { transaction: t });
    if (!tanque) throw new Error("Tanque no encontrado.");

    let litrosReales;
    let tipoMedicion;
    let diferenciaNetaManual = null; // Para guardar la diferencia manual si existe
    const datosMedicion = {}; // Objeto para guardar los datos específicos

    // 3. Lógica Condicional: AFORO vs. MANUAL vs. EDICIÓN FORZADA

    // Verificar si es edición manual forzada desde el frontend
    const flagEdicionManual =
      es_edicion_manual === true || es_edicion_manual === "true";

    if (flagEdicionManual) {
      // ===== MODO SOBRESCRITURA MANUAL =====
      // El usuario editó manualmente los valores en el frontend.
      // Ignoramos aforos y fórmulas y confiamos en los valores enviados.
      tipoMedicion = "MANUAL"; // Se registra como manual porque fue editado a mano

      // Validación básica
      if (litros_real === undefined || litros_real === null) {
        throw new Error(
          "Se indicó edición manual pero falta el valor de Litros Reales."
        );
      }

      litrosReales = parseFloat(litros_real);
      if (isNaN(litrosReales)) throw new Error("Litros Reales inválidos.");

      datosMedicion.litros_manuales_ingresados = litrosReales; // Se guarda como manual
      datosMedicion.litros_reales_aforo = litrosReales; // También en aforo para consistencia en reportes

      // Si viene medida de vara, la guardamos como referencia histórica
      if (
        medida_vara !== undefined &&
        medida_vara !== null &&
        medida_vara !== ""
      ) {
        const mv = parseFloat(medida_vara);
        if (!isNaN(mv)) datosMedicion.medida_vara = mv;
      }

      // Si viene diferencia manual, la guardamos para usarla después
      if (litros_diferencia !== undefined && litros_diferencia !== null) {
        diferenciaNetaManual = parseFloat(litros_diferencia);
      }
    } else {
      // ===== MODOS AUTOMÁTICOS (AFORO / FÓRMULA / MANUAL ESTÁNDAR) =====
      let aforo = tanque.tabla_aforo;
      if (typeof aforo === "string") {
        try {
          aforo = JSON.parse(aforo);
        } catch (e) {
          aforo = null; // Si está corrupta, se trata como si no existiera
        }
      }

      if (aforo && typeof aforo === "object" && Object.keys(aforo).length > 0) {
        // --- MODO AFORO ---
        tipoMedicion = "AFORO";
        const medidaVaraNum = parseFloat(medida_vara);
        if (isNaN(medidaVaraNum)) {
          throw new Error(
            "El valor para 'medida_vara' es inválido o no fue proporcionado."
          );
        }

        const keyMedida = medida_vara.toString();
        const volumenTabla = aforo[keyMedida];

        if (volumenTabla === undefined) {
          throw new Error(
            `La medida ${medida_vara} no existe en la tabla de aforo.`
          );
        }
        litrosReales = parseFloat(volumenTabla);
        datosMedicion.medida_vara = parseFloat(medida_vara);
        datosMedicion.litros_reales_aforo = litrosReales;
      } else if (
        (tanque.tipo_tanque === "RECTANGULAR" ||
          tanque.tipo_tanque === "CUADRADO") &&
        tanque.largo > 0 &&
        tanque.ancho > 0 &&
        tanque.alto > 0
      ) {
        // --- MODO FORMULA RECTANGULAR ---
        tipoMedicion = "AFORO";
        const medidaVaraNum = parseFloat(medida_vara);
        if (isNaN(medidaVaraNum)) {
          throw new Error("Medida de vara inválida para cálculo rectangular.");
        }

        let h_m =
          tanque.unidad_medida === "PULGADAS"
            ? medidaVaraNum * 0.0254
            : medidaVaraNum / 100;

        const litrosCalculados = calcularVolumenTanque(
          h_m,
          parseFloat(tanque.largo),
          parseFloat(tanque.ancho),
          tanque.tipo_tanque,
          parseFloat(tanque.alto)
        );
        litrosReales = parseFloat(litrosCalculados.toFixed(2));

        datosMedicion.medida_vara = medidaVaraNum;
        datosMedicion.litros_reales_aforo = litrosReales;
      } else if (
        tanque.largo &&
        tanque.radio &&
        parseFloat(tanque.largo) > 0 &&
        parseFloat(tanque.radio) > 0
      ) {
        // --- MODO FORMULA CILINDRICA ---
        tipoMedicion = "AFORO";
        const medidaVaraNum = parseFloat(medida_vara);
        if (isNaN(medidaVaraNum)) {
          throw new Error("Medida de vara inválida para cálculo cilíndrico.");
        }

        let h_m =
          tanque.unidad_medida === "PULGADAS"
            ? medidaVaraNum * 0.0254
            : medidaVaraNum / 100;

        const litrosCalculados = calcularVolumenTanque(
          h_m,
          parseFloat(tanque.largo),
          parseFloat(tanque.radio),
          "CILINDRICO"
        );
        litrosReales = parseFloat(litrosCalculados.toFixed(2));

        datosMedicion.medida_vara = medidaVaraNum;
        datosMedicion.litros_reales_aforo = litrosReales;
      } else {
        // --- MODO MANUAL (SIN TABLA) ---
        tipoMedicion = "MANUAL";
        const litrosManualesNum = parseFloat(litros_manuales_ingresados);
        if (isNaN(litrosManualesNum)) {
          throw new Error(
            "El valor para 'litros_manuales_ingresados' es inválido o no fue proporcionado."
          );
        }

        litrosReales = litrosManualesNum;
        datosMedicion.litros_manuales_ingresados = litrosReales;

        // También guardar litros_reales_aforo para mantener consistencia en reportes
        datosMedicion.litros_reales_aforo = litrosReales;

        // Si se proporcionó medida_vara, también la guardamos como referencia
        if (
          medida_vara !== undefined &&
          medida_vara !== null &&
          medida_vara !== ""
        ) {
          const medidaVaraNum = parseFloat(medida_vara);
          if (!isNaN(medidaVaraNum)) {
            datosMedicion.medida_vara = medidaVaraNum;
          }
        }
      }
    }

    // 4. Cálculos Matemáticos Unificados
    const nivelSistema = parseFloat(tanque.nivel_actual); // LA TEORÍA
    const evaporacion = parseFloat(litros_evaporacion || 0);

    // Determinar la Diferencia Final
    let diferenciaFinal;

    if (
      flagEdicionManual &&
      diferenciaNetaManual !== null &&
      !isNaN(diferenciaNetaManual)
    ) {
      // Si la diferencia fue editada manualmente, la usamos directamente
      diferenciaFinal = diferenciaNetaManual;
    } else {
      // Si no, la calculamos: Diferencia = Esperado - Realidad
      // Inventario Esperado = Lo que tenía - Lo que se evaporó legalmente
      const inventarioEsperado = nivelSistema - evaporacion;
      diferenciaFinal = inventarioEsperado - litrosReales;
    }

    // 5. Construir Fecha/Hora
    const fechaHoraMedicion = new Date(`${fecha}T${hora}:00`);
    if (isNaN(fechaHoraMedicion.getTime()))
      throw new Error("Fecha u hora inválida.");

    // 6. Actualizar Tanque
    // Actualizamos el nivel_actual con la medición física (Vara)
    // Esto aplica tanto para GASOLINA (para registrar evaporación) como para GASOIL.
    const updatePayload = {
      fecha_modificacion: new Date(),
      nivel_actual: litrosReales,
    };

    await tanque.update(updatePayload, { transaction: t });

    // 7. Guardar Registro Histórico
    const nuevaMedicion = await MedicionTanque.create(
      {
        id_tanque,
        id_usuario: req.usuario.id_usuario,
        fecha_hora_medicion: fechaHoraMedicion,
        tipo_medicion: tipoMedicion,

        nivel_sistema_anterior: parseFloat(nivelSistema),

        // Usamos el objeto dinámico para llenar los campos correspondientes
        ...datosMedicion,

        litros_evaporacion: parseFloat(evaporacion),
        diferencia_neta: parseFloat(diferenciaFinal), // Aseguramos que sea un número

        observacion,
        estado: "PROCESADO",
      },
      { transaction: t }
    );

    await t.commit();

    res.status(201).json({
      msg: "Medición registrada exitosamente.",
      medicion: nuevaMedicion,
      resumen: {
        sistema_previo: nivelSistema,
        medida_vara: medida_vara,
        litros_reales: litrosReales,
        ajuste_aplicado: diferenciaFinal,
      },
    });
  } catch (error) {
    await t.rollback();
    console.error(error);
    res
      .status(400)
      .json({ msg: error.message || "Error al registrar medición" });
  }
};

// =====================================================================
// 2. CONSULTAR MEDICIONES (Todos los roles operativos)
// =====================================================================
exports.obtenerMediciones = async (req, res) => {
  const rol = req.usuario.tipo_usuario;
  if (!["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(rol)) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  try {
    // Filtros opcionales por query string pueden manejarse aquí si es necesario
    const result = await paginate(MedicionTanque, req.query, {
      order: [["fecha_hora_medicion", "DESC"]],
      include: [
        { model: Tanque, attributes: ["codigo", "nombre", "unidad_medida"] },
        { model: Usuario, attributes: ["nombre", "apellido", "tipo_usuario"] },
      ],
    });
    res.json(result);
  } catch (error) {
    res.status(500).json({ msg: "Error al obtener historial de mediciones" });
  }
};

// =====================================================================
// 3. ANULAR MEDICIÓN (Solo Administrador)
// =====================================================================
exports.anularMedicion = async (req, res) => {
  // Validación estricta de rol
  if (req.usuario.tipo_usuario !== "ADMIN") {
    return res
      .status(403)
      .json({ msg: "Solo Administradores pueden anular mediciones." });
  }

  const { id } = req.params;
  const t = await sequelize.transaction();

  try {
    const medicion = await MedicionTanque.findByPk(id, { transaction: t });
    if (!medicion) throw new Error("Medición no encontrada.");
    if (medicion.estado === "ANULADO") throw new Error("Ya está anulada.");

    // VALIDACIÓN CRÍTICA:
    // Solo se puede anular la ÚLTIMA medición activa de ese tanque.
    // Si anulamos una medición vieja, descuadramos todos los cálculos posteriores.
    const ultimaMedicion = await MedicionTanque.findOne({
      where: { id_tanque: medicion.id_tanque, estado: "PROCESADO" },
      order: [["fecha_hora_medicion", "DESC"]],
      transaction: t,
    });

    if (ultimaMedicion && ultimaMedicion.id_medicion !== medicion.id_medicion) {
      throw new Error(
        "Solo se puede anular la última medición registrada para este tanque. Existen mediciones posteriores."
      );
    }

    // Revertir Tanque
    // El tanque vuelve a tener lo que tenía ANTES de meter la vara (Snapshot guardado)
    const tanque = await Tanque.findByPk(medicion.id_tanque, {
      transaction: t,
    });

    await tanque.update(
      { nivel_actual: medicion.nivel_sistema_anterior },
      { transaction: t }
    );

    // Marcar como anulado
    medicion.estado = "ANULADO";
    medicion.observacion =
      (medicion.observacion || "") + " [ANULADO POR ADMIN]";
    await medicion.save({ transaction: t });

    await t.commit();
    res.json({
      msg: "Medición anulada e inventario revertido al estado anterior.",
    });
  } catch (error) {
    await t.rollback();
    res.status(400).json({ msg: error.message });
  }
};
