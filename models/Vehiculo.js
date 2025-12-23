const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const Vehiculo = sequelize.define(
  "Vehiculo",
  {
    id_vehiculo: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    placa: {
      type: DataTypes.STRING(20),
      allowNull: false,
      unique: false, // Las placas son únicas
    },
    anio: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    color: {
      type: DataTypes.STRING(30),
      allowNull: true,
    },
    id_gerencia: {
      type: DataTypes.INTEGER,
      allowNull: true, // Puede ser null si el carro no está asignado aún
    },
    es_generador: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
      comment:
        "TRUE si es planta eléctrica/generador, FALSE si es vehículo flota",
    },
    tipoCombustible: {
      type: DataTypes.ENUM("GASOLINA", "GASOIL"),
      defaultValue: "GASOIL",
      allowNull: false,
    },

    // Relaciones
    id_marca: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    id_modelo: {
      type: DataTypes.INTEGER,
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
    tableName: "vehiculos",
    timestamps: false,
  }
);

module.exports = Vehiculo;
