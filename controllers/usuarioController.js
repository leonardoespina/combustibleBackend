const Usuario = require("../models/Usuario");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { paginate } = require("../helpers/paginationHelper");

// --- CREAR USUARIO (Solo Admin) ---
exports.crearUsuario = async (req, res) => {
  // VALIDACIÓN DE ROL
  if (req.usuario.tipo_usuario !== "ADMIN") {
    return res
      .status(403)
      .json({
        msg: "Acceso denegado: Solo administradores pueden crear usuarios.",
      });
  }

  const { nombre, apellido, cedula, password, tipo_usuario } = req.body;

  try {
    // 1. Verificar Cédula Duplicada
    let usuario = await Usuario.findOne({ where: { cedula } });
    if (usuario) {
      return res.status(400).json({ msg: "La cédula ya está registrada" });
    }

    // 2. Hashear Password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // 3. Guardar en BD
    usuario = await Usuario.create({
      nombre,
      apellido,
      cedula,
      password: hashedPassword,
      tipo_usuario: tipo_usuario || "INSPECTOR",
      registrado_por: req.usuario.id_usuario, // ID del Admin
      fecha_registro: new Date(),
      estado: "ACTIVO",
    });

    res.status(201).json({
      msg: "Usuario creado exitosamente",
      usuario,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error en el servidor" });
  }
};

// --- LOGIN (Público) ---
exports.loginUsuario = async (req, res) => {
  // ... (El código de login se mantiene igual que tu versión anterior) ...
  const { cedula, password } = req.body;

  try {
    const usuario = await Usuario.findOne({ where: { cedula } });

    if (!usuario)
      return res.status(400).json({ msg: "Credenciales incorrectas (Cédula)" });
    if (usuario.estado !== "ACTIVO")
      return res.status(403).json({ msg: "Usuario Inactivo" });

    const isMatch = await bcrypt.compare(password, usuario.password);
    if (!isMatch)
      return res
        .status(400)
        .json({ msg: "Credenciales incorrectas (Password)" });

    await usuario.update({ ultimo_acceso: new Date() });

    const payload = {
      id_usuario: usuario.id_usuario,
      tipo_usuario: usuario.tipo_usuario,
      nombre: usuario.nombre,
    };

    const token = jwt.sign(payload, process.env.JWT_SECRET, {
      expiresIn: "12h",
    });

    res.json({ msg: "Login OK", token, usuario });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error en el login" });
  }
};

// --- OBTENER USUARIOS (Solo Admin) ---
exports.obtenerUsuarios = async (req, res) => {
  // VALIDACIÓN DE ROL
  if (req.usuario.tipo_usuario !== "ADMIN") {
    return res
      .status(403)
      .json({
        msg: "Acceso denegado: Solo administradores pueden ver la lista de usuarios.",
      });
  }

  try {
    const searchableFields = ["nombre", "apellido", "cedula"];

    // No necesitamos filtrar por ID de usuario porque solo entra el ADMIN
    const paginatedResults = await paginate(Usuario, req.query, {
      where: {}, // Trae a todos
      searchableFields,
      attributes: { exclude: ["password"] },
    });

    res.json(paginatedResults);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error obteniendo usuarios" });
  }
};

// --- ACTUALIZAR USUARIO (Solo Admin - PUT) ---
exports.actualizarUsuario = async (req, res) => {
  // VALIDACIÓN DE ROL
  if (req.usuario.tipo_usuario !== "ADMIN") {
    return res
      .status(403)
      .json({
        msg: "Acceso denegado: Solo administradores pueden editar usuarios.",
      });
  }

  const { id } = req.params; // ID del usuario a editar
  const { password, cedula, ...restoDatos } = req.body; // Separamos password y cedula para tratarlos especial

  try {
    // 1. Verificar si el usuario existe
    let usuario = await Usuario.findByPk(id);
    if (!usuario) {
      return res.status(404).json({ msg: "Usuario no encontrado" });
    }

    // 2. Verificar si cambiaron la cédula y si ya existe otra igual
    if (cedula && cedula !== usuario.cedula) {
      const cedulaExiste = await Usuario.findOne({ where: { cedula } });
      if (cedulaExiste) {
        return res
          .status(400)
          .json({ msg: "La cédula ya está registrada por otro usuario" });
      }
      usuario.cedula = cedula;
    }

    // 3. Verificar si enviaron contraseña nueva para hashearla
    if (password) {
      const salt = await bcrypt.genSalt(10);
      usuario.password = await bcrypt.hash(password, salt);
    }

    // 4. Actualizar resto de campos (nombre, apellido, tipo_usuario, estado, etc.)
    // Usamos Object.assign para mezclar los datos nuevos con la instancia
    Object.assign(usuario, restoDatos);

    // Actualizamos la fecha de modificación
    usuario.fecha_modificacion = new Date();

    // 5. Guardar cambios
    await usuario.save();

    res.json({
      msg: "Usuario actualizado correctamente",
      usuario,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al actualizar usuario" });
  }
};

// --- ELIMINAR (DESACTIVAR) USUARIO (Solo Admin - DELETE) ---
exports.desactivarUsuario = async (req, res) => {
  // VALIDACIÓN DE ROL
  if (req.usuario.tipo_usuario !== "ADMIN") {
    return res
      .status(403)
      .json({
        msg: "Acceso denegado: Solo administradores pueden eliminar usuarios.",
      });
  }

  const { id } = req.params;

  try {
    // 1. Buscar usuario
    const usuario = await Usuario.findByPk(id);

    if (!usuario) {
      return res.status(404).json({ msg: "Usuario no encontrado" });
    }

    // 2. Validar que no se esté eliminando a sí mismo (opcional pero recomendado)
    if (usuario.id_usuario === req.usuario.id_usuario) {
      return res
        .status(400)
        .json({ msg: "No puedes desactivar tu propio usuario administrador" });
    }

    // 3. Soft Delete: Cambiar estado a INACTIVO
    await usuario.update({
      estado: "INACTIVO",
      fecha_modificacion: new Date(),
    });

    res.json({ msg: "Usuario desactivado exitosamente (Soft Delete)" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al desactivar usuario" });
  }
};
