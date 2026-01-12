const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const controller = require("../controllers/despachoController");
const authMiddleware = require("../middlewares/authMiddleware");
const validarCampos = require("../middlewares/validationMiddleware");

router.use(authMiddleware);

router.get("/", controller.obtenerDespachos);

router.post(
  "/",
  [
    check("numero_ticket", "Ticket requerido").not().isEmpty(),
    check("fecha", "Fecha requerida").not().isEmpty(),
    check("hora", "Hora requerida").not().isEmpty(),
    check("id_dispensador", "Dispensador requerido").isNumeric(),
    check("cantidad_solicitada", "Cantidad Solicitada numérica").isNumeric(),
    check("cantidad_despachada", "Cantidad Despachada numérica").isNumeric(),
    check("tipo_destino").isIn(["VEHICULO", "BIDON"]),
    check("id_almacenista", "Almacenista requerido").isNumeric(),

    // Validación Condicional: VEHICULO
    check("id_vehiculo")
      .if((value, { req }) => req.body.tipo_destino === "VEHICULO")
      .notEmpty()
      .withMessage("Vehículo requerido"),
    check("id_chofer")
      .if((value, { req }) => req.body.tipo_destino === "VEHICULO")
      .notEmpty()
      .withMessage("Chofer requerido"),

    // Validación Condicional: BIDON
    check("id_gerencia")
      .if((value, { req }) => req.body.tipo_destino === "BIDON")
      .notEmpty()
      .withMessage("Gerencia requerida para Bidón"),

    // Observación es opcional, no necesita check obligatorio.

    validarCampos,
  ],
  controller.registrarDespacho
);

router.put(
  "/:id",
  [
    check("cantidad_despachada", "Cantidad Despachada numérica")
      .optional()
      .custom((value) => {
        if (value === null || value === "") return true;
        return !isNaN(parseFloat(value));
      }),
    check("id_vehiculo")
      .optional()
      .custom((v) => v === null || !isNaN(v)),
    check("id_chofer")
      .optional()
      .custom((v) => v === null || !isNaN(v)),
    check("id_gerencia")
      .optional()
      .custom((v) => v === null || !isNaN(v)),
    check("id_almacenista")
      .optional()
      .custom((v) => v === null || !isNaN(v)),
    check("fecha").optional().notEmpty().withMessage("Fecha inválida"),
    check("hora").optional().notEmpty().withMessage("Hora inválida"),
    validarCampos,
  ],
  controller.editarDespacho
);

router.delete("/:id", controller.anularDespacho);

module.exports = router;
