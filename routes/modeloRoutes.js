const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const modeloController = require("../controllers/modeloController");
const authMiddleware = require("../middlewares/authMiddleware");
const validarCampos = require("../middlewares/validationMiddleware");

router.use(authMiddleware);

router.get("/", modeloController.obtenerModelos);

router.post(
  "/",
  [
    check("nombre", "El nombre es obligatorio").not().isEmpty(),
    check(
      "id_marca",
      "El ID de la marca es obligatorio y numérico"
    ).isNumeric(),
    validarCampos,
  ],
  modeloController.crearModelo
);

router.put(
  "/:id",
  [
    check("nombre", "El nombre no puede estar vacío")
      .optional()
      .not()
      .isEmpty(),
    check("id_marca", "ID de marca inválido").optional().isNumeric(),
    validarCampos,
  ],
  modeloController.actualizarModelo
);

router.delete("/:id", modeloController.desactivarModelo);

module.exports = router;
