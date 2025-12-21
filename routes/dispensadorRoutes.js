const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const controller = require("../controllers/dispensadorController");
const authMiddleware = require("../middlewares/authMiddleware");
const validarCampos = require("../middlewares/validationMiddleware");

router.use(authMiddleware);

router.get("/", controller.obtenerDispensadores);
router.get("/lista", controller.obtenerListaDispensadores);
router.post(
  "/",
  [
    check("nombre", "Nombre requerido").not().isEmpty(),
    check("id_tanque_asociado", "Tanque requerido").isNumeric(),
    validarCampos,
  ],
  controller.crearDispensador
);
router.put("/:id", controller.actualizarDispensador);
router.delete("/:id", controller.desactivarDispensador);

module.exports = router;
