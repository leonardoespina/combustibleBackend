const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const controller = require("../controllers/cargaCisternaController");
const authMiddleware = require("../middlewares/authMiddleware");
const validarCampos = require("../middlewares/validationMiddleware");

router.use(authMiddleware);

router.get("/", controller.obtenerCargasCisterna);

router.post(
  "/",
  [
    check("numero_guia", "Guía requerida").not().isEmpty(),
    check("id_vehiculo", "Cisterna requerida").isNumeric(),
    check("fecha", "Fecha requerida").not().isEmpty(),
    check("hora", "Hora requerida").not().isEmpty(),
    check("id_tanque", "Tanque requerido").isNumeric(),
    check("id_almacenista", "Almacenista requerido").isNumeric(),

    // Medidas Vara
    check("medida_inicial", "Medida inicial numérica").isNumeric(),
    check("medida_final", "Medida final numérica").isNumeric(),

    // Documento
    check("litros_segun_guia", "Litros guía numéricos").isNumeric(),

    // Flujómetro (Opcional pero debe ser numérico si viene)
    check("litros_flujometro")
      .optional({ nullable: true, checkFalsy: true })
      .isNumeric(),

    validarCampos,
  ],
  controller.crearCargaCisterna
);

router.put(
  "/:id",
  [check("numero_guia").optional().notEmpty(), validarCampos],
  controller.actualizarCargaCisterna
);
router.delete("/:id", controller.anularCargaCisterna);

module.exports = router;
