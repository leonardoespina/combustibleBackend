const { sequelize } = require("../config/database");
const Despacho = require("../models/Despacho");
const Dispensador = require("../models/Dispensador");
const Tanque = require("../models/Tanque");
const Vehiculo = require("../models/Vehiculo");
const Chofer = require("../models/Chofer");
const Gerencia = require("../models/Gerencia");
const Almacenista = require("../models/Almacenista");
const Usuario = require("../models/Usuario");
const { paginate } = require("../helpers/paginationHelper");

exports.registrarDespacho = async (req, res) => {
  if (
    !["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const {
    numero_ticket,
    fecha,
    hora,
    id_dispensador,
    cantidad_solicitada,
    cantidad_despachada,
    tipo_destino,
    // Vehículo
    id_vehiculo,
    id_chofer,
    // Bidón
    id_gerencia,
    // General
    id_almacenista,
    observacion, // <--- Nuevo campo
  } = req.body;

  const t = await sequelize.transaction();

  try {
    // 1. Validar Ticket
    const existeTicket = await Despacho.findOne({ where: { numero_ticket } });
    if (existeTicket) {
      await t.rollback();
      return res.status(400).json({ msg: "Ticket ya registrado." });
    }

    // 2. Construir Fecha
    const fechaHoraCombinada = new Date(`${fecha}T${hora}:00`);
    if (isNaN(fechaHoraCombinada.getTime())) throw new Error("Fecha inválida");

    const litrosReales = parseFloat(cantidad_despachada);

    // 3. Obtener Dispensador y Tanque
    const dispensador = await Dispensador.findByPk(id_dispensador, {
      transaction: t,
    });
    if (!dispensador || dispensador.estado !== "ACTIVO")
      throw new Error("Dispensador inválido.");

    const tanque = await Tanque.findByPk(dispensador.id_tanque_asociado, {
      transaction: t,
    });
    if (!tanque) throw new Error("Tanque asociado no encontrado.");

    // 4. Validar Stock
    if (parseFloat(tanque.nivel_actual) < litrosReales) {
      throw new Error(`Stock insuficiente en tanque ${tanque.nombre}.`);
    }

    // 5. Preparar Datos según Destino
    let final_id_vehiculo = null;
    let final_id_chofer = null;
    let final_id_gerencia = null;

    if (tipo_destino === "VEHICULO") {
      if (!id_vehiculo || !id_chofer)
        throw new Error("Vehículo y Chofer requeridos.");

      // Validamos existencia
      const vehiculo = await Vehiculo.findByPk(id_vehiculo);
      const chofer = await Chofer.findByPk(id_chofer);
      if (!vehiculo || !chofer) throw new Error("Vehículo o Chofer inválido.");

      // Validar compatibilidad de combustible (Nuevo requerimiento)
      // Vehículo: tipoCombustible (GASOLINA/GASOIL)
      // Tanque: tipo_combustible (GASOLINA/GASOIL)
      if (vehiculo.tipoCombustible !== tanque.tipo_combustible) {
        throw new Error(
          `Error de Combustible: El vehículo es de ${vehiculo.tipoCombustible} y el surtidor despacha ${tanque.tipo_combustible}.`
        );
      }

      final_id_vehiculo = id_vehiculo;
      final_id_chofer = id_chofer;
    } else if (tipo_destino === "BIDON") {
      if (!id_gerencia) throw new Error("Gerencia requerida.");
      const gerencia = await Gerencia.findByPk(id_gerencia);
      if (!gerencia) throw new Error("Gerencia inválida.");

      final_id_gerencia = id_gerencia;
      // Ya no hay campos manuales de beneficiario
    }

    // 6. Actualizar Odómetro y Tanque
    const odometroPrevio = parseFloat(dispensador.odometro_actual);
    const odometroNuevo = odometroPrevio + litrosReales;

    await dispensador.update(
      { odometro_actual: odometroNuevo },
      { transaction: t }
    );

    const nivelNuevoTanque = parseFloat(tanque.nivel_actual) - litrosReales;
    await tanque.update({ nivel_actual: nivelNuevoTanque }, { transaction: t });

    // 7. Guardar Despacho
    const nuevoDespacho = await Despacho.create(
      {
        numero_ticket,
        fecha_hora: fechaHoraCombinada,
        id_dispensador,
        odometro_previo: odometroPrevio,
        odometro_final: odometroNuevo,
        cantidad_solicitada,
        cantidad_despachada: litrosReales,
        tipo_destino,

        id_vehiculo: final_id_vehiculo,
        id_chofer: final_id_chofer,
        id_gerencia: final_id_gerencia,

        observacion: observacion || null, // Guardamos la observación si existe

        id_tanque: tanque.id_tanque, // <--- CAMPO NUEVO: Guardamos el tanque origen

        id_almacenista,
        id_usuario: req.usuario.id_usuario,
      },
      { transaction: t }
    );

    await t.commit();
    res.status(201).json({
      msg: "Despacho registrado exitosamente",
      despacho: nuevoDespacho,
    });
  } catch (error) {
    await t.rollback();
    console.error(error);
    res
      .status(400)
      .json({ msg: error.message || "Error al procesar despacho" });
  }
};

exports.obtenerDespachos = async (req, res) => {
  if (
    !["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado" });
  }

  try {
    const result = await paginate(Despacho, req.query, {
      searchableFields: ["numero_ticket"],
      order: [["fecha_hora", "DESC"]],
      include: [
        { model: Dispensador, attributes: ["nombre"] },
        { model: Vehiculo, attributes: ["placa"] },
        { model: Chofer, attributes: ["nombre", "apellido", "cedula"] }, // El front usará esto
        { model: Gerencia, attributes: ["nombre"] }, // El front usará esto
        { model: Almacenista, attributes: ["nombre", "apellido"] },
        { model: Usuario, attributes: ["nombre", "apellido"] },
      ],
    });
    res.json(result);
  } catch (error) {
    res.status(500).json({ msg: "Error al listar despachos" });
  }
};

exports.anularDespacho = async (req, res) => {
  if (req.usuario.tipo_usuario !== "ADMIN")
    return res.status(403).json({ msg: "Solo Admin puede anular." });

  const { id } = req.params;
  const t = await sequelize.transaction();

  try {
    const despacho = await Despacho.findByPk(id, { transaction: t });
    if (!despacho) throw new Error("Despacho no encontrado");
    if (despacho.estado === "ANULADO") throw new Error("Ya está anulado");

    const litros = parseFloat(despacho.cantidad_despachada);

    // 1. Devolver litros al Tanque (sin tocar odómetro)
    const dispensador = await Dispensador.findByPk(despacho.id_dispensador, {
      transaction: t,
    });
    if (dispensador) {
      const tanque = await Tanque.findByPk(dispensador.id_tanque_asociado, {
        transaction: t,
      });
      if (tanque) {
        await tanque.update(
          { nivel_actual: parseFloat(tanque.nivel_actual) + litros },
          { transaction: t }
        );
      }
    }

    despacho.estado = "ANULADO";
    // Si anulamos, agregamos nota a la observación
    despacho.observacion = (despacho.observacion || "") + " [ANULADO]";

    await despacho.save({ transaction: t });

    await t.commit();
    res.json({ msg: "Despacho anulado e inventario restaurado." });
  } catch (error) {
    await t.rollback();
    res.status(500).json({ msg: "Error al anular" });
  }
};
