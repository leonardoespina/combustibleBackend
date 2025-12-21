const { sequelize } = require("../config/database");
const { Op } = require("sequelize");
const { paginate } = require("../helpers/paginationHelper");
const CierreInventario = require("../models/CierreInventario");
const Despacho = require("../models/Despacho");
const Dispensador = require("../models/Dispensador");
const Tanque = require("../models/Tanque");
const Vehiculo = require("../models/Vehiculo");
const Marca = require("../models/Marca");
const Modelo = require("../models/Modelo");
const Chofer = require("../models/Chofer");
const Gerencia = require("../models/Gerencia");
const Usuario = require("../models/Usuario");

exports.obtenerDespachosPendientes = async (req, res) => {
  try {
    const despachos = await Despacho.findAll({
      where: {
        id_cierre: null, // Filtro principal: Despachos no cerrados
      },
      include: [
        {
          model: Dispensador,
          attributes: ["nombre"],
          include: [
            {
              model: Tanque,
              as: "TanqueAsociado",
              attributes: ["tipo_combustible"],
            },
          ],
        },
        {
          model: Vehiculo,
          attributes: ["placa"],
          include: [
            { model: Marca, attributes: ["nombre"] },
            { model: Modelo, attributes: ["nombre"] },
            { model: Gerencia, attributes: ["nombre"] }, // Incluimos Gerencia del vehículo
          ],
        },
        {
          model: Chofer,
          attributes: ["nombre", "apellido", "cedula"],
        },
        {
          model: Gerencia,
          attributes: ["nombre"],
        },
        {
          model: Usuario,
          attributes: ["nombre", "apellido"],
        },
      ],
      order: [["fecha_hora", "ASC"]],
    });

    // Estructura de respuesta organizada
    const reporte = {
      GASOLINA: [],
      GASOIL: [],
    };

    despachos.forEach((d) => {
      // Extraemos el tipo de combustible desde la relación anidada
      const tipoCombustible = d.Dispensador?.TanqueAsociado?.tipo_combustible;

      // Prioridad: Gerencia directa (Bidón) > Gerencia del vehículo
      // Nota: Sequelize puede nombrar la relación como "Gerencium" o "Gerencia"
      const gerenciaDirecta = d.Gerencia || d.Gerencium;
      const gerenciaVehiculo = d.Vehiculo
        ? d.Vehiculo.Gerencia || d.Vehiculo.Gerencium
        : null;

      const nombreGerencia =
        gerenciaDirecta?.nombre || gerenciaVehiculo?.nombre || "N/A";

      // Formateamos el objeto de salida para que sea fácil de consumir en el front
      const fila = {
        id_despacho: d.id_despacho,
        fecha_hora: d.fecha_hora,
        usuario: d.Usuario
          ? `${d.Usuario.nombre} ${d.Usuario.apellido}`
          : "N/A",

        // Datos Vehículo (puede ser null si es BIDON)
        placa: d.Vehiculo ? d.Vehiculo.placa : "N/A",
        marca: d.Vehiculo?.Marca ? d.Vehiculo.Marca.nombre : "N/A",
        modelo: d.Vehiculo?.Modelo ? d.Vehiculo.Modelo.nombre : "N/A",

        chofer: d.Chofer ? `${d.Chofer.nombre} ${d.Chofer.apellido}` : "N/A",

        litros_solicitados: d.cantidad_solicitada,
        litros_despachados: d.cantidad_despachada,

        tipo_combustible: tipoCombustible, // GASOIL o GASOLINA

        gerencia: nombreGerencia,
        tipo_destino: d.tipo_destino, // VEHICULO, BIDON
      };

      // Clasificamos en el arreglo correspondiente
      if (tipoCombustible === "GASOLINA") {
        reporte.GASOLINA.push(fila);
      } else if (tipoCombustible === "GASOIL") {
        reporte.GASOIL.push(fila);
      }
    });

    res.json(reporte);
  } catch (error) {
    console.error("Error en reporte de despachos pendientes:", error);
    res.status(500).json({ msg: "Error al generar el reporte." });
  }
};

