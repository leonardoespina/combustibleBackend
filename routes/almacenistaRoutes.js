const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const almacenistaController = require("../controllers/almacenistaController");
const authMiddleware = require("../middlewares/authMiddleware");
const validarCampos = require("../middlewares/validationMiddleware");

router.use(authMiddleware);

// GET
router.get("/", almacenistaController.obtenerAlmacenistas);
router.get("/lista", almacenistaController.obtenerListaAlmacenistas); // Para Selects

// POST
router.post(
  "/",
  [
    check("nombre", "El nombre es obligatorio").not().isEmpty(),
    check("apellido", "El apellido es obligatorio").not().isEmpty(),
    check("cedula", "La cédula es obligatoria").not().isEmpty(),
    check("cargo", "El cargo es obligatorio").not().isEmpty(),
    check("telefono", "El teléfono es obligatorio").not().isEmpty(),
    validarCampos,
  ],
  almacenistaController.crearAlmacenista
);

// PUT
router.put(
  "/:id",
  [
    check("cedula", "La cédula no puede estar vacía")
      .optional()
      .not()
      .isEmpty(),
    validarCampos,
  ],
  almacenistaController.actualizarAlmacenista
);

// DELETE
router.delete("/:id", almacenistaController.desactivarAlmacenista);

module.exports = router;
