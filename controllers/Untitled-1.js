// =================================================================
// 1. VALIDACIÓN DE VIGENCIA DE MEDICIÓN (NUEVO)
// =================================================================
const ultimaMedicionReal = await MedicionTanque.findOne({
  where: { id_tanque: tanque.id_tanque, estado: "PROCESADO" },
  order: [["fecha_hora_medicion", "DESC"]],
});

if (!ultimaMedicionReal) {
  // Si nunca se ha medido, obligamos a medir para iniciar el sistema
  throw new Error(
    `El tanque '${tanque.nombre}' no tiene ninguna medición registrada. Debe realizar una medición inicial.`
  );
}

// Calculamos la diferencia en minutos
// Usamos la fecha de cierre que mandó el usuario vs la fecha de la medición
const diffTiempo = Math.abs(
  fechaCierre - new Date(ultimaMedicionReal.fecha_hora_medicion)
);
const diffMinutos = Math.floor(diffTiempo / 1000 / 60);
const UMBRAL_MINUTOS = 30; // Tiempo máximo permitido

if (diffMinutos > UMBRAL_MINUTOS) {
  throw new Error(
    `La última medición del tanque '${tanque.nombre}' fue hace ${diffMinutos} minutos. Es muy antigua (Máx ${UMBRAL_MINUTOS} min). Realice una nueva medición para cerrar.`
  );
}