exports.obtenerConsumoPorVehiculo = async (req, res) => {
  const { placa, fechaInicio, fechaFin } = req.query;

  if (!fechaInicio || !fechaFin) {
    return res
      .status(400)
      .json({ msg: "Debe proporcionar fechaInicio y fechaFin (YYYY-MM-DD)" });
  }

  const start = new Date(`${fechaInicio}T00:00:00`);
  const end = new Date(`${fechaFin}T23:59:59`);

  try {
    const whereDespacho = {
      fecha_hora: {
        [Op.between]: [start, end],
      },
      estado: "PROCESADO",
      tipo_destino: "VEHICULO",
    };

    const whereVehiculo = {};
    if (placa) {
      // Búsqueda parcial o exacta si se desea
      whereVehiculo.placa = { [Op.like]: `%${placa}%` };
    }

    // Usamos paginate sobre el modelo Vehiculo para paginar unidades
    const result = await paginate(Vehiculo, req.query, {
      where: whereVehiculo,
      searchableFields: ["placa"], // Permite usar ?search=... también si se desea
      distinct: true, // Importante para contar Vehículos correctamente
      include: [
        {
          model: Despacho,
          where: whereDespacho,
          required: true, // Solo vehículos con consumo en el periodo (INNER JOIN)
          include: [
            {
              model: Dispensador,
              include: [
                {
                  model: Tanque,
                  as: "TanqueAsociado",
                  attributes: ["tipo_combustible"],
                },
              ],
            },
          ],
        },
        { model: Marca, attributes: ["nombre"] },
        { model: Modelo, attributes: ["nombre"] },
      ],
      order: [["placa", "ASC"]],
    });

    // Transformar los datos: calcular totales usando los despachos traídos por el include
    const formattedData = result.data.map((vehiculo) => {
      let gasolina = 0;
      let gasoil = 0;
      let total = 0;
      let despachosCount = 0;

      if (vehiculo.Despachos) {
        vehiculo.Despachos.forEach((d) => {
          const litros = parseFloat(d.cantidad_despachada || 0);
          const tipo = d.Dispensador?.TanqueAsociado?.tipo_combustible;

          if (tipo === "GASOLINA") gasolina += litros;
          if (tipo === "GASOIL") gasoil += litros;
          total += litros;
          despachosCount++;
        });
      }

      return {
        placa: vehiculo.placa,
        vehiculo: `${vehiculo.Marca?.nombre || ""} ${
          vehiculo.Modelo?.nombre || ""
        }`.trim(),
        gasolina: parseFloat(gasolina.toFixed(2)),
        gasoil: parseFloat(gasoil.toFixed(2)),
        total: parseFloat(total.toFixed(2)),
        cantidad_despachos: despachosCount,
      };
    });

    // Reemplazar data cruda con la procesada
    result.data = formattedData;

    res.json(result);
  } catch (error) {
    console.error("Error en reporte de consumo por vehiculo:", error);
    res.status(500).json({ msg: "Error al generar el reporte de vehiculo." });
  }
};

exports.obtenerConsumoPorGerencia = async (req, res) => {
  const { fechaInicio, fechaFin, tipoCombustible } = req.query;

  if (!fechaInicio || !fechaFin) {
    return res
      .status(400)
      .json({ msg: "Debe proporcionar fechaInicio y fechaFin (YYYY-MM-DD)" });
  }

  // Ajustar fechas para cubrir todo el día local o UTC según se envíe
  // Asumimos formato YYYY-MM-DD
  const start = new Date(`${fechaInicio}T00:00:00`);
  const end = new Date(`${fechaFin}T23:59:59`);

  try {
    // Construir condición de filtrado para el tanque
    const tanqueWhere = {};
    if (tipoCombustible) {
      tanqueWhere.tipo_combustible = tipoCombustible;
    }

    const despachos = await Despacho.findAll({
      where: {
        fecha_hora: {
          [Op.between]: [start, end],
        },
        estado: "PROCESADO", // Solo contar despachos efectivos
      },
      attributes: ["cantidad_despachada", "tipo_destino"],
      include: [
        {
          model: Vehiculo,
          attributes: ["id_vehiculo"],
          include: [{ model: Gerencia, attributes: ["nombre"] }],
        },
        {
          model: Gerencia,
          attributes: ["nombre"],
        },
        {
          model: Dispensador,
          attributes: ["id_dispensador"],
          required: true, // Inner Join
          include: [
            {
              model: Tanque,
              as: "TanqueAsociado",
              attributes: ["tipo_combustible"],
              where: tanqueWhere,
              required: true, // Inner Join
            },
          ],
        },
      ],
    });

    const consumo = {};

    despachos.forEach((d) => {
      // Misma lógica robusta para encontrar la Gerencia
      const gerenciaDirecta = d.Gerencia || d.Gerencium;
      const gerenciaVehiculo = d.Vehiculo
        ? d.Vehiculo.Gerencia || d.Vehiculo.Gerencium
        : null;

      const nombreGerencia =
        gerenciaDirecta?.nombre || gerenciaVehiculo?.nombre || "SIN ASIGNAR";

      const litros = parseFloat(d.cantidad_despachada || 0);

      if (!consumo[nombreGerencia]) {
        consumo[nombreGerencia] = 0;
      }
      consumo[nombreGerencia] += litros;
    });

    // Convertir objeto a array
    const reporte = Object.keys(consumo).map((key) => ({
      gerencia: key,
      total: parseFloat(consumo[key].toFixed(2)),
    }));

    // Ordenar por total descendente
    reporte.sort((a, b) => b.total - a.total);

    res.json(reporte);
  } catch (error) {
    console.error("Error en reporte de consumo por gerencia:", error);
    res.status(500).json({ msg: "Error al generar el reporte de consumo." });
  }
};

