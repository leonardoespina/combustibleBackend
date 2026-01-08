const Tanque = require("../models/Tanque");
const { paginate } = require("../helpers/paginationHelper");
const { Op } = require("sequelize");

// --- CREAR TANQUE (Solo Admin) ---
exports.crearTanque = async (req, res) => {
  if (req.usuario.tipo_usuario !== "ADMIN")
    return res.status(403).json({ msg: "Acceso denegado." });

  const {
    codigo,
    nombre,
    ubicacion,
    tipo_combustible,
    tipo_jerarquia, // Nuevo campo
    unidad_medida,
    capacidad_maxima,
    nivel_alarma,
    nivel_actual,
    tabla_aforo,
    radio,
    largo,
    ancho, // Nuevo campo para tanques rectangulares
    alto, // Renombrado de longitud para claridad (altura)
    tipo_tanque, // Nuevo campo para diferenciar el tipo de tanque
  } = req.body;

  // Establecer tipo_tanque por defecto a CILINDRICO si no se especifica
  const tipoTanqueFinal = tipo_tanque || "CILINDRICO";

  try {
    // 1. Validar Código Único
    const existeCodigo = await Tanque.findOne({ where: { codigo } });
    if (existeCodigo)
      return res.status(400).json({ msg: `El código '${codigo}' ya existe.` });

    // 2. VALIDACIÓN DE REGLA DE NEGOCIO (Solo un Principal por Combustible)
    if (tipo_jerarquia === "PRINCIPAL") {
      const yaExistePrincipal = await Tanque.findOne({
        where: {
          tipo_combustible: tipo_combustible, // Ej: GASOIL
          tipo_jerarquia: "PRINCIPAL",
          estado: "ACTIVO", // Solo cuenta si está activo
        },
      });

      if (yaExistePrincipal) {
        return res.status(400).json({
          msg: `Ya existe un Tanque Principal activo para ${tipo_combustible} (${yaExistePrincipal.nombre}). No puedes crear otro.`,
        });
      }
    }

    // 3. Validar Aforo
    if (
      tabla_aforo &&
      (typeof tabla_aforo !== "object" || Array.isArray(tabla_aforo))
    ) {
      return res.status(400).json({ msg: "Tabla de aforo inválida." });
    }

    // 4. Validar dimensiones según el tipo de tanque
    if (tipoTanqueFinal === "CILINDRICO") {
      if (!radio || !largo) {
        return res.status(400).json({
          msg: "Para tanques CILINDRICOS se requieren radio y largo.",
        });
      }
      if (ancho !== undefined || alto !== undefined) {
        return res.status(400).json({
          msg: "No se deben especificar ancho o alto para tanques CILINDRICOS.",
        });
      }
    } else if (tipoTanqueFinal === "RECTANGULAR") {
      if (!largo || !ancho || !alto) {
        return res.status(400).json({
          msg: "Para tanques RECTANGULARES se requieren largo, ancho y alto.",
        });
      }
      if (radio !== undefined) {
        return res.status(400).json({
          msg: "No se debe especificar radio para tanques RECTANGULARES.",
        });
      }
    } else {
      return res.status(400).json({
        msg: "Tipo de tanque inválido. Debe ser CILINDRICO o RECTANGULAR.",
      });
    }

    // 5. Crear Tanque
    const nuevoTanque = await Tanque.create({
      codigo,
      nombre,
      ubicacion,
      tipo_combustible,
      tipo_jerarquia: tipo_jerarquia || "AUXILIAR",
      unidad_medida: unidad_medida || "CM",
      capacidad_maxima,
      nivel_alarma,
      nivel_actual: nivel_actual || 0,
      tabla_aforo: tabla_aforo || null,
      // Dimensiones según el tipo de tanque
      radio: tipoTanqueFinal === "CILINDRICO" ? radio : null,
      largo: largo,
      ancho: tipoTanqueFinal === "RECTANGULAR" ? ancho : null,
      alto: tipoTanqueFinal === "RECTANGULAR" ? alto : null,
      tipo_tanque: tipoTanqueFinal,
      registrado_por: req.usuario.id_usuario,
      fecha_registro: new Date(),
      fecha_modificacion: new Date(),
    });

    res.status(201).json({ msg: "Tanque creado", tanque: nuevoTanque });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al crear tanque" });
  }
};

