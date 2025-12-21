const Modelo = require("../models/Modelo");
const Marca = require("../models/Marca"); // Necesario para validar que la marca existe
const { paginate } = require("../helpers/paginationHelper");

// --- CREAR MODELO (Solo Admin) ---
exports.crearModelo = async (req, res) => {
  // 1. Seguridad RBAC
  if (
    !["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res
      .status(403)
      .json({ msg: "Acceso denegado: Solo administradores." });
  }

  const { nombre, id_marca } = req.body;

  try {
    // 2. Validar que la Marca exista
    const marcaExiste = await Marca.findByPk(id_marca);
    if (!marcaExiste) {
      return res.status(404).json({ msg: "La marca seleccionada no existe." });
    }

    // 3. Validar duplicado (Mismo nombre en la misma marca)
    const modeloExiste = await Modelo.findOne({
      where: { nombre, id_marca },
    });
    if (modeloExiste) {
      return res
        .status(400)
        .json({ msg: `El modelo '${nombre}' ya existe en esta marca.` });
    }

    // 4. Crear con Auditoría
    const nuevoModelo = await Modelo.create({
      nombre,
      id_marca,
      estado: "ACTIVO",
      registrado_por: req.usuario.id_usuario,
      fecha_registro: new Date(),
      fecha_modificacion: new Date(),
    });

    res.status(201).json({
      msg: "Modelo creado exitosamente",
      modelo: nuevoModelo,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al crear modelo" });
  }
};

// --- OBTENER MODELOS (Solo Admin - Paginado) ---
exports.obtenerModelos = async (req, res) => {
  if (
    !["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  try {
    const searchableFields = ["nombre"];

    // Usamos el helper, pero le pasamos "include" para que traiga el nombre de la Marca
    const result = await paginate(Modelo, req.query, {
      searchableFields,
      include: [
        {
          model: Marca,
          attributes: ["nombre"], // Solo queremos el nombre de la marca
        },
      ],
    });

    res.json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al obtener modelos" });
  }
};

// --- ACTUALIZAR MODELO (Solo Admin) ---
exports.actualizarModelo = async (req, res) => {
  if (
    !["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const { id } = req.params;
  const { nombre, id_marca, estado } = req.body;

  try {
    const modelo = await Modelo.findByPk(id);
    if (!modelo) {
      return res.status(404).json({ msg: "Modelo no encontrado" });
    }

    // Validaciones si cambian datos clave
    if (id_marca && id_marca !== modelo.id_marca) {
      const marcaExiste = await Marca.findByPk(id_marca);
      if (!marcaExiste)
        return res.status(404).json({ msg: "La nueva marca no existe" });
      modelo.id_marca = id_marca;
    }

    if (nombre) modelo.nombre = nombre;
    if (estado) modelo.estado = estado;

    // Auditoría
    modelo.fecha_modificacion = new Date();

    await modelo.save();

    res.json({ msg: "Modelo actualizado", modelo });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al actualizar modelo" });
  }
};

// --- DESACTIVAR MODELO (Solo Admin) ---
exports.desactivarModelo = async (req, res) => {
  if (req.usuario.tipo_usuario !== "ADMIN") {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const { id } = req.params;

  try {
    const modelo = await Modelo.findByPk(id);
    if (!modelo) return res.status(404).json({ msg: "Modelo no encontrado" });

    await modelo.update({
      estado: "INACTIVO",
      fecha_modificacion: new Date(),
    });

    res.json({ msg: "Modelo desactivado exitosamente" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al desactivar modelo" });
  }
};