// =====================================================================
// REPORTE: HISTORIAL DE CIERRES DE INVENTARIO (POR RANGO DE FECHAS)
// =====================================================================
exports.obtenerHistorialCierreInventario = async (req, res) => {
  const { fechaInicio, fechaFin } = req.query;

  try {
    const whereClause = {};

    if (fechaInicio && fechaFin) {
      // Ajuste de fechas para incluir el día completo
      const start = new Date(`${fechaInicio}T00:00:00`);
      const end = new Date(`${fechaFin}T23:59:59`);
      whereClause.fecha_cierre = {
        [Op.between]: [start, end],
      };
    }

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
      where: whereClause,
      group: ["grupo_cierre_uuid", "fecha_cierre", "turno"],
      order: [["fecha_cierre", "DESC"]],
    });

    res.json(actas);
  } catch (error) {
    console.error("Error al obtener historial de cierres:", error);
    res.status(500).json({ msg: "Error al listar historial." });
  }
};

// =====================================================================
// REPORTE: DETALLE DE DESPACHOS POR ACTA DE CIERRE
// =====================================================================
exports.obtenerDetalleDespachosPorActa = async (req, res) => {
  const { grupo_uuid } = req.params;

  try {
    // 1. Obtener los IDs de cierre asociados al grupo
    const cierres = await CierreInventario.findAll({
      where: { grupo_cierre_uuid: grupo_uuid },
      attributes: ["id_cierre"],
    });

    if (!cierres || cierres.length === 0) {
      return res.status(404).json({ msg: "Acta no encontrada." });
    }

    const idsCierre = cierres.map((c) => c.id_cierre);

    // 2. Buscar despachos asociados a esos cierres
    const despachos = await Despacho.findAll({
      where: {
        id_cierre: { [Op.in]: idsCierre },
      },
      include: [
        {
          model: Dispensador,
          attributes: ["id_dispensador", "nombre"], // Ajusta según tu modelo
          include: [
            {
              model: Tanque,
              as: "TanqueAsociado",
              attributes: ["tipo_combustible", "nombre"],
            },
          ],
        },
        {
          model: Vehiculo,
          attributes: ["placa"],
          include: [
            { model: Marca, attributes: ["nombre"] },
            { model: Modelo, attributes: ["nombre"] },
          ],
        },
        {
          model: Chofer,
          attributes: ["nombre", "apellido", "cedula"],
        },
        {
          model: Usuario,
          attributes: ["nombre", "apellido"],
        },
        {
          model: Gerencia, // Para el caso de BIDONES
          attributes: ["nombre"],
        },
      ],
      order: [["fecha_hora", "ASC"]],
    });

    // Formatear respuesta
    const resultado = despachos.map((d) => {
      // Determinar Gerencia (similar a otros reportes)
      const gerenciaDirecta = d.Gerencia || d.Gerencium;
      const gerenciaVehiculo = d.Vehiculo
        ? d.Vehiculo.Gerencia || d.Vehiculo.Gerencium
        : null;
      const nombreGerencia =
        gerenciaDirecta?.nombre || gerenciaVehiculo?.nombre || "N/A";

      return {
        id_despacho: d.id_despacho,
        fecha_hora: d.fecha_hora,
        ticket: d.numero_ticket,
        dispensador: d.Dispensador?.nombre || "N/A",
        tanque: d.Dispensador?.TanqueAsociado?.nombre || "N/A",
        tipo_combustible:
          d.Dispensador?.TanqueAsociado?.tipo_combustible || "N/A",
        cantidad: d.cantidad_despachada,
        destino: d.tipo_destino,
        placa: d.Vehiculo?.placa || "N/A",
        vehiculo: d.Vehiculo
          ? `${d.Vehiculo.Marca?.nombre || ""} ${
              d.Vehiculo.Modelo?.nombre || ""
            }`.trim()
          : "N/A",
        chofer: d.Chofer ? `${d.Chofer.nombre} ${d.Chofer.apellido}` : "N/A",
        usuario: d.Usuario
          ? `${d.Usuario.nombre} ${d.Usuario.apellido}`
          : "N/A",
        gerencia: nombreGerencia,
        observacion: d.observacion,
      };
    });

    res.json(resultado);
  } catch (error) {
    console.error("Error al obtener detalle de despachos:", error);
    res.status(500).json({ msg: "Error al obtener detalles." });
  }
};

