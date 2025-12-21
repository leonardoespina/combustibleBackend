const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const MedicionTanque = sequelize.define(
  "MedicionTanque",
  {
    id_medicion: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    // RELACIONES
    id_tanque: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    id_usuario: {
      // Usuario que realizó el registro
      type: DataTypes.INTEGER,
      allowNull: false,
    },

    // FECHA Y HORA DE LA MEDICIÓN (Manual)
    fecha_hora_medicion: {
      type: DataTypes.DATE,
      allowNull: false,
    },

    // --- SNAPSHOT DEL SISTEMA (ANTES) ---
    nivel_sistema_anterior: {
      type: DataTypes.DECIMAL(12, 2),
      allowNull: false,
      comment: "Inventario teórico que tenía el software antes de medir",
    },

    // --- DATOS DE CAMPO (INPUT) ---
    // Para mediciones por AFORO
    medida_vara: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: true, // Nulo si es manual
      comment: "Altura leída en CM o Pulgadas",
    },
    // Para mediciones MANUALES
    litros_manuales_ingresados: {
      type: DataTypes.DECIMAL(12, 2),
      allowNull: true, // Nulo si es por aforo
      comment: "Litros ingresados manualmente por el usuario",
    },
    litros_evaporacion: {
      type: DataTypes.DECIMAL(10, 2),
      defaultValue: 0,
      comment: "Merma justificada por evaporación",
    },

    // --- RESULTADOS (CALCULADOS) ---
    litros_reales_aforo: {
      type: DataTypes.DECIMAL(12, 2),
      allowNull: true, // Nulo si es manual
      comment: "Volumen resultante según la tabla de aforo",
    },

    // Diferencia = (Sistema - Evaporación) - Realidad
    // Positivo (+): Faltante / Consumo.
    // Negativo (-): Sobrante.
    diferencia_neta: {
      type: DataTypes.DECIMAL(12, 2),
      allowNull: false,
    },

    // --- AUDITORÍA ---
    tipo_medicion: {
      type: DataTypes.ENUM("AFORO", "MANUAL"),
      allowNull: false,
      comment: "Indica si la medición se basó en tabla de aforo o fue manual",
    },
    observacion: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    estado: {
      type: DataTypes.ENUM("PROCESADO", "ANULADO"),
      defaultValue: "PROCESADO",
    },
    // Fecha técnica de inserción en BD
    fecha_registro: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
    id_cierre: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
  },
  {
    tableName: "mediciones_tanques",
    timestamps: false,
  }
);

module.exports = MedicionTanque;
