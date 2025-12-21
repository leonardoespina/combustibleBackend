const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const tanqueController = require("../controllers/tanqueController");
const authMiddleware = require("../middlewares/authMiddleware");
const validarCampos = require("../middlewares/validationMiddleware");

router.use(authMiddleware);

// GET
router.get("/", tanqueController.obtenerTanques); // Paginado
router.get("/lista", tanqueController.obtenerListaTanques); // Lista simple
router.get("/:id", tanqueController.obtenerTanquePorId); // Detalle (con aforo)

// POST (Crear)
router.post(
  "/",
  [
    check("codigo", "El código es obligatorio").not().isEmpty(),
    check("nombre", "El nombre es obligatorio").not().isEmpty(),
    check("capacidad_maxima", "La capacidad es obligatoria").isNumeric(),
    check("tipo_combustible", "Debe ser GASOIL o GASOLINA").isIn([
      "GASOIL",
      "GASOLINA",
    ]),
    check("tipo_jerarquia", "Debe ser PRINCIPAL o AUXILIAR").isIn([
      "PRINCIPAL",
      "AUXILIAR",
    ]),

    validarCampos,
    check("unidad_medida", "Debe ser CM o PULGADAS").isIn(["CM", "PULGADAS"]),
    validarCampos,
  ],
  tanqueController.crearTanque
);

// PUT (Actualizar)
router.put(
  "/:id",
  [
    check("capacidad_maxima", "Debe ser numérico").optional().isNumeric(),
    validarCampos,
  ],
  tanqueController.actualizarTanque
);

// DELETE
router.delete("/:id", tanqueController.desactivarTanque);

module.exports = router;
