const Vehiculo = require("../models/Vehiculo");
const Marca = require("../models/Marca");
const Modelo = require("../models/Modelo");
const Gerencia = require("../models/Gerencia"); // <--- IMPORTANTE: Importamos el modelo
const { paginate } = require("../helpers/paginationHelper");

// --- CREAR VEHÍCULO (Solo Admin) ---
exports.crearVehiculo = async (req, res) => {
  if (
    !["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  // Recibimos los campos incluyendo tipoCombustible
  const {
    placa,
    anio,
    color,
    id_marca,
    id_modelo,
    id_gerencia,
    es_generador,
    tipoCombustible,
  } = req.body;

  try {
    // 1. Validar duplicado de placa/código
    const vehiculoExistente = await Vehiculo.findOne({ where: { placa } });
    if (vehiculoExistente)
      return res
        .status(400)
        .json({ msg: `La placa/código ${placa} ya está registrada.` });

    // 2. Validar consistencia Modelo/Marca
    const modelo = await Modelo.findOne({ where: { id_modelo, id_marca } });
    if (!modelo) {
      return res.status(400).json({
        msg: "El modelo seleccionado no pertenece a la marca indicada",
      });
    }

    // 3. Validar Gerencia (si la envían)
    if (id_gerencia) {
      const gerencia = await Gerencia.findByPk(id_gerencia);
      if (!gerencia)
        return res.status(400).json({ msg: "Gerencia no encontrada" });
    }

    // 4. Crear
    const vehiculo = await Vehiculo.create({
      placa, // Aquí irá la Placa o el Código GEN-01
      anio,
      color,
      id_marca,
      id_modelo,
      id_gerencia: id_gerencia || null,
      es_generador: es_generador || false,
      tipoCombustible: tipoCombustible || "GASOIL",
      registrado_por: req.usuario.id_usuario,
      fecha_registro: new Date(),
      fecha_modificacion: new Date(),
      estado: "ACTIVO",
    });

    res.status(201).json({ msg: "Registro exitoso", vehiculo });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al registrar" });
  }
};

// --- OBTENER VEHÍCULOS (Paginado + JOINs) ---
exports.obtenerVehiculos = async (req, res) => {
  if (
    !["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  try {
    const searchableFields = ["placa", "color"];

    const result = await paginate(Vehiculo, req.query, {
      searchableFields,
      // Incluimos Marca, Modelo y ahora GERENCIA
      include: [
        {
          model: Marca,
          attributes: ["nombre"],
        },
        {
          model: Modelo,
          attributes: ["nombre"],
        },
        {
          model: Gerencia,
          attributes: ["nombre", "encargado_nombre", "encargado_apellido"], // Traemos info útil
        },
      ],
    });

    res.json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al obtener vehículos" });
  }
};

// --- ACTUALIZAR VEHÍCULO ---
exports.actualizarVehiculo = async (req, res) => {
  if (
    !["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const { id } = req.params;
  const {
    placa,
    anio,
    color,
    id_marca,
    id_modelo,
    id_gerencia,
    es_generador,
    tipoCombustible,
    estado,
  } = req.body;

  try {
    const vehiculo = await Vehiculo.findByPk(id);
    if (!vehiculo)
      return res.status(404).json({ msg: "Vehículo no encontrado" });

    // Validaciones de integridad (Placa, Marca, Modelo, Gerencia)... se mantienen igual
    if (placa && placa !== vehiculo.placa) {
      const existe = await Vehiculo.findOne({ where: { placa } });
      if (existe)
        return res.status(400).json({ msg: "Placa/Código ya registrado" });
      vehiculo.placa = placa;
    }
    if (id_marca && id_modelo) {
      const modeloValido = await Modelo.findOne({
        where: { id_modelo, id_marca },
      });
      if (!modeloValido)
        return res.status(400).json({ msg: "Modelo no coincide con marca" });
      vehiculo.id_marca = id_marca;
      vehiculo.id_modelo = id_modelo;
    }
    if (id_gerencia !== undefined) {
      if (id_gerencia) {
        const g = await Gerencia.findByPk(id_gerencia);
        if (!g) return res.status(400).json({ msg: "Gerencia no existe" });
      }
      vehiculo.id_gerencia = id_gerencia;
    }

    // --- ACTUALIZAR CAMPOS ---
    if (es_generador !== undefined) {
      vehiculo.es_generador = es_generador;
    }
    if (tipoCombustible !== undefined) {
      vehiculo.tipoCombustible = tipoCombustible;
    }

    if (anio) vehiculo.anio = anio;
    if (color) vehiculo.color = color;
    if (estado) vehiculo.estado = estado;

    vehiculo.fecha_modificacion = new Date();
    await vehiculo.save();

    res.json({ msg: "Actualizado correctamente", vehiculo });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al actualizar" });
  }
};

// --- DESACTIVAR VEHÍCULO ---
exports.desactivarVehiculo = async (req, res) => {
  if (req.usuario.tipo_usuario !== "ADMIN") {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const { id } = req.params;

  try {
    const vehiculo = await Vehiculo.findByPk(id);
    if (!vehiculo)
      return res.status(404).json({ msg: "Vehículo no encontrado" });

    await vehiculo.update({
      estado: "INACTIVO",
      fecha_modificacion: new Date(),
    });

    res.json({ msg: "Vehículo desactivado exitosamente" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al desactivar vehículo" });
  }
};

// --- LISTA SIMPLE DE MODELOS (Para Dropdowns) ---
exports.obtenerModelosPorMarca = async (req, res) => {
  if (
    !["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }

  const { id_marca } = req.params;

  try {
    const modelos = await Modelo.findAll({
      where: {
        id_marca: id_marca,
        estado: "ACTIVO",
      },
      attributes: ["id_modelo", "nombre"],
      order: [["nombre", "ASC"]],
    });

    res.json(modelos);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Error al obtener la lista de modelos" });
  }
};
exports.obtenerListaVehiculos = async (req, res) => {
  if (
    !["ADMIN", "INSPECTOR", "SUPERVISOR"].includes(req.usuario.tipo_usuario)
  ) {
    return res.status(403).json({ msg: "Acceso denegado." });
  }
  try {
    // Puedes pasar un query param ?tipo=generador para filtrar
    const whereClause = { estado: "ACTIVO" };

    // Si el front pide solo generadores: /lista?es_generador=true
    if (req.query.es_generador === "true") {
      whereClause.es_generador = true;
    } else if (req.query.es_generador === "false") {
      whereClause.es_generador = false;
    }

    const vehiculos = await Vehiculo.findAll({
      where: whereClause,
      attributes: ["id_vehiculo", "placa", "color", "es_generador"],
      include: [
        { model: Marca, attributes: ["nombre"] },
        { model: Modelo, attributes: ["nombre"] },
      ],
      order: [["placa", "ASC"]],
    });
    res.json(vehiculos);
    console.log(vehiculos);
  } catch (error) {
    res.status(500).json({ msg: "Error al listar" });
  }
};
