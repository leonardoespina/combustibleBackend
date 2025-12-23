const Dispensador = require("../models/Dispensador");
const Tanque = require("../models/Tanque");
const { paginate } = require("../helpers/paginationHelper");

// --- CREAR (Solo Admin) ---
exports.crearDispensador = async (req, res) => {
  if (req.usuario.tipo_usuario !== "ADMIN")
    return res.status(403).json({ msg: "Acceso denegado." });

  const { nombre, odometro_actual, id_tanque_asociado } = req.body;

  try {
    // Validar que el tanque exista
    const tanque = await Tanque.findByPk(id_tanque_asociado);
    if (!tanque)
      return res.status(400).json({ msg: "El tanque asociado no existe." });

    const nuevo = await Dispensador.create({
      nombre,
      odometro_actual: odometro_actual || 0,
      id_tanque_asociado,
      registrado_por: req.usuario.id_usuario,
      fecha_registro: new Date(),
      fecha_modificacion: new Date(),
    });
    res.status(201).json({ msg: "Dispensador creado", dispensador: nuevo });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al crear dispensador" });
  }
};

// --- OBTENER (Solo Admin - Gestión) ---
exports.obtenerDispensadores = async (req, res) => {
  if (
    !["ADMIN", "SUPERVISOR", "INSPECTOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }
  try {
    const result = await paginate(Dispensador, req.query, {
      include: [
        {
          model: Tanque,
          as: "TanqueAsociado",
          attributes: ["nombre", "tipo_combustible"],
        },
      ],
    });
    res.json(result);
  } catch (error) {
    res.status(500).json({ msg: "Error obteniendo dispensadores" });
  }
};

// --- ACTUALIZAR (Solo Admin) ---
exports.actualizarDispensador = async (req, res) => {
  if (!["ADMIN", "SUPERVISOR"].includes(req.usuario.tipo_usuario))
    return res.status(403).json({ msg: "Acceso denegado." });
  const { id } = req.params;
  const { nombre, odometro_actual, id_tanque_asociado, estado } = req.body;

  try {
    const disp = await Dispensador.findByPk(id);
    if (!disp) return res.status(404).json({ msg: "No encontrado" });

    if (nombre) disp.nombre = nombre;
    if (odometro_actual !== undefined) disp.odometro_actual = odometro_actual;
    if (id_tanque_asociado) disp.id_tanque_asociado = id_tanque_asociado;
    if (estado) disp.estado = estado;

    disp.fecha_modificacion = new Date();
    await disp.save();
    res.json({ msg: "Dispensador actualizado", dispensador: disp });
  } catch (error) {
    res.status(500).json({ msg: "Error al actualizar" });
  }
};

// --- DESACTIVAR (Solo Admin) ---
exports.desactivarDispensador = async (req, res) => {
  if (req.usuario.tipo_usuario !== "ADMIN")
    return res.status(403).json({ msg: "Acceso denegado." });
  const { id } = req.params;
  try {
    await Dispensador.update(
      { estado: "INACTIVO" },
      { where: { id_dispensador: id } }
    );
    res.json({ msg: "Dispensador desactivado" });
  } catch (error) {
    res.status(500).json({ msg: "Error al desactivar" });
  }
};

// --- LISTA SIMPLE (Admin e Inspector - Para el Select de Despacho) ---
exports.obtenerListaDispensadores = async (req, res) => {
  if (
    !["ADMIN", "SUPERVISOR", "INSPECTOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }
  try {
    const lista = await Dispensador.findAll({
      where: { estado: "ACTIVO" },
      include: [
        {
          model: Tanque,
          as: "TanqueAsociado",
          attributes: ["nombre", "tipo_combustible"],
        },
      ],
      attributes: ["id_dispensador", "nombre", "odometro_actual"],
    });

    const resultado = lista.map((d) => ({
      ...d.toJSON(),
      tipo_combustible: d.TanqueAsociado?.tipo_combustible,
    }));

    res.json(resultado);
  } catch (error) {
    res.status(500).json({ msg: "Error al listar" });
  }
};
