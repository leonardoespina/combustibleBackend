const express = require("express");
const router = express.Router();
const controller = require("../controllers/cierreInventarioController");
const authMiddleware = require("../middlewares/authMiddleware");
const { check } = require("express-validator");
const validarCampos = require("../middlewares/validationMiddleware");

router.use(authMiddleware);

// Endpoint principal para generar un nuevo cierre
router.post(
  "/",
  [
    //check("fecha", "La fecha es obligatoria").not().isEmpty(),
    //check("hora", "La hora es obligatoria").not().isEmpty(),
    check("turno", "Debe seleccionar un turno").isIn(["DIURNO", "NOCTURNO"]),
    validarCampos,
  ],
  controller.generarActaDeCierre
);

// Endpoint para ver la lista de cierres generados
router.get("/", controller.obtenerHistorialActas);

// Endpoint para obtener los datos formateados de un acta específica para el PDF
router.get("/acta/:grupo_uuid", controller.obtenerDatosParaActaPDF);

// Endpoint para anular/revertir un acta de cierre
router.delete("/revertir/:grupo_uuid", controller.revertirActaDeCierre);

module.exports = router;
