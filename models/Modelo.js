const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const Modelo = sequelize.define(
  "Modelo",
  {
    id_modelo: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    nombre: {
      type: DataTypes.STRING(50),
      allowNull: false,
    },
    // Clave foránea explícita
    id_marca: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    estado: {
      type: DataTypes.ENUM("ACTIVO", "INACTIVO"),
      defaultValue: "ACTIVO",
    },
    // --- CAMPOS DE AUDITORÍA ---
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
      allowNull: true, // ID del Admin
    },
  },
  {
    tableName: "modelos",
    timestamps: false,
  }
);

module.exports = Modelo;
