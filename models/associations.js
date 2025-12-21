const Usuario = require("./Usuario");
const Marca = require("./Marca");
const Modelo = require("./Modelo");
const Vehiculo = require("./Vehiculo");
const Tanque = require("./Tanque");
const Chofer = require("./Chofer");
const Gerencia = require("./Gerencia");
const Almacenista = require("./Almacenista");
const Despacho = require("./Despacho");
const Dispensador = require("./Dispensador");
const CargaCisterna = require("./CargaCisterna");
const MedicionTanque = require("./MedicionTanque");
const CierreInventario = require("./CierreInventario");
const TransferenciaInterna = require("./TransferenciaInterna");

// ============================================================
// DEFINIR ASOCIACIONES
// ============================================================

// --- FLOTA (Marcas, Modelos, Vehículos) ---
Marca.hasMany(Modelo, { foreignKey: "id_marca" });
Modelo.belongsTo(Marca, { foreignKey: "id_marca" });

Marca.hasMany(Vehiculo, { foreignKey: "id_marca" });
Vehiculo.belongsTo(Marca, { foreignKey: "id_marca" });

Modelo.hasMany(Vehiculo, { foreignKey: "id_modelo" });
Vehiculo.belongsTo(Modelo, { foreignKey: "id_modelo" });

Gerencia.hasMany(Vehiculo, { foreignKey: "id_gerencia" });
Vehiculo.belongsTo(Gerencia, { foreignKey: "id_gerencia" });

// --- TANQUES Y DISPENSADORES ---
Tanque.hasMany(Dispensador, { foreignKey: "id_tanque_asociado" });
Dispensador.belongsTo(Tanque, {
  as: "TanqueAsociado",
  foreignKey: "id_tanque_asociado",
});

// --- CISTERNA Y CARGAS ---
Vehiculo.hasMany(CargaCisterna, { foreignKey: "id_vehiculo" });
CargaCisterna.belongsTo(Vehiculo, { foreignKey: "id_vehiculo" });

Tanque.hasMany(CargaCisterna, { foreignKey: "id_tanque" });
CargaCisterna.belongsTo(Tanque, { foreignKey: "id_tanque" });

Almacenista.hasMany(CargaCisterna, { foreignKey: "id_almacenista" });
CargaCisterna.belongsTo(Almacenista, { foreignKey: "id_almacenista" });

Usuario.hasMany(CargaCisterna, { foreignKey: "id_usuario" });
CargaCisterna.belongsTo(Usuario, { foreignKey: "id_usuario" });

// --- DESPACHOS ---
Dispensador.hasMany(Despacho, { foreignKey: "id_dispensador" });
Despacho.belongsTo(Dispensador, { foreignKey: "id_dispensador" });

Vehiculo.hasMany(Despacho, { foreignKey: "id_vehiculo" });
Despacho.belongsTo(Vehiculo, { foreignKey: "id_vehiculo" });

Gerencia.hasMany(Despacho, { foreignKey: "id_gerencia" });
Despacho.belongsTo(Gerencia, { foreignKey: "id_gerencia" });

Almacenista.hasMany(Despacho, { foreignKey: "id_almacenista" });
Despacho.belongsTo(Almacenista, { foreignKey: "id_almacenista" });

Usuario.hasMany(Despacho, { foreignKey: "id_usuario" });
Despacho.belongsTo(Usuario, { foreignKey: "id_usuario" });

Chofer.hasMany(Despacho, { foreignKey: "id_chofer" });
Despacho.belongsTo(Chofer, { foreignKey: "id_chofer" });

// --- MEDICIONES TANQUE ---
Tanque.hasMany(MedicionTanque, { foreignKey: "id_tanque" });
MedicionTanque.belongsTo(Tanque, { foreignKey: "id_tanque" });

Usuario.hasMany(MedicionTanque, { foreignKey: "id_usuario" });
MedicionTanque.belongsTo(Usuario, { foreignKey: "id_usuario" });

// --- CIERRE DE INVENTARIO ---
// Relaciones para el Cierre
Tanque.hasMany(CierreInventario, { foreignKey: "id_tanque" });
CierreInventario.belongsTo(Tanque, { foreignKey: "id_tanque" });

Usuario.hasMany(CierreInventario, { foreignKey: "id_usuario" });
CierreInventario.belongsTo(Usuario, { foreignKey: "id_usuario" });

// Un Cierre agrupa muchos despachos
CierreInventario.hasMany(Despacho, { foreignKey: "id_cierre" });
Despacho.belongsTo(CierreInventario, { foreignKey: "id_cierre" });

// Un Cierre agrupa muchas cargas
CierreInventario.hasMany(CargaCisterna, { foreignKey: "id_cierre" });
CargaCisterna.belongsTo(CierreInventario, { foreignKey: "id_cierre" });

// Un Cierre agrupa muchas mediciones
CierreInventario.hasMany(MedicionTanque, { foreignKey: "id_cierre" });
MedicionTanque.belongsTo(CierreInventario, { foreignKey: "id_cierre" });

// --- TRANSFERENCIAS INTERNAS ---
Tanque.hasMany(TransferenciaInterna, {
  as: "TransferenciasOrigen",
  foreignKey: "id_tanque_origen",
});
TransferenciaInterna.belongsTo(Tanque, {
  as: "TanqueOrigen",
  foreignKey: "id_tanque_origen",
});

Tanque.hasMany(TransferenciaInterna, {
  as: "TransferenciasDestino",
  foreignKey: "id_tanque_destino",
});
TransferenciaInterna.belongsTo(Tanque, {
  as: "TanqueDestino",
  foreignKey: "id_tanque_destino",
});

Almacenista.hasMany(TransferenciaInterna, { foreignKey: "id_almacenista" });
TransferenciaInterna.belongsTo(Almacenista, { foreignKey: "id_almacenista" });

Usuario.hasMany(TransferenciaInterna, { foreignKey: "id_usuario" });
TransferenciaInterna.belongsTo(Usuario, { foreignKey: "id_usuario" });

module.exports = {
  Usuario,
  Marca,
  Modelo,
  Vehiculo,
  Tanque,
  Chofer,
  Gerencia,
  Almacenista,
  Despacho,
  Dispensador,
  CargaCisterna,
  MedicionTanque,
  CierreInventario,
  TransferenciaInterna,
};
