const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const usuarioController = require("../controllers/usuarioController");
const authMiddleware = require("../middlewares/authMiddleware");
const validarCampos = require("../middlewares/validationMiddleware");

// --- RUTAS PÚBLICAS ---

// POST /api/usuarios/login (Login)
router.post(
  "/login",
  [
    check("cedula", "La cédula es obligatoria").not().isEmpty(),
    check("password", "El password es obligatorio").exists(),
    validarCampos,
  ],
  usuarioController.loginUsuario
);

// --- RUTAS PROTEGIDAS (Requieren Token) ---
// Nota: La validación de si es ADMIN se hace dentro del controlador

// GET /api/usuarios (Listar)
router.get("/", authMiddleware, usuarioController.obtenerUsuarios);

// POST /api/usuarios (Crear)
router.post(
  "/",
  [
    authMiddleware, // Ahora es protegido
    check("nombre", "El nombre es obligatorio").not().isEmpty(),
    check("apellido", "El apellido es obligatorio").not().isEmpty(),
    check("cedula", "La cédula es obligatoria").not().isEmpty(),
    check("password", "Mínimo 6 caracteres").isLength({ min: 6 }),
    validarCampos,
  ],
  usuarioController.crearUsuario
);

// PUT /api/usuarios/:id (Actualizar)
router.put(
  "/:id",
  [
    authMiddleware,
    check("nombre", "El nombre es obligatorio").optional().not().isEmpty(),
    check("apellido", "El apellido es obligatorio").optional().not().isEmpty(),
    // Si envían password, validamos longitud
    check("password", "Mínimo 6 caracteres").optional().isLength({ min: 6 }),
    validarCampos,
  ],
  usuarioController.actualizarUsuario
);

// DELETE /api/usuarios/:id (Desactivar)
router.delete("/:id", authMiddleware, usuarioController.desactivarUsuario);

module.exports = router;
