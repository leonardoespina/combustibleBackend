const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const gerenciaController = require("../controllers/gerenciaController");
const authMiddleware = require("../middlewares/authMiddleware");
const validarCampos = require("../middlewares/validationMiddleware");

router.use(authMiddleware);

// --- RUTAS PRINCIPALES ---
router.get("/", gerenciaController.obtenerGerencias);

// --- RUTA PARA DROPDOWN (Debe ir antes de /:id para que no confunda "lista" con un ID) ---
router.get("/lista", gerenciaController.obtenerListaGerencias);

// --- CRUD ---
router.post(
  "/",
  [
    check("nombre", "El nombre de la gerencia es obligatorio").not().isEmpty(),
    check("encargado_cedula", "La cédula del encargado es obligatoria")
      .not()
      .isEmpty(),
    check("encargado_nombre", "El nombre del encargado es obligatorio")
      .not()
      .isEmpty(),
    check("encargado_apellido", "El apellido del encargado es obligatorio")
      .not()
      .isEmpty(),
    check("encargado_telefono", "El teléfono del encargado es obligatorio")
      .not()
      .isEmpty(),
    check("correo", "Debe ser un correo válido").optional().isEmail(),
  ],
  gerenciaController.crearGerencia
);

router.put(
  "/:id",
  [
    check("nombre", "El nombre no puede estar vacío")
      .optional()
      .not()
      .isEmpty(),
    check("correo", "Debe ser un correo válido").optional().isEmail(),
  ],
  gerenciaController.actualizarGerencia
);

router.delete("/:id", gerenciaController.desactivarGerencia);

module.exports = router;
