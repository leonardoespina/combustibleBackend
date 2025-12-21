const { sequelize } = require("../config/database");
const CargaCisterna = require("../models/CargaCisterna");
const MedicionTanque = require("../models/MedicionTanque");
const Tanque = require("../models/Tanque");
const Vehiculo = require("../models/Vehiculo");
const Almacenista = require("../models/Almacenista");
const Usuario = require("../models/Usuario");
const { paginate } = require("../helpers/paginationHelper");

// =====================================================================
// 1. CREAR CARGA (INSPECTOR y ADMIN)
// =====================================================================
exports.crearCargaCisterna = async (req, res) => {
  if (
    req.usuario.tipo_usuario !== "ADMIN" &&
    req.usuario.tipo_usuario !== "INSPECTOR" &&
    req.usuario.tipo_usuario !== "SUPERVISOR"
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const {
    numero_guia,
    id_vehiculo,
    id_chofer,
    fecha,
    hora,
    fecha_emision,
    fecha_recepcion,
    id_tanque,
    id_almacenista,
    medida_inicial,
    medida_final,
    litros_segun_guia,
    litros_flujometro,
    // Nuevos campos de pesaje
    peso_entrada,
    peso_salida,
    // Nuevos campos de tiempo
    hora_inicio_descarga,
    hora_fin_descarga,
    observacion,
    // Flag de edición manual
    litros_editados_manualmente,
    litros_iniciales,
    litros_finales,
  } = req.body;

  const t = await sequelize.transaction();

  try {
    // Variables para almacenar medidas de vara (usadas en ambos modos)
    let medida_vara_inicial = null;
    let medida_vara_final = null;

    // 1. Validar Guía
    const guiaExiste = await CargaCisterna.findOne({ where: { numero_guia } });
    if (guiaExiste) {
      await t.rollback();
      return res.status(400).json({ msg: "El número de guía ya existe." });
    }

    // 2. Validar Entidades
    const vehiculo = await Vehiculo.findByPk(id_vehiculo);
    const almacenista = await Almacenista.findByPk(id_almacenista);
    const tanque = await Tanque.findByPk(id_tanque, { transaction: t });

    if (!vehiculo || !almacenista || !tanque)
      throw new Error("Datos de vehículo, tanque o almacenista inválidos.");

    // 3. Determinar modo: AFORO o MANUAL
    let aforo = tanque.tabla_aforo;
    if (typeof aforo === "string") {
      try {
        aforo = JSON.parse(aforo);
      } catch (e) {
        aforo = null;
      }
    }

    const tieneAforo =
      aforo && typeof aforo === "object" && Object.keys(aforo).length > 0;

    let l_inicial, l_final, l_recibidos_real;

    // Verificar si se forzó la edición manual de litros desde el frontend
    const esEdicionManual =
      litros_editados_manualmente === true ||
      litros_editados_manualmente === "true";

    if (esEdicionManual) {
      // ===== MODO SOBRESCRITURA MANUAL =====
      // El usuario editó manualmente los litros, ignoramos la tabla de aforo para el cálculo

      if (litros_iniciales === undefined || litros_finales === undefined) {
        throw new Error(
          "Se indicó edición manual pero faltan los valores de litros."
        );
      }

      l_inicial = parseFloat(litros_iniciales);
      l_final = parseFloat(litros_finales);

      if (isNaN(l_inicial) || isNaN(l_final)) {
        throw new Error(
          "Los litros ingresados manualmente deben ser valores numéricos válidos."
        );
      }

      // Guardamos la medida de vara solo como referencia
      if (medida_inicial !== undefined && medida_inicial !== null) {
        medida_vara_inicial = parseFloat(medida_inicial);
      }
      if (medida_final !== undefined && medida_final !== null) {
        medida_vara_final = parseFloat(medida_final);
      }

      if (l_final <= l_inicial)
        throw new Error("El valor final debe ser mayor al inicial.");

      l_recibidos_real = l_final - l_inicial;
    } else if (tieneAforo) {
      // ===== MODO AFORO (Con tabla de aforo) =====
      const keyInicio = medida_inicial.toString();
      const keyFinal = medida_final.toString();

      const volInicio = aforo[keyInicio];
      const volFinal = aforo[keyFinal];

      if (volInicio === undefined) {
        throw new Error(
          `Medida inicial ${medida_inicial} no existe en la tabla de aforo.`
        );
      }
      if (volFinal === undefined) {
        throw new Error(
          `Medida final ${medida_final} no existe en la tabla de aforo.`
        );
      }

      l_inicial = parseFloat(volInicio);
      l_final = parseFloat(volFinal);

      if (l_final <= l_inicial)
        throw new Error("La medida final debe ser mayor a la inicial.");

      l_recibidos_real = l_final - l_inicial;

      // Guardar medidas de vara para el registro
      medida_vara_inicial = parseFloat(medida_inicial);
      medida_vara_final = parseFloat(medida_final);
    } else {
      // ===== MODO MANUAL (Sin tabla de aforo) =====
      // El usuario ingresa medidas de vara + litros calculados manualmente

      if (!medida_inicial || !medida_final) {
        throw new Error("Debe ingresar las medidas de vara inicial y final.");
      }

      // Validar y almacenar medidas de vara
      medida_vara_inicial = parseFloat(medida_inicial);
      medida_vara_final = parseFloat(medida_final);

      if (isNaN(medida_vara_inicial) || isNaN(medida_vara_final)) {
        throw new Error(
          "Las medidas de vara deben ser valores numéricos válidos."
        );
      }

      // Obtener litros (calculados por el frontend o ingresados directamente)
      if (req.body.litros_iniciales && req.body.litros_finales) {
        // CASO 1: El frontend envía vara + litros calculados
        l_inicial = parseFloat(req.body.litros_iniciales);
        l_final = parseFloat(req.body.litros_finales);

        if (isNaN(l_inicial) || isNaN(l_final)) {
          throw new Error(
            "Los litros calculados deben ser valores numéricos válidos."
          );
        }
      } else {
        // CASO 2: Modo manual tradicional (litros = medidas de vara)
        l_inicial = medida_vara_inicial;
        l_final = medida_vara_final;
      }

      if (l_final <= l_inicial)
        throw new Error("El valor final debe ser mayor al inicial.");

      l_recibidos_real = l_final - l_inicial;
    }

    // 4. CÁLCULOS DE COMPARACIÓN (Mismo para ambos modos)
    const l_guia = parseFloat(litros_segun_guia);
    const l_faltantes = l_guia - l_recibidos_real;

    // Flujómetro (opcional)
    let l_flujometro = null;
    let dif_vara_flu = null;

    if (
      litros_flujometro !== undefined &&
      litros_flujometro !== null &&
      litros_flujometro !== ""
    ) {
      l_flujometro = parseFloat(litros_flujometro);
      dif_vara_flu = l_recibidos_real - l_flujometro;
    }

    // 5. CÁLCULOS DE NUEVOS CAMPOS
    let pesoNeto = null;
    if (peso_entrada && peso_salida) {
      pesoNeto = parseFloat(peso_entrada) - parseFloat(peso_salida);
    }

    let tiempoDescargaMinutos = null;
    if (hora_inicio_descarga && hora_fin_descarga) {
      const [hIni, mIni] = hora_inicio_descarga.split(":").map(Number);
      const [hFin, mFin] = hora_fin_descarga.split(":").map(Number);
      const minIni = hIni * 60 + mIni;
      const minFin = hFin * 60 + mFin;
      tiempoDescargaMinutos = minFin - minIni;
    }

    // =====================================================================
    // 6. CALCULAR DIFERENCIA NETA SEGÚN MODO
    // =====================================================================
    const nivelSistemaPreCarga = parseFloat(tanque.nivel_actual);

    let diferenciaNeta;

    if (tieneAforo) {
      // ✅ MODO AFORO: Diferencia = Consumo de Planta
      // Comparamos el nivel del sistema ANTES de la carga con la medición física INICIAL
      const litrosFisicosPreCarga = l_inicial;
      diferenciaNeta = nivelSistemaPreCarga - litrosFisicosPreCarga;
    } else {
      // ✅ MODO MANUAL: Diferencia = Litros Faltantes según Guía
      // Es la diferencia entre lo que dice la guía y lo que realmente se recibió
      diferenciaNeta = l_faltantes;
    }

    // =====================================================================
    // 7. GENERAR MEDICIÓN AUTOMÁTICA (POST-CARGA)
    // =====================================================================
    // Registra el ESTADO FINAL del tanque después de recibir la carga
    const fechaHoraMedicionAuto = new Date(`${fecha}T${hora}:00`);

    await MedicionTanque.create(
      {
        id_tanque,
        id_usuario: req.usuario.id_usuario,
        fecha_hora_medicion: fechaHoraMedicionAuto,
        tipo_medicion: tieneAforo ? "AFORO" : "MANUAL",

        nivel_sistema_anterior: nivelSistemaPreCarga,

        // ✅ Registrar estado FINAL del tanque
        medida_vara: medida_vara_final, // Medida FINAL en cm
        litros_reales_aforo: l_final, // Litros FINALES del tanque
        litros_manuales_ingresados: !tieneAforo ? l_final : null,

        litros_evaporacion: 0,
        diferencia_neta: diferenciaNeta, // AFORO: consumo planta | MANUAL: faltantes guía

        observacion: tieneAforo
          ? `Medición Automática por Recepción de Cisterna (Guía: ${numero_guia}). Consumo de planta: ${diferenciaNeta.toFixed(
              2
            )} L. Nivel final: ${l_final.toFixed(2)} L. ${observacion || ""}`
          : `Medición Automática por Recepción de Cisterna (Guía: ${numero_guia}). Faltantes en guía: ${diferenciaNeta.toFixed(
              2
            )} L. Nivel final: ${l_final.toFixed(2)} L. ${observacion || ""}`,

        estado: "PROCESADO",
      },
      { transaction: t }
    );

    // 8. ACTUALIZAR TANQUE
    await tanque.update(
      { nivel_actual: l_final, fecha_modificacion: new Date() },
      { transaction: t }
    );

    // 9. Guardar Registro de Carga Cisterna
    const fechaLlegada = new Date(`${fecha}T${hora}:00`);

    const nuevaCarga = await CargaCisterna.create(
      {
        numero_guia,
        id_vehiculo,
        id_chofer,
        fecha_emision,
        fecha_recepcion,
        fecha_hora_llegada: fechaLlegada,
        id_tanque,
        id_almacenista,
        id_usuario: req.usuario.id_usuario,
        tipo_combustible: tanque.tipo_combustible,
        observacion,

        // Datos de medición
        medida_inicial: medida_vara_inicial,
        medida_final: medida_vara_final,
        litros_iniciales: l_inicial,
        litros_finales: l_final,
        litros_recibidos_real: l_recibidos_real,

        // Datos Guía
        litros_segun_guia: l_guia,
        litros_faltantes: l_faltantes,

        // Datos Flujómetro
        litros_flujometro: l_flujometro,
        diferencia_vara_flujometro: dif_vara_flu,

        // Nuevos campos de pesaje
        peso_entrada: peso_entrada ? parseFloat(peso_entrada) : null,
        peso_salida: peso_salida ? parseFloat(peso_salida) : null,
        peso_neto: pesoNeto,

        // Nuevos campos de tiempo
        hora_inicio_descarga,
        hora_fin_descarga,
        tiempo_descarga_minutos: tiempoDescargaMinutos,

        estado: "PROCESADO",
      },
      { transaction: t }
    );

    await t.commit();

    res.status(201).json({
      msg: "Carga registrada exitosamente",
      carga: nuevaCarga,
    });
  } catch (error) {
    await t.rollback();
    console.error(error);
    res.status(400).json({ msg: error.message || "Error al registrar" });
  }
};

// --- OBTENER ---
exports.obtenerCargasCisterna = async (req, res) => {
  if (
    req.usuario.tipo_usuario !== "ADMIN" &&
    req.usuario.tipo_usuario !== "INSPECTOR" &&
    req.usuario.tipo_usuario !== "SUPERVISOR"
  )
    return res.status(403).json({ msg: "Acceso denegado." });
  try {
    const result = await paginate(CargaCisterna, req.query, {
      searchableFields: ["numero_guia"],
      order: [["fecha_hora_llegada", "DESC"]],
      include: [
        { model: Vehiculo, attributes: ["placa"] },
        { model: Tanque, attributes: ["codigo", "nombre"] },
        { model: Almacenista, attributes: ["nombre", "apellido"] },
        { model: Usuario, attributes: ["nombre", "apellido"] },
      ],
    });
    res.json(result);
  } catch (error) {
    res.status(500).json({ msg: "Error al obtener cargas" });
  }
};
// --- OBTENER ---
exports.obtenerCargasCisterna = async (req, res) => {
  if (
    req.usuario.tipo_usuario !== "ADMIN" &&
    req.usuario.tipo_usuario !== "INSPECTOR" &&
    req.usuario.tipo_usuario !== "SUPERVISOR"
  )
    return res.status(403).json({ msg: "Acceso denegado." });
  try {
    const result = await paginate(CargaCisterna, req.query, {
      searchableFields: ["numero_guia"],
      order: [["fecha_hora_llegada", "DESC"]],
      include: [
        { model: Vehiculo, attributes: ["placa"] },
        { model: Tanque, attributes: ["codigo", "nombre"] },
        { model: Almacenista, attributes: ["nombre", "apellido"] },
        { model: Usuario, attributes: ["nombre", "apellido"] },
      ],
    });
    res.json(result);
  } catch (error) {
    res.status(500).json({ msg: "Error al obtener cargas" });
  }
};

// --- ACTUALIZAR (Solo Admin) ---
exports.actualizarCargaCisterna = async (req, res) => {
  if (req.usuario.tipo_usuario !== "ADMIN")
    return res.status(403).json({ msg: "Solo Admin." });
  const { id } = req.params;
  const { numero_guia, fecha, hora, id_almacenista, observacion } = req.body;
  try {
    const carga = await CargaCisterna.findByPk(id);
    if (!carga) return res.status(404).json({ msg: "No encontrada" });
    if (carga.estado === "ANULADO")
      return res.status(400).json({ msg: "Carga anulada." });

    if (numero_guia) carga.numero_guia = numero_guia;
    if (id_almacenista) carga.id_almacenista = id_almacenista;
    if (observacion) carga.observacion = observacion;
    if (fecha && hora)
      carga.fecha_hora_llegada = new Date(`${fecha}T${hora}:00`);

    await carga.save();
    res.json({ msg: "Actualizado", carga });
  } catch (error) {
    res.status(500).json({ msg: "Error al actualizar" });
  }
};

// --- ANULAR (Solo Admin) ---
exports.anularCargaCisterna = async (req, res) => {
  if (req.usuario.tipo_usuario !== "ADMIN")
    return res.status(403).json({ msg: "Solo Admin." });
  const { id } = req.params;
  const t = await sequelize.transaction();
  try {
    const carga = await CargaCisterna.findByPk(id, { transaction: t });
    if (!carga) throw new Error("No encontrada");
    if (carga.estado === "ANULADO") throw new Error("Ya está anulada");

    const tanque = await Tanque.findByPk(carga.id_tanque, { transaction: t });
    if (tanque) {
      const litrosEntraron = parseFloat(carga.litros_recibidos_real);
      const nuevoNivel = parseFloat(tanque.nivel_actual) - litrosEntraron;
      if (nuevoNivel < 0)
        throw new Error("Imposible anular: Combustible ya consumido.");
      await tanque.update({ nivel_actual: nuevoNivel }, { transaction: t });
    }

    carga.estado = "ANULADO";
    carga.observacion = (carga.observacion || "") + " [ANULADO]";
    await carga.save({ transaction: t });

    await t.commit();
    res.json({ msg: "Anulada correctamente" });
  } catch (error) {
    await t.rollback();
    res.status(400).json({ msg: error.message });
  }
};
