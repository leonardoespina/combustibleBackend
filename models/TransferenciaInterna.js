const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const TransferenciaInterna = sequelize.define(
  "TransferenciaInterna",
  {
    id_transferencia: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    id_tanque_origen: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "tanques",
        key: "id_tanque",
      },
    },
    id_tanque_destino: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "tanques",
        key: "id_tanque",
      },
    },
    id_almacenista: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "almacenistas",
        key: "id_almacenista",
      },
    },
    id_usuario: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "usuarios",
        key: "id_usuario",
      },
    },
    hora_inicio: {
      type: DataTypes.DATE,
      allowNull: false,
      comment: "Momento exacto en que comienza la transferencia",
    },
    litros_antes_origen: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      comment: "Cantidad de litros en el tanque origen antes de la operación",
    },
    litros_despues_destino: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      comment:
        "Cantidad de litros en el tanque destino después de completar la transferencia",
    },
    litros_transferidos: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
      comment: "Cantidad de litros efectivamente transferidos",
    },
    medida_vara_destino: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: true,
      comment: "Medida de vara final en el tanque destino",
    },
    observacion: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    fecha_registro: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
  },
  {
    tableName: "transferencias_internas",
    timestamps: false,
  }
);

module.exports = TransferenciaInterna;
