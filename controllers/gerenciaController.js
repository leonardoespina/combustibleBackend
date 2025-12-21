const Gerencia = require("../models/Gerencia");
const { paginate } = require("../helpers/paginationHelper");

// --- CREAR GERENCIA (Solo Admin) ---
exports.crearGerencia = async (req, res) => {
  if (!["ADMIN", "SUPERVISOR"].includes(req.usuario.tipo_usuario)) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const {
    nombre,
    encargado_cedula,
    encargado_nombre,
    encargado_apellido,
    encargado_telefono,
    correo,
  } = req.body;

  try {
    // 1. Validar nombre duplicado
    const existe = await Gerencia.findOne({ where: { nombre } });
    if (existe) {
      return res
        .status(400)
        .json({ msg: `La gerencia '${nombre}' ya existe.` });
    }

    // 2. Crear
    const gerencia = await Gerencia.create({
      nombre,
      encargado_cedula,
      encargado_nombre,
      encargado_apellido,
      encargado_telefono,
      correo,
      registrado_por: req.usuario.id_usuario,
      fecha_registro: new Date(),
      fecha_modificacion: new Date(),
      estado: "ACTIVO",
    });

    res.status(201).json({
      msg: "Gerencia creada exitosamente",
      gerencia,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al crear gerencia" });
  }
};

// --- OBTENER GERENCIAS (Paginado - Tabla Principal) ---
exports.obtenerGerencias = async (req, res) => {
  if (
    !["ADMIN", "SUPERVISOR", "INSPECTOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  try {
    // Permitimos buscar por nombre de gerencia o nombre/cédula del encargado
    const searchableFields = [
      "nombre",
      "encargado_nombre",
      "encargado_apellido",
      "encargado_cedula",
    ];

    const result = await paginate(Gerencia, req.query, {
      searchableFields,
    });

    res.json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al obtener gerencias" });
  }
};

// --- ACTUALIZAR GERENCIA ---
exports.actualizarGerencia = async (req, res) => {
  if (!["ADMIN", "SUPERVISOR"].includes(req.usuario.tipo_usuario)) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const { id } = req.params;
  const {
    nombre,
    encargado_cedula,
    encargado_nombre,
    encargado_apellido,
    encargado_telefono,
    correo,
    estado,
  } = req.body;

  try {
    const gerencia = await Gerencia.findByPk(id);
    if (!gerencia)
      return res.status(404).json({ msg: "Gerencia no encontrada" });

    // Validar nombre duplicado si cambia
    if (nombre && nombre !== gerencia.nombre) {
      const existe = await Gerencia.findOne({ where: { nombre } });
      if (existe)
        return res
          .status(400)
          .json({ msg: `El nombre '${nombre}' ya está en uso.` });
      gerencia.nombre = nombre;
    }

    // Actualizamos campos si vienen en el body
    if (encargado_cedula) gerencia.encargado_cedula = encargado_cedula;
    if (encargado_nombre) gerencia.encargado_nombre = encargado_nombre;
    if (encargado_apellido) gerencia.encargado_apellido = encargado_apellido;
    if (encargado_telefono) gerencia.encargado_telefono = encargado_telefono;
    if (correo !== undefined) gerencia.correo = correo; // Permite borrar el correo enviando string vacio
    if (estado) gerencia.estado = estado;

    gerencia.fecha_modificacion = new Date();

    await gerencia.save();

    res.json({ msg: "Gerencia actualizada", gerencia });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al actualizar gerencia" });
  }
};

// --- DESACTIVAR GERENCIA ---
exports.desactivarGerencia = async (req, res) => {
  if (req.usuario.tipo_usuario !== "ADMIN") {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const { id } = req.params;

  try {
    const gerencia = await Gerencia.findByPk(id);
    if (!gerencia)
      return res.status(404).json({ msg: "Gerencia no encontrada" });

    await gerencia.update({
      estado: "INACTIVO",
      fecha_modificacion: new Date(),
    });

    res.json({ msg: "Gerencia desactivada exitosamente" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al desactivar gerencia" });
  }
};

// ---------------------------------------------------------
// --- LISTA SIMPLE PARA DROPDOWNS (Sin paginación) ---
// ---------------------------------------------------------
exports.obtenerListaGerencias = async (req, res) => {
  if (
    !["ADMIN", "SUPERVISOR", "INSPECTOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  try {
    const gerencias = await Gerencia.findAll({
      where: { estado: "ACTIVO" }, // Solo activas
      attributes: ["id_gerencia", "nombre"], // Solo lo necesario para el <select>
      order: [["nombre", "ASC"]],
    });

    res.json(gerencias);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al obtener lista de gerencias" });
  }
};
