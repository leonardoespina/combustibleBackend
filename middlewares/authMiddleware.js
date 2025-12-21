const jwt = require('jsonwebtoken');

module.exports = (req, res, next) => {
    const token = req.header('Authorization')?.split(' ')[1];

    if (!token) {
        return res.status(401).json({ msg: 'No hay token, permiso denegado' });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.usuario = decoded; // Aquí guardamos { id_usuario, tipo_usuario... }
        next();
    } catch (error) {
        res.status(401).json({ msg: 'Token no válido' });
    }
};