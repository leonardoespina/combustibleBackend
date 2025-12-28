// app.js (CORREGIDO)

const express = require("express");
const cors = require("cors");
const { dbConnect } = require("./config/database");
require("dotenv").config();

// ============================================================
// 1. CARGAR MODELOS Y ASOCIACIONES
// ============================================================
require("./models/associations");

const app = express();

// ============================================================
// 2. CONFIGURACIÓN DEL SERVIDOR
// ============================================================
const whitelist = [
  "http://10.60.6.57:5173",
  "http://localhost:5173",
  "http://192.168.1.106:5173",
  "http://10.60.7.97:5173",
];

const corsOptions = {
  origin: function (origin, callback) {
    if (!origin) return callback(null, true);
    if (whitelist.indexOf(origin) !== -1) {
      callback(null, true);
    } else {
      callback(new Error("No permitido por CORS"));
    }
  },
  methods: "GET,HEAD,PUT,PATCH,POST,DELETE",
  credentials: true,
};

// Conexión BD
dbConnect();

// Middlewares
app.use(cors(corsOptions));
app.use(express.json());

// ============================================================
// 3. RUTAS
// ============================================================
app.use("/api/usuarios", require("./routes/usuarioRoutes"));
app.use("/api/marcas", require("./routes/marcaRoutes"));
app.use("/api/modelos", require("./routes/modeloRoutes"));
app.use("/api/vehiculos", require("./routes/vehiculoRoutes"));
app.use("/api/gerencias", require("./routes/gerenciaRoutes"));
app.use("/api/tanques", require("./routes/tanqueRoutes"));
app.use("/api/almacenistas", require("./routes/almacenistaRoutes"));
app.use("/api/choferes", require("./routes/choferRoutes"));
app.use("/api/despachos", require("./routes/despachoRoutes"));
app.use("/api/dispensadores", require("./routes/dispensadorRoutes"));
app.use("/api/cargas-cisterna", require("./routes/cargaCisternaRoutes"));
//app.use("/api/mediciones-tanque", require("./routes/medicionTanqueRoutes"));
app.use("/api/mediciones", require("./routes/medicionTanqueRoutes"));
app.use("/api/cierres", require("./routes/cierreInventarioRoutes"));
app.use("/api/reportes", require("./routes/reporteRoutes"));
app.use(
  "/api/transferencias-internas",
  require("./routes/transferenciaInternaRoutes")
);

// Arranque
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Servidor Inventario corriendo en puerto ${PORT}`);
});
