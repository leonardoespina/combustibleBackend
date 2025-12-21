const Almacenista = require("../models/Almacenista");
const { paginate } = require("../helpers/paginationHelper");

// --- CREAR ALMACENISTA (Solo Admin) ---
exports.crearAlmacenista = async (req, res) => {
  if (
    !["ADMIN", "SUPERVISOR", "INSPECTOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const { nombre, apellido, cedula, cargo, telefono } = req.body;

  try {
    // 1. Validar Cédula Duplicada
    const existe = await Almacenista.findOne({ where: { cedula } });
    if (existe) {
      return res
        .status(400)
        .json({ msg: `La cédula ${cedula} ya está registrada.` });
    }

    // 2. Crear
    const nuevoAlmacenista = await Almacenista.create({
      nombre,
      apellido,
      cedula,
      cargo,
      telefono,
      estado: "ACTIVO",
      registrado_por: req.usuario.id_usuario,
      fecha_registro: new Date(),
      fecha_modificacion: new Date(),
    });

    res.status(201).json({
      msg: "Almacenista registrado exitosamente",
      almacenista: nuevoAlmacenista,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al registrar almacenista" });
  }
};

// --- OBTENER ALMACENISTAS (Paginado - Tabla Admin) ---
exports.obtenerAlmacenistas = async (req, res) => {
  if (
    !["ADMIN", "SUPERVISOR", "INSPECTOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  try {
    const searchableFields = ["nombre", "apellido", "cedula", "cargo"];

    const result = await paginate(Almacenista, req.query, {
      searchableFields,
    });

    res.json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al obtener almacenistas" });
  }
};

// --- ACTUALIZAR ALMACENISTA ---
exports.actualizarAlmacenista = async (req, res) => {
  if (
    !["ADMIN", "SUPERVISOR", "INSPECTOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const { id } = req.params;
  const { nombre, apellido, cedula, cargo, telefono, estado } = req.body;

  try {
    const almacenista = await Almacenista.findByPk(id);
    if (!almacenista)
      return res.status(404).json({ msg: "Almacenista no encontrado" });

    // Validar cambio de cédula
    if (cedula && cedula !== almacenista.cedula) {
      const existe = await Almacenista.findOne({ where: { cedula } });
      if (existe)
        return res
          .status(400)
          .json({ msg: "La cédula ya está registrada por otro almacenista." });
      almacenista.cedula = cedula;
    }

    if (nombre) almacenista.nombre = nombre;
    if (apellido) almacenista.apellido = apellido;
    if (cargo) almacenista.cargo = cargo;
    if (telefono) almacenista.telefono = telefono;
    if (estado) almacenista.estado = estado;

    almacenista.fecha_modificacion = new Date();

    await almacenista.save();

    res.json({ msg: "Almacenista actualizado", almacenista });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al actualizar almacenista" });
  }
};

// --- DESACTIVAR ALMACENISTA ---
exports.desactivarAlmacenista = async (req, res) => {
  if (req.usuario.tipo_usuario !== "ADMIN") {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const { id } = req.params;

  try {
    const almacenista = await Almacenista.findByPk(id);
    if (!almacenista)
      return res.status(404).json({ msg: "Almacenista no encontrado" });

    await almacenista.update({
      estado: "INACTIVO",
      fecha_modificacion: new Date(),
    });

    res.json({ msg: "Almacenista desactivado exitosamente" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al desactivar almacenista" });
  }
};

// --- LISTA SIMPLE (Para Dropdown en Despacho) ---
exports.obtenerListaAlmacenistas = async (req, res) => {
  // Admin e Inspector pueden ver la lista para seleccionarlo en el despacho
  if (
    !["ADMIN", "SUPERVISOR", "INSPECTOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  try {
    const lista = await Almacenista.findAll({
      where: { estado: "ACTIVO" },
      attributes: ["id_almacenista", "nombre", "apellido", "cedula"],
      order: [["nombre", "ASC"]],
    });

    res.json(lista);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al listar almacenistas" });
  }
};
