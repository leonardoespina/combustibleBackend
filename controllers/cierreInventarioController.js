const { sequelize } = require("../config/database");
const { Op } = require("sequelize");
const { v4: uuidv4 } = require("uuid"); // Asegúrate de tener: npm install uuid
const CierreInventario = require("../models/CierreInventario");
const Tanque = require("../models/Tanque");
const Despacho = require("../models/Despacho");
const CargaCisterna = require("../models/CargaCisterna");
const MedicionTanque = require("../models/MedicionTanque");
const Dispensador = require("../models/Dispensador");
const Vehiculo = require("../models/Vehiculo");
const Usuario = require("../models/Usuario");
const Almacenista = require("../models/Almacenista");

// =====================================================================
// 1. GENERAR ACTA DE CIERRE
// =====================================================================
// =====================================================================
// CARGA CISTERNA - SINCRONIZA CON FÍSICO
// =====================================================================

exports.generarActaDeCierre = async (req, res) => {
  // Solo necesitamos el turno y observación. La fecha es automática (NOW).
  const { turno, observacion_general, fechaCierre, id_almacenista } = req.body;
  // La hora real del servidor es la ley

  if (
    !["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const t = await sequelize.transaction();
  const grupoUUID = uuidv4();

  try {
    // Obtener datos del usuario actual (inspector/supervisor)
    const usuarioActual = await Usuario.findByPk(req.usuario.id_usuario, {
      attributes: ["nombre", "apellido", "cedula"],
    });

    // Obtener datos del almacenista
    const almacenista = await Almacenista.findByPk(id_almacenista, {
      attributes: ["nombre", "apellido", "cedula"],
    });

    if (!almacenista) {
      throw new Error("Almacenista no encontrado.");
    }

    const tanquesActivos = await Tanque.findAll({
      where: { estado: "ACTIVO" },
    });
    if (tanquesActivos.length === 0) throw new Error("No hay tanques activos.");

    const resultadosCierre = [];

    for (const tanque of tanquesActivos) {
      // 1. BUSCAR SALDO INICIAL (Del cierre anterior inmediato)
      const ultimoCierre = await CierreInventario.findOne({
        where: { id_tanque: tanque.id_tanque },
        order: [["id_cierre", "DESC"]], // Usamos ID, es más seguro cronológicamente
      });

      // Si no hay cierre previo, asumimos 0 o el nivel actual si es la primera vez
      const saldoInicial = ultimoCierre
        ? parseFloat(ultimoCierre.saldo_final_real)
        : parseFloat(tanque.nivel_actual);

      // 2. BARRIDO DE MOVIMIENTOS PENDIENTES (id_cierre IS NULL)

      // A. Cargas (Entradas)
      const cargasPendientes = await CargaCisterna.findAll({
        where: {
          id_tanque: tanque.id_tanque,
          estado: "PROCESADO",
          id_cierre: null,
        },
      });
      const totalEntradas = cargasPendientes.reduce(
        (acc, c) => acc + parseFloat(c.litros_recibidos_real),
        0
      );

      // B. Mediciones (Ajustes/Consumo Planta)
      // Importante: Solo tomamos las mediciones PENDIENTES.
      const medicionesPendientes = await MedicionTanque.findAll({
        where: {
          id_tanque: tanque.id_tanque,
          estado: "PROCESADO",
          id_cierre: null,
        },
      });
      // Sumamos las diferencias. (Si es Principal es consumo, si es Auxiliar es ajuste)
      const totalAjustes = medicionesPendientes.reduce(
        (acc, m) => acc + parseFloat(m.diferencia_neta),
        0
      );

      // C. Despachos (Salidas)
      // Buscamos dispensadores asociados actualmente (para retrocompatibilidad con registros viejos)
      const dispensadores = await Dispensador.findAll({
        where: { id_tanque_asociado: tanque.id_tanque },
      });
      const idsDispensadores = dispensadores.map((d) => d.id_dispensador);

      // ESTRATEGIA HÍBRIDA DE BÚSQUEDA:
      // 1. Despachos Nuevos: Tienen id_tanque grabado. Buscamos directo por id_tanque.
      // 2. Despachos Viejos: Tienen id_tanque NULL. Buscamos por id_dispensador (si el dispensador sigue asociado a este tanque).
      const despachosPendientes = await Despacho.findAll({
        where: {
          estado: "PROCESADO",
          id_cierre: null,
          [Op.or]: [
            { id_tanque: tanque.id_tanque }, // Nuevo método: Preciso y a prueba de cambios de dispensador
            {
              // Método Legacy: Solo si id_tanque es NULL y el dispensador coincide
              id_tanque: null,
              id_dispensador:
                idsDispensadores.length > 0
                  ? { [Op.in]: idsDispensadores }
                  : -1, // -1 para que no traiga nada si no hay dispensadores
            },
          ],
        },
        include: [{ model: Vehiculo, attributes: ["es_generador"] }],
      });

      const consumoVehiculosNormales = despachosPendientes
        .filter(
          (d) => d.tipo_destino === "VEHICULO" && !d.Vehiculo.es_generador
        )
        .reduce((acc, d) => acc + parseFloat(d.cantidad_despachada), 0);

      const consumoBidones = despachosPendientes
        .filter((d) => d.tipo_destino === "BIDON")
        .reduce((acc, d) => acc + parseFloat(d.cantidad_despachada), 0);

      // Desglose para el Snapshot JSON
      const consumoGeneradores = despachosPendientes
        .filter((d) => d.tipo_destino === "VEHICULO" && d.Vehiculo.es_generador)
        .reduce((acc, d) => acc + parseFloat(d.cantidad_despachada), 0);

      // Se incluye generadores en el total despachado para sacarlo de la merma/consumo planta
      // Se mantiene una variable 'totalDespachosContable' que incluye generadores
      // para el cálculo de merma, pero 'consumo_despachos_total' para BD no los incluye.
      const totalDespachosContable =
        consumoVehiculosNormales + consumoBidones + consumoGeneradores;

      // 3. CREAR EL REGISTRO DE CIERRE
      const nuevoCierre = await CierreInventario.create(
        {
          grupo_cierre_uuid: grupoUUID,
          tipo_combustible_cierre: tanque.tipo_combustible,
          turno,
          fecha_cierre: fechaCierre,
          id_usuario: req.usuario.id_usuario,
          id_tanque: tanque.id_tanque,

          saldo_inicial_real: saldoInicial,
          total_entradas_cisterna: totalEntradas,
          consumo_planta_merma:
            saldoInicial +
            totalEntradas -
            totalDespachosContable -
            parseFloat(tanque.nivel_actual),
          // consumo_despachos_total ahora solo incluye vehículos normales y bidones, SIN generadores
          consumo_despachos_total: consumoVehiculosNormales + consumoBidones,
          saldo_final_real: parseFloat(tanque.nivel_actual), // Foto actual

          snapshot_desglose_despachos: {
            vehiculos: consumoVehiculosNormales,
            generadores: consumoGeneradores,
            bidones: consumoBidones,
            usuario: {
              nombre: usuarioActual.nombre,
              apellido: usuarioActual.apellido,
              cedula: usuarioActual.cedula,
            },
            almacenista: {
              nombre: almacenista.nombre,
              apellido: almacenista.apellido,
              cedula: almacenista.cedula,
            },
          },
          observacion: observacion_general,
        },
        { transaction: t }
      );

      // 4. EL SELLADO (STAMPING) - Actualizamos los registros con el ID del cierre
      if (cargasPendientes.length > 0) {
        await CargaCisterna.update(
          { id_cierre: nuevoCierre.id_cierre },
          {
            where: {
              id_carga: { [Op.in]: cargasPendientes.map((c) => c.id_carga) },
            },
            transaction: t,
          }
        );
      }
      if (medicionesPendientes.length > 0) {
        await MedicionTanque.update(
          { id_cierre: nuevoCierre.id_cierre },
          {
            where: {
              id_medicion: {
                [Op.in]: medicionesPendientes.map((m) => m.id_medicion),
              },
            },
            transaction: t,
          }
        );
      }
      if (despachosPendientes.length > 0) {
        await Despacho.update(
          { id_cierre: nuevoCierre.id_cierre },
          {
            where: {
              id_despacho: {
                [Op.in]: despachosPendientes.map((d) => d.id_despacho),
              },
            },
            transaction: t,
          }
        );
      }

      resultadosCierre.push(nuevoCierre);
    }

    await t.commit();
    res.status(201).json({
      msg: "Acta de cierre generada correctamente.",
      grupo: grupoUUID,
    });
  } catch (error) {
    await t.rollback();
    console.error(error);
    res.status(500).json({ msg: error.message || "Error al cerrar." });
  }
};
// =====================================================================
// 2. LISTAR HISTORIAL DE ACTAS (Agrupado)
// =====================================================================
exports.obtenerHistorialActas = async (req, res) => {
  try {
    const actas = await CierreInventario.findAll({
      attributes: [
        "grupo_cierre_uuid",
        "fecha_cierre",
        "turno",
        [
          sequelize.fn("COUNT", sequelize.col("id_tanque")),
          "tanques_involucrados",
        ],
      ],
      group: ["grupo_cierre_uuid", "fecha_cierre", "turno"],
      order: [["fecha_cierre", "DESC"]],
    });
    res.json(actas);
  } catch (error) {
    res.status(500).json({ msg: "Error al listar historial." });
  }
};

// =====================================================================
// 3. GENERAR DATOS PARA EL PDF DEL ACTA
// =====================================================================
exports.obtenerDatosParaActaPDF = async (req, res) => {
  const { grupo_uuid } = req.params;

  try {
    const cierresDelGrupo = await CierreInventario.findAll({
      where: { grupo_cierre_uuid: grupo_uuid },
      include: [
        {
          model: Tanque,
          attributes: [
            "nombre",
            "codigo",
            "tipo_combustible",
            "tipo_jerarquia",
          ],
        },
        { model: Usuario, attributes: ["nombre", "apellido"] },
      ],
    });

    if (cierresDelGrupo.length === 0)
      return res.status(404).json({ msg: "Acta no encontrada." });

    const primerRegistro = cierresDelGrupo[0];
    const inspector = primerRegistro.Usuario;

    // =======================================================================
    // ESTRATEGIA DINÁMICA DE SELECCIÓN DE TANQUE PRINCIPAL (PROTAGONISTA)
    // =======================================================================

    // 1. Identificar el Tanque Principal configurado en BD
    const cierrePrincipalDB = cierresDelGrupo.find(
      (c) =>
        c.Tanque.tipo_combustible === "GASOIL" &&
        c.Tanque.tipo_jerarquia === "PRINCIPAL"
    );

    // 2. Identificar los Tanques Auxiliares
    const cierresAuxiliares = cierresDelGrupo.filter(
      (c) =>
        c.Tanque.tipo_combustible === "GASOIL" &&
        c.Tanque.tipo_jerarquia !== "PRINCIPAL"
    );

    // 3. Selección del Protagonista:
    // Por defecto el Principal DB. Si está inactivo (consumo 0) y un Auxiliar trabajó, el Auxiliar toma el mando.
    let cierreProtagonista = cierrePrincipalDB;

    const principalInactivo =
      !cierrePrincipalDB ||
      parseFloat(cierrePrincipalDB.consumo_despachos_total || 0) === 0;

    if (principalInactivo) {
      // Buscamos un auxiliar que sí haya trabajado (tenga despachos)
      const auxiliarActivo = cierresAuxiliares.find(
        (c) => parseFloat(c.consumo_despachos_total || 0) > 0
      );

      // Si encontramos uno activo, ese será el protagonista del reporte
      if (auxiliarActivo) {
        cierreProtagonista = auxiliarActivo;
      }
    }

    // Calcular el consumo total de planta (merma) de TODOS los tanques de GASOIL
    const totalConsumoPlantaGasoil = cierresDelGrupo
      .filter((c) => c.Tanque.tipo_combustible === "GASOIL")
      .reduce((sum, c) => sum + parseFloat(c.consumo_planta_merma || 0), 0);

    // NUEVO REQUERIMIENTO: "necesito que el Stock_total pase a ser el nivel_inicio"
    // Calculamos la suma de los saldos iniciales de TODOS los tanques de Gasoil
    const saldoInicialTotalGasoil = cierresDelGrupo
      .filter((c) => c.Tanque.tipo_combustible === "GASOIL")
      .reduce((sum, c) => sum + parseFloat(c.saldo_inicial_real || 0), 0);

    // Calculamos la suma de los saldos finales de TODOS los tanques de Gasoil (Stock Total)
    const saldoFinalTotalGasoil = cierresDelGrupo
      .filter((c) => c.Tanque.tipo_combustible === "GASOIL")
      .reduce((sum, c) => sum + parseFloat(c.saldo_final_real || 0), 0);

    // Construir la estructura del Acta
    const actaPDF = {
      encabezado: {
        /* Tus datos fijos */
      },
      datos_generales: {
        turno: primerRegistro.turno,
        inspector_servicio: `${inspector.nombre} ${inspector.apellido}`,
        fecha_cierre: primerRegistro.fecha_cierre,
      },
      seccion_principal: cierreProtagonista
        ? {
            // CAMBIO: Ahora mostramos el TOTAL INICIAL de la estación (Suma de todos los tanques)
            nivel_inicio: saldoInicialTotalGasoil,

            // Consumos del Protagonista (o Total si así se prefiere, pero mantenemos lógica de protagonista para esto)
            consumo_planta: cierreProtagonista.consumo_planta_merma,
            consumo_total_despachos: cierreProtagonista.consumo_despachos_total,
            // Extraemos consumo generadores del snapshot para mostrarlo explícitamente
            consumo_generadores:
              cierreProtagonista.snapshot_desglose_despachos?.generadores || 0,
            desglose_consumo: cierreProtagonista.snapshot_desglose_despachos,

            // CAMBIO: Mostramos el TOTAL FINAL de la estación (Stock Total Disponible)
            total_disponible: saldoFinalTotalGasoil,

            // Agregamos el nombre para que el reporte sepa quién es el protagonista de los consumos
            nombre_tanque: cierreProtagonista.Tanque.nombre,
          }
        : null,
      inventario_gasoil: {
        tanques: cierresDelGrupo
          .filter((c) => c.Tanque.tipo_combustible === "GASOIL")
          .map((c) => ({
            nombre: c.Tanque.nombre,
            es_principal: c.Tanque.tipo_jerarquia === "PRINCIPAL",
            nivel_final: c.saldo_final_real,
          })),
        stock_total: cierresDelGrupo
          .filter((c) => c.Tanque.tipo_combustible === "GASOIL")
          .reduce((sum, c) => sum + parseFloat(c.saldo_final_real), 0),
      },
      inventario_gasolina: {
        tanques: cierresDelGrupo
          .filter((c) => c.Tanque.tipo_combustible === "GASOLINA")
          .map((c) => ({
            nombre: c.Tanque.nombre,
            nivel_inicio: c.saldo_inicial_real,
            nivel_final: c.saldo_final_real,
            consumo_total: c.consumo_despachos_total,
            evaporizacion: c.consumo_planta_merma, // Por tanque individual
          })),

        saldo_inicial_total: cierresDelGrupo
          .filter((c) => c.Tanque.tipo_combustible === "GASOLINA")
          .reduce((sum, c) => sum + parseFloat(c.saldo_inicial_real || 0), 0),

        stock_total: cierresDelGrupo
          .filter((c) => c.Tanque.tipo_combustible === "GASOLINA")
          .reduce(
            (sum, c) =>
              sum +
              parseFloat(c.saldo_final_real) +
              parseFloat(c.consumo_planta_merma || 0),
            0
          ),

        consumo_total_despachos: cierresDelGrupo
          .filter((c) => c.Tanque.tipo_combustible === "GASOLINA")
          .reduce(
            (sum, c) => sum + parseFloat(c.consumo_despachos_total || 0),
            0
          ),

        // ✅ NUEVO: Total de evaporización para todos los tanques de gasolina
        evaporizacion_total: cierresDelGrupo
          .filter((c) => c.Tanque.tipo_combustible === "GASOLINA")
          .reduce((sum, c) => sum + parseFloat(c.consumo_planta_merma || 0), 0),

        desglose_consumo: (() => {
          const cierresGasolina = cierresDelGrupo.filter(
            (c) => c.Tanque.tipo_combustible === "GASOLINA"
          );
          let vehiculos = 0;
          let bidones = 0;

          cierresGasolina.forEach((c) => {
            let desglose = c.snapshot_desglose_despachos;
            if (typeof desglose === "string") {
              try {
                desglose = JSON.parse(desglose);
              } catch (e) {
                desglose = {};
              }
            }
            if (desglose) {
              vehiculos += parseFloat(desglose.vehiculos || 0);
              bidones += parseFloat(desglose.bidones || 0);
            }
          });

          return { vehiculos, bidones };
        })(),
      },
      observacion: primerRegistro.observacion,
    };

    res.json(actaPDF);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al generar datos del acta." });
  }
};

// =====================================================================
// 4. REVERTIR ACTA DE CIERRE (ANULAR)
// =====================================================================
exports.revertirActaDeCierre = async (req, res) => {
  const { grupo_uuid } = req.params;

  // 1. Validación de Permisos
  if (!["ADMIN", "SUPERVISOR"].includes(req.usuario.tipo_usuario)) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const t = await sequelize.transaction();

  try {
    // 2. Verificación de Cronología: Asegurarse que es la última acta.
    const ultimoCierreGlobal = await CierreInventario.findOne({
      order: [["fecha_cierre", "DESC"]],
      attributes: ["fecha_cierre"],
      raw: true,
    });

    if (!ultimoCierreGlobal) {
      throw new Error("No hay actas para revertir.");
    }

    const cierresDelGrupo = await CierreInventario.findAll({
      where: { grupo_cierre_uuid: grupo_uuid },
      attributes: ["id_cierre", "fecha_cierre"],
      transaction: t,
    });

    if (cierresDelGrupo.length === 0) {
      throw new Error("El grupo de actas especificado no existe.");
    }

    // Comparamos la fecha del grupo a revertir con la fecha del último cierre global
    const fechaGrupoARevertir = new Date(cierresDelGrupo[0].fecha_cierre);
    const fechaUltimoCierre = new Date(ultimoCierreGlobal.fecha_cierre);

    if (fechaGrupoARevertir.getTime() !== fechaUltimoCierre.getTime()) {
      throw new Error(
        "Operación denegada: Solo se puede revertir la última acta generada en el sistema."
      );
    }

    const idsCierreARevertir = cierresDelGrupo.map((c) => c.id_cierre);

    // 3. "Liberar" los Movimientos Sellados (Poner id_cierre en NULL)
    await CargaCisterna.update(
      { id_cierre: null },
      { where: { id_cierre: { [Op.in]: idsCierreARevertir } }, transaction: t }
    );
    await MedicionTanque.update(
      { id_cierre: null },
      { where: { id_cierre: { [Op.in]: idsCierreARevertir } }, transaction: t }
    );
    await Despacho.update(
      { id_cierre: null },
      { where: { id_cierre: { [Op.in]: idsCierreARevertir } }, transaction: t }
    );

    // 4. Eliminar los Registros del Acta
    await CierreInventario.destroy({
      where: { grupo_cierre_uuid: grupo_uuid },
      transaction: t,
    });

    // 5. Confirmar la Transacción
    await t.commit();
    res.json({ msg: "Acta revertida y anulada correctamente." });
  } catch (error) {
    await t.rollback();
    console.error("Error al revertir acta:", error);
    res
      .status(500)
      .json({ msg: error.message || "Error interno al revertir el acta." });
  }
};
