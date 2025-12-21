const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const Tanque = sequelize.define(
  "Tanque",
  {
    id_tanque: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    codigo: {
      type: DataTypes.STRING(20),
      allowNull: false,
      unique: false, // Ej: TQ-01
      comment: "Identificador único rotulado en el tanque",
    },
    nombre: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    tabla_aforo: {
      type: DataTypes.JSON,
      allowNull: true,
      comment: 'Objeto JSON con la calibración: { "medida": volumen }',
    },
    unidad_medida: {
      type: DataTypes.ENUM("CM", "PULGADAS"),
      allowNull: false,
      defaultValue: "CM",
      comment:
        "Define en qué unidad está expresada la tabla de aforo y la vara",
    },
    ubicacion: {
      type: DataTypes.STRING(150),
      allowNull: false,
    },
    tipo_combustible: {
      type: DataTypes.ENUM("GASOIL", "GASOLINA"),
      allowNull: false,
    },
    // Usamos DECIMAL(10,2) para permitir hasta 99,999,999.99 litros
    capacidad_maxima: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
    },
    nivel_actual: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      defaultValue: 0.0,
    },
    nivel_alarma: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      defaultValue: 500.0,
      comment: "Nivel mínimo para lanzar alerta de reabastecimiento",
    },
    radio: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: true,
    },
    largo: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: true,
    },
    longitud: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: true,
    },
    estado: {
      type: DataTypes.ENUM("ACTIVO", "INACTIVO", "MANTENIMIENTO"),
      defaultValue: "ACTIVO",
    },
    tipo_jerarquia: {
      type: DataTypes.ENUM("PRINCIPAL", "AUXILIAR"),
      allowNull: false,
      defaultValue: "AUXILIAR",
      comment: "Define si es el tanque madre o uno de reserva",
    },
    // --- AUDITORÍA ---
    fecha_registro: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
    fecha_modificacion: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
    registrado_por: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
  },
  {
    tableName: "tanques",
    timestamps: false,
  }
);

module.exports = Tanque;
