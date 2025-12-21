const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const controller = require("../controllers/medicionTanqueController");
const authMiddleware = require("../middlewares/authMiddleware");
const validarCampos = require("../middlewares/validationMiddleware");

router.use(authMiddleware);

// LEER
router.get("/", controller.obtenerMediciones);

// CREAR
router.post(
  "/",
  [
    check("id_tanque", "Debe seleccionar un tanque").isNumeric(),
    check("fecha", "La fecha es obligatoria").not().isEmpty(),
    check("hora", "La hora es obligatoria").not().isEmpty(),
    // medida_vara y litros_manuales_ingresados son opcionales porque dependen del modo
    check("medida_vara").optional().isNumeric(),
    check("litros_manuales_ingresados").optional().isNumeric(),
    check("litros_evaporacion").optional().isNumeric(),
    validarCampos,
  ],
  controller.registrarMedicion
);

// ELIMINAR / ANULAR (Solo Admin)
router.delete("/:id", controller.anularMedicion);

module.exports = router;
