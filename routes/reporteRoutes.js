const express = require("express");
const router = express.Router();
const controller = require("../controllers/reporteController");
const authMiddleware = require("../middlewares/authMiddleware");

// Protegemos todas las rutas de reportes
router.use(authMiddleware);

// GET /api/reportes/pendientes
router.get("/pendientes", controller.obtenerDespachosPendientes);

// GET /api/reportes/consumo-gerencia?fechaInicio=YYYY-MM-DD&fechaFin=YYYY-MM-DD
router.get("/consumo-gerencia", controller.obtenerConsumoPorGerencia);

// GET /api/reportes/consumo-detallado-gerencia?fechaInicio=...&fechaFin=...&id_gerencia=...
router.get(
  "/consumo-detallado-gerencia",
  controller.obtenerReporteConsumoGerencia
);

// GET /api/reportes/consumo-vehiculo?fechaInicio=...&fechaFin=...&placa=...
router.get("/consumo-vehiculo", controller.obtenerConsumoPorVehiculo);

// GET /api/reportes/historial-cierres?fechaInicio=...&fechaFin=...
router.get("/historial-cierres", controller.obtenerHistorialCierreInventario);

// GET /api/reportes/historial-cierres/:grupo_uuid/despachos
router.get(
  "/historial-cierres/:grupo_uuid/despachos",
  controller.obtenerDetalleDespachosPorActa
);

module.exports = router;
