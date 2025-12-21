const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const choferController = require("../controllers/choferController");
const authMiddleware = require("../middlewares/authMiddleware");
const validarCampos = require("../middlewares/validationMiddleware");

router.use(authMiddleware);

// GET
router.get("/", choferController.obtenerChoferes);
router.get("/lista", choferController.obtenerListaChoferes); // <--- IMPORTANTE para el dropdown

// POST
router.post(
  "/",
  [
    check("nombre", "El nombre es obligatorio").not().isEmpty(),
    check("apellido", "El apellido es obligatorio").not().isEmpty(),
    check("cedula", "La cédula es obligatoria").not().isEmpty(),
    validarCampos,
  ],
  choferController.crearChofer
);

// PUT
router.put(
  "/:id",
  [
    check("nombre", "El nombre no puede estar vacío")
      .optional()
      .not()
      .isEmpty(),
    validarCampos,
  ],
  choferController.actualizarChofer
);

// DELETE
router.delete("/:id", choferController.desactivarChofer);

module.exports = router;
