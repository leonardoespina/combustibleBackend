const Marca = require("../models/Marca");
const { paginate } = require("../helpers/paginationHelper");

// --- CREAR MARCA (Solo Admin) ---
exports.crearMarca = async (req, res) => {
  // 1. Seguridad RBAC

  console.log(req.body);

  if (
    !["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({
      msg: "Acceso denegado: Solo administradores pueden crear marcas.",
    });
  }

  const { nombre } = req.body;

  try {
    // 2. Validar duplicados
    const existe = await Marca.findOne({ where: { nombre } });
    if (existe) {
      return res.status(400).json({ msg: `La marca '${nombre}' ya existe.` });
    }

    // 3. Crear registro con auditoría
    const nuevaMarca = await Marca.create({
      nombre,
      estado: "ACTIVO",
      registrado_por: req.usuario.id_usuario, // Auditoría: Quién lo hizo
      fecha_registro: new Date(),
      fecha_modificacion: new Date(),
    });

    res.status(201).json({
      msg: "Marca creada exitosamente",
      marca: nuevaMarca,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al crear la marca" });
  }
};

// --- OBTENER MARCAS (Solo Admin - Paginado y Búsqueda) ---
exports.obtenerMarcas = async (req, res) => {
  // 1. Seguridad RBAC
  if (
    !["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  try {
    // 2. Configurar búsqueda
    const searchableFields = ["nombre"]; // Buscaremos por nombre

    // 3. Usar el Helper
    // Nota: No ponemos filtro 'where' extra porque el admin puede ver activas e inactivas
    const result = await paginate(Marca, req.query, {
      searchableFields,
    });

    res.json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al obtener marcas" });
  }
};

// --- ACTUALIZAR MARCA (Solo Admin) ---
exports.actualizarMarca = async (req, res) => {
  // 1. Seguridad RBAC
  if (
    !["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const { id } = req.params;
  const { nombre, estado } = req.body;

  try {
    const marca = await Marca.findByPk(id);

    if (!marca) {
      return res.status(404).json({ msg: "Marca no encontrada" });
    }

    // 2. Validar nombre duplicado (si se está cambiando el nombre)
    if (nombre && nombre !== marca.nombre) {
      const existe = await Marca.findOne({ where: { nombre } });
      if (existe) {
        return res.status(400).json({ msg: `La marca '${nombre}' ya existe.` });
      }
      marca.nombre = nombre;
    }

    // 3. Actualizar estado si se envía
    if (estado) {
      marca.estado = estado;
    }

    // 4. Auditoría de modificación
    marca.fecha_modificacion = new Date();

    await marca.save();

    res.json({
      msg: "Marca actualizada correctamente",
      marca,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al actualizar la marca" });
  }
};

// --- DESACTIVAR MARCA (Solo Admin - Soft Delete) ---
exports.desactivarMarca = async (req, res) => {
  // 1. Seguridad RBAC
  if (req.usuario.tipo_usuario !== "ADMIN") {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const { id } = req.params;

  try {
    const marca = await Marca.findByPk(id);

    if (!marca) {
      return res.status(404).json({ msg: "Marca no encontrada" });
    }

    // 2. Soft Delete
    await marca.update({
      estado: "INACTIVO",
      fecha_modificacion: new Date(),
    });

    res.json({ msg: "Marca desactivada exitosamente" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al desactivar la marca" });
  }
};
exports.obtenerListaMarcas = async (req, res) => {
  // 1. Seguridad
  if (
    !["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  try {
    // 2. Consulta directa (Sin paginación)
    const marcas = await Marca.findAll({
      where: { estado: "ACTIVO" }, // Solo traemos las activas
      attributes: ["id_marca", "nombre"], // Solo ID y Nombre (lo necesario para el <select>)
      order: [["nombre", "ASC"]], // Orden alfabético
    });

    res.json(marcas);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al obtener la lista de marcas" });
  }
};