// --- OBTENER TANQUES (Paginado) ---
exports.obtenerTanques = async (req, res) => {
  if (!["ADMIN", "SUPERVISOR"].includes(req.usuario.tipo_usuario)) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  try {
    const searchableFields = ["codigo", "nombre", "ubicacion"];
    // Nota: Por defecto trae el campo tabla_aforo. Si pesa mucho, podríamos excluirlo.
    const result = await paginate(Tanque, req.query, { searchableFields });
    res.json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al obtener tanques" });
  }
};

// --- OBTENER UN SOLO TANQUE (Para ver su aforo en detalle) ---
exports.obtenerTanquePorId = async (req, res) => {
  const { id } = req.params;
  try {
    const tanque = await Tanque.findByPk(id);
    if (!tanque) return res.status(404).json({ msg: "Tanque no encontrado" });
    res.json(tanque);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al obtener tanque" });
  }
};

// --- ACTUALIZAR TANQUE (Incluye Aforo) ---
exports.actualizarTanque = async (req, res) => {
  console.log(req.body);

  if (req.usuario.tipo_usuario !== "ADMIN")
    return res.status(403).json({ msg: "Acceso denegado." });

  const { id } = req.params;
  const {
    codigo,
    nombre,
    ubicacion,
    tipo_combustible,
    tipo_jerarquia, // Nuevo
    unidad_medida,
    capacidad_maxima,
    nivel_alarma,
    tabla_aforo,
    estado,
    nivel_actual,
    radio,
    largo,
    ancho, // Nuevo
    alto, // Renombrado
    tipo_tanque, // Nuevo
  } = req.body;

  try {
    const tanque = await Tanque.findByPk(id);
    if (!tanque) return res.status(404).json({ msg: "Tanque no encontrado" });

    // Validar Código
    if (codigo && codigo !== tanque.codigo) {
      const existe = await Tanque.findOne({ where: { codigo } });
      if (existe)
        return res.status(400).json({ msg: "El código ya está en uso." });
      tanque.codigo = codigo;
    }

    // VALIDACIÓN DE JERARQUÍA AL ACTUALIZAR
    // Si están intentando cambiarlo a PRINCIPAL, o si cambian el combustible de un PRINCIPAL
    const nuevaJerarquia = tipo_jerarquia || tanque.tipo_jerarquia;
    const nuevoCombustible = tipo_combustible || tanque.tipo_combustible;

    if (nuevaJerarquia === "PRINCIPAL") {
      // Buscamos si hay OTRO principal que no sea este mismo
      const otroPrincipal = await Tanque.findOne({
        where: {
          tipo_combustible: nuevoCombustible,
          tipo_jerarquia: "PRINCIPAL",
          estado: "ACTIVO",
          id_tanque: { [Op.ne]: id }, // Excluir el actual (Op.ne = Not Equal)
        },
      });

      if (otroPrincipal) {
        return res.status(400).json({
          msg: `No puedes marcar este tanque como PRINCIPAL porque ya existe '${otroPrincipal.nombre}' para ${nuevoCombustible}.`,
        });
      }
    }

    // Determinar el tipo de tanque actual o el que se está intentando establecer
    const tipoTanqueActualizado = tipo_tanque || tanque.tipo_tanque;

    // Validar y actualizar dimensiones según el tipo de tanque
    if (tipoTanqueActualizado === "CILINDRICO") {
      if (radio !== undefined) tanque.radio = radio;
      else tanque.radio = null; // Si no se provee, nullify
      if (largo !== undefined) tanque.largo = largo;
      else tanque.largo = null; // Se usa para cilindricos
      // Para tanques cilíndricos, ancho y alto deben ser nulos
      tanque.ancho = null;
      tanque.alto = null;
      // Si se intentan enviar dimensiones incorrectas
      if (
        (ancho !== undefined && ancho !== null) ||
        (alto !== undefined && alto !== null)
      ) {
        return res.status(400).json({
          msg: "No se deben especificar ancho o alto para tanques CILINDRICOS.",
        });
      }
    } else if (tipoTanqueActualizado === "RECTANGULAR") {
      if (largo !== undefined) tanque.largo = largo; // Se usa para rectangulares
      if (ancho !== undefined) tanque.ancho = ancho;
      else tanque.ancho = null;
      if (alto !== undefined) tanque.alto = alto;
      else tanque.alto = null;
      // Para tanques rectangulares, radio debe ser nulo
      tanque.radio = null;
      // Si se intenta enviar radio incorrecto
      if (radio !== undefined && radio !== null) {
        return res.status(400).json({
          msg: "No se debe especificar radio para tanques RECTANGULARES.",
        });
      }
    } else {
      return res.status(400).json({
        msg: "Tipo de tanque inválido. Debe ser CILINDRICO o RECTANGULAR.",
      });
    }

    // Actualizar campos generales
    if (nombre) tanque.nombre = nombre;
    if (ubicacion) tanque.ubicacion = ubicacion;
    if (tipo_combustible) tanque.tipo_combustible = tipo_combustible;
    if (tipo_jerarquia) tanque.tipo_jerarquia = tipo_jerarquia;
    if (unidad_medida) tanque.unidad_medida = unidad_medida;
    if (capacidad_maxima !== undefined)
      tanque.capacidad_maxima = capacidad_maxima;
    if (nivel_alarma !== undefined) tanque.nivel_alarma = nivel_alarma;
    // El tipo de tanque se actualiza aquí si se envía en el body
    if (tipo_tanque) tanque.tipo_tanque = tipo_tanque;

    // Permitir explícitamente actualizar tabla_aforo a null o {} (objeto vacío)
    if (tabla_aforo !== undefined) {
      tanque.tabla_aforo = tabla_aforo;
    }
    if (estado) tanque.estado = estado;
    if (nivel_actual !== undefined) tanque.nivel_actual = nivel_actual;

    tanque.fecha_modificacion = new Date();
    await tanque.save();

    res.json({ msg: "Tanque actualizado", tanque });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al actualizar" });
  }
};

