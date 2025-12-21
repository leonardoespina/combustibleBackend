const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const Almacenista = sequelize.define(
  "Almacenista",
  {
    id_almacenista: {
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
    cargo: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    telefono: {
      type: DataTypes.STRING(20),
      allowNull: false,
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
    tableName: "almacenistas",
    timestamps: false,
  }
);

module.exports = Almacenista;
