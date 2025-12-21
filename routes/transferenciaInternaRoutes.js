const express = require("express");
const router = express.Router();
const transferenciaInternaController = require("../controllers/transferenciaInternaController");
const authMiddleware = require("../middlewares/authMiddleware");

// Todas las rutas requieren autenticación
router.use(authMiddleware);

router.post("/", transferenciaInternaController.crearTransferencia);
router.get("/", transferenciaInternaController.obtenerTransferencias);

module.exports = router;