// --- DESACTIVAR TANQUE ---
exports.desactivarTanque = async (req, res) => {
  if (req.usuario.tipo_usuario !== "ADMIN") {
    return res.status(403).json({ msg: "Acceso denegado." });
  }
  const { id } = req.params;
  try {
    const tanque = await Tanque.findByPk(id);
    if (!tanque) return res.status(404).json({ msg: "Tanque no encontrado" });

    await tanque.update({ estado: "INACTIVO", fecha_modificacion: new Date() });
    res.json({ msg: "Tanque desactivado" });
  } catch (error) {
    res.status(500).json({ msg: "Error al desactivar" });
  }
};

// --- LISTA SIMPLE (DROPDOWN) ---
// IMPORTANTE: Aquí NO devolvemos la tabla_aforo para que la respuesta sea ligera
exports.obtenerTanques = async (req, res) => {
  if (!["ADMIN", "SUPERVISOR", "INSPECTOR"].includes(req.usuario.tipo_usuario))
    return res.status(403).json({ msg: "Acceso denegado." });
  try {
    const result = await paginate(Tanque, req.query, {
      searchableFields: ["nombre", "codigo"],
    });
    res.json(result);
  } catch (error) {
    res.status(500).json({ msg: "Error" });
  }
};

exports.obtenerListaTanques = async (req, res) => {
  if (!["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario))
    return res.status(403).json({ msg: "Acceso denegado." });
  try {
    const tanques = await Tanque.findAll({
      where: { estado: "ACTIVO" },
      attributes: [
        "id_tanque",
        "codigo",
        "nombre",
        "tipo_combustible",
        "tipo_jerarquia",
        "unidad_medida",
        "nivel_actual",
        "capacidad_maxima",
        "tipo_tanque", // Incluir el nuevo campo
        "radio", // Incluir para mostrar dimensiones
        "largo",
        "ancho",
        "alto",
      ],
      order: [["codigo", "ASC"]],
    });
    res.json(tanques);
  } catch (error) {
    res.status(500).json({ msg: "Error" });
  }
};

exports.obtenerTanquePorId = async (req, res) => {
  const { id } = req.params;
  try {
    const tanque = await Tanque.findByPk(id);
    if (!tanque) return res.status(404).json({ msg: "No encontrado" });
    res.json(tanque);
  } catch (error) {
    res.status(500).json({ msg: "Error" });
  }
};

exports.desactivarTanque = async (req, res) => {
  if (req.usuario.tipo_usuario !== "ADMIN")
    return res.status(403).json({ msg: "Acceso denegado." });
  const { id } = req.params;
  try {
    await Tanque.update({ estado: "INACTIVO" }, { where: { id_tanque: id } });
    res.json({ msg: "Desactivado" });
  } catch (error) {
    res.status(500).json({ msg: "Error" });
  }
};
