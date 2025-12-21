const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const Gerencia = sequelize.define(
  "Gerencia",
  {
    id_gerencia: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    nombre: {
      type: DataTypes.STRING(100),
      allowNull: false,
      unique: false, // No pueden haber dos gerencias con el mismo nombre
    },
    // --- DATOS DEL ENCARGADO ---
    encargado_cedula: {
      type: DataTypes.STRING(20),
      allowNull: false,
    },
    encargado_nombre: {
      type: DataTypes.STRING(50),
      allowNull: false,
    },
    encargado_apellido: {
      type: DataTypes.STRING(50),
      allowNull: false,
    },
    encargado_telefono: {
      type: DataTypes.STRING(20),
      allowNull: false,
    },
    correo: {
      type: DataTypes.STRING(100),
      allowNull: true, // Opcional
    },
    estado: {
      type: DataTypes.ENUM("ACTIVO", "INACTIVO"),
      defaultValue: "ACTIVO",
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
    tableName: "gerencias",
    timestamps: false,
  }
);

module.exports = Gerencia;
