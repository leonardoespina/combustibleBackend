const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const Despacho = sequelize.define(
  "Despacho",
  {
    id_despacho: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    numero_ticket: {
      type: DataTypes.STRING(50),
      allowNull: false,
      unique: false,
    },
    fecha_hora: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
      allowNull: false,
    },

    // --- DISPENSADOR ---
    id_dispensador: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    odometro_previo: {
      type: DataTypes.DECIMAL(12, 2),
      allowNull: false,
    },
    odometro_final: {
      type: DataTypes.DECIMAL(12, 2),
      allowNull: false,
    },

    // --- CANTIDADES ---
    cantidad_solicitada: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
    },
    cantidad_despachada: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
    },

    // --- DESTINO ---
    tipo_destino: {
      type: DataTypes.ENUM("VEHICULO", "BIDON"),
      allowNull: false,
    },

    // Caso VEHICULO
    id_vehiculo: { type: DataTypes.INTEGER, allowNull: true },
    id_chofer: { type: DataTypes.INTEGER, allowNull: true },

    // Caso BIDON
    id_gerencia: { type: DataTypes.INTEGER, allowNull: true },

    // --- CAMPO NUEVO ---
    observacion: {
      type: DataTypes.TEXT, // Texto libre para notas adicionales
      allowNull: true, // Opcional
    },

    // --- AUDITORÍA ---
    id_almacenista: { type: DataTypes.INTEGER, allowNull: false },
    id_usuario: { type: DataTypes.INTEGER, allowNull: false },

    // CAMPO NUEVO: Para soportar cambios de tanque en dispensadores (Gasoil)
    id_tanque: {
      type: DataTypes.INTEGER,
      allowNull: true,
      comment: "ID del tanque al momento del despacho",
    },

    id_cierre: {
      type: DataTypes.INTEGER,
      allowNull: true, // Nace NULL (Pendiente). Se llena al cerrar.
      comment: "ID del cierre de inventario que procesó este movimiento",
    },

    estado: {
      type: DataTypes.ENUM("PROCESADO", "ANULADO"),
      defaultValue: "PROCESADO",
    },
  },
  { tableName: "despachos", timestamps: false }
);

module.exports = Despacho;
