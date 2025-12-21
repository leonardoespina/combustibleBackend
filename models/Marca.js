const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const Marca = sequelize.define(
  "Marca",
  {
    id_marca: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    nombre: {
      type: DataTypes.STRING(50),
      allowNull: false,
      unique: false,
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
      allowNull: true, // Guardará el ID del Admin que creó la marca
    },
  },
  {
    tableName: "marcas",
    timestamps: false,
  }
);

module.exports = Marca;
