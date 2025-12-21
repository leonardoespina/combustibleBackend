// tankMath.js
// Esta función es pura: entra altura, sale volumen. No depende del DOM ni de la BD.

const calcularVolumenTanque = (h, L, R) => {
  // Validaciones de seguridad física
  if (h < 0) return 0;
  if (h > 2 * R) h = 2 * R; // O lanzar error, depende de tu lógica

  // Fórmula del segmento circular
  const term1 = (Math.PI * Math.pow(R, 2)) / 2;
  const term2 = (h - R) * Math.sqrt(2 * R * h - Math.pow(h, 2));

  // Evitar NaN si h es exactamente 0 o 2R por redondeo
  let term3 = 0;
  // La parte del arcoseno puede fallar si el argumento es > 1 o < -1 por decimales ínfimos
  const argumentoAsin = (h - R) / R;

  if (argumentoAsin >= 1) {
    term3 = Math.pow(R, 2) * (Math.PI / 2); // 90 grados
  } else if (argumentoAsin <= -1) {
    term3 = Math.pow(R, 2) * (-Math.PI / 2); // -90 grados
  } else {
    term3 = Math.pow(R, 2) * Math.asin(argumentoAsin);
  }

  const volumenM3 = L * (term1 + term2 + term3);
  return volumenM3 * 1000; // Retorna Litros
};

module.exports = { calcularVolumenTanque };
