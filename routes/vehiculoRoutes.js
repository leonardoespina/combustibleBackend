const express = require("express");
const router = express.Router();
const { check } = require("express-validator");
const vehiculoController = require("../controllers/vehiculoController");
const authMiddleware = require("../middlewares/authMiddleware");
const validarCampos = require("../middlewares/validationMiddleware");

router.use(authMiddleware);

router.get("/", vehiculoController.obtenerVehiculos);
router.get("/lista", vehiculoController.obtenerListaVehiculos);

router.post(
  "/",
  [
    check("placa", "La placa es obligatoria").not().isEmpty(),
    check("anio", "El año es obligatorio").isNumeric(),
    check("id_marca", "La marca es obligatoria").isNumeric(),
    check("id_modelo", "El modelo es obligatorio").isNumeric(),
    check("es_generador").optional().isBoolean(),
    // Validar que si envían gerencia, sea un número
    check("id_gerencia", "El ID de gerencia debe ser numérico")
      .optional({ nullable: true })
      .isNumeric(),
    validarCampos,
  ],
  vehiculoController.crearVehiculo
);

router.put(
  "/:id",
  [
    check("placa", "La placa no puede estar vacía").optional().not().isEmpty(),
    check("es_generador").optional().isBoolean(),
    check("id_gerencia", "El ID de gerencia debe ser numérico")
      .optional({ nullable: true })
      .isNumeric(),
    validarCampos,
  ],
  vehiculoController.actualizarVehiculo
);

router.delete("/:id", vehiculoController.desactivarVehiculo);
router.get(
  "/listas/modelos/:id_marca",
  vehiculoController.obtenerModelosPorMarca
);

module.exports = router;
