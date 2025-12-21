const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const Dispensador = sequelize.define(
  "Dispensador",
  {
    id_dispensador: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    nombre: {
      type: DataTypes.STRING(100),
      allowNull: false,
      comment: "Identificador ej: Surtidor Gasolina 01",
    },
    odometro_actual: {
      type: DataTypes.DECIMAL(12, 2),
      allowNull: false,
      defaultValue: 0,
      comment: "Lectura acumulada del contador mecánico",
    },
    id_tanque_asociado: {
      type: DataTypes.INTEGER,
      allowNull: false,
      comment: "De qué tanque descuenta el inventario",
    },
    estado: {
      type: DataTypes.ENUM("ACTIVO", "INACTIVO"),
      defaultValue: "ACTIVO",
    },
    // Auditoría
    registrado_por: { type: DataTypes.INTEGER },
    fecha_registro: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
    fecha_modificacion: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
  },
  { tableName: "dispensadores", timestamps: false }
);

module.exports = Dispensador;
