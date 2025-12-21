const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const CargaCisterna = sequelize.define(
  "CargaCisterna",
  {
    id_carga: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    numero_guia: {
      type: DataTypes.STRING(50),
      allowNull: false,
      unique: false,
    },
    // Relaciones
    id_vehiculo: { type: DataTypes.INTEGER, allowNull: false },
    id_chofer: { type: DataTypes.INTEGER, allowNull: true },
    id_tanque: { type: DataTypes.INTEGER, allowNull: false },
    id_almacenista: { type: DataTypes.INTEGER, allowNull: false },

    // Fechas
    fecha_emision: { type: DataTypes.DATEONLY, allowNull: true },
    fecha_recepcion: { type: DataTypes.DATEONLY, allowNull: true },
    fecha_hora_llegada: { type: DataTypes.DATE, allowNull: false },

    // Tipo de combustible (se copia del tanque para registro histórico)
    tipo_combustible: { type: DataTypes.STRING(20), allowNull: true },

    // --- MEDICIÓN VARA (ESTÁTICA) - Opcionales para modo manual ---
    medida_inicial: { type: DataTypes.DECIMAL(10, 2), allowNull: true },
    medida_final: { type: DataTypes.DECIMAL(10, 2), allowNull: true },
    litros_iniciales: { type: DataTypes.DECIMAL(12, 2), allowNull: true },
    litros_finales: { type: DataTypes.DECIMAL(12, 2), allowNull: true },

    // Este es el valor OFICIAL que entra al inventario (según Vara)
    litros_recibidos_real: {
      type: DataTypes.DECIMAL(12, 2),
      allowNull: false,
      comment: "Calculado por Vara (Final - Inicial)",
    },

    // --- MEDICIÓN FLUJÓMETRO (DINÁMICA) ---
    litros_flujometro: {
      type: DataTypes.DECIMAL(12, 2),
      allowNull: true, // Opcional, por si el equipo falla o no tiene
      comment: "Lectura del contador de flujo al descargar",
    },
    diferencia_vara_flujometro: {
      type: DataTypes.DECIMAL(12, 2),
      allowNull: true,
      comment: "Vara - Flujómetro. (Positivo = Vara marcó más)",
    },

    // --- COMPARACIÓN GUÍA ---
    litros_segun_guia: { type: DataTypes.DECIMAL(12, 2), allowNull: false },
    litros_faltantes: {
      type: DataTypes.DECIMAL(12, 2),
      allowNull: false,
      comment: "Guía - Recibido Real",
    },

    // --- DATOS DE PESAJE ---
    peso_entrada: { type: DataTypes.DECIMAL(12, 2), allowNull: true },
    peso_salida: { type: DataTypes.DECIMAL(12, 2), allowNull: true },
    peso_neto: { type: DataTypes.DECIMAL(12, 2), allowNull: true },

    // --- TIEMPOS DE DESCARGA ---
    hora_inicio_descarga: { type: DataTypes.TIME, allowNull: true },
    hora_fin_descarga: { type: DataTypes.TIME, allowNull: true },
    tiempo_descarga_minutos: { type: DataTypes.INTEGER, allowNull: true },

    // Auditoría
    observacion: { type: DataTypes.TEXT, allowNull: true },
    id_usuario: { type: DataTypes.INTEGER, allowNull: false },
    id_cierre: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },

    estado: {
      type: DataTypes.ENUM("PROCESADO", "ANULADO"),
      defaultValue: "PROCESADO",
    },
    fecha_registro: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
  },
  { tableName: "cargas_cisterna", timestamps: false }
);

module.exports = CargaCisterna;
