const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const Chofer = sequelize.define(
  "Chofer",
  {
    id_chofer: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    nombre: {
      type: DataTypes.STRING(50),
      allowNull: false,
    },
    apellido: {
      type: DataTypes.STRING(50),
      allowNull: false,
    },
    cedula: {
      type: DataTypes.STRING(20),
      allowNull: false,
      unique: false,
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
    tableName: "choferes",
    timestamps: false,
  }
);

module.exports = Chofer;
