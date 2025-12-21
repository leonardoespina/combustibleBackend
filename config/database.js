const { Sequelize } = require("sequelize");
require("dotenv").config();

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASS,
  {
    host: process.env.DB_HOST,
    dialect: "mysql",
    timezone: "-04:00",
    logging: false, // Desactiva logs de SQL en consola para limpieza
  }
);

const dbConnect = async () => {
  try {
    await sequelize.authenticate();
    console.log("✅ Conexión a MySQL exitosa.");
    // Sincroniza modelos (crea tablas si no existen)
    await sequelize.sync({ alter: true });
    console.log("✅ Modelos sincronizados.");
  } catch (error) {
    console.error("❌ Error conectando a la BD:", error);
  }
};

module.exports = { sequelize, dbConnect };
