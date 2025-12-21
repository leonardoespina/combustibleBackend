const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const CierreInventario = sequelize.define(
  "CierreInventario",
  {
    id_cierre: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    // AGRUPADOR: Identifica todos los registros de un mismo evento de cierre
    grupo_cierre_uuid: {
      type: DataTypes.STRING(36), // UUID
      allowNull: false,
    },
    // ENCABEZADO
    tipo_combustible_cierre: {
      type: DataTypes.STRING(20), // 'GASOIL' o 'GASOLINA'
      allowNull: false,
    },
    turno: {
      type: DataTypes.ENUM("DIURNO", "NOCTURNO"),
      allowNull: false,
    },
    fecha_cierre: {
      type: DataTypes.DATE,
      allowNull: false,
    },
    id_usuario: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },

    // --- DATOS POR TANQUE ---
    id_tanque: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },

    // --- MÉTRICAS CALCULADAS ---
    saldo_inicial_real: {
      type: DataTypes.DECIMAL(12, 2),
      allowNull: false,
    },
    total_entradas_cisterna: {
      type: DataTypes.DECIMAL(12, 2),
      defaultValue: 0,
    },
    consumo_planta_merma: {
      // Unifica el concepto de 'diferencia'
      type: DataTypes.DECIMAL(12, 2),
      defaultValue: 0,
    },
    consumo_despachos_total: {
      type: DataTypes.DECIMAL(12, 2),
      defaultValue: 0,
    },
    saldo_final_real: {
      type: DataTypes.DECIMAL(12, 2),
      allowNull: false,
    },

    // JSON para guardar el desglose de despachos de ese tanque
    snapshot_desglose_despachos: {
      type: DataTypes.JSON,
      allowNull: true,
    },
    observacion: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
  },
  {
    tableName: "cierres_inventario",
    timestamps: false,
  }
);

module.exports = CierreInventario;
