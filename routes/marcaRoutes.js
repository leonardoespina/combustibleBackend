const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const marcaController = require("../controllers/marcaController");
const authMiddleware = require("../middlewares/authMiddleware");
const validarCampos = require("../middlewares/validationMiddleware");

// Todas las rutas de marcas requieren estar logueado
router.use(authMiddleware);

// GET /api/marcas - Listar y Buscar
router.get("/", marcaController.obtenerMarcas);

// POST /api/marcas - Crear
router.post(
  "/",
  [
    check("nombre", "El nombre de la marca es obligatorio").not().isEmpty(),
    validarCampos,
  ],
  marcaController.crearMarca
);

// PUT /api/marcas/:id - Modificar
router.put(
  "/:id",
  [
    check("nombre", "El nombre no puede estar vacío")
      .optional()
      .not()
      .isEmpty(),
    validarCampos,
  ],
  marcaController.actualizarMarca
);

// DELETE /api/marcas/:id - Desactivar
router.delete("/:id", marcaController.desactivarMarca);

router.get("/lista", marcaController.obtenerListaMarcas);

module.exports = router;