// =====================================================================
// NUEVO REPORTE: CONSUMO DETALLADO POR GERENCIA (GASOLINA vs GASOIL)
// =====================================================================
exports.obtenerReporteConsumoGerencia = async (req, res) => {
  const { fechaInicio, fechaFin, id_gerencia } = req.query;

  if (!fechaInicio || !fechaFin) {
    return res
      .status(400)
      .json({ msg: "Debe proporcionar fechaInicio y fechaFin (YYYY-MM-DD)" });
  }

  const start = new Date(`${fechaInicio}T00:00:00`);
  const end = new Date(`${fechaFin}T23:59:59`);

  try {
    const whereClause = {
      fecha_hora: {
        [Op.between]: [start, end],
      },
      estado: "PROCESADO",
    };

    // Si viene id_gerencia, el filtrado es más complejo porque el ID puede estar
    // en Despacho.id_gerencia (Bidón) O en Vehiculo.id_gerencia.
    // Lo manejaremos post-query para simplificar, o construimos un where complejo.
    // Dado que el volumen de datos no suele ser masivo, post-procesamiento es seguro y más claro.

    const despachos = await Despacho.findAll({
      where: whereClause,
      include: [
        {
          model: Vehiculo,
          attributes: ["id_gerencia"],
          include: [{ model: Gerencia, attributes: ["id_gerencia", "nombre"] }],
        },
        {
          model: Gerencia,
          attributes: ["id_gerencia", "nombre"],
        },
        {
          model: Dispensador,
          attributes: ["id_dispensador"],
          include: [
            {
              model: Tanque,
              as: "TanqueAsociado",
              attributes: ["tipo_combustible"],
            },
          ],
        },
      ],
    });

    // Estructura de agrupación: { "ID_GERENCIA": { nombre: "X", gasolina: 0, gasoil: 0 } }
    const reporteMap = {};

    despachos.forEach((d) => {
      // 1. Determinar Gerencia
      let gerencia = null;

      if (d.tipo_destino === "VEHICULO" && d.Vehiculo) {
        // Accedemos a la relación anidada Vehiculo -> Gerencia
        // Sequelize suele llamar a la relación singular "Gerencium" o "Gerencia"
        gerencia = d.Vehiculo.Gerencium || d.Vehiculo.Gerencia;
      } else if (d.tipo_destino === "BIDON") {
        gerencia = d.Gerencium || d.Gerencia;
      }

      // Si se filtró por id_gerencia específico y no coincide, saltamos
      if (id_gerencia && gerencia?.id_gerencia != id_gerencia) {
        return;
      }

      // Si no tiene gerencia asignada, lo agrupamos como "SIN ASIGNAR"
      const idKey = gerencia ? gerencia.id_gerencia : "SIN_ASIGNAR";
      const nombreKey = gerencia ? gerencia.nombre : "SIN ASIGNAR";

      if (!reporteMap[idKey]) {
        reporteMap[idKey] = {
          id_gerencia: idKey,
          nombre: nombreKey,
          gasolina: 0,
          gasoil: 0,
          total: 0,
        };
      }

      // 2. Determinar Combustible y Sumar
      const tipo = d.Dispensador?.TanqueAsociado?.tipo_combustible; // GASOLINA o GASOIL
      const litros = parseFloat(d.cantidad_despachada || 0);

      if (tipo === "GASOLINA") {
        reporteMap[idKey].gasolina += litros;
      } else if (tipo === "GASOIL") {
        reporteMap[idKey].gasoil += litros;
      }
      reporteMap[idKey].total += litros;
    });

    // Convertir a array y formatear decimales
    const reporteArray = Object.values(reporteMap).map((item) => ({
      ...item,
      gasolina: parseFloat(item.gasolina.toFixed(2)),
      gasoil: parseFloat(item.gasoil.toFixed(2)),
      total: parseFloat(item.total.toFixed(2)),
    }));

    // Ordenar por total descendente
    reporteArray.sort((a, b) => b.total - a.total);

    res.json(reporteArray);
  } catch (error) {
    console.error("Error en reporte detallado de gerencia:", error);
    res.status(500).json({ msg: "Error al generar el reporte." });
  }
};
