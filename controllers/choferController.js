const Chofer = require("../models/Chofer");
const { paginate } = require("../helpers/paginationHelper");

// --- CREAR CHOFER (Solo Admin) ---
exports.crearChofer = async (req, res) => {
  if (
    !["ADMIN", "SUPERVISOR", "INSPECTOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const { nombre, apellido, cedula } = req.body;

  try {
    // 1. Validar duplicado
    const existe = await Chofer.findOne({ where: { cedula } });
    if (existe) {
      return res
        .status(400)
        .json({ msg: `La cédula ${cedula} ya está registrada.` });
    }

    // 2. Crear
    const nuevoChofer = await Chofer.create({
      nombre,
      apellido,
      cedula,
      estado: "ACTIVO",
      registrado_por: req.usuario.id_usuario,
      fecha_registro: new Date(),
      fecha_modificacion: new Date(),
    });

    res.status(201).json({
      msg: "Chofer registrado exitosamente",
      chofer: nuevoChofer,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al crear chofer" });
  }
};

// --- OBTENER CHOFERES (Paginado - Tabla de Gestión) ---
exports.obtenerChoferes = async (req, res) => {
  if (
    !["ADMIN", "SUPERVISOR", "INSPECTOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  try {
    const searchableFields = ["nombre", "apellido", "cedula"];

    const result = await paginate(Chofer, req.query, {
      searchableFields,
    });

    res.json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al obtener choferes" });
  }
};

// --- ACTUALIZAR CHOFER ---
exports.actualizarChofer = async (req, res) => {
  if (!["ADMIN", "SUPERVISOR"].includes(req.usuario.tipo_usuario)) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const { id } = req.params;
  const { nombre, apellido, cedula, estado } = req.body;

  try {
    const chofer = await Chofer.findByPk(id);
    if (!chofer) return res.status(404).json({ msg: "Chofer no encontrado" });

    // Validar cambio de cédula
    if (cedula && cedula !== chofer.cedula) {
      const existe = await Chofer.findOne({ where: { cedula } });
      if (existe)
        return res.status(400).json({ msg: "La cédula ya está en uso." });
      chofer.cedula = cedula;
    }

    if (nombre) chofer.nombre = nombre;
    if (apellido) chofer.apellido = apellido;
    if (estado) chofer.estado = estado;

    chofer.fecha_modificacion = new Date();

    await chofer.save();

    res.json({ msg: "Chofer actualizado", chofer });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al actualizar chofer" });
  }
};

// --- DESACTIVAR CHOFER ---
exports.desactivarChofer = async (req, res) => {
  if (req.usuario.tipo_usuario !== "ADMIN") {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const { id } = req.params;

  try {
    const chofer = await Chofer.findByPk(id);
    if (!chofer) return res.status(404).json({ msg: "Chofer no encontrado" });

    await chofer.update({
      estado: "INACTIVO",
      fecha_modificacion: new Date(),
    });

    res.json({ msg: "Chofer desactivado exitosamente" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al desactivar chofer" });
  }
};

// --- LISTA SIMPLE (Para Dropdown en Despacho) ---
exports.obtenerListaChoferes = async (req, res) => {
  // Admin e Inspector necesitan ver esto para despachar
  if (
    !["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  try {
    const choferes = await Chofer.findAll({
      where: { estado: "ACTIVO" },
      attributes: ["id_chofer", "nombre", "apellido", "cedula"],
      order: [["nombre", "ASC"]],
    });

    res.json(choferes);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al listar choferes" });
  }
};
