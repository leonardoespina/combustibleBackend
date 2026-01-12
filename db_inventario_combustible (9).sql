-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 12-01-2026 a las 16:56:46
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `db_inventario_combustible`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacenistas`
--

CREATE TABLE `almacenistas` (
  `id_almacenista` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `cedula` varchar(20) NOT NULL,
  `cargo` varchar(100) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_registro` datetime DEFAULT NULL,
  `fecha_modificacion` datetime DEFAULT NULL,
  `registrado_por` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `almacenistas`
--

INSERT INTO `almacenistas` (`id_almacenista`, `nombre`, `apellido`, `cedula`, `cargo`, `telefono`, `estado`, `fecha_registro`, `fecha_modificacion`, `registrado_por`) VALUES
(1, 'RAMON', 'BOLIVAR', '123456', 'ALMACENISTA 01', '0412345678', 'ACTIVO', '2025-11-23 12:58:56', '2026-01-12 07:18:12', 1),
(2, 'NOLAN', 'VELASQUEZ', '12543670', 'ALMACENISTA 01', '0412345687', 'ACTIVO', '2025-11-23 12:59:57', '2026-01-12 07:18:40', 1),
(3, 'JEAN FRANCO', 'DI GEMMA', '1234565', 'Almacenista 02', '435435435', 'ACTIVO', '2025-11-24 08:11:12', '2025-12-03 16:02:45', 1),
(4, 'Leonel', 'Granado', '1234567', 'Almacen', '04242334223', 'ACTIVO', '2025-12-07 15:37:29', '2025-12-07 15:37:29', 1),
(5, 'JHON', 'GARCIA', '3333333', 'ALMACENISTA 01', '222222', 'ACTIVO', '2025-12-08 14:22:58', '2025-12-08 14:22:58', 1),
(6, 'CARLOS', 'ACEVEDO', '12543678', 'ALMACENISTA I', '00000000', 'ACTIVO', '2025-12-27 08:32:56', '2025-12-27 08:32:56', 1),
(7, 'RONNY', 'RODRIGUEZ', '2321423', 'ALMACENISTA', '12312312', 'ACTIVO', '2026-01-05 09:18:26', '2026-01-12 07:17:54', 1),
(8, 'RONNY', 'GRANADOS', '234324', 'ALMACENISTA I', '242342', 'ACTIVO', '2026-01-05 13:12:52', '2026-01-05 13:12:52', 1),
(9, 'ANIBAL', 'FUENTES', '23242342', 'ALMACENISTA I', '000000000', 'ACTIVO', '2026-01-08 08:02:45', '2026-01-08 08:02:45', 1),
(10, 'CRISTIAN', 'VALLES', '21124239', 'ALMACENISTA II', '00000000000', 'ACTIVO', '2026-01-08 08:30:52', '2026-01-08 08:30:52', 1),
(11, 'PEDRO', 'RAMIREZ', '32431241', 'ALMACENISTA I', '00000000000', 'ACTIVO', '2026-01-08 09:04:42', '2026-01-08 09:04:42', 1),
(12, 'JOSMAR', 'ROJAS', '28086728', 'ALMACENISTA', '000000000', 'ACTIVO', '2026-01-12 07:17:41', '2026-01-12 07:17:41', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cargas_cisterna`
--

CREATE TABLE `cargas_cisterna` (
  `id_carga` int(11) NOT NULL,
  `numero_guia` varchar(50) NOT NULL,
  `id_vehiculo` int(11) NOT NULL,
  `id_tanque` int(11) NOT NULL,
  `id_almacenista` int(11) NOT NULL,
  `medida_inicial` decimal(10,2) DEFAULT NULL,
  `medida_final` decimal(10,2) DEFAULT NULL,
  `litros_iniciales` decimal(12,2) DEFAULT NULL,
  `litros_finales` decimal(12,2) DEFAULT NULL,
  `litros_recibidos_real` decimal(12,2) NOT NULL COMMENT 'Calculado por Vara (Final - Inicial)',
  `litros_flujometro` decimal(12,2) DEFAULT NULL COMMENT 'Lectura del contador de flujo al descargar',
  `diferencia_vara_flujometro` decimal(12,2) DEFAULT NULL COMMENT 'Vara - Flujómetro. (Positivo = Vara marcó más)',
  `litros_segun_guia` decimal(12,2) NOT NULL,
  `litros_faltantes` decimal(12,2) NOT NULL COMMENT 'Guía - Recibido Real',
  `observacion` text DEFAULT NULL,
  `id_usuario` int(11) NOT NULL,
  `estado` enum('PROCESADO','ANULADO') DEFAULT 'PROCESADO',
  `fecha_registro` datetime DEFAULT NULL,
  `id_cierre` int(11) DEFAULT NULL,
  `fecha_hora_llegada` datetime NOT NULL,
  `id_chofer` int(11) DEFAULT NULL,
  `fecha_emision` date DEFAULT NULL,
  `fecha_recepcion` date DEFAULT NULL,
  `tipo_combustible` varchar(20) DEFAULT NULL,
  `peso_entrada` decimal(12,2) DEFAULT NULL,
  `peso_salida` decimal(12,2) DEFAULT NULL,
  `peso_neto` decimal(12,2) DEFAULT NULL,
  `hora_inicio_descarga` time DEFAULT NULL,
  `hora_fin_descarga` time DEFAULT NULL,
  `tiempo_descarga_minutos` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cargas_cisterna`
--

INSERT INTO `cargas_cisterna` (`id_carga`, `numero_guia`, `id_vehiculo`, `id_tanque`, `id_almacenista`, `medida_inicial`, `medida_final`, `litros_iniciales`, `litros_finales`, `litros_recibidos_real`, `litros_flujometro`, `diferencia_vara_flujometro`, `litros_segun_guia`, `litros_faltantes`, `observacion`, `id_usuario`, `estado`, `fecha_registro`, `id_cierre`, `fecha_hora_llegada`, `id_chofer`, `fecha_emision`, `fecha_recepcion`, `tipo_combustible`, `peso_entrada`, `peso_salida`, `peso_neto`, `hora_inicio_descarga`, `hora_fin_descarga`, `tiempo_descarga_minutos`) VALUES
(2, '13212312', 5, 3, 3, 142.00, 200.00, 23565.11, 35566.00, 12000.89, NULL, NULL, 12000.00, -0.89, '', 1, 'PROCESADO', '2026-01-02 17:33:25', 425, '2026-01-02 17:30:00', 13, '2026-01-02', '2026-01-02', 'GASOIL', NULL, NULL, NULL, '08:00:00', '09:00:00', 60),
(5, '23234334', 24, 3, 3, 83.00, 205.00, 11467.25, 36426.16, 24958.91, NULL, NULL, 25000.00, 41.09, '', 1, 'PROCESADO', '2026-01-05 14:46:37', 545, '2026-01-05 14:44:00', 13, '2026-01-05', '2026-01-25', 'GASOIL', 2333.00, 234.00, 2099.00, '08:00:00', '09:00:00', 60),
(6, '13131313', 36, 3, 6, 148.00, 246.00, 24832.51, 43375.35, 18542.84, NULL, NULL, 38000.00, 19457.16, '', 1, 'PROCESADO', '2026-01-07 16:33:24', 597, '2026-01-07 16:25:00', 13, '2026-01-05', '2026-01-05', 'GASOIL', 48660.00, 16920.00, 31740.00, '08:00:00', '10:00:00', 120),
(7, '123231', 36, 8, 3, 89.10, 194.48, 12001.20, 31515.04, 19513.84, NULL, NULL, 19457.00, -56.84, '', 1, 'PROCESADO', '2026-01-07 16:40:19', 601, '2026-01-07 16:37:00', 13, '2026-01-07', '2026-01-07', 'GASOIL', 2424.00, 24234.00, -21810.00, '08:00:00', '09:00:00', 60),
(8, '131323', 23, 4, 6, 0.00, 124.57, 0.00, 36997.00, 36997.00, NULL, NULL, 36997.00, 0.00, '', 1, 'PROCESADO', '2026-01-07 18:22:54', 614, '2026-01-07 18:20:00', 13, '2026-01-07', '2026-01-07', 'GASOIL', 1232222.00, 12312.00, 1219910.00, '08:00:00', '09:00:00', 60),
(9, '123123123', 24, 6, 10, 42.00, 214.00, 4307.00, 34307.00, 30000.00, NULL, NULL, 39000.00, 9000.00, '', 1, 'PROCESADO', '2026-01-08 10:44:46', 647, '2026-01-08 10:41:00', 45, '2026-01-08', '2026-01-08', 'GASOLINA', NULL, NULL, NULL, '08:00:00', '09:00:00', 60),
(10, '12312313', 24, 2, 6, 3.98, 105.22, 78.00, 9078.00, 9000.00, NULL, NULL, 39000.00, 30000.00, '', 1, 'PROCESADO', '2026-01-08 10:48:04', 644, '2026-01-08 10:45:00', 17, '2026-01-08', '2026-01-08', 'GASOLINA', 3123.00, 12.00, 3111.00, '08:00:00', '09:00:00', 60),
(11, '3212312', 24, 4, 6, 131.00, 253.00, 38883.00, 75880.00, 36997.00, NULL, NULL, 36997.00, 0.00, '', 1, 'PROCESADO', '2026-01-08 14:00:03', 646, '2026-01-08 13:57:00', 61, '2026-01-08', '2026-01-08', 'GASOIL', 123.00, 2.00, 121.00, '08:00:00', '09:00:00', 60),
(12, '00-18634858', 24, 7, 8, 125.40, 365.00, 9992.00, 46996.00, 37004.00, NULL, NULL, 37004.00, 0.00, ' [ANULADO]', 1, 'ANULADO', '2026-01-09 09:57:07', NULL, '2026-01-09 09:50:00', 1, '2026-01-09', '2026-01-09', 'GASOLINA', 49.44, 18.64, 30.80, '21:00:00', '00:40:00', -1220),
(13, '00-186348581', 24, 3, 6, 75.21, 280.00, 9992.00, 46996.00, 37004.00, NULL, NULL, 37004.00, 0.00, '', 1, 'PROCESADO', '2026-01-09 10:04:09', 669, '2026-01-09 09:59:00', 13, '2026-01-09', '2026-01-09', 'GASOIL', 49.44, 18.64, 30.80, '21:00:00', '00:40:00', -1220),
(14, '312312', 23, 7, 6, 206.36, 289.00, 20726.00, 33720.00, 12994.00, NULL, NULL, 12994.00, 0.00, ' [ANULADO]', 1, 'ANULADO', '2026-01-11 19:23:52', NULL, '2026-01-11 19:11:00', 78, '2026-01-11', '2026-01-11', 'GASOLINA', NULL, NULL, NULL, '08:00:00', '09:00:00', 60),
(15, '131312', 23, 3, 6, 129.00, 188.00, 20726.00, 33720.00, 12994.00, NULL, NULL, 12994.00, 0.00, '', 1, 'PROCESADO', '2026-01-11 19:26:25', 717, '2026-01-11 19:24:00', 45, '2026-01-11', '2026-01-11', 'GASOIL', NULL, NULL, NULL, '08:00:00', '09:00:00', 60);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `choferes`
--

CREATE TABLE `choferes` (
  `id_chofer` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `cedula` varchar(20) NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_registro` datetime DEFAULT NULL,
  `fecha_modificacion` datetime DEFAULT NULL,
  `registrado_por` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `choferes`
--

INSERT INTO `choferes` (`id_chofer`, `nombre`, `apellido`, `cedula`, `estado`, `fecha_registro`, `fecha_modificacion`, `registrado_por`) VALUES
(1, 'ANTONIO', 'ESCALA', '19536748', 'ACTIVO', '2025-11-23 12:53:08', '2025-11-23 12:53:08', 1),
(2, 'JOSE ', 'HERNANDEZ', '20251650', 'ACTIVO', '2025-11-23 13:13:04', '2025-11-23 13:13:04', 1),
(3, 'HECTOR', 'VILLARROEL', '267299071', 'ACTIVO', '2025-11-23 13:13:48', '2025-11-23 13:13:48', 1),
(4, 'CARLOS', 'CONTASTI', '9904195', 'ACTIVO', '2025-11-23 13:14:15', '2025-11-23 13:19:39', 1),
(5, 'WILLIAM', 'NAVARRO', '15467456', 'ACTIVO', '2025-11-24 07:58:05', '2025-11-24 07:58:05', 1),
(6, 'JOSE', 'YEPEZ', '8535638', 'ACTIVO', '2025-11-24 07:58:53', '2025-11-24 07:58:53', 1),
(7, 'Pedro', 'Vallejo', '15036089', 'ACTIVO', '2025-11-24 08:04:53', '2025-11-24 08:04:53', 1),
(8, 'Jesus', 'Martinez', '26984378', 'ACTIVO', '2025-11-24 08:05:31', '2025-11-24 08:05:31', 1),
(9, 'Victor', 'Delgado', '18181543', 'ACTIVO', '2025-12-07 15:34:08', '2025-12-07 15:34:08', 1),
(10, 'Orange', 'Gonzalez', '12186771', 'ACTIVO', '2025-12-07 16:11:07', '2025-12-07 16:11:07', 1),
(11, 'Erick', 'Brito', '24524451', 'ACTIVO', '2025-12-08 11:16:33', '2025-12-08 11:16:33', 1),
(12, 'Sommer', 'Garcia', '28368603', 'ACTIVO', '2025-12-08 11:27:54', '2025-12-08 11:27:54', 1),
(13, 'ALI', 'ADAMS', '14153358', 'ACTIVO', '2025-12-08 11:42:42', '2025-12-08 11:42:42', 1),
(14, 'HERMES', 'MANZANO', '18478034', 'ACTIVO', '2025-12-08 11:49:54', '2025-12-08 11:49:54', 1),
(15, 'JHONATHAN ', 'JON', '15476990', 'ACTIVO', '2025-12-08 11:52:35', '2025-12-08 11:52:35', 1),
(16, 'Oscar', 'Gomez', '28628175', 'ACTIVO', '2025-12-08 11:56:14', '2025-12-08 11:56:14', 1),
(17, 'Alexander', 'Azocar', '14874485', 'ACTIVO', '2025-12-08 12:08:52', '2025-12-08 12:08:52', 1),
(18, 'DANIEL', 'BETANCOURT', '15211891', 'ACTIVO', '2025-12-08 12:12:26', '2025-12-08 12:12:26', 1),
(19, 'Carlos', 'Tome', '14089215', 'ACTIVO', '2025-12-08 13:40:32', '2025-12-08 13:40:32', 1),
(20, 'CELSO', 'SUAREZ', '11338997', 'ACTIVO', '2025-12-08 13:57:26', '2025-12-08 13:57:26', 1),
(21, 'Victor', 'Gallo', '30254697', 'ACTIVO', '2025-12-08 14:04:18', '2025-12-08 14:04:18', 1),
(22, 'JORGE LUIS  ', 'CHAGUAN', '16181661', 'ACTIVO', '2025-12-08 14:06:19', '2025-12-08 14:06:19', 1),
(23, 'JOSE', 'MARTINEZ', '17422393', 'ACTIVO', '2025-12-08 14:13:42', '2025-12-08 14:13:42', 1),
(24, 'HAO', 'DONG', '3081033', 'ACTIVO', '2025-12-08 14:17:41', '2025-12-08 14:17:41', 1),
(25, 'GODOY', 'MAESTRE', '9950266', 'ACTIVO', '2025-12-08 14:38:08', '2025-12-08 14:38:08', 1),
(26, 'JULIO', 'CAMPOS', '16632210', 'ACTIVO', '2025-12-09 12:35:13', '2025-12-09 12:35:13', 1),
(27, 'CARLOS ', 'RONDON', '16757609', 'ACTIVO', '2025-12-09 16:12:32', '2025-12-09 16:12:32', 1),
(28, 'EDUARDO', 'LAFFONT', '15277970', 'ACTIVO', '2025-12-09 16:27:31', '2025-12-09 16:28:28', 1),
(29, 'JHON', 'QUINTERO', '159532', 'ACTIVO', '2025-12-09 16:29:19', '2025-12-09 16:29:19', 1),
(30, 'EDGAR', 'MIRANDA', '24742355', 'ACTIVO', '2025-12-09 16:36:10', '2025-12-09 16:36:10', 1),
(31, 'LEONARDO', 'MEDINA', '21110594', 'ACTIVO', '2025-12-09 16:39:46', '2025-12-09 16:39:46', 1),
(32, 'LUIS', 'PRADO', '19703599', 'ACTIVO', '2025-12-21 19:10:50', '2025-12-21 19:10:50', 1),
(33, 'DIXON', 'RAMIREZ', '25081352', 'ACTIVO', '2025-12-21 22:19:02', '2025-12-21 22:19:02', 1),
(34, 'JUAN', 'MARTINEZ', '18247487', 'ACTIVO', '2025-12-27 08:48:04', '2025-12-27 08:48:04', 1),
(35, 'LUIS', 'MICHELENA', '18806483', 'ACTIVO', '2026-01-05 08:55:10', '2026-01-05 08:55:10', 1),
(36, 'JOSE', 'MICHELL', '5302223', 'ACTIVO', '2026-01-05 08:55:50', '2026-01-05 08:55:50', 1),
(37, 'JOSE', 'MAYORGA', '27766340', 'ACTIVO', '2026-01-05 09:11:26', '2026-01-05 09:11:26', 1),
(38, 'JOSE', 'RIVAS', '21124239', 'ACTIVO', '2026-01-05 09:47:26', '2026-01-05 09:47:26', 1),
(39, 'JORDAN', 'ASIBE', '22804045', 'ACTIVO', '2026-01-05 13:33:40', '2026-01-05 13:33:40', 1),
(40, 'MARCOS', 'DOMINGUEZ', '20184755', 'ACTIVO', '2026-01-07 15:17:59', '2026-01-07 15:17:59', 1),
(41, 'HECTOR', 'VILLAROEL', '26729907', 'ACTIVO', '2026-01-08 07:58:14', '2026-01-08 07:58:14', 1),
(42, 'FRANK', 'GOMEZ', '15845530', 'ACTIVO', '2026-01-08 08:02:03', '2026-01-08 08:02:03', 1),
(43, 'LUIS', 'BORGES', '015689034', 'ACTIVO', '2026-01-08 08:07:36', '2026-01-08 08:07:36', 1),
(44, 'ITAMAR', 'BOLIVAR', '18138417', 'ACTIVO', '2026-01-08 08:20:21', '2026-01-08 08:20:21', 1),
(45, 'ALEXANDER', 'LARA', '20355355', 'ACTIVO', '2026-01-08 08:26:21', '2026-01-08 08:26:21', 1),
(46, 'JOSE', 'MARENGO', '15467871', 'ACTIVO', '2026-01-08 09:03:24', '2026-01-08 09:03:24', 1),
(47, 'MAIBELYN', 'TORREALBA', '16394444', 'ACTIVO', '2026-01-08 09:16:23', '2026-01-08 09:16:23', 1),
(48, 'ROBERT', 'RUPERTI', '8924321', 'ACTIVO', '2026-01-08 09:17:11', '2026-01-08 09:17:11', 1),
(49, 'THAMIR', 'VITAL', '25446972', 'ACTIVO', '2026-01-08 09:18:09', '2026-01-08 09:18:09', 1),
(50, 'LENIXON', 'GUEVARA', '24541914', 'ACTIVO', '2026-01-08 09:19:08', '2026-01-08 09:19:08', 1),
(51, 'KEIBER', 'CAMPOS', '15969781', 'ACTIVO', '2026-01-08 09:27:04', '2026-01-08 09:27:04', 1),
(52, 'JOYCE', 'RODRIGUEZ', '17548311', 'ACTIVO', '2026-01-08 09:55:05', '2026-01-08 09:55:05', 1),
(53, 'RONEL', 'RINCONES', '18238817', 'ACTIVO', '2026-01-08 11:02:16', '2026-01-08 11:02:16', 1),
(54, 'GERARDO', 'APONTE', '11998153', 'ACTIVO', '2026-01-08 11:03:11', '2026-01-08 11:03:11', 1),
(55, 'DOUGLAS', 'VILLARROEL', '14725655', 'ACTIVO', '2026-01-08 11:06:03', '2026-01-08 11:06:03', 1),
(56, 'GREGORY', 'GUAYQUENEP', '26582500', 'ACTIVO', '2026-01-08 11:06:51', '2026-01-08 11:06:51', 1),
(57, 'NELSON', 'GUEVARA', '12600300', 'ACTIVO', '2026-01-08 11:08:32', '2026-01-08 11:08:32', 1),
(58, 'VICTOR', 'RIERA', '26699029', 'ACTIVO', '2026-01-08 11:16:45', '2026-01-08 11:16:45', 1),
(59, 'MARTIN', 'HERNANDEZ', '18909489', 'ACTIVO', '2026-01-08 13:32:01', '2026-01-08 13:32:01', 1),
(60, 'LEOMAR', 'REYES', '9940124', 'ACTIVO', '2026-01-08 13:37:32', '2026-01-08 13:37:32', 1),
(61, 'AMILCAR', 'TOVAR', '29594809', 'ACTIVO', '2026-01-08 13:43:21', '2026-01-08 13:43:21', 1),
(62, 'RAMON', 'PAEZ', '9912768', 'ACTIVO', '2026-01-09 06:54:25', '2026-01-09 06:54:25', 1),
(63, 'JHONY', 'RONDON', '25086290', 'ACTIVO', '2026-01-09 07:02:06', '2026-01-09 07:02:06', 1),
(64, 'JURGEN', 'GUTIERREZ', '26829085', 'ACTIVO', '2026-01-09 07:41:11', '2026-01-09 07:41:11', 1),
(65, 'ENDERSON', 'RAMIREZ', '30453096', 'ACTIVO', '2026-01-09 07:56:59', '2026-01-09 07:56:59', 1),
(66, 'JEAN CARLOS', 'MEDINA', '21327747', 'ACTIVO', '2026-01-09 08:10:14', '2026-01-09 08:10:14', 1),
(67, 'RAMON', 'MORALES', '4778171', 'ACTIVO', '2026-01-09 09:05:05', '2026-01-09 09:05:05', 1),
(68, 'YOMAR', 'MEDINA', '28534462', 'ACTIVO', '2026-01-09 09:33:00', '2026-01-09 09:33:00', 1),
(69, 'VICTOR', 'GARCIA', '30421616', 'ACTIVO', '2026-01-11 15:27:01', '2026-01-11 15:27:01', 1),
(70, 'DANILO', 'MARTINEZ', '10416697', 'ACTIVO', '2026-01-11 15:38:00', '2026-01-11 15:38:00', 1),
(71, 'JOEL', 'VASQUEZ', '19126800', 'ACTIVO', '2026-01-11 15:39:55', '2026-01-11 15:39:55', 1),
(72, 'EDGAR', 'PARRA', '10573182', 'ACTIVO', '2026-01-11 15:45:03', '2026-01-11 15:45:03', 1),
(73, 'PASTOR', 'VILLASANA', '13963543', 'ACTIVO', '2026-01-11 16:00:43', '2026-01-11 16:00:43', 1),
(74, 'AARON', 'MOROCOIMA', '25615076', 'ACTIVO', '2026-01-11 16:31:39', '2026-01-11 16:31:39', 1),
(75, 'LEANDROMAR', 'URBANO', '29630234', 'ACTIVO', '2026-01-11 16:37:33', '2026-01-11 16:37:33', 1),
(76, 'SERGIO', 'MEJIAS', '16009657', 'ACTIVO', '2026-01-11 16:40:40', '2026-01-11 16:40:40', 1),
(77, 'YOAN', 'GRANADO', '13089292', 'ACTIVO', '2026-01-11 16:43:21', '2026-01-11 16:43:21', 1),
(78, 'ADRIAN', 'AMARISTA', '19403561', 'ACTIVO', '2026-01-11 17:06:16', '2026-01-11 17:06:16', 1),
(79, 'ANDRES', 'GARCIA', '30050597', 'ACTIVO', '2026-01-11 17:11:21', '2026-01-11 17:11:21', 1),
(80, 'MARCOS', 'MORILLO', '11997990', 'ACTIVO', '2026-01-11 17:42:24', '2026-01-11 17:42:24', 1),
(81, 'NOELYN', 'QUIJADA', '19803935', 'ACTIVO', '2026-01-11 17:51:43', '2026-01-11 17:51:43', 1),
(82, 'DANIEL', 'RONDON', '23593104', 'ACTIVO', '2026-01-11 18:28:00', '2026-01-11 18:28:00', 1),
(83, 'CESAR', 'DEVERA', '28415101', 'ACTIVO', '2026-01-11 18:52:34', '2026-01-11 18:52:34', 1),
(84, 'ALGEMIRO', 'ARGUELLES', '17958048', 'ACTIVO', '2026-01-12 07:24:29', '2026-01-12 07:24:29', 1),
(85, 'DEREK', 'SOTO', '33168232', 'ACTIVO', '2026-01-12 07:25:47', '2026-01-12 07:25:47', 1),
(86, 'MIGUEL', 'RODRIGUEZ', '17031547', 'ACTIVO', '2026-01-12 07:38:01', '2026-01-12 07:38:01', 1),
(87, 'EDSON', 'DIAZ', '17879759', 'ACTIVO', '2026-01-12 08:29:06', '2026-01-12 08:29:06', 1),
(88, 'SAMUEL', 'SANCHEZ', '21497769', 'ACTIVO', '2026-01-12 08:41:51', '2026-01-12 08:41:51', 1),
(89, 'SIMON', 'MENDOZA', '11337465', 'ACTIVO', '2026-01-12 08:45:37', '2026-01-12 08:45:37', 1),
(90, 'JESSER', 'LEIVA', '31910873', 'ACTIVO', '2026-01-12 08:48:41', '2026-01-12 08:48:41', 1),
(91, 'JOSE', 'CEDEÑO', '21329536', 'ACTIVO', '2026-01-12 08:50:54', '2026-01-12 08:50:54', 1),
(92, 'EGNIS', 'GARCIAS', '17373299', 'ACTIVO', '2026-01-12 08:55:27', '2026-01-12 08:55:27', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cierres_inventario`
--

CREATE TABLE `cierres_inventario` (
  `id_cierre` int(11) NOT NULL,
  `grupo_cierre_uuid` varchar(36) NOT NULL,
  `tipo_combustible_cierre` varchar(20) NOT NULL,
  `turno` enum('DIURNO','NOCTURNO') NOT NULL,
  `fecha_cierre` datetime NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_tanque` int(11) NOT NULL,
  `saldo_inicial_real` decimal(12,2) NOT NULL,
  `total_entradas_cisterna` decimal(12,2) DEFAULT 0.00,
  `consumo_planta_merma` decimal(12,2) DEFAULT 0.00,
  `consumo_despachos_total` decimal(12,2) DEFAULT 0.00,
  `saldo_final_real` decimal(12,2) NOT NULL,
  `snapshot_desglose_despachos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`snapshot_desglose_despachos`)),
  `observacion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cierres_inventario`
--

INSERT INTO `cierres_inventario` (`id_cierre`, `grupo_cierre_uuid`, `tipo_combustible_cierre`, `turno`, `fecha_cierre`, `id_usuario`, `id_tanque`, `saldo_inicial_real`, `total_entradas_cisterna`, `consumo_planta_merma`, `consumo_despachos_total`, `saldo_final_real`, `snapshot_desglose_despachos`, `observacion`) VALUES
(411, 'cfa0fd89-6670-4406-9339-aaca0001cfe7', 'GASOIL', 'DIURNO', '2026-01-02 16:36:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(412, 'cfa0fd89-6670-4406-9339-aaca0001cfe7', 'GASOLINA', 'DIURNO', '2026-01-02 16:36:00', 1, 2, 78.00, 0.00, 0.00, 0.00, 78.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(413, 'cfa0fd89-6670-4406-9339-aaca0001cfe7', 'GASOIL', 'DIURNO', '2026-01-02 16:36:00', 1, 3, 29027.96, 0.00, -781.00, 781.00, 29027.96, '{\"vehiculos\":781,\"generadores\":300,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(414, 'cfa0fd89-6670-4406-9339-aaca0001cfe7', 'GASOIL', 'DIURNO', '2026-01-02 16:36:00', 1, 4, 1886.00, 0.00, 0.00, 0.00, 1886.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(415, 'cfa0fd89-6670-4406-9339-aaca0001cfe7', 'GASOLINA', 'DIURNO', '2026-01-02 16:36:00', 1, 6, 5822.00, 0.00, -473.00, 473.00, 5822.00, '{\"vehiculos\":473,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(416, 'cfa0fd89-6670-4406-9339-aaca0001cfe7', 'GASOLINA', 'DIURNO', '2026-01-02 16:36:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(423, '79bfdd41-bf00-4c97-88bb-69fb8b1f9863', 'GASOIL', 'DIURNO', '2026-01-02 17:52:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(424, '79bfdd41-bf00-4c97-88bb-69fb8b1f9863', 'GASOLINA', 'DIURNO', '2026-01-02 17:52:00', 1, 2, 78.00, 0.00, 0.00, 0.00, 78.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(425, '79bfdd41-bf00-4c97-88bb-69fb8b1f9863', 'GASOIL', 'DIURNO', '2026-01-02 17:52:00', 1, 3, 29027.96, 12000.89, 7493.13, 270.00, 33265.00, '{\"vehiculos\":270,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(426, '79bfdd41-bf00-4c97-88bb-69fb8b1f9863', 'GASOIL', 'DIURNO', '2026-01-02 17:52:00', 1, 4, 1886.00, 0.00, 0.00, 0.00, 1886.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(427, '79bfdd41-bf00-4c97-88bb-69fb8b1f9863', 'GASOLINA', 'DIURNO', '2026-01-02 17:52:00', 1, 6, 5822.00, 0.00, 0.00, 28.00, 5794.00, '{\"vehiculos\":28,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(428, '79bfdd41-bf00-4c97-88bb-69fb8b1f9863', 'GASOLINA', 'DIURNO', '2026-01-02 17:52:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(429, '4ff118bd-7967-4c9e-b96e-860f3771f706', 'GASOIL', 'DIURNO', '2026-01-02 19:02:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(430, '4ff118bd-7967-4c9e-b96e-860f3771f706', 'GASOLINA', 'DIURNO', '2026-01-02 19:02:00', 1, 2, 78.00, 0.00, 0.00, 0.00, 78.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(431, '4ff118bd-7967-4c9e-b96e-860f3771f706', 'GASOIL', 'DIURNO', '2026-01-02 19:02:00', 1, 3, 33265.00, 0.00, 4605.00, 466.00, 28194.00, '{\"vehiculos\":466,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(432, '4ff118bd-7967-4c9e-b96e-860f3771f706', 'GASOIL', 'DIURNO', '2026-01-02 19:02:00', 1, 4, 1886.00, 0.00, 0.00, 0.00, 1886.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(433, '4ff118bd-7967-4c9e-b96e-860f3771f706', 'GASOLINA', 'DIURNO', '2026-01-02 19:02:00', 1, 6, 5794.00, 0.00, 0.00, 127.00, 5667.00, '{\"vehiculos\":127,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(434, '4ff118bd-7967-4c9e-b96e-860f3771f706', 'GASOLINA', 'DIURNO', '2026-01-02 19:02:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(453, 'ff6a9157-7980-4b3c-87b7-5a0264198f5f', 'GASOIL', 'DIURNO', '2026-01-02 19:44:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(454, 'ff6a9157-7980-4b3c-87b7-5a0264198f5f', 'GASOLINA', 'DIURNO', '2026-01-02 19:44:00', 1, 2, 78.00, 0.00, 0.00, 0.00, 78.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(455, 'ff6a9157-7980-4b3c-87b7-5a0264198f5f', 'GASOIL', 'DIURNO', '2026-01-02 19:44:00', 1, 3, 28194.00, 0.00, 4304.00, 220.00, 23670.00, '{\"vehiculos\":220,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(456, 'ff6a9157-7980-4b3c-87b7-5a0264198f5f', 'GASOIL', 'DIURNO', '2026-01-02 19:44:00', 1, 4, 1886.00, 0.00, 0.00, 0.00, 1886.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(457, 'ff6a9157-7980-4b3c-87b7-5a0264198f5f', 'GASOLINA', 'DIURNO', '2026-01-02 19:44:00', 1, 6, 5667.00, 0.00, 50.00, 0.00, 5617.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(458, 'ff6a9157-7980-4b3c-87b7-5a0264198f5f', 'GASOLINA', 'DIURNO', '2026-01-02 19:44:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(501, 'e3bb3284-afc8-41f2-ae7b-648283e73dba', 'GASOIL', 'NOCTURNO', '2026-01-04 18:42:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(502, 'e3bb3284-afc8-41f2-ae7b-648283e73dba', 'GASOLINA', 'NOCTURNO', '2026-01-04 18:42:00', 1, 2, 78.00, 0.00, 0.00, 0.00, 78.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(503, 'e3bb3284-afc8-41f2-ae7b-648283e73dba', 'GASOIL', 'NOCTURNO', '2026-01-04 18:42:00', 1, 3, 23670.00, 0.00, 2772.01, 726.00, 19771.99, '{\"vehiculos\":726,\"generadores\":400,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(504, 'e3bb3284-afc8-41f2-ae7b-648283e73dba', 'GASOIL', 'NOCTURNO', '2026-01-04 18:42:00', 1, 4, 1886.00, 0.00, 0.00, 0.00, 1886.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(505, 'e3bb3284-afc8-41f2-ae7b-648283e73dba', 'GASOLINA', 'NOCTURNO', '2026-01-04 18:42:00', 1, 6, 5617.00, 0.00, 0.00, 146.00, 5471.00, '{\"vehiculos\":146,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(506, 'e3bb3284-afc8-41f2-ae7b-648283e73dba', 'GASOLINA', 'NOCTURNO', '2026-01-04 18:42:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(507, 'a1f2e5f0-3b52-49d0-977a-8538c134932d', 'GASOIL', 'DIURNO', '2026-01-04 18:57:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(508, 'a1f2e5f0-3b52-49d0-977a-8538c134932d', 'GASOLINA', 'DIURNO', '2026-01-04 18:57:00', 1, 2, 78.00, 0.00, 0.00, 0.00, 78.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(509, 'a1f2e5f0-3b52-49d0-977a-8538c134932d', 'GASOIL', 'DIURNO', '2026-01-04 18:57:00', 1, 3, 19771.99, 0.00, 3190.99, 131.00, 16450.00, '{\"vehiculos\":131,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(510, 'a1f2e5f0-3b52-49d0-977a-8538c134932d', 'GASOIL', 'DIURNO', '2026-01-04 18:57:00', 1, 4, 1886.00, 0.00, 0.00, 0.00, 1886.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(511, 'a1f2e5f0-3b52-49d0-977a-8538c134932d', 'GASOLINA', 'DIURNO', '2026-01-04 18:57:00', 1, 6, 5471.00, 0.00, 3.50, 243.00, 5224.50, '{\"vehiculos\":243,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(512, 'a1f2e5f0-3b52-49d0-977a-8538c134932d', 'GASOLINA', 'DIURNO', '2026-01-04 18:57:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(537, '511604d8-b3b6-4889-aa52-bfcc8a6cd02c', 'GASOIL', 'DIURNO', '2026-01-05 13:09:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(538, '511604d8-b3b6-4889-aa52-bfcc8a6cd02c', 'GASOLINA', 'DIURNO', '2026-01-05 13:09:00', 1, 2, 78.00, 0.00, 0.00, 0.00, 78.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(539, '511604d8-b3b6-4889-aa52-bfcc8a6cd02c', 'GASOIL', 'DIURNO', '2026-01-05 13:09:00', 1, 3, 16450.00, 0.00, 2732.75, 250.00, 11467.25, '{\"vehiculos\":250,\"generadores\":2000,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(540, '511604d8-b3b6-4889-aa52-bfcc8a6cd02c', 'GASOIL', 'DIURNO', '2026-01-05 13:09:00', 1, 4, 1886.00, 0.00, 0.00, 0.00, 1886.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(541, '511604d8-b3b6-4889-aa52-bfcc8a6cd02c', 'GASOLINA', 'DIURNO', '2026-01-05 13:09:00', 1, 6, 5224.50, 0.00, -1.50, 294.00, 4932.00, '{\"vehiculos\":294,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(542, '511604d8-b3b6-4889-aa52-bfcc8a6cd02c', 'GASOLINA', 'DIURNO', '2026-01-05 13:09:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(543, 'cf1ab620-da14-4feb-9673-46bdb24b146e', 'GASOIL', 'NOCTURNO', '2026-01-05 15:15:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RONNY\",\"apellido\":\"RODRIGUEZ\",\"cedula\":\"2321423\"}}', ''),
(544, 'cf1ab620-da14-4feb-9673-46bdb24b146e', 'GASOLINA', 'NOCTURNO', '2026-01-05 15:15:00', 1, 2, 78.00, 0.00, 0.00, 0.00, 78.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RONNY\",\"apellido\":\"RODRIGUEZ\",\"cedula\":\"2321423\"}}', ''),
(545, 'cf1ab620-da14-4feb-9673-46bdb24b146e', 'GASOIL', 'NOCTURNO', '2026-01-05 15:15:00', 1, 3, 11467.25, 24958.91, 2393.85, 323.00, 33709.31, '{\"vehiculos\":323,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RONNY\",\"apellido\":\"RODRIGUEZ\",\"cedula\":\"2321423\"}}', ''),
(546, 'cf1ab620-da14-4feb-9673-46bdb24b146e', 'GASOIL', 'NOCTURNO', '2026-01-05 15:15:00', 1, 4, 1886.00, 0.00, 0.00, 0.00, 1886.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RONNY\",\"apellido\":\"RODRIGUEZ\",\"cedula\":\"2321423\"}}', ''),
(547, 'cf1ab620-da14-4feb-9673-46bdb24b146e', 'GASOLINA', 'NOCTURNO', '2026-01-05 15:15:00', 1, 6, 4932.00, 0.00, 79.16, 70.00, 4782.84, '{\"vehiculos\":70,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RONNY\",\"apellido\":\"RODRIGUEZ\",\"cedula\":\"2321423\"}}', ''),
(548, 'cf1ab620-da14-4feb-9673-46bdb24b146e', 'GASOLINA', 'NOCTURNO', '2026-01-05 15:15:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RONNY\",\"apellido\":\"RODRIGUEZ\",\"cedula\":\"2321423\"}}', ''),
(549, 'cf1ab620-da14-4feb-9673-46bdb24b146e', 'GASOIL', 'NOCTURNO', '2026-01-05 15:15:00', 1, 8, 12000.00, 0.00, 0.00, 0.00, 12000.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RONNY\",\"apellido\":\"RODRIGUEZ\",\"cedula\":\"2321423\"}}', ''),
(557, 'bd29fb5c-3424-41f3-b9a9-10d9939dcb46', 'GASOIL', 'DIURNO', '2026-01-05 16:10:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(558, 'bd29fb5c-3424-41f3-b9a9-10d9939dcb46', 'GASOLINA', 'DIURNO', '2026-01-05 16:10:00', 1, 2, 78.00, 0.00, 0.00, 0.00, 78.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(559, 'bd29fb5c-3424-41f3-b9a9-10d9939dcb46', 'GASOIL', 'DIURNO', '2026-01-05 16:10:00', 1, 3, 33709.31, 0.00, 539.30, 660.00, 32510.01, '{\"vehiculos\":660,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(560, 'bd29fb5c-3424-41f3-b9a9-10d9939dcb46', 'GASOIL', 'DIURNO', '2026-01-05 16:10:00', 1, 4, 1886.00, 0.00, 0.00, 0.00, 1886.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(561, 'bd29fb5c-3424-41f3-b9a9-10d9939dcb46', 'GASOLINA', 'DIURNO', '2026-01-05 16:10:00', 1, 6, 4782.84, 0.00, 0.84, 29.00, 4753.00, '{\"vehiculos\":29,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(562, 'bd29fb5c-3424-41f3-b9a9-10d9939dcb46', 'GASOLINA', 'DIURNO', '2026-01-05 16:10:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(563, 'bd29fb5c-3424-41f3-b9a9-10d9939dcb46', 'GASOIL', 'DIURNO', '2026-01-05 16:10:00', 1, 8, 12000.00, 0.00, 0.00, 0.00, 12000.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(564, '702cf629-ef4f-4f05-8769-b7fddb4b3ab8', 'GASOIL', 'DIURNO', '2026-01-05 16:21:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(565, '702cf629-ef4f-4f05-8769-b7fddb4b3ab8', 'GASOLINA', 'DIURNO', '2026-01-05 16:21:00', 1, 2, 78.00, 0.00, 0.00, 0.00, 78.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(566, '702cf629-ef4f-4f05-8769-b7fddb4b3ab8', 'GASOIL', 'DIURNO', '2026-01-05 16:21:00', 1, 3, 32510.01, 0.00, 1842.17, 70.00, 30597.84, '{\"vehiculos\":70,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(567, '702cf629-ef4f-4f05-8769-b7fddb4b3ab8', 'GASOIL', 'DIURNO', '2026-01-05 16:21:00', 1, 4, 1886.00, 0.00, 0.00, 0.00, 1886.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(568, '702cf629-ef4f-4f05-8769-b7fddb4b3ab8', 'GASOLINA', 'DIURNO', '2026-01-05 16:21:00', 1, 6, 4753.00, 0.00, 65.71, 0.00, 4687.29, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(569, '702cf629-ef4f-4f05-8769-b7fddb4b3ab8', 'GASOLINA', 'DIURNO', '2026-01-05 16:21:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(570, '702cf629-ef4f-4f05-8769-b7fddb4b3ab8', 'GASOIL', 'DIURNO', '2026-01-05 16:21:00', 1, 8, 12000.00, 0.00, 0.00, 0.00, 12000.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(595, 'e7b10caf-3e6c-452a-9671-8a48102d7a24', 'GASOIL', 'DIURNO', '2026-01-07 17:01:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(596, 'e7b10caf-3e6c-452a-9671-8a48102d7a24', 'GASOLINA', 'DIURNO', '2026-01-07 17:01:00', 1, 2, 78.00, 0.00, 0.00, 0.00, 78.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(597, 'e7b10caf-3e6c-452a-9671-8a48102d7a24', 'GASOIL', 'DIURNO', '2026-01-07 17:01:00', 1, 3, 30597.84, 18542.84, 5600.68, 510.00, 42330.00, '{\"vehiculos\":310,\"generadores\":700,\"bidones\":200,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(598, 'e7b10caf-3e6c-452a-9671-8a48102d7a24', 'GASOIL', 'DIURNO', '2026-01-07 17:01:00', 1, 4, 1886.00, 0.00, 0.00, 0.00, 1886.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(599, 'e7b10caf-3e6c-452a-9671-8a48102d7a24', 'GASOLINA', 'DIURNO', '2026-01-07 17:01:00', 1, 6, 4687.29, 0.00, 0.29, 99.00, 4588.00, '{\"vehiculos\":79,\"generadores\":0,\"bidones\":20,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(600, 'e7b10caf-3e6c-452a-9671-8a48102d7a24', 'GASOLINA', 'DIURNO', '2026-01-07 17:01:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(601, 'e7b10caf-3e6c-452a-9671-8a48102d7a24', 'GASOIL', 'DIURNO', '2026-01-07 17:01:00', 1, 8, 12000.00, 19513.84, 13.84, 0.00, 31500.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(602, 'e7b10caf-3e6c-452a-9671-8a48102d7a24', 'GASOIL', 'DIURNO', '2026-01-07 17:01:00', 1, 9, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(611, '4842ac74-534c-407b-af87-6343013a524a', 'GASOIL', 'DIURNO', '2026-01-07 18:29:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(612, '4842ac74-534c-407b-af87-6343013a524a', 'GASOLINA', 'DIURNO', '2026-01-07 18:29:00', 1, 2, 78.00, 0.00, 0.00, 0.00, 78.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(613, '4842ac74-534c-407b-af87-6343013a524a', 'GASOIL', 'DIURNO', '2026-01-07 18:29:00', 1, 3, 42330.00, 0.00, 3110.00, 850.00, 38370.00, '{\"vehiculos\":850,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(614, '4842ac74-534c-407b-af87-6343013a524a', 'GASOIL', 'DIURNO', '2026-01-07 18:29:00', 1, 4, 1886.00, 36997.00, 0.00, 0.00, 38883.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(615, '4842ac74-534c-407b-af87-6343013a524a', 'GASOLINA', 'DIURNO', '2026-01-07 18:29:00', 1, 6, 4588.00, 0.00, 0.00, 16.00, 4572.00, '{\"vehiculos\":16,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(616, '4842ac74-534c-407b-af87-6343013a524a', 'GASOLINA', 'DIURNO', '2026-01-07 18:29:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(617, '4842ac74-534c-407b-af87-6343013a524a', 'GASOIL', 'DIURNO', '2026-01-07 18:29:00', 1, 8, 31500.00, 0.00, 0.00, 0.00, 31500.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(618, '4842ac74-534c-407b-af87-6343013a524a', 'GASOIL', 'DIURNO', '2026-01-07 18:29:00', 1, 9, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RAMON\",\"apellido\":\"BOLIVAR\",\"cedula\":\"123456\"}}', ''),
(627, '9745d416-9fb4-4a12-8707-d02812103f5a', 'GASOIL', 'DIURNO', '2026-01-08 08:48:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(628, '9745d416-9fb4-4a12-8707-d02812103f5a', 'GASOLINA', 'DIURNO', '2026-01-08 08:48:00', 1, 2, 78.00, 0.00, 0.00, 0.00, 78.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(629, '9745d416-9fb4-4a12-8707-d02812103f5a', 'GASOIL', 'DIURNO', '2026-01-08 08:48:00', 1, 3, 38370.00, 0.00, 3790.00, 570.00, 33510.00, '{\"vehiculos\":570,\"generadores\":500,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(630, '9745d416-9fb4-4a12-8707-d02812103f5a', 'GASOIL', 'DIURNO', '2026-01-08 08:48:00', 1, 4, 38883.00, 0.00, 0.00, 0.00, 38883.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(631, '9745d416-9fb4-4a12-8707-d02812103f5a', 'GASOLINA', 'DIURNO', '2026-01-08 08:48:00', 1, 6, 4572.00, 0.00, 0.00, 172.00, 4400.00, '{\"vehiculos\":132,\"generadores\":0,\"bidones\":40,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(632, '9745d416-9fb4-4a12-8707-d02812103f5a', 'GASOLINA', 'DIURNO', '2026-01-08 08:48:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(633, '9745d416-9fb4-4a12-8707-d02812103f5a', 'GASOIL', 'DIURNO', '2026-01-08 08:48:00', 1, 8, 31500.00, 0.00, 0.00, 0.00, 31500.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(634, '9745d416-9fb4-4a12-8707-d02812103f5a', 'GASOIL', 'DIURNO', '2026-01-08 08:48:00', 1, 9, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(635, '2892828b-a802-429f-89b9-aba3a5666884', 'GASOIL', 'DIURNO', '2026-01-08 09:46:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(636, '2892828b-a802-429f-89b9-aba3a5666884', 'GASOLINA', 'DIURNO', '2026-01-08 09:46:00', 1, 2, 78.00, 0.00, 0.00, 0.00, 78.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(637, '2892828b-a802-429f-89b9-aba3a5666884', 'GASOIL', 'DIURNO', '2026-01-08 09:46:00', 1, 3, 33510.00, 0.00, 5462.28, 480.00, 27567.72, '{\"vehiculos\":480,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(638, '2892828b-a802-429f-89b9-aba3a5666884', 'GASOIL', 'DIURNO', '2026-01-08 09:46:00', 1, 4, 38883.00, 0.00, 0.00, 0.00, 38883.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(639, '2892828b-a802-429f-89b9-aba3a5666884', 'GASOLINA', 'DIURNO', '2026-01-08 09:46:00', 1, 6, 4400.00, 0.00, 0.00, 93.00, 4307.00, '{\"vehiculos\":93,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(640, '2892828b-a802-429f-89b9-aba3a5666884', 'GASOLINA', 'DIURNO', '2026-01-08 09:46:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(641, '2892828b-a802-429f-89b9-aba3a5666884', 'GASOIL', 'DIURNO', '2026-01-08 09:46:00', 1, 8, 31500.00, 0.00, 0.00, 0.00, 31500.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(642, '2892828b-a802-429f-89b9-aba3a5666884', 'GASOIL', 'DIURNO', '2026-01-08 09:46:00', 1, 9, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(643, '5ac0b0bc-a6e3-4ad8-973b-b89a68ecb57a', 'GASOIL', 'DIURNO', '2026-01-08 14:02:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(644, '5ac0b0bc-a6e3-4ad8-973b-b89a68ecb57a', 'GASOLINA', 'DIURNO', '2026-01-08 14:02:00', 1, 2, 78.00, 9000.00, 0.00, 0.00, 9078.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(645, '5ac0b0bc-a6e3-4ad8-973b-b89a68ecb57a', 'GASOIL', 'DIURNO', '2026-01-08 14:02:00', 1, 3, 27567.72, 0.00, 2743.72, 859.00, 23565.00, '{\"vehiculos\":859,\"generadores\":400,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(646, '5ac0b0bc-a6e3-4ad8-973b-b89a68ecb57a', 'GASOIL', 'DIURNO', '2026-01-08 14:02:00', 1, 4, 38883.00, 36997.00, 0.00, 0.00, 75880.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(647, '5ac0b0bc-a6e3-4ad8-973b-b89a68ecb57a', 'GASOLINA', 'DIURNO', '2026-01-08 14:02:00', 1, 6, 4307.00, 30000.00, 0.00, 300.00, 34007.00, '{\"vehiculos\":280,\"generadores\":0,\"bidones\":20,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(648, '5ac0b0bc-a6e3-4ad8-973b-b89a68ecb57a', 'GASOLINA', 'DIURNO', '2026-01-08 14:02:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(649, '5ac0b0bc-a6e3-4ad8-973b-b89a68ecb57a', 'GASOIL', 'DIURNO', '2026-01-08 14:02:00', 1, 8, 31500.00, 0.00, 0.00, 0.00, 31500.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(650, '5ac0b0bc-a6e3-4ad8-973b-b89a68ecb57a', 'GASOIL', 'DIURNO', '2026-01-08 14:02:00', 1, 9, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(651, 'd13c8601-749e-4dd2-af6e-bde0b9b7bed1', 'GASOIL', 'NOCTURNO', '2026-01-08 06:30:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(652, 'd13c8601-749e-4dd2-af6e-bde0b9b7bed1', 'GASOLINA', 'NOCTURNO', '2026-01-08 06:30:00', 1, 2, 9078.00, 0.00, 0.00, 0.00, 9078.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(653, 'd13c8601-749e-4dd2-af6e-bde0b9b7bed1', 'GASOIL', 'NOCTURNO', '2026-01-08 06:30:00', 1, 3, 23565.00, 0.00, 6377.69, 326.00, 16861.31, '{\"vehiculos\":326,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(654, 'd13c8601-749e-4dd2-af6e-bde0b9b7bed1', 'GASOIL', 'NOCTURNO', '2026-01-08 06:30:00', 1, 4, 75880.00, 0.00, 0.00, 0.00, 75880.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(655, 'd13c8601-749e-4dd2-af6e-bde0b9b7bed1', 'GASOLINA', 'NOCTURNO', '2026-01-08 06:30:00', 1, 6, 34007.00, 0.00, 0.00, 1100.00, 32907.00, '{\"vehiculos\":100,\"generadores\":0,\"bidones\":1000,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(656, 'd13c8601-749e-4dd2-af6e-bde0b9b7bed1', 'GASOLINA', 'NOCTURNO', '2026-01-08 06:30:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(657, 'd13c8601-749e-4dd2-af6e-bde0b9b7bed1', 'GASOIL', 'NOCTURNO', '2026-01-08 06:30:00', 1, 8, 31500.00, 0.00, 0.00, 0.00, 31500.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(658, 'd13c8601-749e-4dd2-af6e-bde0b9b7bed1', 'GASOIL', 'NOCTURNO', '2026-01-08 06:30:00', 1, 9, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(659, 'b78abc77-59ca-448b-9018-d6f59e5b4c49', 'GASOIL', 'DIURNO', '2026-01-08 19:00:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(660, 'b78abc77-59ca-448b-9018-d6f59e5b4c49', 'GASOLINA', 'DIURNO', '2026-01-08 19:00:00', 1, 2, 9078.00, 0.00, 0.00, 0.00, 9078.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(661, 'b78abc77-59ca-448b-9018-d6f59e5b4c49', 'GASOIL', 'DIURNO', '2026-01-08 19:00:00', 1, 3, 16861.31, 0.00, 5380.31, 855.00, 10326.00, '{\"vehiculos\":775,\"generadores\":300,\"bidones\":80,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(662, 'b78abc77-59ca-448b-9018-d6f59e5b4c49', 'GASOIL', 'DIURNO', '2026-01-08 19:00:00', 1, 4, 75880.00, 0.00, 0.00, 0.00, 75880.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(663, 'b78abc77-59ca-448b-9018-d6f59e5b4c49', 'GASOLINA', 'DIURNO', '2026-01-08 19:00:00', 1, 6, 32907.00, 0.00, 0.00, 188.00, 32719.00, '{\"vehiculos\":148,\"generadores\":0,\"bidones\":40,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(664, 'b78abc77-59ca-448b-9018-d6f59e5b4c49', 'GASOLINA', 'DIURNO', '2026-01-08 19:00:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(665, 'b78abc77-59ca-448b-9018-d6f59e5b4c49', 'GASOIL', 'DIURNO', '2026-01-08 19:00:00', 1, 8, 31500.00, 0.00, 0.00, 0.00, 31500.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(666, 'b78abc77-59ca-448b-9018-d6f59e5b4c49', 'GASOIL', 'DIURNO', '2026-01-08 19:00:00', 1, 9, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(667, 'd8c7004c-1ca7-4bc0-846c-0a9ca7b9a2a9', 'GASOIL', 'NOCTURNO', '2026-01-09 06:30:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RONNY\",\"apellido\":\"GRANADOS\",\"cedula\":\"234324\"}}', 'Se recibio Gandola Cisterna con 37.004 Lts.'),
(668, 'd8c7004c-1ca7-4bc0-846c-0a9ca7b9a2a9', 'GASOLINA', 'NOCTURNO', '2026-01-09 06:30:00', 1, 2, 9078.00, 0.00, 0.00, 0.00, 9078.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RONNY\",\"apellido\":\"GRANADOS\",\"cedula\":\"234324\"}}', 'Se recibio Gandola Cisterna con 37.004 Lts.'),
(669, 'd8c7004c-1ca7-4bc0-846c-0a9ca7b9a2a9', 'GASOIL', 'NOCTURNO', '2026-01-09 06:30:00', 1, 3, 10326.00, 37004.00, 3521.00, 434.00, 43375.00, '{\"vehiculos\":434,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RONNY\",\"apellido\":\"GRANADOS\",\"cedula\":\"234324\"}}', 'Se recibio Gandola Cisterna con 37.004 Lts.'),
(670, 'd8c7004c-1ca7-4bc0-846c-0a9ca7b9a2a9', 'GASOIL', 'NOCTURNO', '2026-01-09 06:30:00', 1, 4, 75880.00, 0.00, 0.00, 0.00, 75880.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RONNY\",\"apellido\":\"GRANADOS\",\"cedula\":\"234324\"}}', 'Se recibio Gandola Cisterna con 37.004 Lts.'),
(671, 'd8c7004c-1ca7-4bc0-846c-0a9ca7b9a2a9', 'GASOLINA', 'NOCTURNO', '2026-01-09 06:30:00', 1, 6, 32719.00, 0.00, 0.00, 30.00, 32689.00, '{\"vehiculos\":10,\"generadores\":0,\"bidones\":20,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RONNY\",\"apellido\":\"GRANADOS\",\"cedula\":\"234324\"}}', 'Se recibio Gandola Cisterna con 37.004 Lts.'),
(672, 'd8c7004c-1ca7-4bc0-846c-0a9ca7b9a2a9', 'GASOLINA', 'NOCTURNO', '2026-01-09 06:30:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RONNY\",\"apellido\":\"GRANADOS\",\"cedula\":\"234324\"}}', 'Se recibio Gandola Cisterna con 37.004 Lts.'),
(673, 'd8c7004c-1ca7-4bc0-846c-0a9ca7b9a2a9', 'GASOIL', 'NOCTURNO', '2026-01-09 06:30:00', 1, 8, 31500.00, 0.00, 0.00, 0.00, 31500.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RONNY\",\"apellido\":\"GRANADOS\",\"cedula\":\"234324\"}}', 'Se recibio Gandola Cisterna con 37.004 Lts.'),
(674, 'd8c7004c-1ca7-4bc0-846c-0a9ca7b9a2a9', 'GASOIL', 'NOCTURNO', '2026-01-09 06:30:00', 1, 9, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"RONNY\",\"apellido\":\"GRANADOS\",\"cedula\":\"234324\"}}', 'Se recibio Gandola Cisterna con 37.004 Lts.'),
(675, '53f6d64e-0626-4b41-b03d-8d58bc4e466d', 'GASOIL', 'DIURNO', '2026-01-09 18:30:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(676, '53f6d64e-0626-4b41-b03d-8d58bc4e466d', 'GASOLINA', 'DIURNO', '2026-01-09 18:30:00', 1, 2, 9078.00, 0.00, 0.00, 0.00, 9078.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(677, '53f6d64e-0626-4b41-b03d-8d58bc4e466d', 'GASOIL', 'DIURNO', '2026-01-09 18:30:00', 1, 3, 43375.00, 0.00, 5800.00, 876.00, 36299.00, '{\"vehiculos\":826,\"generadores\":400,\"bidones\":50,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(678, '53f6d64e-0626-4b41-b03d-8d58bc4e466d', 'GASOIL', 'DIURNO', '2026-01-09 18:30:00', 1, 4, 75880.00, 0.00, 0.00, 0.00, 75880.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(679, '53f6d64e-0626-4b41-b03d-8d58bc4e466d', 'GASOLINA', 'DIURNO', '2026-01-09 18:30:00', 1, 6, 32689.00, 0.00, 0.00, 430.00, 32259.00, '{\"vehiculos\":180,\"generadores\":0,\"bidones\":250,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(680, '53f6d64e-0626-4b41-b03d-8d58bc4e466d', 'GASOLINA', 'DIURNO', '2026-01-09 18:30:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(681, '53f6d64e-0626-4b41-b03d-8d58bc4e466d', 'GASOIL', 'DIURNO', '2026-01-09 18:30:00', 1, 8, 31500.00, 0.00, 0.00, 0.00, 31500.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(682, '53f6d64e-0626-4b41-b03d-8d58bc4e466d', 'GASOIL', 'DIURNO', '2026-01-09 18:30:00', 1, 9, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(683, '6049b7dd-b73e-4f91-9ea9-3c065eb91fa7', 'GASOIL', 'NOCTURNO', '2026-01-10 06:00:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', '');
INSERT INTO `cierres_inventario` (`id_cierre`, `grupo_cierre_uuid`, `tipo_combustible_cierre`, `turno`, `fecha_cierre`, `id_usuario`, `id_tanque`, `saldo_inicial_real`, `total_entradas_cisterna`, `consumo_planta_merma`, `consumo_despachos_total`, `saldo_final_real`, `snapshot_desglose_despachos`, `observacion`) VALUES
(684, '6049b7dd-b73e-4f91-9ea9-3c065eb91fa7', 'GASOLINA', 'NOCTURNO', '2026-01-10 06:00:00', 1, 2, 9078.00, 0.00, 0.00, 0.00, 9078.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(685, '6049b7dd-b73e-4f91-9ea9-3c065eb91fa7', 'GASOIL', 'NOCTURNO', '2026-01-10 06:00:00', 1, 3, 36299.00, 0.00, 3281.00, 150.00, 32868.00, '{\"vehiculos\":150,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(686, '6049b7dd-b73e-4f91-9ea9-3c065eb91fa7', 'GASOIL', 'NOCTURNO', '2026-01-10 06:00:00', 1, 4, 75880.00, 0.00, 0.00, 0.00, 75880.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(687, '6049b7dd-b73e-4f91-9ea9-3c065eb91fa7', 'GASOLINA', 'NOCTURNO', '2026-01-10 06:00:00', 1, 6, 32259.00, 0.00, 120.00, 100.00, 32039.00, '{\"vehiculos\":60,\"generadores\":0,\"bidones\":40,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(688, '6049b7dd-b73e-4f91-9ea9-3c065eb91fa7', 'GASOLINA', 'NOCTURNO', '2026-01-10 06:00:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(689, '6049b7dd-b73e-4f91-9ea9-3c065eb91fa7', 'GASOIL', 'NOCTURNO', '2026-01-10 06:00:00', 1, 8, 31500.00, 0.00, 0.00, 0.00, 31500.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(690, '6049b7dd-b73e-4f91-9ea9-3c065eb91fa7', 'GASOIL', 'NOCTURNO', '2026-01-10 06:00:00', 1, 9, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(691, '77a58d6c-6677-4ae4-8f29-1b816a844e79', 'GASOIL', 'DIURNO', '2026-01-10 18:00:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(692, '77a58d6c-6677-4ae4-8f29-1b816a844e79', 'GASOLINA', 'DIURNO', '2026-01-10 18:00:00', 1, 2, 9078.00, 0.00, 0.00, 0.00, 9078.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(693, '77a58d6c-6677-4ae4-8f29-1b816a844e79', 'GASOIL', 'DIURNO', '2026-01-10 18:00:00', 1, 3, 32868.00, 0.00, 6845.00, 4480.00, 21243.00, '{\"vehiculos\":480,\"generadores\":300,\"bidones\":4000,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(694, '77a58d6c-6677-4ae4-8f29-1b816a844e79', 'GASOIL', 'DIURNO', '2026-01-10 18:00:00', 1, 4, 75880.00, 0.00, 0.00, 0.00, 75880.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(695, '77a58d6c-6677-4ae4-8f29-1b816a844e79', 'GASOLINA', 'DIURNO', '2026-01-10 18:00:00', 1, 6, 32039.00, 0.00, -155.00, 532.00, 31662.00, '{\"vehiculos\":202,\"generadores\":0,\"bidones\":330,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(696, '77a58d6c-6677-4ae4-8f29-1b816a844e79', 'GASOLINA', 'DIURNO', '2026-01-10 18:00:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(697, '77a58d6c-6677-4ae4-8f29-1b816a844e79', 'GASOIL', 'DIURNO', '2026-01-10 18:00:00', 1, 8, 31500.00, 0.00, 0.00, 0.00, 31500.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(698, '77a58d6c-6677-4ae4-8f29-1b816a844e79', 'GASOIL', 'DIURNO', '2026-01-10 18:00:00', 1, 9, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JEAN FRANCO\",\"apellido\":\"DI GEMMA\",\"cedula\":\"1234565\"}}', ''),
(715, '2628cd35-1891-40d3-a5dd-871da780a4e0', 'GASOIL', 'NOCTURNO', '2026-01-11 06:00:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(716, '2628cd35-1891-40d3-a5dd-871da780a4e0', 'GASOLINA', 'NOCTURNO', '2026-01-11 06:00:00', 1, 2, 9078.00, 0.00, 0.00, 0.00, 9078.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(717, '2628cd35-1891-40d3-a5dd-871da780a4e0', 'GASOIL', 'NOCTURNO', '2026-01-11 06:00:00', 1, 3, 21243.00, 12994.00, 3658.00, 517.00, 30062.00, '{\"vehiculos\":517,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(718, '2628cd35-1891-40d3-a5dd-871da780a4e0', 'GASOIL', 'NOCTURNO', '2026-01-11 06:00:00', 1, 4, 75880.00, 0.00, 0.00, 0.00, 75880.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(719, '2628cd35-1891-40d3-a5dd-871da780a4e0', 'GASOLINA', 'NOCTURNO', '2026-01-11 06:00:00', 1, 6, 31662.00, 0.00, 120.00, 90.00, 31452.00, '{\"vehiculos\":90,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(720, '2628cd35-1891-40d3-a5dd-871da780a4e0', 'GASOLINA', 'NOCTURNO', '2026-01-11 06:00:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(721, '2628cd35-1891-40d3-a5dd-871da780a4e0', 'GASOIL', 'NOCTURNO', '2026-01-11 06:00:00', 1, 8, 31500.00, 0.00, 0.00, 0.00, 31500.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(722, '2628cd35-1891-40d3-a5dd-871da780a4e0', 'GASOIL', 'NOCTURNO', '2026-01-11 06:00:00', 1, 9, 0.00, 0.00, -24000.00, 0.00, 24000.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"PEDRO\",\"apellido\":\"RAMIREZ\",\"cedula\":\"32431241\"}}', ''),
(723, 'f970da3e-05a8-4b32-9092-ffd7e0f27bbe', 'GASOIL', 'DIURNO', '2026-01-11 18:30:00', 1, 1, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JOSMAR\",\"apellido\":\"ROJAS\",\"cedula\":\"28086728\"}}', ''),
(724, 'f970da3e-05a8-4b32-9092-ffd7e0f27bbe', 'GASOLINA', 'DIURNO', '2026-01-11 18:30:00', 1, 2, 9078.00, 0.00, 0.00, 0.00, 9078.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JOSMAR\",\"apellido\":\"ROJAS\",\"cedula\":\"28086728\"}}', ''),
(725, 'f970da3e-05a8-4b32-9092-ffd7e0f27bbe', 'GASOIL', 'DIURNO', '2026-01-11 18:30:00', 1, 3, 30062.00, 0.00, 5788.56, 1659.00, 22614.44, '{\"vehiculos\":1219,\"generadores\":0,\"bidones\":440,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JOSMAR\",\"apellido\":\"ROJAS\",\"cedula\":\"28086728\"}}', ''),
(726, 'f970da3e-05a8-4b32-9092-ffd7e0f27bbe', 'GASOIL', 'DIURNO', '2026-01-11 18:30:00', 1, 4, 75880.00, 0.00, 0.00, 0.00, 75880.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JOSMAR\",\"apellido\":\"ROJAS\",\"cedula\":\"28086728\"}}', ''),
(727, 'f970da3e-05a8-4b32-9092-ffd7e0f27bbe', 'GASOLINA', 'DIURNO', '2026-01-11 18:30:00', 1, 6, 31452.00, 0.00, 0.00, 287.00, 31165.00, '{\"vehiculos\":267,\"generadores\":0,\"bidones\":20,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JOSMAR\",\"apellido\":\"ROJAS\",\"cedula\":\"28086728\"}}', ''),
(728, 'f970da3e-05a8-4b32-9092-ffd7e0f27bbe', 'GASOLINA', 'DIURNO', '2026-01-11 18:30:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JOSMAR\",\"apellido\":\"ROJAS\",\"cedula\":\"28086728\"}}', ''),
(729, 'f970da3e-05a8-4b32-9092-ffd7e0f27bbe', 'GASOIL', 'DIURNO', '2026-01-11 18:30:00', 1, 8, 31500.00, 0.00, 0.00, 0.00, 31500.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JOSMAR\",\"apellido\":\"ROJAS\",\"cedula\":\"28086728\"}}', ''),
(730, 'f970da3e-05a8-4b32-9092-ffd7e0f27bbe', 'GASOIL', 'DIURNO', '2026-01-11 18:30:00', 1, 9, 24000.00, 0.00, 0.00, 0.00, 24000.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JOSMAR\",\"apellido\":\"ROJAS\",\"cedula\":\"28086728\"}}', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `despachos`
--

CREATE TABLE `despachos` (
  `id_despacho` int(11) NOT NULL,
  `numero_ticket` varchar(50) NOT NULL,
  `fecha_hora` datetime NOT NULL,
  `id_dispensador` int(11) NOT NULL,
  `odometro_previo` decimal(12,2) NOT NULL,
  `odometro_final` decimal(12,2) NOT NULL,
  `cantidad_solicitada` decimal(10,2) NOT NULL,
  `cantidad_despachada` decimal(10,2) NOT NULL,
  `tipo_destino` enum('VEHICULO','BIDON') NOT NULL,
  `id_vehiculo` int(11) DEFAULT NULL,
  `id_chofer` int(11) DEFAULT NULL,
  `id_gerencia` int(11) DEFAULT NULL,
  `observacion` text DEFAULT NULL,
  `id_almacenista` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `estado` enum('PROCESADO','ANULADO') DEFAULT 'PROCESADO',
  `id_cierre` int(11) DEFAULT NULL COMMENT 'ID del cierre de inventario que procesó este movimiento',
  `id_tanque` int(11) DEFAULT NULL COMMENT 'ID del tanque al momento del despacho'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `despachos`
--

INSERT INTO `despachos` (`id_despacho`, `numero_ticket`, `fecha_hora`, `id_dispensador`, `odometro_previo`, `odometro_final`, `cantidad_solicitada`, `cantidad_despachada`, `tipo_destino`, `id_vehiculo`, `id_chofer`, `id_gerencia`, `observacion`, `id_almacenista`, `id_usuario`, `estado`, `id_cierre`, `id_tanque`) VALUES
(57, '1231233', '2026-01-02 16:20:00', 4, 7113.00, 7586.00, 473.00, 473.00, 'VEHICULO', 49, 19, NULL, NULL, 4, 1, 'PROCESADO', 415, 6),
(58, '124234', '2026-01-02 16:25:00', 3, 51099.00, 51880.00, 781.00, 781.00, 'VEHICULO', 28, 19, NULL, NULL, 5, 1, 'PROCESADO', 413, 3),
(59, '23423423', '2026-01-02 16:27:00', 3, 51880.00, 52180.00, 300.00, 300.00, 'VEHICULO', 2, 4, NULL, NULL, 4, 1, 'PROCESADO', 413, 3),
(60, '123123a', '2026-01-02 16:41:00', 3, 52180.00, 52450.00, 270.00, 270.00, 'VEHICULO', 36, 19, NULL, NULL, 5, 1, 'PROCESADO', 425, 3),
(61, 'sfr2342342', '2026-01-02 16:44:00', 4, 7586.00, 7614.00, 28.00, 28.00, 'VEHICULO', 57, 20, NULL, NULL, 4, 1, 'PROCESADO', 427, 6),
(62, '1234123412', '2026-01-02 18:54:00', 3, 52450.00, 52916.00, 466.00, 466.00, 'VEHICULO', 19, 20, NULL, NULL, 5, 1, 'PROCESADO', 431, 3),
(63, '12412312dw', '2026-01-02 18:55:00', 4, 7614.00, 7741.00, 127.00, 127.00, 'VEHICULO', 51, 20, NULL, NULL, 4, 1, 'PROCESADO', 433, 6),
(64, 'awde23423', '2026-01-02 19:03:00', 3, 52916.00, 53136.00, 220.00, 220.00, 'VEHICULO', 36, 20, NULL, NULL, 4, 1, 'PROCESADO', 455, 3),
(65, '45254253', '2026-01-02 14:48:00', 3, 53136.00, 53862.00, 726.00, 726.00, 'VEHICULO', 19, 1, NULL, NULL, 2, 1, 'PROCESADO', 503, 3),
(66, '24234we324', '2026-01-02 14:55:00', 3, 53862.00, 54262.00, 400.00, 400.00, 'VEHICULO', 2, 4, NULL, NULL, 2, 1, 'PROCESADO', 503, 3),
(67, '24234wr', '2026-01-02 14:56:00', 4, 7741.00, 7887.00, 146.00, 146.00, 'VEHICULO', 57, 4, NULL, NULL, 2, 1, 'PROCESADO', 505, 6),
(68, '2134154sd', '2026-01-03 18:48:00', 3, 54262.00, 54393.00, 131.00, 131.00, 'VEHICULO', 36, 19, NULL, NULL, 4, 1, 'PROCESADO', 509, 3),
(69, '2134134', '2026-01-03 18:49:00', 4, 7887.00, 8130.00, 243.00, 243.00, 'VEHICULO', 57, 27, NULL, NULL, 5, 1, 'PROCESADO', 511, 6),
(70, 'R533000411', '2026-01-03 10:41:00', 4, 8130.00, 8140.00, 10.00, 10.00, 'VEHICULO', 62, 35, NULL, NULL, 1, 1, 'PROCESADO', 541, 6),
(71, 'R411002945', '2026-01-03 10:42:00', 4, 8140.00, 8180.00, 40.00, 40.00, 'VEHICULO', 55, 36, NULL, NULL, 2, 1, 'PROCESADO', 541, 6),
(72, 'R411002946', '2026-01-03 10:43:00', 4, 8180.00, 8186.00, 6.00, 6.00, 'VEHICULO', 37, 36, NULL, NULL, 2, 1, 'PROCESADO', 541, 6),
(73, 'R411002944', '2026-01-03 10:44:00', 4, 8186.00, 8216.00, 30.00, 30.00, 'VEHICULO', 49, 36, NULL, NULL, 2, 1, 'PROCESADO', 541, 6),
(74, 'R171000456', '2026-01-03 10:48:00', 4, 8216.00, 8226.00, 10.00, 10.00, 'VEHICULO', 66, 37, NULL, NULL, 7, 1, 'PROCESADO', 541, 6),
(75, 'R171000455', '2026-01-03 10:49:00', 4, 8226.00, 8236.00, 10.00, 10.00, 'VEHICULO', 63, 37, NULL, NULL, 7, 1, 'PROCESADO', 541, 6),
(76, 'B171000454', '2026-01-03 10:54:00', 4, 8236.00, 8261.00, 25.00, 25.00, 'VEHICULO', 64, 37, NULL, NULL, 2, 1, 'PROCESADO', 541, 6),
(77, 'R311000886', '2026-01-03 10:55:00', 4, 8261.00, 8296.00, 40.00, 35.00, 'VEHICULO', 60, 1, NULL, NULL, 2, 1, 'PROCESADO', 541, 6),
(78, 'R311000888', '2026-01-03 10:56:00', 4, 8296.00, 8336.00, 40.00, 40.00, 'VEHICULO', 59, 1, NULL, NULL, 2, 1, 'PROCESADO', 541, 6),
(79, 'R311000887', '2026-01-03 10:57:00', 4, 8336.00, 8376.00, 40.00, 40.00, 'VEHICULO', 61, 1, NULL, NULL, 2, 1, 'PROCESADO', 541, 6),
(80, 'R291003624', '2026-01-03 10:57:00', 4, 8376.00, 8424.00, 50.00, 48.00, 'VEHICULO', 65, 18, NULL, NULL, 7, 1, 'PROCESADO', 541, 6),
(81, 'R1610023587', '2026-01-03 11:08:00', 3, 54393.00, 54493.00, 100.00, 100.00, 'VEHICULO', 3, 38, NULL, NULL, 2, 1, 'PROCESADO', 539, 3),
(82, 'R531002160', '2026-01-03 11:10:00', 3, 54493.00, 54573.00, 80.00, 80.00, 'VEHICULO', 31, 20, NULL, NULL, 4, 1, 'PROCESADO', 539, 3),
(84, 'R161002356', '2026-01-03 11:11:00', 3, 56573.00, 56643.00, 70.00, 70.00, 'VEHICULO', 3, 5, NULL, NULL, 2, 1, 'PROCESADO', 539, 3),
(85, '2342332', '2026-01-03 13:01:00', 3, 56643.00, 58643.00, 2000.00, 2000.00, 'VEHICULO', 25, 20, NULL, NULL, 4, 1, 'PROCESADO', 539, 3),
(86, 'R161002360', '2026-01-03 13:23:00', 3, 58643.00, 58713.00, 70.00, 70.00, 'VEHICULO', 6, 38, NULL, NULL, 8, 1, 'PROCESADO', 545, 3),
(87, 'R531002161', '2026-01-03 13:27:00', 3, 58713.00, 58913.00, 200.00, 200.00, 'VEHICULO', 13, 32, NULL, NULL, 4, 1, 'PROCESADO', 545, 3),
(88, 'R531002162', '2026-01-03 13:28:00', 3, 58913.00, 58966.00, 80.00, 53.00, 'VEHICULO', 4, 4, NULL, NULL, 8, 1, 'PROCESADO', 545, 3),
(89, 'R242000267', '2026-01-03 13:49:00', 4, 8424.00, 8444.00, 20.00, 20.00, 'VEHICULO', 67, 39, NULL, NULL, 8, 1, 'PROCESADO', 547, 6),
(90, 'R531002163', '2026-01-03 13:50:00', 4, 8444.00, 8494.00, 50.00, 50.00, 'VEHICULO', 45, 6, NULL, NULL, 8, 1, 'PROCESADO', 547, 6),
(91, '2424324', '2026-01-04 15:18:00', 3, 58966.00, 59036.00, 70.00, 70.00, 'VEHICULO', 6, 20, NULL, ' [ANULADO]', 4, 1, 'ANULADO', NULL, 3),
(92, '24323423', '2026-01-04 16:05:00', 3, 59036.00, 59696.00, 660.00, 660.00, 'VEHICULO', 36, 20, NULL, NULL, 4, 1, 'PROCESADO', 559, 3),
(93, '24234234', '2026-01-04 16:06:00', 4, 8494.00, 8523.00, 29.00, 29.00, 'VEHICULO', 57, 18, NULL, NULL, 2, 1, 'PROCESADO', 561, 6),
(94, '2423423', '2026-01-05 16:12:00', 3, 59696.00, 59766.00, 70.00, 70.00, 'VEHICULO', 19, 20, NULL, NULL, 1, 1, 'PROCESADO', 566, 3),
(95, 'R161002370', '2026-01-05 15:46:00', 3, 59766.00, 59836.00, 70.00, 70.00, 'VEHICULO', 6, 38, NULL, NULL, 2, 1, 'PROCESADO', 597, 3),
(96, 'R531002171', '2026-01-05 15:47:00', 3, 59836.00, 59916.00, 80.00, 80.00, 'VEHICULO', 20, 40, NULL, NULL, 8, 1, 'PROCESADO', 597, 3),
(97, 'R531002173', '2026-01-07 15:48:00', 3, 59916.00, 59996.00, 80.00, 80.00, 'VEHICULO', 27, 40, NULL, NULL, 8, 1, 'PROCESADO', 597, 3),
(98, 'R531002172', '2026-01-07 15:53:00', 3, 59996.00, 60076.00, 80.00, 80.00, 'VEHICULO', 18, 40, NULL, NULL, 8, 1, 'PROCESADO', 597, 3),
(99, 'R311000892', '2026-01-07 15:54:00', 3, 60076.00, 60776.00, 700.00, 700.00, 'VEHICULO', 2, 1, NULL, NULL, 1, 1, 'PROCESADO', 597, 3),
(100, 'B531002175', '2026-01-05 15:55:00', 3, 60776.00, 60976.00, 200.00, 200.00, 'BIDON', NULL, NULL, 4, 'Jumbo Hyundai ', 8, 1, 'PROCESADO', 597, 3),
(101, 'R171000457', '2026-01-07 16:06:00', 4, 8523.00, 8533.00, 10.00, 10.00, 'VEHICULO', 69, 37, NULL, NULL, 2, 1, 'PROCESADO', 599, 6),
(102, 'R531002176', '2026-01-05 16:07:00', 4, 8533.00, 8583.00, 50.00, 50.00, 'VEHICULO', 44, 6, NULL, NULL, 8, 1, 'PROCESADO', 599, 6),
(103, '8531002174', '2026-01-05 16:13:00', 4, 8583.00, 8603.00, 20.00, 20.00, 'BIDON', NULL, NULL, 4, 'Moto bomba', 8, 1, 'PROCESADO', 599, 6),
(104, 'R291003643', '2026-01-05 16:18:00', 4, 8603.00, 8614.00, 12.00, 11.00, 'VEHICULO', 70, 4, NULL, NULL, 8, 1, 'PROCESADO', 599, 6),
(105, 'R291003644', '2026-01-07 16:20:00', 4, 8614.00, 8624.00, 10.00, 8.00, 'VEHICULO', 71, 27, NULL, NULL, 8, 1, 'PROCESADO', 599, 6),
(106, 'R531002180', '2026-01-05 17:30:00', 3, 60976.00, 61056.00, 80.00, 80.00, 'VEHICULO', 21, 13, NULL, NULL, 2, 1, 'PROCESADO', 613, 3),
(107, 'R5310021', '2026-01-07 17:31:00', 3, 61056.00, 61136.00, 80.00, 80.00, 'VEHICULO', 19, 13, NULL, NULL, 2, 1, 'PROCESADO', 613, 3),
(108, 'R531002182', '2026-01-05 17:32:00', 3, 61136.00, 61216.00, 80.00, 80.00, 'VEHICULO', 28, 13, NULL, NULL, 2, 1, 'PROCESADO', 613, 3),
(109, 'R531002181', '2026-01-05 17:33:00', 3, 61216.00, 61296.00, 80.00, 80.00, 'VEHICULO', 23, 13, NULL, NULL, 6, 1, 'PROCESADO', 613, 3),
(110, 'R531002177', '2026-01-07 17:34:00', 3, 61296.00, 61356.00, 80.00, 60.00, 'VEHICULO', 4, 37, NULL, NULL, 6, 1, 'PROCESADO', 613, 3),
(111, 'R161002374', '2026-01-05 17:35:00', 3, 61356.00, 61456.00, 100.00, 100.00, 'VEHICULO', 3, 34, NULL, NULL, 8, 1, 'PROCESADO', 613, 3),
(112, 'R161002375', '2026-01-05 17:48:00', 3, 61456.00, 61556.00, 100.00, 100.00, 'VEHICULO', 8, 34, NULL, NULL, 8, 1, 'PROCESADO', 613, 3),
(113, 'R161002373', '2026-01-05 17:48:00', 3, 61556.00, 61626.00, 70.00, 70.00, 'VEHICULO', 15, 34, NULL, NULL, 8, 1, 'PROCESADO', 613, 3),
(114, 'R531007178', '2026-01-07 17:51:00', 3, 61626.00, 61826.00, 200.00, 200.00, 'VEHICULO', 13, 4, NULL, NULL, 6, 1, 'PROCESADO', 613, 3),
(115, 'R191001567', '2026-01-07 17:58:00', 4, 8624.00, 8640.00, 16.00, 16.00, 'VEHICULO', 72, 34, NULL, NULL, 1, 1, 'PROCESADO', 615, 6),
(116, 'R191001569', '2026-01-06 08:13:00', 4, 8640.00, 8652.00, 12.00, 12.00, 'VEHICULO', 73, 41, NULL, NULL, 3, 1, 'PROCESADO', 631, 6),
(117, 'R191001568', '2026-01-06 08:15:00', 4, 8652.00, 8660.00, 8.00, 8.00, 'VEHICULO', 72, 41, NULL, NULL, 3, 1, 'PROCESADO', 631, 6),
(118, 'R171000460', '2026-01-06 08:16:00', 4, 8660.00, 8670.00, 10.00, 10.00, 'VEHICULO', 74, 42, NULL, NULL, 9, 1, 'PROCESADO', 631, 6),
(119, 'B171000459', '2026-01-06 08:17:00', 4, 8670.00, 8690.00, 20.00, 20.00, 'BIDON', NULL, NULL, 20, 'Frank Gomez', 9, 1, 'PROCESADO', 631, 6),
(120, 'R531002188', '2026-01-06 08:18:00', 4, 8690.00, 8710.00, 20.00, 20.00, 'BIDON', NULL, NULL, 4, 'Moto bomba', 9, 1, 'PROCESADO', 631, 6),
(121, 'R171000458', '2026-01-06 08:20:00', 4, 8710.00, 8720.00, 10.00, 10.00, 'VEHICULO', 75, 44, NULL, NULL, 9, 1, 'PROCESADO', 631, 6),
(122, 'R131000404', '2026-01-06 08:21:00', 4, 8720.00, 8752.00, 32.00, 32.00, 'VEHICULO', 76, 43, NULL, NULL, 3, 1, 'PROCESADO', 631, 6),
(123, 'R242000268', '2026-01-06 08:21:00', 4, 8752.00, 8812.00, 60.00, 60.00, 'VEHICULO', 77, 39, NULL, NULL, 3, 1, 'PROCESADO', 631, 6),
(124, 'R161032380', '2026-01-06 08:31:00', 3, 61826.00, 61926.00, 100.00, 100.00, 'VEHICULO', 8, 38, NULL, NULL, 10, 1, 'PROCESADO', 629, 3),
(125, '8311000894', '2026-01-06 08:33:00', 3, 61926.00, 62426.00, 500.00, 500.00, 'VEHICULO', 2, 32, NULL, NULL, 9, 1, 'PROCESADO', 629, 3),
(126, 'R531007', '2026-01-06 08:33:00', 3, 62426.00, 62626.00, 200.00, 200.00, 'VEHICULO', 46, 8, NULL, NULL, 9, 1, 'PROCESADO', 629, 3),
(127, 'R530001071', '2026-01-06 08:34:00', 3, 62626.00, 62656.00, 50.00, 30.00, 'VEHICULO', 79, 45, NULL, NULL, 6, 1, 'PROCESADO', 629, 3),
(128, 'RE30001070', '2026-01-06 08:36:00', 3, 62656.00, 62696.00, 40.00, 40.00, 'VEHICULO', 78, 45, NULL, NULL, 6, 1, 'PROCESADO', 629, 3),
(129, 'R161002379', '2026-01-06 08:36:00', 3, 62696.00, 62796.00, 100.00, 100.00, 'VEHICULO', 3, 38, NULL, NULL, 10, 1, 'PROCESADO', 629, 3),
(130, 'R161002378', '2026-01-06 08:37:00', 3, 62796.00, 62896.00, 100.00, 100.00, 'VEHICULO', 15, 38, NULL, NULL, 10, 1, 'PROCESADO', 629, 3),
(131, 'R161002384', '2026-01-06 09:06:00', 3, 62896.00, 62966.00, 70.00, 70.00, 'VEHICULO', 15, 34, NULL, NULL, 9, 1, 'PROCESADO', 637, 3),
(132, 'R161002381', '2026-01-06 09:06:00', 3, 62966.00, 63026.00, 60.00, 60.00, 'VEHICULO', 3, 34, NULL, NULL, 9, 1, 'PROCESADO', 637, 3),
(133, 'R161002385', '2026-01-06 09:07:00', 3, 63026.00, 63096.00, 70.00, 70.00, 'VEHICULO', 8, 34, NULL, NULL, 9, 1, 'PROCESADO', 637, 3),
(134, 'R531002192', '2026-01-06 09:08:00', 3, 63096.00, 63176.00, 80.00, 80.00, 'VEHICULO', 4, 46, NULL, NULL, 11, 1, 'PROCESADO', 637, 3),
(135, 'R531002193', '2026-01-06 09:08:00', 3, 63176.00, 63376.00, 200.00, 200.00, 'VEHICULO', 13, 46, NULL, NULL, 11, 1, 'PROCESADO', 637, 3),
(136, 'R191001571', '2026-01-06 09:29:00', 4, 8812.00, 8817.00, 5.00, 5.00, 'VEHICULO', 80, 34, NULL, NULL, 11, 1, 'PROCESADO', 639, 6),
(137, 'R161002386', '2026-01-06 09:30:00', 4, 8817.00, 8862.00, 45.00, 45.00, 'VEHICULO', 81, 47, NULL, NULL, 11, 1, 'PROCESADO', 639, 6),
(138, 'R191001570', '2026-01-06 09:31:00', 4, 8862.00, 8867.00, 5.00, 5.00, 'VEHICULO', 72, 34, NULL, NULL, 11, 1, 'PROCESADO', 639, 6),
(139, 'R141000175', '2026-01-06 09:32:00', 4, 8867.00, 8877.00, 10.00, 10.00, 'VEHICULO', 38, 48, NULL, NULL, 11, 1, 'PROCESADO', 639, 6),
(140, 'R141000174', '2026-01-06 09:32:00', 4, 8877.00, 8887.00, 10.00, 10.00, 'VEHICULO', 42, 49, NULL, NULL, 3, 1, 'PROCESADO', 639, 6),
(141, 'R141000173', '2026-01-06 09:35:00', 4, 8887.00, 8897.00, 10.00, 10.00, 'VEHICULO', 43, 50, NULL, NULL, 3, 1, 'PROCESADO', 639, 6),
(142, 'R301000398', '2026-01-06 09:35:00', 4, 8897.00, 8905.00, 8.00, 8.00, 'VEHICULO', 82, 51, NULL, NULL, 8, 1, 'PROCESADO', 639, 6),
(143, 'R531002206', '2026-01-07 10:48:00', 3, 63376.00, 63496.00, 120.00, 120.00, 'VEHICULO', 9, 12, NULL, NULL, 6, 1, 'PROCESADO', 645, 3),
(144, 'R531002217', '2026-01-07 10:49:00', 3, 63496.00, 63576.00, 80.00, 80.00, 'VEHICULO', 31, 20, NULL, NULL, 8, 1, 'PROCESADO', 645, 3),
(145, 'R531002205', '2026-01-07 10:50:00', 3, 63576.00, 63656.00, 80.00, 80.00, 'VEHICULO', 36, 12, NULL, NULL, 6, 1, 'PROCESADO', 645, 3),
(146, 'R631002208', '2026-01-07 10:50:00', 3, 63656.00, 63736.00, 80.00, 80.00, 'VEHICULO', 20, 12, NULL, NULL, 6, 1, 'PROCESADO', 645, 3),
(147, 'R531002211', '2026-01-07 10:51:00', 3, 63736.00, 63936.00, 200.00, 200.00, 'VEHICULO', 83, 19, NULL, NULL, 8, 1, 'PROCESADO', 645, 3),
(148, 'R531002210', '2026-01-07 10:53:00', 3, 63936.00, 64136.00, 200.00, 200.00, 'VEHICULO', 84, 19, NULL, NULL, 8, 1, 'PROCESADO', 645, 3),
(149, 'RE30001072', '2026-01-07 10:54:00', 3, 64136.00, 64165.00, 30.00, 29.00, 'VEHICULO', 78, 45, NULL, NULL, 11, 1, 'PROCESADO', 645, 3),
(150, 'R161002389', '2026-01-07 10:55:00', 3, 64165.00, 64235.00, 70.00, 70.00, 'VEHICULO', 15, 34, NULL, NULL, 11, 1, 'PROCESADO', 645, 3),
(151, 'B311000898', '2026-01-07 10:59:00', 3, 64235.00, 64635.00, 400.00, 400.00, 'VEHICULO', 2, 32, NULL, NULL, 8, 1, 'PROCESADO', 645, 3),
(152, 'R532000419', '2026-01-07 13:30:00', 4, 8905.00, 8957.00, 52.00, 52.00, 'VEHICULO', 53, 58, NULL, NULL, 8, 1, 'PROCESADO', 647, 6),
(153, 'R411002948', '2026-01-07 13:31:00', 4, 8957.00, 8964.00, 7.00, 7.00, 'VEHICULO', 37, 1, NULL, NULL, 8, 1, 'PROCESADO', 647, 6),
(154, 'R242000269', '2026-01-07 13:35:00', 4, 8964.00, 8989.00, 25.00, 25.00, 'VEHICULO', 89, 39, NULL, NULL, 8, 1, 'PROCESADO', 647, 6),
(155, 'R181004617', '2026-01-07 13:39:00', 4, 8989.00, 9029.00, 40.00, 40.00, 'VEHICULO', 90, 60, NULL, NULL, 8, 1, 'PROCESADO', 647, 6),
(156, 'R534000419', '2026-01-08 13:43:00', 4, 9029.00, 9059.00, 30.00, 30.00, 'VEHICULO', 91, 61, NULL, NULL, 8, 1, 'PROCESADO', 647, 6),
(157, 'R141000176', '2026-01-08 13:45:00', 4, 9059.00, 9069.00, 10.00, 10.00, 'VEHICULO', 88, 57, NULL, NULL, 8, 1, 'PROCESADO', 647, 6),
(158, 'R291003666', '2026-01-07 13:46:00', 4, 9069.00, 9079.00, 10.00, 10.00, 'VEHICULO', 87, 56, NULL, NULL, 8, 1, 'PROCESADO', 647, 6),
(159, 'R241000259', '2026-01-08 13:46:00', 4, 9079.00, 9169.00, 90.00, 90.00, 'VEHICULO', 86, 55, NULL, NULL, 8, 1, 'PROCESADO', 647, 6),
(160, 'R191001572', '2026-01-07 13:47:00', 4, 9169.00, 9179.00, 9.00, 9.00, 'VEHICULO', 72, 54, NULL, NULL, 8, 1, 'PROCESADO', 647, 6),
(161, 'B531002209', '2026-01-07 13:48:00', 4, 9179.00, 9199.00, 20.00, 20.00, 'BIDON', NULL, NULL, 4, NULL, 6, 1, 'PROCESADO', 647, 6),
(162, 'R411002947', '2026-01-07 13:52:00', 4, 9199.00, 9206.00, 7.00, 7.00, 'VEHICULO', 85, 53, NULL, NULL, 8, 1, 'PROCESADO', 647, 6),
(163, 'R161902392', '2026-01-07 06:55:00', 3, 64635.00, 64705.00, 70.00, 70.00, 'VEHICULO', 3, 62, NULL, NULL, 9, 1, 'PROCESADO', 653, 3),
(164, 'R531002203', '2026-01-07 06:55:00', 3, 64705.00, 64892.00, 200.00, 187.00, 'VEHICULO', 13, 12, NULL, NULL, 6, 1, 'PROCESADO', 653, 3),
(165, 'R631002204', '2026-01-07 06:56:00', 3, 64892.00, 64972.00, 80.00, 69.00, 'VEHICULO', 4, 12, NULL, NULL, 6, 1, 'PROCESADO', 653, 3),
(166, 'R531002219', '2026-01-07 07:02:00', 4, 9206.00, 9306.00, 100.00, 100.00, 'VEHICULO', 44, 6, NULL, NULL, 8, 1, 'PROCESADO', 655, 6),
(167, 'B405000107', '2026-01-07 07:13:00', 4, 9306.00, 10306.00, 1000.00, 1000.00, 'BIDON', NULL, NULL, 25, NULL, 11, 1, 'PROCESADO', 655, 6),
(168, 'R311090901', '2026-01-08 07:45:00', 4, 10306.00, 10314.00, 8.00, 8.00, 'VEHICULO', 92, 32, NULL, NULL, 9, 1, 'PROCESADO', 663, 6),
(169, 'R171000462', '2026-01-08 07:47:00', 4, 10314.00, 10319.00, 5.00, 5.00, 'VEHICULO', 93, 44, NULL, NULL, 8, 1, 'PROCESADO', 663, 6),
(170, 'B171000461', '2026-01-08 07:47:00', 4, 10319.00, 10339.00, 20.00, 20.00, 'BIDON', NULL, NULL, 20, NULL, 8, 1, 'PROCESADO', 663, 6),
(171, 'R531002232', '2026-01-08 07:48:00', 4, 10339.00, 10409.00, 70.00, 70.00, 'VEHICULO', 45, 8, NULL, NULL, 8, 1, 'PROCESADO', 663, 6),
(172, 'R531002231', '2026-01-08 07:49:00', 4, 10409.00, 10429.00, 20.00, 20.00, 'BIDON', NULL, NULL, 4, NULL, 8, 1, 'PROCESADO', 663, 6),
(173, 'R411002949', '2026-01-08 07:50:00', 4, 10429.00, 10474.00, 45.00, 45.00, 'VEHICULO', 49, 36, NULL, NULL, 3, 1, 'PROCESADO', 663, 6),
(174, 'R531002226', '2026-01-08 07:50:00', 4, 10474.00, 10484.00, 10.00, 10.00, 'VEHICULO', 56, 17, NULL, NULL, 8, 1, 'PROCESADO', 663, 6),
(175, 'R191001573', '2026-01-08 07:51:00', 4, 10484.00, 10494.00, 10.00, 10.00, 'VEHICULO', 73, 64, NULL, NULL, 8, 1, 'PROCESADO', 663, 6),
(176, 'R161002395', '2026-01-09 08:14:00', 3, 64972.00, 65042.00, 70.00, 70.00, 'VEHICULO', 3, 65, NULL, NULL, 11, 1, 'PROCESADO', 661, 3),
(177, 'R531002220', '2026-01-08 08:15:00', 3, 65042.00, 65122.00, 80.00, 80.00, 'VEHICULO', 27, 13, NULL, NULL, 3, 1, 'PROCESADO', 661, 3),
(178, 'R531002218', '2026-01-08 08:16:00', 3, 65122.00, 65202.00, 80.00, 80.00, 'VEHICULO', 28, 14, NULL, NULL, 3, 1, 'PROCESADO', 661, 3),
(179, 'R831002212', '2026-01-08 08:17:00', 3, 65202.00, 65282.00, 80.00, 80.00, 'VEHICULO', 19, 14, NULL, NULL, 3, 1, 'PROCESADO', 661, 3),
(180, 'R131000405', '2026-01-08 08:18:00', 3, 65282.00, 65296.00, 30.00, 14.00, 'VEHICULO', 94, 43, NULL, NULL, 8, 1, 'PROCESADO', 661, 3),
(181, 'R531002222', '2026-01-08 08:19:00', 3, 65296.00, 65376.00, 80.00, 80.00, 'VEHICULO', 18, 66, NULL, NULL, 8, 1, 'PROCESADO', 661, 3),
(182, 'R631002223', '2026-01-08 08:20:00', 3, 65376.00, 65456.00, 80.00, 80.00, 'VEHICULO', 21, 66, NULL, NULL, 8, 1, 'PROCESADO', 661, 3),
(183, 'R831002224', '2026-01-08 08:20:00', 3, 65456.00, 65536.00, 80.00, 80.00, 'VEHICULO', 22, 66, NULL, NULL, 8, 1, 'PROCESADO', 661, 3),
(184, 'R531002228', '2026-01-08 08:21:00', 3, 65536.00, 65616.00, 80.00, 80.00, 'VEHICULO', 23, 17, NULL, NULL, 9, 1, 'PROCESADO', 661, 3),
(185, 'B531002213', '2026-01-08 08:22:00', 3, 65616.00, 65656.00, 40.00, 40.00, 'BIDON', NULL, NULL, 4, NULL, 8, 1, 'PROCESADO', 661, 3),
(186, 'R530001075', '2026-01-08 08:22:00', 3, 65656.00, 65687.00, 31.00, 31.00, 'VEHICULO', 79, 23, NULL, NULL, 3, 1, 'PROCESADO', 661, 3),
(187, 'B530001074', '2026-01-08 08:24:00', 3, 65687.00, 65727.00, 40.00, 40.00, 'BIDON', NULL, NULL, 10, NULL, 3, 1, 'PROCESADO', 661, 3),
(188, 'R531002227', '2026-01-08 08:25:00', 3, 65727.00, 65827.00, 100.00, 100.00, 'VEHICULO', 95, 17, NULL, NULL, 8, 1, 'PROCESADO', 661, 3),
(189, 'B311000900', '2026-01-09 08:25:00', 3, 65827.00, 66127.00, 300.00, 300.00, 'VEHICULO', 2, 32, NULL, NULL, 9, 1, 'PROCESADO', 661, 3),
(190, 'R531002241', '2026-01-08 08:58:00', 3, 66127.00, 66227.00, 100.00, 100.00, 'VEHICULO', 46, 19, NULL, NULL, 4, 1, 'PROCESADO', 669, 3),
(191, 'R161002398', '2026-01-08 09:03:00', 3, 66227.00, 66297.00, 70.00, 70.00, 'VEHICULO', 6, 62, NULL, NULL, 8, 1, 'PROCESADO', 669, 3),
(192, 'RA31002234', '2026-01-08 09:05:00', 3, 66297.00, 66377.00, 80.00, 64.00, 'VEHICULO', 4, 67, NULL, NULL, 11, 1, 'PROCESADO', 669, 3),
(193, 'R531002233', '2026-01-08 09:06:00', 3, 66377.00, 66577.00, 200.00, 200.00, 'VEHICULO', 5, 67, NULL, NULL, 11, 1, 'PROCESADO', 669, 3),
(194, 'R241000261', '2026-01-08 09:44:00', 4, 10494.00, 10504.00, 10.00, 10.00, 'VEHICULO', 96, 68, NULL, NULL, 6, 1, 'PROCESADO', 671, 6),
(195, 'B531002225', '2026-01-08 09:45:00', 4, 10504.00, 10524.00, 20.00, 20.00, 'BIDON', NULL, NULL, 4, NULL, 8, 1, 'PROCESADO', 671, 6),
(196, 'R831002256', '2026-01-09 15:23:00', 3, 66577.00, 66657.00, 80.00, 80.00, 'VEHICULO', 31, 20, NULL, NULL, 8, 1, 'PROCESADO', 677, 3),
(197, 'B311000903', '2026-01-09 15:25:00', 3, 66657.00, 67057.00, 400.00, 400.00, 'VEHICULO', 2, 32, NULL, NULL, 8, 1, 'PROCESADO', 677, 3),
(198, 'RO31002253', '2026-01-09 15:31:00', 3, 67057.00, 67112.00, 100.00, 55.00, 'VEHICULO', 97, 69, NULL, NULL, 3, 1, 'PROCESADO', 677, 3),
(199, 'R531002254', '2026-01-09 15:36:00', 3, 67112.00, 67212.00, 100.00, 100.00, 'VEHICULO', 98, 18, NULL, NULL, 9, 1, 'PROCESADO', 677, 3),
(200, 'R531002257', '2026-01-09 15:38:00', 3, 67212.00, 67292.00, 100.00, 80.00, 'VEHICULO', 95, 70, NULL, NULL, 3, 1, 'PROCESADO', 677, 3),
(201, 'R431002251', '2026-01-09 15:38:00', 3, 67292.00, 67372.00, 80.00, 80.00, 'VEHICULO', 20, 17, NULL, NULL, 8, 1, 'PROCESADO', 677, 3),
(202, 'R631002244', '2026-01-09 15:43:00', 3, 67372.00, 67413.00, 60.00, 41.00, 'VEHICULO', 99, 71, NULL, NULL, 8, 1, 'PROCESADO', 677, 3),
(203, 'R931002250', '2026-01-09 15:58:00', 3, 67413.00, 67493.00, 80.00, 80.00, 'VEHICULO', 22, 72, NULL, NULL, 8, 1, 'PROCESADO', 677, 3),
(204, 'R531002247', '2026-01-09 16:01:00', 3, 67493.00, 67573.00, 80.00, 80.00, 'VEHICULO', 27, 73, NULL, NULL, 8, 1, 'PROCESADO', 677, 3),
(205, 'R531002248', '2026-01-09 16:02:00', 3, 67573.00, 67653.00, 80.00, 80.00, 'VEHICULO', 21, 13, NULL, NULL, 8, 1, 'PROCESADO', 677, 3),
(206, 'R531002249', '2026-01-09 16:03:00', 3, 67653.00, 67733.00, 80.00, 80.00, 'VEHICULO', 28, 73, NULL, NULL, 8, 1, 'PROCESADO', 677, 3),
(207, 'R161002400', '2026-01-09 16:10:00', 3, 67733.00, 67803.00, 70.00, 70.00, 'VEHICULO', 8, 65, NULL, NULL, 11, 1, 'PROCESADO', 677, 3),
(208, 'Bidon01', '2026-01-09 16:11:00', 3, 67803.00, 67853.00, 50.00, 50.00, 'BIDON', NULL, NULL, 7, NULL, 3, 1, 'PROCESADO', 677, 3),
(209, 'R241900262', '2026-01-09 16:20:00', 4, 10524.00, 10574.00, 50.00, 50.00, 'VEHICULO', 100, 68, NULL, NULL, 9, 1, 'PROCESADO', 679, 6),
(210, 'B141800177', '2026-01-09 16:32:00', 4, 10574.00, 10594.00, 20.00, 20.00, 'VEHICULO', 39, 74, NULL, NULL, 8, 1, 'PROCESADO', 679, 6),
(211, 'B532000420', '2026-01-11 16:33:00', 4, 10594.00, 10614.00, 20.00, 20.00, 'BIDON', NULL, NULL, 12, NULL, 8, 1, 'PROCESADO', 679, 6),
(212, 'B537000057', '2026-01-09 16:37:00', 4, 10614.00, 10684.00, 70.00, 70.00, 'BIDON', NULL, NULL, 26, NULL, 8, 1, 'PROCESADO', 679, 6),
(213, 'B537000056', '2026-01-09 16:38:00', 4, 10684.00, 10824.00, 140.00, 140.00, 'BIDON', NULL, NULL, 26, NULL, 8, 1, 'PROCESADO', 679, 6),
(214, 'B531002258', '2026-01-09 16:39:00', 4, 10824.00, 10844.00, 20.00, 20.00, 'BIDON', NULL, NULL, 4, 'Celso Suárez retira', 8, 1, 'PROCESADO', 679, 6),
(215, 'R291003693', '2026-01-09 16:40:00', 4, 10844.00, 10914.00, 70.00, 70.00, 'VEHICULO', 52, 76, NULL, NULL, 8, 1, 'PROCESADO', 679, 6),
(216, 'R181004618', '2026-01-09 16:43:00', 4, 10914.00, 10954.00, 40.00, 40.00, 'VEHICULO', 101, 77, NULL, NULL, 9, 1, 'PROCESADO', 679, 6),
(217, 'R531002255', '2026-01-09 17:07:00', 3, 67853.00, 67933.00, 80.00, 80.00, 'VEHICULO', 36, 78, NULL, NULL, 3, 1, 'PROCESADO', 685, 3),
(218, 'R161002405', '2026-01-09 17:08:00', 3, 67933.00, 68003.00, 70.00, 70.00, 'VEHICULO', 6, 62, NULL, NULL, 9, 1, 'PROCESADO', 685, 3),
(219, 'R530001076', '2026-01-09 17:11:00', 4, 10954.00, 11014.00, 60.00, 60.00, 'VEHICULO', 102, 79, NULL, NULL, 11, 1, 'PROCESADO', 687, 6),
(220, 'B530001077', '2026-01-09 17:12:00', 4, 11014.00, 11054.00, 40.00, 40.00, 'BIDON', NULL, NULL, 10, NULL, 11, 1, 'PROCESADO', 687, 6),
(221, 'B242000270', '2026-01-11 17:33:00', 4, 11054.00, 11074.00, 20.00, 20.00, 'BIDON', NULL, NULL, 7, NULL, 8, 1, 'PROCESADO', 695, 6),
(222, 'R211000109', '2026-01-10 17:34:00', 4, 11074.00, 11094.00, 20.00, 20.00, 'VEHICULO', 58, 33, NULL, NULL, 3, 1, 'PROCESADO', 695, 6),
(223, '8531002271', '2026-01-10 17:35:00', 4, 11094.00, 11114.00, 20.00, 20.00, 'BIDON', NULL, NULL, 4, 'Moto bomba', 8, 1, 'PROCESADO', 695, 6),
(224, 'R291003701', '2026-01-11 17:43:00', 4, 11114.00, 11134.00, 20.00, 20.00, 'VEHICULO', 103, 80, NULL, NULL, 8, 1, 'PROCESADO', 695, 6),
(225, 'R311000905', '2026-01-10 17:46:00', 4, 11134.00, 11194.00, 60.00, 60.00, 'VEHICULO', 50, 28, NULL, NULL, 8, 1, 'PROCESADO', 695, 6),
(226, 'R411002951', '2026-01-10 17:47:00', 4, 11194.00, 11239.00, 45.00, 45.00, 'VEHICULO', 55, 27, NULL, NULL, 3, 1, 'PROCESADO', 695, 6),
(227, 'R141000178', '2026-01-10 17:48:00', 4, 11239.00, 11249.00, 10.00, 10.00, 'VEHICULO', 88, 57, NULL, NULL, 9, 1, 'PROCESADO', 695, 6),
(228, 'R291003700', '2026-01-10 17:54:00', 4, 11249.00, 11289.00, 40.00, 40.00, 'VEHICULO', 104, 81, NULL, NULL, 9, 1, 'PROCESADO', 695, 6),
(229, 'R411002950', '2026-01-11 17:55:00', 4, 11289.00, 11296.00, 7.00, 7.00, 'VEHICULO', 85, 53, NULL, NULL, 3, 1, 'PROCESADO', 695, 6),
(230, '8534000420', '2026-01-10 17:56:00', 4, 11296.00, 11366.00, 70.00, 70.00, 'BIDON', NULL, NULL, 24, NULL, 3, 1, 'PROCESADO', 695, 6),
(231, 'B171000463', '2026-01-10 17:57:00', 4, 11366.00, 11386.00, 20.00, 20.00, 'BIDON', NULL, NULL, 20, NULL, 8, 1, 'PROCESADO', 695, 6),
(232, 'B531002270', '2026-01-11 18:14:00', 4, 11386.00, 11586.00, 200.00, 200.00, 'BIDON', NULL, NULL, 4, NULL, 9, 1, 'PROCESADO', 695, 6),
(233, 'R161002408', '2026-01-10 18:15:00', 3, 68003.00, 68073.00, 70.00, 70.00, 'VEHICULO', 6, 65, NULL, NULL, 11, 1, 'PROCESADO', 693, 3),
(234, 'R531002273', '2026-01-10 18:16:00', 3, 68073.00, 68153.00, 80.00, 80.00, 'VEHICULO', 35, 19, NULL, NULL, 8, 1, 'PROCESADO', 693, 3),
(235, 'B311000906', '2026-01-10 18:17:00', 3, 68153.00, 68453.00, 300.00, 300.00, 'VEHICULO', 2, 32, NULL, NULL, 9, 1, 'PROCESADO', 693, 3),
(236, 'B410000025', '2026-01-10 18:17:00', 3, 68453.00, 69453.00, 1000.00, 1000.00, 'BIDON', NULL, NULL, 15, NULL, 8, 1, 'PROCESADO', 693, 3),
(237, 'B409000068', '2026-01-10 18:18:00', 3, 69453.00, 70453.00, 1000.00, 1000.00, 'BIDON', NULL, NULL, 13, NULL, 8, 1, 'PROCESADO', 693, 3),
(238, 'B404000038', '2026-01-10 18:22:00', 3, 70453.00, 72453.00, 2000.00, 2000.00, 'BIDON', NULL, NULL, 27, NULL, 8, 1, 'PROCESADO', 693, 3),
(239, 'R531002262', '2026-01-10 18:22:00', 3, 72453.00, 72653.00, 200.00, 200.00, 'VEHICULO', 13, 2, NULL, NULL, 3, 1, 'PROCESADO', 693, 3),
(240, 'R531002263', '2026-01-10 18:23:00', 3, 72653.00, 72733.00, 80.00, 80.00, 'VEHICULO', 4, 2, NULL, NULL, 3, 1, 'PROCESADO', 693, 3),
(241, 'R191001574', '2026-01-10 18:28:00', 3, 72733.00, 72783.00, 50.00, 50.00, 'VEHICULO', 105, 82, NULL, NULL, 3, 1, 'PROCESADO', 693, 3),
(242, 'R531002275', '2026-01-10 18:42:00', 3, 72783.00, 72848.00, 80.00, 65.00, 'VEHICULO', 106, 67, NULL, NULL, 8, 1, 'PROCESADO', 717, 3),
(243, 'R161002413', '2026-01-10 18:47:00', 3, 72848.00, 72948.00, 100.00, 100.00, 'VEHICULO', 8, 67, NULL, NULL, 8, 1, 'PROCESADO', 717, 3),
(244, 'R161002414', '2026-01-10 18:48:00', 3, 72948.00, 73018.00, 70.00, 70.00, 'VEHICULO', 15, 62, NULL, NULL, 8, 1, 'PROCESADO', 717, 3),
(245, 'R161002412', '2026-01-10 18:49:00', 3, 73018.00, 73118.00, 100.00, 100.00, 'VEHICULO', 3, 62, NULL, NULL, 8, 1, 'PROCESADO', 717, 3),
(246, 'R531002274', '2026-01-10 18:49:00', 3, 73118.00, 73318.00, 200.00, 182.00, 'VEHICULO', 13, 67, NULL, NULL, 8, 1, 'PROCESADO', 717, 3),
(247, 'R531002276', '2026-01-10 18:52:00', 4, 11586.00, 11646.00, 60.00, 60.00, 'VEHICULO', 45, 83, NULL, NULL, 8, 1, 'PROCESADO', 719, 6),
(248, 'R141000181', '2026-01-10 18:53:00', 4, 11646.00, 11656.00, 10.00, 10.00, 'VEHICULO', 38, 48, NULL, NULL, 11, 1, 'PROCESADO', 719, 6),
(249, 'R141000179', '2026-01-10 18:54:00', 4, 11656.00, 11666.00, 10.00, 10.00, 'VEHICULO', 43, 50, NULL, NULL, 11, 1, 'PROCESADO', 719, 6),
(250, 'R141000180', '2026-01-10 18:55:00', 4, 11666.00, 11676.00, 10.00, 10.00, 'VEHICULO', 42, 50, NULL, NULL, 11, 1, 'PROCESADO', 719, 6),
(251, 'R530001080', '2026-01-11 07:22:00', 4, 11676.00, 11733.00, 60.00, 57.00, 'VEHICULO', 102, 79, NULL, NULL, 2, 1, 'PROCESADO', 727, 6),
(252, 'R131000408', '2026-01-11 07:24:00', 4, 11733.00, 11793.00, 60.00, 60.00, 'VEHICULO', 76, 84, NULL, NULL, 10, 1, 'PROCESADO', 727, 6),
(253, 'R531002300', '2026-01-11 07:31:00', 4, 11793.00, 11823.00, 30.00, 30.00, 'VEHICULO', 107, 85, NULL, NULL, 8, 1, 'PROCESADO', 727, 6),
(254, 'R171000464', '2026-01-11 07:32:00', 4, 11823.00, 11833.00, 10.00, 10.00, 'VEHICULO', 69, 37, NULL, NULL, 8, 1, 'PROCESADO', 727, 6),
(255, 'R131000406', '2026-01-11 07:35:00', 4, 11833.00, 11843.00, 10.00, 10.00, 'VEHICULO', 108, 43, NULL, NULL, 12, 1, 'PROCESADO', 727, 6),
(257, 'R531002295', '2026-01-11 08:08:00', 4, 11903.00, 11958.00, 60.00, 55.00, 'VEHICULO', 45, 86, NULL, ' [Editado Cant: 60 -> 55]', 12, 1, 'PROCESADO', 727, 6),
(258, 'R531002294', '2026-01-11 08:17:00', 4, 11958.00, 11978.00, 20.00, 20.00, 'BIDON', NULL, NULL, 4, 'Bidón Mantenimiento  [Editado Cant: 20 -> 20]', 8, 1, 'PROCESADO', 727, 6),
(259, 'R211000110', '2026-01-11 08:30:00', 4, 11978.00, 11993.00, 15.00, 15.00, 'VEHICULO', 109, 87, NULL, ' [Editado Cant: 15 -> 15] [Editado Cant: 15 -> 15] [Editado Cant: 15 -> 15] [Editado Cant: 15 -> 15]', 8, 1, 'PROCESADO', 727, 6),
(260, 'R1910641575', '2026-01-11 08:41:00', 4, 11993.00, 12023.00, 30.00, 30.00, 'VEHICULO', 110, 88, NULL, NULL, 6, 1, 'PROCESADO', 727, 6),
(261, 'RS31002289', '2026-01-11 08:45:00', 3, 73318.00, 73518.00, 200.00, 200.00, 'VEHICULO', 13, 89, NULL, NULL, 8, 1, 'PROCESADO', 725, 3),
(262, 'R531002302', '2026-01-11 08:46:00', 3, 73518.00, 73598.00, 80.00, 80.00, 'VEHICULO', 31, 20, NULL, NULL, 8, 1, 'PROCESADO', 725, 3),
(263, 'B531002301', '2026-01-11 08:47:00', 3, 73598.00, 73638.00, 40.00, 40.00, 'BIDON', NULL, NULL, 4, NULL, 8, 1, 'PROCESADO', 725, 3),
(264, 'R531002299', '2026-01-11 12:48:00', 3, 73638.00, 73700.00, 100.00, 62.00, 'VEHICULO', 4, 90, NULL, ' [Editado Cant: 100 -> 62]', 10, 1, 'PROCESADO', 725, 3),
(265, 'B531002283', '2026-01-11 08:49:00', 3, 73738.00, 73938.00, 200.00, 200.00, 'BIDON', NULL, NULL, 4, NULL, 8, 1, 'PROCESADO', 725, 3),
(266, 'R531002293', '2026-01-11 08:52:00', 3, 73938.00, 74018.00, 80.00, 80.00, 'VEHICULO', 24, 91, NULL, NULL, 8, 1, 'PROCESADO', 725, 3),
(267, 'R531002292', '2026-01-11 08:53:00', 3, 74018.00, 74098.00, 80.00, 80.00, 'VEHICULO', 20, 91, NULL, NULL, 8, 1, 'PROCESADO', 725, 3),
(268, 'B531002282', '2026-01-11 08:54:00', 3, 74098.00, 74298.00, 200.00, 200.00, 'BIDON', NULL, NULL, 4, NULL, 8, 1, 'PROCESADO', 725, 3),
(269, 'R531002284', '2026-01-11 08:55:00', 3, 74298.00, 74378.00, 80.00, 80.00, 'VEHICULO', 19, 92, NULL, NULL, 8, 1, 'PROCESADO', 725, 3),
(270, 'R531002288', '2026-01-11 08:56:00', 3, 74378.00, 74458.00, 80.00, 80.00, 'VEHICULO', 23, 73, NULL, NULL, 8, 1, 'PROCESADO', 725, 3),
(271, 'R531002287', '2026-01-11 08:57:00', 3, 74458.00, 74538.00, 80.00, 80.00, 'VEHICULO', 27, 73, NULL, NULL, 8, 1, 'PROCESADO', 725, 3),
(272, 'R531002286', '2026-01-11 08:58:00', 3, 74538.00, 74618.00, 80.00, 80.00, 'VEHICULO', 18, 91, NULL, NULL, 8, 1, 'PROCESADO', 725, 3),
(273, 'R531002285', '2026-01-11 08:58:00', 3, 74618.00, 74698.00, 80.00, 80.00, 'VEHICULO', 28, 73, NULL, NULL, 8, 1, 'PROCESADO', 725, 3),
(274, 'R161002419', '2026-01-11 08:59:00', 3, 74698.00, 74798.00, 100.00, 100.00, 'VEHICULO', 8, 65, NULL, NULL, 11, 1, 'PROCESADO', 725, 3),
(275, 'R130001078', '2026-01-11 09:00:00', 3, 74798.00, 74845.00, 50.00, 47.00, 'VEHICULO', 78, 45, NULL, NULL, 8, 1, 'PROCESADO', 725, 3),
(276, 'R161002418', '2026-01-11 09:01:00', 3, 74845.00, 74945.00, 100.00, 100.00, 'VEHICULO', 3, 65, NULL, NULL, 11, 1, 'PROCESADO', 725, 3),
(277, 'R161002417', '2026-01-11 09:02:00', 3, 74945.00, 75015.00, 70.00, 70.00, 'VEHICULO', 15, 65, NULL, NULL, 11, 1, 'PROCESADO', 725, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dispensadores`
--

CREATE TABLE `dispensadores` (
  `id_dispensador` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL COMMENT 'Identificador ej: Surtidor Gasolina 01',
  `odometro_actual` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT 'Lectura acumulada del contador mecánico',
  `id_tanque_asociado` int(11) NOT NULL COMMENT 'De qué tanque descuenta el inventario',
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `registrado_por` int(11) DEFAULT NULL,
  `fecha_registro` datetime DEFAULT NULL,
  `fecha_modificacion` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `dispensadores`
--

INSERT INTO `dispensadores` (`id_dispensador`, `nombre`, `odometro_actual`, `id_tanque_asociado`, `estado`, `registrado_por`, `fecha_registro`, `fecha_modificacion`) VALUES
(3, 'SURTIDOR GASOIL 01', 74977.00, 3, 'ACTIVO', 1, '2025-11-23 13:24:37', '2025-12-28 16:21:29'),
(4, 'SURTIDOR GASOLINA 01', 12023.00, 6, 'ACTIVO', 1, '2025-11-25 17:13:26', '2025-12-27 09:12:29');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gerencias`
--

CREATE TABLE `gerencias` (
  `id_gerencia` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `encargado_cedula` varchar(20) NOT NULL,
  `encargado_nombre` varchar(50) NOT NULL,
  `encargado_apellido` varchar(50) NOT NULL,
  `encargado_telefono` varchar(20) NOT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_registro` datetime DEFAULT NULL,
  `fecha_modificacion` datetime DEFAULT NULL,
  `registrado_por` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `gerencias`
--

INSERT INTO `gerencias` (`id_gerencia`, `nombre`, `encargado_cedula`, `encargado_nombre`, `encargado_apellido`, `encargado_telefono`, `correo`, `estado`, `fecha_registro`, `fecha_modificacion`, `registrado_por`) VALUES
(1, 'GERENCIA DE PREVENCION CONTROL Y PERDIDA', '123456', 'PEDRO', 'GONZALES', '12323232323232', '', 'ACTIVO', '2025-11-23 11:41:13', '2025-11-23 11:41:13', 1),
(2, 'PROCESOS INTERNOS GPYMM', '123456', 'RUBILET', 'ALVAREZ', '3444444444', '', 'ACTIVO', '2025-11-23 11:41:41', '2025-12-08 16:19:52', 1),
(3, 'PROCESOS INTERNOS GGEP', '18073922', 'PEDRO ', 'PEREZ', '33333333333333', '', 'ACTIVO', '2025-11-23 12:49:31', '2025-11-23 12:56:27', 1),
(4, 'GENESIS', '123456', 'PEDRO', 'JULIAN', '222222222', '', 'ACTIVO', '2025-11-23 13:03:30', '2025-11-23 13:03:30', 1),
(5, 'PROCESOS INTERNOS GTH', '1234562', 'SIRIA', 'MUÑOZ', '2233333333', '', 'ACTIVO', '2025-11-23 13:06:02', '2025-11-23 13:06:02', 1),
(6, 'PROCESOS INTERNOS GPGA', '1234556', 'NOLAN', 'VELASQUEZ', '3333333333', '', 'ACTIVO', '2025-11-24 08:04:04', '2025-11-24 08:04:04', 1),
(7, 'GNB', '12345678', 'JOSE ', 'PEREZ', '0286000000', '', 'ACTIVO', '2025-12-08 10:56:59', '2025-12-08 10:56:59', 1),
(8, 'AURORA GLOBAL SPARK C.A', '1234567', 'AURORA', 'LOPEZ', '000000000', '', 'ACTIVO', '2025-12-08 14:17:09', '2025-12-08 14:17:09', 1),
(9, 'PROCESOS INTERNOS GL', '22424222', 'PEDRO', 'PEREZ', '000000000', '', 'ACTIVO', '2025-12-08 16:20:49', '2025-12-08 16:20:49', 1),
(10, 'PRESIDENCIA', '23423134', 'CESAR', 'JAIME', '0000000000', '', 'ACTIVO', '2025-12-09 15:58:36', '2025-12-09 15:58:36', 1),
(11, 'PRODUCCION DE MINA GPM', '23233422', 'PEDROQ', 'LION', '000000000', '', 'ACTIVO', '2025-12-09 16:34:06', '2025-12-09 16:34:06', 1),
(12, 'INGENIERIA 615 AVENDAÑO', '2345463', 'JULIAN', 'PEREZ', '00000000', '', 'ACTIVO', '2025-12-09 16:38:53', '2025-12-09 16:38:53', 1),
(13, 'MINAVEN C.A', '27727341', 'ROSVELT', 'FLORES', '0000000', '', 'ACTIVO', '2025-12-09 16:44:21', '2025-12-09 16:44:21', 1),
(14, 'MINA LOS REYES AK', '1234562', 'JOSE', 'BORDONEZ', '0000000000', '', 'ACTIVO', '2025-12-09 16:45:35', '2025-12-09 16:45:35', 1),
(15, 'MINASIL C.A', '23456789', 'JOSE', 'BORDONES', '000000000000', '', 'ACTIVO', '2025-12-09 16:46:17', '2025-12-09 16:46:17', 1),
(16, 'BETA PUNTO DORADO', '12345678', 'JOSE ', 'BORDONES', '0000000000', '', 'ACTIVO', '2025-12-11 15:11:17', '2025-12-11 15:11:17', 1),
(17, 'PROCESOS INTERNOS GTI', '18073922', 'JOSE', 'PEREZ', '00000000', '', 'ACTIVO', '2025-12-21 22:20:46', '2025-12-21 22:20:46', 1),
(18, 'PROCESOS INTERNOS', '12345678', 'PEDRO ', 'PEREZ', '00000000', '', 'ACTIVO', '2026-01-05 08:37:57', '2026-01-05 08:37:57', 1),
(19, 'PROCESOS INTERNOS GGO', '12345678', 'PEDRO', 'PEREZ', '00000000', '', 'ACTIVO', '2026-01-05 08:41:22', '2026-01-05 08:41:22', 1),
(20, 'PROCESOS INTERNOS GSGYA', '123435678', 'AMALIA', 'IZAGA', '00000000', '', 'ACTIVO', '2026-01-05 09:10:38', '2026-01-05 09:10:38', 1),
(21, 'PROCESOS INTERNOS GP', '12543678', '`LORENA', 'BRAVO', '00000000', '', 'ACTIVO', '2026-01-08 09:21:16', '2026-01-08 09:21:16', 1),
(22, 'DGCIM', '12543876', 'JOSE', 'MONCADA', '00000000', '', 'ACTIVO', '2026-01-08 11:03:58', '2026-01-08 11:03:58', 1),
(23, 'PROCESOS INTERNOS GPE', '121212', 'ROSA', 'GIMENEZ', '0000000', '', 'ACTIVO', '2026-01-08 13:37:05', '2026-01-08 13:37:05', 1),
(24, 'URRA CAPITAL', '12543876', 'MENDEZ', 'GONZALOS', '000000000', '', 'ACTIVO', '2026-01-08 13:41:46', '2026-01-08 13:41:46', 1),
(25, 'CORPORACION MINING VENEZUELA', '22678903', 'JOSUE', 'MONAGAS', '00000000', '', 'ACTIVO', '2026-01-09 07:13:20', '2026-01-09 07:13:20', 1),
(26, 'JEH0VA ES FIEL', '23456789', 'JOSE', 'BORNODES', '0000000', '', 'ACTIVO', '2026-01-11 16:36:30', '2026-01-11 16:36:30', 1),
(27, 'MOLIENDA PEMON C.A', '23456789', 'JOSE', 'BORDONES', '00000000', '', 'ACTIVO', '2026-01-11 18:20:06', '2026-01-11 18:20:06', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marcas`
--

CREATE TABLE `marcas` (
  `id_marca` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_registro` datetime DEFAULT NULL,
  `fecha_modificacion` datetime DEFAULT NULL,
  `registrado_por` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `marcas`
--

INSERT INTO `marcas` (`id_marca`, `nombre`, `estado`, `fecha_registro`, `fecha_modificacion`, `registrado_por`) VALUES
(1, 'Toyota', 'ACTIVO', '2025-11-19 13:58:23', '2025-11-19 13:58:23', 1),
(2, 'FORD', 'ACTIVO', '2025-11-19 14:05:21', '2025-11-19 14:05:21', 1),
(3, 'JEEP', 'ACTIVO', '2025-11-19 14:06:48', '2025-11-19 14:06:48', 1),
(4, 'Volkswagen', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(5, 'Mercedes-Benz', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(6, 'BMW', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(7, 'Honda', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(8, 'Nissan', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(9, 'Chevrolet', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(10, 'Hyundai', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(11, 'Kia', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(12, 'Volvo', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(13, 'Audi', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(14, 'Renault', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(15, 'Peugeot', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(16, 'Mitsubishi', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(17, 'Subaru', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(18, 'Mazda', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(19, 'Isuzu', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(20, 'Scania', 'ACTIVO', '2025-11-23 11:24:28', '2025-11-23 11:24:28', 1),
(21, 'Masven', 'ACTIVO', '2025-11-23 11:39:52', '2025-11-23 11:39:52', 1),
(22, 'CUMMINS', 'ACTIVO', '2025-11-23 11:40:00', '2025-11-23 12:50:56', 1),
(23, 'Caterpila', 'ACTIVO', '2025-11-23 13:02:24', '2025-11-23 13:02:24', 1),
(24, 'Encava', 'ACTIVO', '2025-11-23 13:07:18', '2025-11-23 13:07:18', 1),
(25, 'Michigan', 'ACTIVO', '2025-11-23 13:15:19', '2025-11-23 13:15:19', 1),
(26, 'Bera', 'ACTIVO', '2025-11-24 07:53:26', '2025-11-24 07:53:26', 1),
(27, 'Mack', 'ACTIVO', '2025-11-24 08:00:37', '2025-11-24 08:00:37', 1),
(28, 'JAC', 'ACTIVO', '2025-11-27 13:37:00', '2025-11-27 13:37:00', 1),
(29, 'FREIGHTLINER', 'ACTIVO', '2025-11-27 13:40:38', '2025-11-27 13:40:38', 1),
(30, 'IVECO', 'ACTIVO', '2025-12-08 11:41:22', '2025-12-08 11:41:22', 1),
(31, 'JUMBO-CASE', 'ACTIVO', '2025-12-08 13:14:52', '2025-12-08 13:20:25', 1),
(32, 'TEYA', 'ACTIVO', '2025-12-08 14:35:09', '2025-12-08 14:35:09', 1),
(33, 'Horse', 'ACTIVO', '2025-12-08 14:42:43', '2025-12-08 14:42:43', 1),
(34, 'Jaguar', 'ACTIVO', '2025-12-08 14:47:16', '2025-12-08 14:47:16', 1),
(35, 'Haojin', 'ACTIVO', '2025-12-08 14:49:49', '2025-12-08 14:49:49', 1),
(36, 'KEEWAY', 'ACTIVO', '2025-12-08 16:30:21', '2025-12-08 16:30:21', 1),
(37, 'DODGE', 'ACTIVO', '2025-12-09 12:34:04', '2025-12-09 12:34:04', 1),
(38, 'DONGFENG', 'ACTIVO', '2025-12-09 16:19:27', '2025-12-09 16:19:27', 1),
(39, 'TOYAMA', 'ACTIVO', '2026-01-05 09:29:29', '2026-01-05 09:29:29', 1),
(40, 'AVA', 'ACTIVO', '2026-01-05 13:31:36', '2026-01-05 13:31:36', 1),
(41, 'MD', 'ACTIVO', '2026-01-07 17:56:55', '2026-01-07 17:56:55', 1),
(42, 'AMBULANCIA', 'ACTIVO', '2026-01-08 09:14:56', '2026-01-08 09:14:56', 1),
(43, 'CHERY', 'ACTIVO', '2026-01-11 17:52:01', '2026-01-11 17:52:01', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mediciones_tanques`
--

CREATE TABLE `mediciones_tanques` (
  `id_medicion` int(11) NOT NULL,
  `id_tanque` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `fecha_hora_medicion` datetime NOT NULL,
  `nivel_sistema_anterior` decimal(12,2) NOT NULL COMMENT 'Inventario teórico que tenía el software antes de medir',
  `medida_vara` decimal(10,2) DEFAULT NULL COMMENT 'Altura leída en CM o Pulgadas',
  `litros_evaporacion` decimal(10,2) DEFAULT 0.00 COMMENT 'Merma justificada por evaporación',
  `litros_reales_aforo` decimal(12,2) DEFAULT NULL COMMENT 'Volumen resultante según la tabla de aforo',
  `diferencia_neta` decimal(12,2) NOT NULL,
  `observacion` text DEFAULT NULL,
  `estado` enum('PROCESADO','ANULADO') DEFAULT 'PROCESADO',
  `fecha_registro` datetime DEFAULT NULL,
  `id_cierre` int(11) DEFAULT NULL,
  `litros_manuales_ingresados` decimal(12,2) DEFAULT NULL COMMENT 'Litros ingresados manualmente por el usuario',
  `tipo_medicion` enum('AFORO','MANUAL') NOT NULL COMMENT 'Indica si la medición se basó en tabla de aforo o fue manual'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `mediciones_tanques`
--

INSERT INTO `mediciones_tanques` (`id_medicion`, `id_tanque`, `id_usuario`, `fecha_hora_medicion`, `nivel_sistema_anterior`, `medida_vara`, `litros_evaporacion`, `litros_reales_aforo`, `diferencia_neta`, `observacion`, `estado`, `fecha_registro`, `id_cierre`, `litros_manuales_ingresados`, `tipo_medicion`) VALUES
(30, 6, 1, '2026-01-02 16:21:00', 5822.00, 51.78, 0.00, 5822.00, 0.00, '', 'PROCESADO', '2026-01-02 16:24:09', 415, NULL, 'AFORO'),
(31, 3, 1, '2026-01-02 16:33:00', 34712.00, 168.00, 0.00, 29027.96, 5684.04, '', 'PROCESADO', '2026-01-02 16:36:32', 413, NULL, 'AFORO'),
(32, 3, 1, '2026-01-02 17:30:00', 28757.96, 200.00, 0.00, 35566.00, -0.89, 'Medición Automática por Recepción de Cisterna (Guía: 13212312). Faltantes en guía: -0.89 L. Nivel final: 35566.00 L. ', 'PROCESADO', '2026-01-02 17:33:25', 425, 35566.00, 'MANUAL'),
(33, 3, 1, '2026-01-02 17:46:00', 35566.00, 188.77, 0.00, 33265.72, 2300.28, '', 'PROCESADO', '2026-01-02 17:47:46', 425, NULL, 'AFORO'),
(34, 6, 1, '2026-01-02 17:47:00', 5794.00, 51.61, 0.00, 5794.00, 0.00, '', 'PROCESADO', '2026-01-02 17:51:55', 427, 5794.00, 'MANUAL'),
(35, 3, 1, '2026-01-02 18:58:00', 32799.72, 164.00, 0.00, 28194.00, 4605.00, '', 'PROCESADO', '2026-01-02 18:59:36', 431, 28194.00, 'MANUAL'),
(36, 6, 1, '2026-01-02 18:59:00', 5667.00, 50.81, 0.00, 5667.00, 0.00, '', 'PROCESADO', '2026-01-02 19:02:07', 433, NULL, 'AFORO'),
(37, 3, 1, '2026-01-02 19:08:00', 27974.00, 142.50, 0.00, 23670.76, 4303.24, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-02 19:11:48', NULL, NULL, 'AFORO'),
(38, 6, 1, '2026-01-02 19:12:00', 5667.00, 50.50, 0.00, 5617.00, 50.00, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-02 19:16:21', NULL, 5617.00, 'MANUAL'),
(39, 6, 1, '2026-01-02 19:37:00', 5667.00, 50.50, 0.00, 5617.00, 50.00, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-02 19:38:13', NULL, 5617.00, 'MANUAL'),
(40, 3, 1, '2026-01-02 19:38:00', 27974.00, 142.50, 0.00, 23670.00, 4304.00, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-02 19:38:41', NULL, 23670.00, 'MANUAL'),
(41, 3, 1, '2026-01-02 19:43:00', 27974.00, 142.50, 0.00, 23670.00, 4304.00, '', 'PROCESADO', '2026-01-02 19:44:13', 455, 23670.00, 'MANUAL'),
(42, 6, 1, '2026-01-02 19:44:00', 5667.00, 50.50, 0.00, 5617.00, 50.00, '', 'PROCESADO', '2026-01-02 19:44:32', 457, 5617.00, 'MANUAL'),
(43, 3, 1, '2026-01-04 14:58:00', 22544.00, 124.00, 0.00, 19771.99, 2772.01, '', 'PROCESADO', '2026-01-04 15:01:06', 503, NULL, 'AFORO'),
(44, 6, 1, '2026-01-04 15:01:00', 5471.00, 49.57, 0.00, 5471.00, 0.00, '', 'PROCESADO', '2026-01-04 15:03:04', 505, NULL, 'AFORO'),
(45, 3, 1, '2026-01-04 18:50:00', 19640.99, 108.00, 0.00, 16450.00, 3190.99, '', 'PROCESADO', '2026-01-04 18:52:49', 509, 16450.00, 'MANUAL'),
(46, 6, 1, '2026-01-04 18:52:00', 5228.00, 48.00, 0.00, 5224.50, 3.50, '', 'PROCESADO', '2026-01-04 18:57:20', 511, NULL, 'AFORO'),
(47, 3, 1, '2026-01-05 11:37:00', 14200.00, 83.00, 0.00, 11467.25, 2732.75, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-05 11:38:40', NULL, NULL, 'AFORO'),
(48, 6, 1, '2026-01-05 11:39:00', 4930.50, 45.13, 0.00, 4782.84, 147.66, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-05 12:04:09', NULL, NULL, 'AFORO'),
(49, 3, 1, '2026-01-05 12:53:00', 14200.00, 83.00, 0.00, 11467.25, 2732.75, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-05 12:53:34', NULL, NULL, 'AFORO'),
(50, 6, 1, '2026-01-05 12:53:00', 4930.50, 46.11, 0.00, 4932.00, -1.50, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-05 12:54:30', NULL, 4932.00, 'MANUAL'),
(51, 3, 1, '2026-01-05 12:58:00', 14200.00, 83.00, 0.00, 11467.00, 2733.00, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-05 12:58:40', NULL, 11467.00, 'MANUAL'),
(52, 6, 1, '2026-01-05 12:58:00', 4930.50, 46.11, 0.00, 4932.49, -1.99, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-05 12:59:05', NULL, NULL, 'AFORO'),
(53, 3, 1, '2026-01-05 13:04:00', 14200.00, 83.00, 0.00, 11467.25, 2732.75, '', 'PROCESADO', '2026-01-05 13:05:13', 539, NULL, 'AFORO'),
(54, 6, 1, '2026-01-05 13:05:00', 4930.50, 46.11, 0.00, 4932.00, 0.00, '', 'PROCESADO', '2026-01-05 13:05:50', 541, 4932.00, 'MANUAL'),
(55, 3, 1, '2026-01-05 14:20:00', 11144.25, 203.50, 0.00, 36141.30, 12134.10, 'Medición Automática por Recepción de Cisterna (Guía: 32323333). Faltantes en guía: 12134.10 L. Nivel final: 36141.30 L.  [ANULADO POR ADMIN]', 'ANULADO', '2026-01-05 14:27:54', NULL, 36141.30, 'MANUAL'),
(56, 6, 1, '2026-01-05 14:28:00', 4862.00, 89.00, 0.00, 12383.00, -383.00, 'Medición Automática por Recepción de Cisterna (Guía: 3123124321123). Faltantes en guía: -383.00 L. Nivel final: 12383.00 L.  [ANULADO POR ADMIN]', 'ANULADO', '2026-01-05 14:31:23', NULL, 12383.00, 'MANUAL'),
(57, 3, 1, '2026-01-05 14:44:00', 11144.25, 205.00, 0.00, 36426.16, 41.09, 'Medición Automática por Recepción de Cisterna (Guía: 23234334). Faltantes en guía: 41.09 L. Nivel final: 36426.16 L. ', 'PROCESADO', '2026-01-05 14:46:37', 545, 36426.16, 'MANUAL'),
(58, 3, 1, '2026-01-05 15:00:00', 36426.16, 191.00, 0.00, 33709.31, 2435.00, '', 'PROCESADO', '2026-01-05 15:02:55', 545, 33709.31, 'MANUAL'),
(59, 6, 1, '2026-01-05 15:13:00', 4940.00, 45.13, 0.00, 4782.84, 80.00, '', 'PROCESADO', '2026-01-05 15:15:26', 547, 4782.84, 'MANUAL'),
(60, 3, 1, '2026-01-05 15:33:00', 33639.31, 185.00, 0.00, 32510.01, 1129.30, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-05 15:39:38', NULL, NULL, 'AFORO'),
(61, 3, 1, '2026-01-05 15:40:00', 33639.31, 175.60, 0.00, 30597.00, 3042.31, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-05 15:41:17', NULL, 30597.00, 'MANUAL'),
(62, 6, 1, '2026-01-05 15:41:00', 4782.84, 44.50, 0.00, 4687.45, 66.00, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-05 15:44:11', NULL, 4687.45, 'MANUAL'),
(63, 3, 1, '2026-01-05 16:06:00', 33049.31, 185.00, 0.00, 32510.01, 539.30, '', 'PROCESADO', '2026-01-05 16:07:43', 559, NULL, 'AFORO'),
(64, 6, 1, '2026-01-05 16:07:00', 4753.84, 44.94, 0.00, 4753.00, 0.00, '', 'PROCESADO', '2026-01-05 16:10:39', 561, 4753.00, 'MANUAL'),
(65, 3, 1, '2026-01-05 16:13:00', 32440.01, 175.60, 0.00, 30597.84, 1842.17, '', 'PROCESADO', '2026-01-05 16:19:42', 566, 30597.84, 'MANUAL'),
(66, 6, 1, '2026-01-05 16:19:00', 4753.00, 44.50, 0.00, 4687.29, 65.71, '', 'PROCESADO', '2026-01-05 16:20:56', 568, NULL, 'AFORO'),
(67, 3, 1, '2026-01-07 16:25:00', 29387.84, 246.00, 0.00, 43375.35, 19457.16, 'Medición Automática por Recepción de Cisterna (Guía: 13131313). Faltantes en guía: 19457.16 L. Nivel final: 43375.35 L. ', 'PROCESADO', '2026-01-07 16:33:24', 597, 43375.35, 'MANUAL'),
(68, 8, 1, '2026-01-07 16:37:00', 12000.00, 194.48, 0.00, 31515.04, -56.84, 'Medición Automática por Recepción de Cisterna (Guía: 123231). Faltantes en guía: -56.84 L. Nivel final: 31515.04 L. ', 'PROCESADO', '2026-01-07 16:40:19', 601, 31515.04, 'MANUAL'),
(69, 3, 1, '2026-01-07 16:40:00', 43375.35, 161.00, 0.00, 27567.00, 15808.35, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-07 16:41:47', NULL, 27567.00, 'MANUAL'),
(70, 8, 1, '2026-01-07 16:41:00', 31515.04, 194.48, 0.00, 31515.04, 0.00, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-07 16:43:21', NULL, 31515.04, 'MANUAL'),
(71, 3, 1, '2026-01-07 16:44:00', 43375.35, 239.00, 0.00, 42330.86, 1044.49, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-07 16:46:30', NULL, NULL, 'AFORO'),
(72, 8, 1, '2026-01-07 16:46:00', 31515.04, 194.48, 0.00, 31515.00, 0.00, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-07 16:48:57', NULL, 31515.00, 'MANUAL'),
(73, 3, 1, '2026-01-07 16:51:00', 43375.35, 239.00, 0.00, 42330.00, 1045.00, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-07 16:51:41', NULL, 42330.00, 'MANUAL'),
(74, 8, 1, '2026-01-07 16:52:00', 31515.04, 194.48, 0.00, 31500.00, 0.00, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-07 16:52:52', NULL, 31500.00, 'MANUAL'),
(75, 3, 1, '2026-01-07 16:56:00', 43375.35, 239.00, 0.00, 42330.00, 1045.00, '', 'PROCESADO', '2026-01-07 16:58:11', 597, 42330.00, 'MANUAL'),
(76, 8, 1, '2026-01-07 16:58:00', 31515.04, 194.39, 0.00, 31500.00, 0.00, '', 'PROCESADO', '2026-01-07 16:59:48', 601, 31500.00, 'MANUAL'),
(77, 6, 1, '2026-01-07 16:59:00', 4586.29, 43.84, 0.00, 4588.00, 0.00, '', 'PROCESADO', '2026-01-07 17:01:43', 599, 4588.00, 'MANUAL'),
(78, 4, 1, '2026-01-07 18:20:00', 1886.00, 124.57, 0.00, 36997.00, 0.00, 'Medición Automática por Recepción de Cisterna (Guía: 131323). Faltantes en guía: 0.00 L. Nivel final: 36997.00 L. ', 'PROCESADO', '2026-01-07 18:22:54', 614, 36997.00, 'MANUAL'),
(79, 3, 1, '2026-01-07 18:23:00', 41480.00, 215.50, 0.00, 38370.00, 3110.00, '', 'PROCESADO', '2026-01-07 18:25:03', 613, 38370.00, 'MANUAL'),
(80, 6, 1, '2026-01-07 18:25:00', 4572.00, 43.74, 0.00, 4572.00, 0.00, '', 'PROCESADO', '2026-01-07 18:26:39', 615, 4572.00, 'MANUAL'),
(81, 4, 1, '2026-01-07 18:27:00', 36997.00, 131.00, 0.00, 38883.00, 0.00, '', 'PROCESADO', '2026-01-07 18:29:38', 614, 38883.00, 'MANUAL'),
(82, 3, 1, '2026-01-08 08:42:00', 37300.00, 190.00, 0.00, 33510.00, 3790.00, '', 'PROCESADO', '2026-01-08 08:43:14', 629, 33510.00, 'MANUAL'),
(83, 6, 1, '2026-01-08 08:43:00', 4400.00, 42.92, 0.00, 4450.00, 0.00, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-08 08:45:24', NULL, 4450.00, 'MANUAL'),
(84, 6, 1, '2026-01-08 08:46:00', 4400.00, 42.60, 0.00, 4400.00, 0.00, '', 'PROCESADO', '2026-01-08 08:48:28', 631, 4400.00, 'MANUAL'),
(85, 3, 1, '2026-01-08 09:36:00', 33030.00, 161.00, 0.00, 27567.72, 5462.28, '', 'PROCESADO', '2026-01-08 09:40:40', 637, NULL, 'AFORO'),
(86, 6, 1, '2026-01-08 09:40:00', 4307.00, 42.00, 0.00, 4307.00, 0.00, '', 'PROCESADO', '2026-01-08 09:46:08', 639, 4307.00, 'MANUAL'),
(87, 6, 1, '2026-01-08 10:41:00', 4307.00, 214.00, 0.00, 34307.00, 9000.00, 'Medición Automática por Recepción de Cisterna (Guía: 123123123). Faltantes en guía: 9000.00 L. Nivel final: 34307.00 L. ', 'PROCESADO', '2026-01-08 10:44:46', 647, 34307.00, 'MANUAL'),
(88, 2, 1, '2026-01-08 10:45:00', 78.00, 105.22, 0.00, 9078.00, 30000.00, 'Medición Automática por Recepción de Cisterna (Guía: 12312313). Faltantes en guía: 30000.00 L. Nivel final: 9078.00 L. ', 'PROCESADO', '2026-01-08 10:48:04', 644, 9078.00, 'MANUAL'),
(89, 4, 1, '2026-01-08 13:57:00', 38883.00, 253.00, 0.00, 75880.00, 0.00, 'Medición Automática por Recepción de Cisterna (Guía: 3212312). Faltantes en guía: 0.00 L. Nivel final: 75880.00 L. ', 'PROCESADO', '2026-01-08 14:00:03', 646, 75880.00, 'MANUAL'),
(90, 3, 1, '2026-01-08 14:00:00', 26308.72, 142.00, 0.00, 23565.00, 2742.00, '', 'PROCESADO', '2026-01-08 14:00:56', 645, 23565.00, 'MANUAL'),
(91, 6, 1, '2026-01-08 14:00:00', 34006.00, 212.00, 0.00, 34007.00, 0.00, '', 'PROCESADO', '2026-01-08 14:01:58', 647, 34007.00, 'MANUAL'),
(92, 3, 1, '2026-01-09 07:15:00', 23228.00, 110.00, 0.00, 16861.31, 6366.69, '', 'PROCESADO', '2026-01-09 07:21:13', 653, NULL, 'AFORO'),
(93, 6, 1, '2026-01-09 07:21:00', 32907.00, 202.73, 0.00, 32907.00, 0.00, '', 'PROCESADO', '2026-01-09 07:24:38', 655, 32907.00, 'MANUAL'),
(94, 3, 1, '2026-01-09 08:32:00', 15706.31, 77.00, 0.00, 10326.00, 5380.00, '', 'PROCESADO', '2026-01-09 08:47:22', 661, 10326.00, 'MANUAL'),
(95, 6, 1, '2026-01-09 08:47:00', 32719.00, 201.38, 0.00, 32719.00, 0.00, '', 'PROCESADO', '2026-01-09 08:49:15', 663, 32719.00, 'MANUAL'),
(96, 7, 1, '2026-01-09 09:50:00', 0.00, 365.00, 0.00, 46996.00, 0.00, 'Medición Automática por Recepción de Cisterna (Guía: 00-18634858). Faltantes en guía: 0.00 L. Nivel final: 46996.00 L.  [ANULADO POR ADMIN]', 'ANULADO', '2026-01-09 09:57:07', NULL, 46996.00, 'MANUAL'),
(97, 3, 1, '2026-01-09 09:59:00', 9876.00, 280.00, 0.00, 46996.00, 0.00, 'Medición Automática por Recepción de Cisterna (Guía: 00-186348581). Faltantes en guía: 0.00 L. Nivel final: 46996.00 L. ', 'PROCESADO', '2026-01-09 10:04:09', 669, 46996.00, 'MANUAL'),
(98, 3, 1, '2026-01-09 10:04:00', 46996.00, 246.00, 0.00, 43375.00, 3621.00, '', 'PROCESADO', '2026-01-09 10:06:45', 669, 43375.00, 'MANUAL'),
(99, 6, 1, '2026-01-09 10:08:00', 32689.00, 201.17, 0.00, 32689.00, 0.00, '', 'PROCESADO', '2026-01-09 10:16:20', 671, 32689.00, 'MANUAL'),
(100, 3, 1, '2026-01-11 16:53:00', 42099.00, 204.33, 0.00, 36299.00, 5800.00, '', 'PROCESADO', '2026-01-11 16:57:05', 677, 36299.00, 'MANUAL'),
(101, 6, 1, '2026-01-11 16:57:00', 32259.00, 198.15, 0.00, 32259.00, 0.00, '', 'PROCESADO', '2026-01-11 16:58:10', 679, 32259.00, 'MANUAL'),
(102, 3, 1, '2026-01-11 17:18:00', 36149.00, 186.75, 0.00, 32868.00, 3281.00, '', 'PROCESADO', '2026-01-11 17:20:37', 685, 32868.00, 'MANUAL'),
(103, 6, 1, '2026-01-11 17:20:00', 32159.00, 196.64, 0.00, 32039.00, 120.00, '', 'PROCESADO', '2026-01-11 17:22:47', 687, 32039.00, 'MANUAL'),
(104, 3, 1, '2026-01-11 18:30:00', 28088.00, 131.00, 0.00, 21243.00, 6845.00, '', 'PROCESADO', '2026-01-11 18:31:37', 693, 21243.00, 'MANUAL'),
(105, 6, 1, '2026-01-11 18:31:00', 31507.00, 194.13, 0.00, 31662.00, 0.00, '', 'PROCESADO', '2026-01-11 18:34:31', 695, 31662.00, 'MANUAL'),
(106, 3, 1, '2026-01-11 19:06:00', 33720.00, 173.00, 0.00, 30062.00, 3658.00, ' [ANULADO POR ADMIN]', 'ANULADO', '2026-01-11 19:06:56', NULL, 30062.00, 'MANUAL'),
(107, 6, 1, '2026-01-11 19:06:00', 31572.00, 192.72, 0.00, 31452.13, 119.87, '', 'PROCESADO', '2026-01-11 19:08:29', 719, NULL, 'AFORO'),
(108, 7, 1, '2026-01-11 19:11:00', 0.00, 289.00, 0.00, 33720.00, 0.00, 'Medición Automática por Recepción de Cisterna (Guía: 312312). Faltantes en guía: 0.00 L. Nivel final: 33720.00 L.  [ANULADO POR ADMIN]', 'ANULADO', '2026-01-11 19:23:52', NULL, 33720.00, 'MANUAL'),
(109, 3, 1, '2026-01-11 19:24:00', 20726.00, 188.00, 0.00, 33720.00, 0.00, 'Medición Automática por Recepción de Cisterna (Guía: 131312). Faltantes en guía: 0.00 L. Nivel final: 33720.00 L. ', 'PROCESADO', '2026-01-11 19:26:25', 717, 33720.00, 'MANUAL'),
(110, 3, 1, '2026-01-11 19:26:00', 33720.00, 173.00, 0.00, 30062.00, 3658.00, '', 'PROCESADO', '2026-01-11 19:27:31', 717, 30062.00, 'MANUAL'),
(111, 6, 1, '2026-01-11 19:28:00', 31452.13, 192.72, 0.00, 31452.00, 0.13, '', 'PROCESADO', '2026-01-11 19:29:27', 719, 31452.00, 'MANUAL'),
(112, 3, 1, '2026-01-12 09:08:00', 28403.00, 137.50, 0.00, 22614.44, 5788.56, '', 'PROCESADO', '2026-01-12 09:09:04', 725, NULL, 'AFORO'),
(113, 6, 1, '2026-01-12 09:49:00', 31165.00, 190.85, 0.00, 31165.00, 0.00, '', 'PROCESADO', '2026-01-12 09:50:14', 727, 31165.00, 'MANUAL');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modelos`
--

CREATE TABLE `modelos` (
  `id_modelo` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `id_marca` int(11) NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_registro` datetime DEFAULT NULL,
  `fecha_modificacion` datetime DEFAULT NULL,
  `registrado_por` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `modelos`
--

INSERT INTO `modelos` (`id_modelo`, `nombre`, `id_marca`, `estado`, `fecha_registro`, `fecha_modificacion`, `registrado_por`) VALUES
(1, 'Masparro', 21, 'ACTIVO', '2025-11-23 11:40:20', '2025-11-23 11:40:20', 1),
(2, '1721', 2, 'ACTIVO', '2025-11-23 11:40:34', '2025-11-23 11:40:34', 1),
(3, 'GENERADOR', 22, 'ACTIVO', '2025-11-23 12:51:18', '2025-11-23 12:51:18', 1),
(4, 'Retroescavadora-Jhon', 23, 'ACTIVO', '2025-11-23 13:04:55', '2025-11-23 13:04:55', 1),
(5, 'ENT-610', 24, 'ACTIVO', '2025-11-23 13:07:45', '2025-11-23 13:07:45', 1),
(6, 'Payloader', 25, 'ACTIVO', '2025-11-23 13:16:28', '2025-11-23 13:16:28', 1),
(7, 'Moto', 26, 'ACTIVO', '2025-11-24 07:53:41', '2025-11-24 07:53:41', 1),
(8, 'pregio', 11, 'ACTIVO', '2025-11-24 08:00:01', '2025-11-24 08:00:01', 1),
(9, 'Granite', 27, 'ACTIVO', '2025-11-24 08:00:52', '2025-11-24 08:00:52', 1),
(10, 'CHUTO TIBURON', 27, 'ACTIVO', '2025-11-24 08:07:55', '2025-11-24 08:07:55', 1),
(11, 'C15', 23, 'ACTIVO', '2025-11-27 13:23:39', '2025-11-27 13:23:39', 1),
(12, 'Kodiak', 9, 'ACTIVO', '2025-11-27 13:35:55', '2025-11-27 13:35:55', 1),
(13, 'VOLQUETE', 28, 'ACTIVO', '2025-11-27 13:38:25', '2025-11-27 13:38:25', 1),
(14, 'CAMION M2', 29, 'ACTIVO', '2025-11-27 13:41:12', '2025-11-27 13:41:12', 1),
(15, 'CAMION VOLTEO', 9, 'ACTIVO', '2025-11-27 13:43:24', '2025-11-27 13:43:24', 1),
(16, 'ECOMODIME', 27, 'ACTIVO', '2025-11-27 13:45:51', '2025-11-27 13:45:51', 1),
(17, 'TRAKKER', 30, 'ACTIVO', '2025-12-08 11:42:04', '2025-12-08 11:42:04', 1),
(18, 'JUMBO-CASE', 31, 'ACTIVO', '2025-12-08 13:15:11', '2025-12-08 13:20:08', 1),
(19, 'TECTOR CISTERNA', 30, 'ACTIVO', '2025-12-08 13:56:29', '2025-12-08 13:56:29', 1),
(20, 'TEYA', 32, 'ACTIVO', '2025-12-08 14:35:21', '2025-12-08 14:35:21', 1),
(21, 'RL', 33, 'ACTIVO', '2025-12-08 14:44:33', '2025-12-08 14:44:33', 1),
(22, 'New Horse', 33, 'ACTIVO', '2025-12-08 14:45:04', '2025-12-08 14:45:04', 1),
(23, 'Horse II', 33, 'ACTIVO', '2025-12-08 14:45:27', '2025-12-08 14:45:27', 1),
(24, 'Toro Jaguar TR-150', 34, 'ACTIVO', '2025-12-08 14:47:43', '2025-12-08 14:47:43', 1),
(25, 'Toro Jaguar TR-200', 34, 'ACTIVO', '2025-12-08 14:48:02', '2025-12-08 14:48:02', 1),
(26, 'AVA Jaguar 150', 34, 'ACTIVO', '2025-12-08 14:48:13', '2025-12-08 14:48:13', 1),
(27, 'Hawk', 35, 'ACTIVO', '2025-12-08 14:50:09', '2025-12-08 14:50:09', 1),
(28, 'MD', 35, 'ACTIVO', '2025-12-08 14:50:25', '2025-12-08 14:50:25', 1),
(29, 'Pigeon', 35, 'ACTIVO', '2025-12-08 14:50:35', '2025-12-08 14:50:35', 1),
(30, 'TRIMOTO', 35, 'ACTIVO', '2025-12-08 14:50:44', '2025-12-08 14:50:44', 1),
(31, 'SBR', 26, 'ACTIVO', '2025-12-08 16:25:53', '2025-12-08 16:25:53', 1),
(32, 'Kavak', 26, 'ACTIVO', '2025-12-08 16:26:06', '2025-12-08 16:26:06', 1),
(33, 'León', 26, 'ACTIVO', '2025-12-08 16:26:25', '2025-12-08 16:26:25', 1),
(34, 'DT', 26, 'ACTIVO', '2025-12-08 16:26:38', '2025-12-08 16:26:38', 1),
(35, 'R1', 26, 'ACTIVO', '2025-12-08 16:26:50', '2025-12-08 16:26:50', 1),
(36, 'Cobra', 26, 'ACTIVO', '2025-12-08 16:27:15', '2025-12-08 16:27:15', 1),
(37, 'Horse', 36, 'ACTIVO', '2025-12-08 16:31:01', '2025-12-08 16:31:01', 1),
(38, 'Arsen', 36, 'ACTIVO', '2025-12-08 16:31:19', '2025-12-08 16:31:19', 1),
(39, 'Speed', 36, 'ACTIVO', '2025-12-08 16:31:40', '2025-12-08 16:31:40', 1),
(40, 'MINIBUS', 2, 'ACTIVO', '2025-12-09 12:32:41', '2025-12-09 12:32:41', 1),
(41, 'DODGE', 37, 'ACTIVO', '2025-12-09 12:34:24', '2025-12-09 12:34:24', 1),
(42, 'GRUA-100TN', 23, 'ACTIVO', '2025-12-09 15:39:35', '2025-12-09 15:39:35', 1),
(43, 'LA VENEZOLNA 4X4 DIESEL', 28, 'ACTIVO', '2025-12-09 15:43:36', '2025-12-09 15:43:36', 1),
(44, 'PICK-UP DOBLE CABINA', 38, 'ACTIVO', '2025-12-09 16:21:00', '2025-12-09 16:21:00', 1),
(45, 'LUV DMAX', 9, 'ACTIVO', '2025-12-09 16:24:18', '2025-12-09 16:24:18', 1),
(46, 'LOGAN', 14, 'ACTIVO', '2025-12-09 16:26:18', '2025-12-09 16:26:18', 1),
(47, 'SILVERADO', 9, 'ACTIVO', '2025-12-09 16:29:43', '2025-12-09 16:29:43', 1),
(48, 'EXPLORER', 2, 'ACTIVO', '2025-12-09 16:31:21', '2025-12-09 16:31:21', 1),
(49, 'HILUX', 1, 'ACTIVO', '2025-12-09 16:37:26', '2025-12-09 16:37:26', 1),
(50, 'BURBUJA', 1, 'ACTIVO', '2025-12-09 16:42:18', '2025-12-09 16:42:18', 1),
(51, 'FIESTA', 2, 'ACTIVO', '2025-12-21 22:21:59', '2025-12-21 22:21:59', 1),
(52, 'PICK-UP', 8, 'ACTIVO', '2025-12-27 08:31:25', '2025-12-27 08:31:25', 1),
(53, 'Corolla', 1, 'ACTIVO', '2025-12-27 08:42:03', '2025-12-27 08:42:03', 1),
(54, 'SEDAN', 16, 'ACTIVO', '2025-12-27 08:45:03', '2025-12-27 08:45:03', 1),
(55, 'EMPIRE', 36, 'ACTIVO', '2026-01-05 09:15:31', '2026-01-05 09:15:31', 1),
(56, 'PLANTA', 39, 'ACTIVO', '2026-01-05 09:30:14', '2026-01-05 09:30:14', 1),
(57, 'GNB', 40, 'ACTIVO', '2026-01-05 13:31:49', '2026-01-05 13:31:49', 1),
(58, 'JUMBO', 10, 'ACTIVO', '2026-01-07 15:21:25', '2026-01-07 15:21:25', 1),
(59, 'LECHUZA', 41, 'ACTIVO', '2026-01-07 17:57:21', '2026-01-07 17:57:21', 1),
(60, 'LAND CRUSIER - MACHITO', 1, 'ACTIVO', '2026-01-08 08:12:03', '2026-01-08 08:12:03', 1),
(61, 'AMBULANCIA', 42, 'ACTIVO', '2026-01-08 09:15:06', '2026-01-08 09:15:06', 1),
(62, 'JUMBO', 23, 'ACTIVO', '2026-01-08 09:53:15', '2026-01-08 09:53:15', 1),
(63, 'PICK-UP', 18, 'ACTIVO', '2026-01-08 11:04:49', '2026-01-08 11:04:49', 1),
(64, 'GETZ', 10, 'ACTIVO', '2026-01-08 13:34:03', '2026-01-08 13:34:03', 1),
(65, 'MONTA-CARGA', 23, 'ACTIVO', '2026-01-09 08:08:24', '2026-01-09 08:08:24', 1),
(66, 'PATROL', 23, 'ACTIVO', '2026-01-09 08:13:08', '2026-01-09 08:13:08', 1),
(67, 'TX', 36, 'ACTIVO', '2026-01-09 09:43:49', '2026-01-09 09:43:49', 1),
(68, 'PAYLOADER', 23, 'ACTIVO', '2026-01-11 15:31:03', '2026-01-11 15:31:03', 1),
(69, 'DYNA', 1, 'ACTIVO', '2026-01-11 15:42:33', '2026-01-11 15:42:33', 1),
(70, 'RANGER', 2, 'ACTIVO', '2026-01-11 16:19:35', '2026-01-11 16:19:35', 1),
(71, 'VITARA', 9, 'ACTIVO', '2026-01-11 17:37:32', '2026-01-11 17:37:32', 1),
(72, 'SEDAN', 43, 'ACTIVO', '2026-01-11 17:52:23', '2026-01-11 17:52:23', 1),
(73, 'FRONTIER', 8, 'ACTIVO', '2026-01-11 18:25:01', '2026-01-11 18:25:01', 1),
(74, '207 COMPACT', 15, 'ACTIVO', '2026-01-12 08:39:20', '2026-01-12 08:39:20', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tanques`
--

CREATE TABLE `tanques` (
  `id_tanque` int(11) NOT NULL,
  `codigo` varchar(20) NOT NULL COMMENT 'Identificador único rotulado en el tanque',
  `nombre` varchar(100) NOT NULL,
  `tabla_aforo` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Objeto JSON con la calibración: { "medida": volumen }' CHECK (json_valid(`tabla_aforo`)),
  `unidad_medida` enum('CM','PULGADAS') NOT NULL DEFAULT 'CM' COMMENT 'Define en qué unidad está expresada la tabla de aforo y la vara',
  `ubicacion` varchar(150) NOT NULL,
  `tipo_combustible` enum('GASOIL','GASOLINA') NOT NULL,
  `capacidad_maxima` decimal(10,2) NOT NULL,
  `nivel_actual` decimal(10,2) NOT NULL DEFAULT 0.00,
  `nivel_alarma` decimal(10,2) NOT NULL DEFAULT 500.00 COMMENT 'Nivel mínimo para lanzar alerta de reabastecimiento',
  `estado` enum('ACTIVO','INACTIVO','MANTENIMIENTO') DEFAULT 'ACTIVO',
  `tipo_jerarquia` enum('PRINCIPAL','AUXILIAR') NOT NULL DEFAULT 'AUXILIAR' COMMENT 'Define si es el tanque madre o uno de reserva',
  `fecha_registro` datetime DEFAULT NULL,
  `fecha_modificacion` datetime DEFAULT NULL,
  `registrado_por` int(11) DEFAULT NULL,
  `radio` decimal(10,2) DEFAULT NULL,
  `largo` decimal(10,2) DEFAULT NULL,
  `ancho` decimal(10,2) DEFAULT NULL,
  `alto` decimal(10,2) DEFAULT NULL,
  `tipo_tanque` enum('CILINDRICO','RECTANGULAR') NOT NULL DEFAULT 'CILINDRICO' COMMENT 'Define la forma geométrica del tanque'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tanques`
--

INSERT INTO `tanques` (`id_tanque`, `codigo`, `nombre`, `tabla_aforo`, `unidad_medida`, `ubicacion`, `tipo_combustible`, `capacidad_maxima`, `nivel_actual`, `nivel_alarma`, `estado`, `tipo_jerarquia`, `fecha_registro`, `fecha_modificacion`, `registrado_por`, `radio`, `largo`, `ancho`, `alto`, `tipo_tanque`) VALUES
(1, 'TQ01', 'TANQUE PRINCIPAL', '{\"1\":93,\"2\":261,\"3\":479,\"4\":736,\"5\":1026,\"6\":1346,\"7\":1691,\"8\":2061,\"9\":2454,\"10\":2867,\"11\":3299,\"12\":3750,\"13\":4217,\"14\":4701,\"15\":5200,\"16\":5714,\"17\":6242,\"18\":6783,\"19\":7337,\"20\":7903,\"21\":8480,\"22\":9006,\"23\":9668,\"24\":10278,\"25\":10897,\"26\":11526,\"27\":12164,\"28\":12810,\"29\":13465,\"30\":14128,\"31\":14799,\"32\":15476,\"33\":16161,\"34\":16853,\"35\":17551,\"36\":18256,\"37\":18966,\"38\":19682,\"39\":20403,\"40\":21130,\"41\":21861,\"42\":22597,\"43\":23338,\"44\":24083,\"45\":24831,\"46\":25584,\"47\":26340,\"48\":27099,\"49\":27861,\"50\":28627,\"51\":29395,\"52\":30165,\"53\":30938,\"54\":31712,\"55\":32486,\"56\":33267,\"57\":34047,\"58\":34825,\"59\":35610,\"60\":36393,\"61\":37176,\"62\":37950,\"63\":38745,\"64\":39529,\"65\":40313,\"66\":41097,\"67\":41880,\"68\":42662,\"69\":43445,\"70\":44226,\"71\":45005,\"72\":45783,\"73\":46559,\"74\":47333,\"75\":48106,\"76\":48875,\"77\":49643,\"78\":50407,\"79\":51169,\"80\":51928,\"81\":52683,\"82\":53435,\"83\":54182,\"84\":54926,\"85\":55666,\"86\":56401,\"87\":57131,\"88\":57856,\"89\":58577,\"90\":59291,\"91\":60000,\"92\":60703,\"93\":61400,\"94\":62090,\"95\":62773,\"96\":63450,\"97\":64118,\"98\":64779,\"99\":65432,\"100\":66077,\"101\":66713,\"102\":67340,\"103\":67957,\"104\":68564,\"105\":69161,\"106\":69747,\"107\":70322,\"108\":70889,\"109\":71443,\"110\":71984,\"111\":72512,\"112\":73026,\"113\":73525,\"114\":74009,\"115\":74476,\"116\":74927,\"117\":75369,\"118\":75782,\"119\":76175,\"120\":76545,\"121\":76890,\"122\":77210,\"123\":77490,\"124\":77747,\"125\":77965,\"126\":78133,\"127\":78226}', 'PULGADAS', 'PATIO PRINCIPAL', 'GASOIL', 78226.00, 0.00, 500.00, 'ACTIVO', 'PRINCIPAL', '2025-11-23 11:46:58', '2026-01-02 13:58:19', 1, NULL, NULL, NULL, NULL, 'CILINDRICO'),
(2, 'TQG02', 'TANQUE Nª 02', NULL, 'CM', 'PATIO PRINCIPAL', 'GASOLINA', 20000.00, 9078.00, 1001.00, 'ACTIVO', 'AUXILIAR', '2025-11-25 17:10:37', '2026-01-08 10:48:04', 1, 1.15, 4.90, NULL, NULL, 'CILINDRICO'),
(3, 'T03', 'TANQUE GASOIL Nª 03', NULL, 'CM', 'PLANTA ARRIBA', 'GASOIL', 47000.00, 22614.44, 500.00, 'ACTIVO', 'AUXILIAR', '2025-11-27 13:18:38', '2026-01-12 09:09:04', 1, 1.42, 7.44, NULL, NULL, 'CILINDRICO'),
(4, 'TQ04', 'TANQUE GASOIL Nª 04', NULL, 'CM', 'ZONA ARRIBA TANQUE', 'GASOIL', 79876.00, 75880.00, 1000.00, 'ACTIVO', 'AUXILIAR', '2025-11-27 13:19:39', '2026-01-11 13:17:40', 1, NULL, 12.00, 2.58, 2.58, 'RECTANGULAR'),
(6, 'TQG01', 'TANQUE Nª 01', NULL, 'CM', 'PATIO PRINCIPAL', 'GASOLINA', 36000.00, 31165.00, 1000.00, 'ACTIVO', 'AUXILIAR', '2025-12-05 12:01:11', '2026-01-12 09:50:14', 1, 1.19, 8.15, NULL, NULL, 'CILINDRICO'),
(7, 'TQG03', 'TANQUE Nª 03', NULL, 'CM', 'PATIO PRINCIPAL', 'GASOLINA', 15000.00, 0.00, 1000.00, 'ACTIVO', 'AUXILIAR', '2025-12-08 10:53:08', '2026-01-11 19:23:52', 1, 7.44, 1.42, NULL, NULL, 'CILINDRICO'),
(8, 'TQGS-03', 'TANQUE GASOIL Nª 1', NULL, 'CM', 'ZONA ARRIBA', 'GASOIL', 35000.00, 31500.00, 2000.00, 'ACTIVO', 'AUXILIAR', '2026-01-05 14:59:10', '2026-01-07 16:59:48', 1, 1.27, 7.57, NULL, NULL, 'CILINDRICO'),
(9, 'TQD02', 'TANQUE GASOIL Nª 2', NULL, 'CM', 'ZONA ARRIBA', 'GASOIL', 30000.00, 24000.00, 1000.00, 'ACTIVO', 'AUXILIAR', '2026-01-06 08:25:53', '2026-01-11 19:04:14', 1, 1.44, 4.86, NULL, NULL, 'CILINDRICO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `transferencias_internas`
--

CREATE TABLE `transferencias_internas` (
  `id_transferencia` int(11) NOT NULL,
  `id_tanque_origen` int(11) NOT NULL,
  `id_tanque_destino` int(11) NOT NULL,
  `id_almacenista` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `hora_inicio` datetime NOT NULL COMMENT 'Momento exacto en que comienza la transferencia',
  `litros_antes_origen` decimal(10,2) NOT NULL COMMENT 'Cantidad de litros en el tanque origen antes de la operación',
  `litros_despues_destino` decimal(10,2) NOT NULL COMMENT 'Cantidad de litros en el tanque destino después de completar la transferencia',
  `litros_transferidos` decimal(10,2) NOT NULL COMMENT 'Cantidad de litros efectivamente transferidos',
  `medida_vara_destino` decimal(10,2) DEFAULT NULL COMMENT 'Medida de vara final en el tanque destino',
  `observacion` text DEFAULT NULL,
  `fecha_registro` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `tipo_usuario` enum('ADMIN','SUPERVISOR','INSPECTOR') NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `cedula` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_registro` datetime DEFAULT NULL,
  `ultimo_acceso` datetime DEFAULT NULL,
  `fecha_modificacion` datetime DEFAULT NULL,
  `registrado_por` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `tipo_usuario`, `nombre`, `apellido`, `cedula`, `password`, `estado`, `fecha_registro`, `ultimo_acceso`, `fecha_modificacion`, `registrado_por`) VALUES
(1, 'ADMIN', 'María', 'González', '12345678', '$2a$10$JDEm4cUMTzU3W.LkaIvKpOeEd4RqGnllntsF1lvhWYuAEu.tsfAzK', 'ACTIVO', '2025-11-19 10:15:00', '2026-01-12 07:21:53', '2025-11-24 15:02:52', 1),
(2, 'ADMIN', 'Pedro', 'Peres', 'V123456', '$2a$10$W0nLuD4p0xPzfJPO.p.X.ONyxsQE/O4Dr4An69//wEdde/e8Rk0Wy', 'ACTIVO', '2025-11-19 10:15:00', '2025-11-19 14:20:00', '2025-11-23 11:39:23', 1),
(3, 'INSPECTOR', 'LEONARDO', 'ESPINA', '18073921', '$2a$10$8oDojCQJ3xmKW7916129MeCad3kJgeFuCxTYTqI2/bdiCXQY./Zgy', 'ACTIVO', '2025-12-04 08:39:53', '2025-12-04 10:31:41', '2025-12-04 08:39:53', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vehiculos`
--

CREATE TABLE `vehiculos` (
  `id_vehiculo` int(11) NOT NULL,
  `placa` varchar(20) NOT NULL,
  `anio` int(11) NOT NULL,
  `color` varchar(30) DEFAULT NULL,
  `id_gerencia` int(11) DEFAULT NULL,
  `es_generador` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'TRUE si es planta eléctrica/generador, FALSE si es vehículo flota',
  `id_marca` int(11) NOT NULL,
  `id_modelo` int(11) NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `fecha_registro` datetime DEFAULT NULL,
  `fecha_modificacion` datetime DEFAULT NULL,
  `registrado_por` int(11) DEFAULT NULL,
  `tipoCombustible` enum('GASOLINA','GASOIL') NOT NULL DEFAULT 'GASOIL'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `vehiculos`
--

INSERT INTO `vehiculos` (`id_vehiculo`, `placa`, `anio`, `color`, `id_gerencia`, `es_generador`, `id_marca`, `id_modelo`, `estado`, `fecha_registro`, `fecha_modificacion`, `registrado_por`, `tipoCombustible`) VALUES
(1, 'KVA-500', 2000, 'AMARILLO', 3, 1, 22, 3, 'ACTIVO', '2025-11-23 12:52:09', '2025-11-26 16:53:14', 1, 'GASOIL'),
(2, '1950020 300KVA', 2000, 'AMARILLO', 3, 1, 22, 3, 'ACTIVO', '2025-11-23 12:57:26', '2025-12-21 19:23:44', 1, 'GASOIL'),
(3, '549AA3W', 2000, 'BLANCO', 5, 0, 24, 5, 'ACTIVO', '2025-11-23 13:17:44', '2025-11-23 13:17:44', 1, 'GASOIL'),
(4, '310E', 2000, 'AMARILLO', 4, 0, 23, 4, 'ACTIVO', '2025-11-23 13:20:46', '2025-11-23 13:20:46', 1, 'GASOIL'),
(5, '125C', 2000, 'AMARILLO', 4, 0, 25, 6, 'ACTIVO', '2025-11-23 13:21:56', '2025-11-23 13:21:56', 1, 'GASOIL'),
(6, '585ATP3P', 2000, 'BLANCO', 5, 0, 24, 5, 'ACTIVO', '2025-11-23 13:22:47', '2025-11-23 13:22:47', 1, 'GASOIL'),
(7, '15579', 2000, 'Rojo', 4, 0, 26, 7, 'ACTIVO', '2025-11-24 07:54:17', '2025-12-07 08:41:15', 1, 'GASOLINA'),
(8, '580AB8S', 2000, 'BLANCO', 5, 0, 24, 5, 'ACTIVO', '2025-11-24 07:57:19', '2025-11-24 07:57:19', 1, 'GASOIL'),
(9, 'A42AUID', 2000, 'BLANCO', 4, 0, 27, 10, 'ACTIVO', '2025-11-24 08:08:44', '2025-11-24 08:08:44', 1, 'GASOIL'),
(10, 'AC042KD', 2000, 'AZUL', 4, 0, 11, 8, 'ACTIVO', '2025-11-24 08:09:40', '2025-11-24 08:09:40', 1, 'GASOIL'),
(11, 'A81AJ9M', 2000, 'BLANCO', 6, 0, 27, 9, 'ACTIVO', '2025-11-24 08:20:01', '2025-11-24 08:20:01', 1, 'GASOIL'),
(12, '310E2', 2000, 'AMARILLO', 4, 0, 23, 4, 'ACTIVO', '2025-11-27 13:22:17', '2025-11-27 13:22:17', 1, 'GASOIL'),
(13, '980G', 2000, 'AMARILLO', 4, 0, 23, 4, 'ACTIVO', '2025-11-27 13:23:03', '2025-11-27 13:23:03', 1, 'GASOIL'),
(14, 'SMPB0062', 2000, 'AMATRILLO', 3, 1, 23, 11, 'ACTIVO', '2025-11-27 13:24:42', '2026-01-05 12:57:36', 1, 'GASOIL'),
(15, '583AB1S', 2000, 'BLANCO', 5, 0, 24, 5, 'ACTIVO', '2025-11-27 13:25:57', '2025-11-27 13:25:57', 1, 'GASOIL'),
(16, '549AS1P', 2000, 'BLANCO', 5, 0, 24, 5, 'ACTIVO', '2025-11-27 13:26:46', '2025-11-27 13:26:46', 1, 'GASOIL'),
(17, '573AA1V', 2000, 'BLANCO', 5, 0, 24, 5, 'ACTIVO', '2025-11-27 13:27:38', '2025-11-27 13:27:38', 1, 'GASOIL'),
(18, 'A72AP3H', 2000, 'ROJO', 4, 0, 21, 1, 'ACTIVO', '2025-11-27 13:30:34', '2025-11-27 13:30:34', 1, 'GASOIL'),
(19, '20252', 2000, 'BLANCO', 4, 0, 21, 1, 'ACTIVO', '2025-11-27 13:31:32', '2025-11-27 13:31:32', 1, 'GASOIL'),
(20, 'A99BI7E', 2000, 'ROJO', 4, 0, 21, 1, 'ACTIVO', '2025-11-27 13:33:03', '2025-12-08 12:11:10', 1, 'GASOIL'),
(21, 'A93CD4K', 2000, 'AMARILLO', 4, 0, 28, 13, 'ACTIVO', '2025-11-27 13:39:08', '2025-11-27 13:39:08', 1, 'GASOIL'),
(22, 'A31AD5H', 2000, 'BLANCO', 4, 0, 9, 15, 'ACTIVO', '2025-11-27 13:44:11', '2025-11-27 13:44:11', 1, 'GASOIL'),
(23, '01L6BL', 2000, 'BLANCO', 4, 0, 29, 14, 'ACTIVO', '2025-11-27 13:44:48', '2025-11-27 13:44:48', 1, 'GASOIL'),
(24, '04DMAO', 2000, 'AZUL', 4, 0, 27, 16, 'ACTIVO', '2025-11-27 13:47:04', '2025-11-27 13:47:04', 1, 'GASOIL'),
(25, 'SPMB0062', 2000, 'AMARILLO', 3, 1, 23, 11, 'ACTIVO', '2025-11-27 13:49:42', '2025-11-27 13:49:42', 1, 'GASOIL'),
(26, 'A47BJ6Y', 2000, 'BLANCO', 4, 0, 9, 12, 'ACTIVO', '2025-11-27 14:00:24', '2025-11-27 14:00:24', 1, 'GASOIL'),
(27, 'A06AW1R', 2000, 'BLANCO', 4, 0, 30, 17, 'ACTIVO', '2025-12-08 11:46:27', '2025-12-08 11:46:27', 1, 'GASOIL'),
(28, '18089', 2000, 'BLANCO', 4, 0, 21, 1, 'ACTIVO', '2025-12-08 11:49:20', '2025-12-08 11:49:20', 1, 'GASOIL'),
(30, '98TOAE', 2000, 'BLANCO', 4, 0, 29, 14, 'ACTIVO', '2025-12-08 13:46:08', '2025-12-08 13:46:08', 1, 'GASOIL'),
(31, '88FLAI', 2000, 'BLANCO', 4, 0, 30, 19, 'ACTIVO', '2025-12-08 13:58:18', '2025-12-08 13:58:18', 1, 'GASOIL'),
(32, '950', 2000, 'AMARILLO', 4, 0, 25, 6, 'ACTIVO', '2025-12-08 14:03:29', '2025-12-08 14:03:29', 1, 'GASOIL'),
(33, 'A91AYOF', 2000, 'VERDE', 4, 0, 27, 10, 'ACTIVO', '2025-12-08 14:09:38', '2025-12-08 14:09:38', 1, 'GASOIL'),
(34, '86GLAB', 2000, 'BLANCO', 4, 0, 27, 10, 'ACTIVO', '2025-12-08 14:12:37', '2025-12-08 14:12:37', 1, 'GASOIL'),
(35, 'A63AK51', 2000, 'ROJO', 4, 0, 32, 20, 'ACTIVO', '2025-12-08 14:36:09', '2025-12-08 14:36:09', 1, 'GASOIL'),
(36, '20204', 2000, 'BLANCO', 4, 0, 21, 1, 'ACTIVO', '2025-12-08 14:37:30', '2025-12-08 14:37:30', 1, 'GASOIL'),
(37, '9758', 2000, 'VERDE', 2, 0, 35, 30, 'ACTIVO', '2025-12-08 16:23:57', '2025-12-08 16:23:57', 1, 'GASOLINA'),
(38, 'AX9J25W', 2000, 'NEGRO', 9, 0, 26, 31, 'ACTIVO', '2025-12-08 16:28:06', '2025-12-08 16:28:06', 1, 'GASOLINA'),
(39, 'AC4N77P', 2000, 'VERDE', 9, 0, 36, 37, 'ACTIVO', '2025-12-08 16:32:26', '2025-12-08 16:32:26', 1, 'GASOLINA'),
(40, 'AP8N54D', 2000, 'AZUL', 9, 0, 35, 27, 'ACTIVO', '2025-12-08 16:33:27', '2025-12-08 16:33:27', 1, 'GASOLINA'),
(41, 'SBR', 2000, 'ROJO', 4, 0, 26, 31, 'ACTIVO', '2025-12-08 16:34:07', '2025-12-08 16:34:07', 1, 'GASOLINA'),
(42, 'A12D94E', 2000, 'AZUL', 9, 0, 26, 31, 'ACTIVO', '2025-12-08 16:35:14', '2025-12-08 16:35:14', 1, 'GASOLINA'),
(43, 'AN4X17N', 2000, 'GRIS', 9, 0, 33, 22, 'ACTIVO', '2025-12-08 16:36:13', '2026-01-08 09:34:58', 1, 'GASOLINA'),
(44, '597AA3M', 2000, 'BLANCO', 4, 0, 2, 40, 'ACTIVO', '2025-12-09 12:33:29', '2025-12-09 12:33:29', 1, 'GASOLINA'),
(45, 'A43AU9G', 2000, 'BLANCO', 4, 0, 37, 41, 'ACTIVO', '2025-12-09 14:09:20', '2025-12-09 14:09:20', 1, 'GASOLINA'),
(46, 'LW3300001', 2000, 'AMARILLO', 4, 0, 23, 42, 'ACTIVO', '2025-12-09 15:40:38', '2025-12-09 15:40:38', 1, 'GASOIL'),
(47, 'A88EB6P', 2000, 'BLANCO', 10, 0, 28, 43, 'ACTIVO', '2025-12-09 15:59:31', '2025-12-09 15:59:31', 1, 'GASOIL'),
(48, 'A33DM2G', 2000, 'NEGRO', 2, 0, 38, 44, 'ACTIVO', '2025-12-09 16:21:46', '2025-12-09 16:21:46', 1, 'GASOLINA'),
(49, 'A65CC7V', 2000, 'BLANCO', 2, 0, 9, 45, 'ACTIVO', '2025-12-09 16:25:32', '2025-12-09 16:25:32', 1, 'GASOLINA'),
(50, 'BBU32F', 2000, 'GRIS', 3, 0, 14, 46, 'ACTIVO', '2025-12-09 16:27:03', '2025-12-09 16:27:03', 1, 'GASOLINA'),
(51, 'A36AM7D', 2000, 'NEGRA', 3, 0, 9, 47, 'ACTIVO', '2025-12-09 16:30:53', '2025-12-09 16:30:53', 1, 'GASOLINA'),
(52, 'AA656SG', 2023, 'NEGRO', 11, 0, 2, 48, 'ACTIVO', '2025-12-09 16:35:33', '2025-12-09 16:35:33', 1, 'GASOLINA'),
(53, 'EJB9786', 2000, 'BLANCA', 12, 0, 1, 49, 'ACTIVO', '2025-12-09 16:41:05', '2025-12-09 16:41:05', 1, 'GASOLINA'),
(54, 'AA588UP', 20000, 'NEGRA', 10, 0, 1, 50, 'ACTIVO', '2025-12-09 16:49:41', '2025-12-09 16:49:41', 1, 'GASOLINA'),
(55, 'A91AJ60', 2000, 'BLANCA', 2, 0, 9, 45, 'ACTIVO', '2025-12-09 17:07:17', '2025-12-09 17:07:17', 1, 'GASOLINA'),
(56, 'AS8R60N', 2000, 'ROJO', 4, 0, 35, 30, 'ACTIVO', '2025-12-11 14:49:52', '2025-12-11 14:49:52', 1, 'GASOLINA'),
(57, 'A55AE6R', 2000, 'BLANCA', 10, 0, 1, 49, 'ACTIVO', '2025-12-11 15:07:48', '2025-12-11 15:07:48', 1, 'GASOLINA'),
(58, 'FBR07V', 2000, 'BLANCO', 17, 0, 2, 51, 'ACTIVO', '2025-12-21 22:22:49', '2025-12-21 22:22:49', 1, 'GASOLINA'),
(59, 'AFT70M', 2000, 'BLANCO', 3, 0, 8, 52, 'ACTIVO', '2025-12-27 08:32:16', '2025-12-27 08:32:16', 1, 'GASOLINA'),
(60, 'AD570WV', 2000, 'ROJO', 3, 0, 1, 53, 'ACTIVO', '2025-12-27 08:43:09', '2025-12-27 08:43:09', 1, 'GASOLINA'),
(61, 'FAI24U', 2000, 'AZUL', 3, 0, 16, 54, 'ACTIVO', '2025-12-27 08:45:55', '2025-12-27 08:45:55', 1, 'GASOLINA'),
(62, 'AJ7N73A', 2000, 'ROJO', 19, 0, 36, 38, 'ACTIVO', '2026-01-05 08:42:43', '2026-01-05 08:42:43', 1, 'GASOLINA'),
(63, 'AL4V17N', 2000, 'BLANCO', 20, 0, 36, 55, 'ACTIVO', '2026-01-05 09:29:00', '2026-01-05 09:29:00', 1, 'GASOLINA'),
(64, '86223', 2000, 'VERDE', 20, 0, 39, 56, 'ACTIVO', '2026-01-05 09:31:03', '2026-01-05 09:31:03', 1, 'GASOLINA'),
(65, 'A01AE6B', 2000, 'VERDE', 2, 0, 1, 49, 'ACTIVO', '2026-01-05 09:46:36', '2026-01-05 09:46:36', 1, 'GASOLINA'),
(66, 'AB7P61L', 2000, 'ROJO', 20, 0, 36, 55, 'ACTIVO', '2026-01-05 10:47:29', '2026-01-05 10:47:29', 1, 'GASOLINA'),
(67, 'DEER250GYS', 2000, 'BLANCO', 7, 0, 40, 57, 'ACTIVO', '2026-01-05 13:32:52', '2026-01-05 13:32:52', 1, 'GASOLINA'),
(68, '360', 2000, 'BLANCO', 4, 0, 31, 18, 'ACTIVO', '2026-01-07 15:22:00', '2026-01-07 15:22:00', 1, 'GASOIL'),
(69, 'AC8N639', 2000, 'ROJO', 20, 0, 36, 37, 'ACTIVO', '2026-01-07 16:03:35', '2026-01-07 16:03:35', 1, 'GASOLINA'),
(70, 'SPMB0055', 2000, 'AZUL', 11, 0, 35, 28, 'ACTIVO', '2026-01-07 16:16:35', '2026-01-07 16:16:35', 1, 'GASOLINA'),
(71, 'AM6H09K', 2000, 'AZUL', 11, 0, 26, 7, 'ACTIVO', '2026-01-07 16:20:26', '2026-01-07 16:20:26', 1, 'GASOLINA'),
(72, 'AB4A85N', 2000, 'ROJA', 1, 0, 36, 39, 'ACTIVO', '2026-01-07 17:56:10', '2026-01-07 17:56:10', 1, 'GASOLINA'),
(73, 'AB4A84N', 2000, 'VERDE', 1, 0, 36, 39, 'ACTIVO', '2026-01-08 07:57:37', '2026-01-08 07:57:37', 1, 'GASOLINA'),
(74, 'AL6X09K', 2000, 'VERDE', 20, 0, 35, 27, 'ACTIVO', '2026-01-08 08:01:28', '2026-01-08 08:01:28', 1, 'GASOLINA'),
(75, 'AL6X08K', 2000, 'VERDE', 20, 0, 35, 30, 'ACTIVO', '2026-01-08 08:06:19', '2026-01-08 08:06:19', 1, 'GASOLINA'),
(76, '27VVTI', 2000, 'BLANCA', 6, 0, 1, 49, 'ACTIVO', '2026-01-08 08:09:46', '2026-01-08 08:09:46', 1, 'GASOLINA'),
(77, 'SPMB0061', 2000, 'VERDE', 7, 0, 1, 60, 'ACTIVO', '2026-01-08 08:12:38', '2026-01-08 08:12:38', 1, 'GASOLINA'),
(78, 'A82EB2P', 2000, 'BLANCA', 10, 0, 28, 43, 'ACTIVO', '2026-01-08 08:25:48', '2026-01-08 08:25:48', 1, 'GASOIL'),
(79, 'A46EA4G', 2000, 'AZUL', 10, 0, 1, 60, 'ACTIVO', '2026-01-08 08:28:15', '2026-01-08 08:28:15', 1, 'GASOIL'),
(80, 'AU5P72G', 2000, 'AZUL', 1, 0, 26, 7, 'ACTIVO', '2026-01-08 09:12:54', '2026-01-08 09:12:54', 1, 'GASOLINA'),
(81, 'A60AG3V', 2000, 'BLANCO', 5, 0, 42, 61, 'ACTIVO', '2026-01-08 09:15:47', '2026-01-08 09:15:47', 1, 'GASOLINA'),
(82, 'AD7X41S', 2000, 'BLANCO', 21, 0, 41, 59, 'ACTIVO', '2026-01-08 09:26:20', '2026-01-08 09:26:20', 1, 'GASOLINA'),
(83, '322', 2000, 'AMARILLO', 4, 0, 23, 62, 'ACTIVO', '2026-01-08 09:53:47', '2026-01-08 09:53:47', 1, 'GASOIL'),
(84, 'J350', 2000, 'AMARILLO', 4, 0, 23, 62, 'ACTIVO', '2026-01-08 10:53:43', '2026-01-08 10:53:43', 1, 'GASOIL'),
(85, '9747', 2000, 'ROJO', 2, 0, 35, 30, 'ACTIVO', '2026-01-08 11:01:27', '2026-01-08 11:01:27', 1, 'GASOLINA'),
(86, '14', 2000, 'NEGRO', 22, 0, 18, 63, 'ACTIVO', '2026-01-08 11:05:20', '2026-01-08 11:05:20', 1, 'GASOLINA'),
(87, 'AM0H72K', 2000, 'ROJO', 11, 0, 26, 7, 'ACTIVO', '2026-01-08 11:07:51', '2026-01-08 11:07:51', 1, 'GASOLINA'),
(88, 'AW1C95V', 2000, 'ROJO', 9, 0, 26, 7, 'ACTIVO', '2026-01-08 11:09:21', '2026-01-08 11:09:21', 1, 'GASOLINA'),
(89, 'AB404IB', 2000, 'AZUL', 7, 0, 10, 64, 'ACTIVO', '2026-01-08 13:34:51', '2026-01-08 13:34:51', 1, 'GASOLINA'),
(90, 'AB099KM', 2000, 'ROJO', 23, 0, 1, 49, 'ACTIVO', '2026-01-08 13:39:31', '2026-01-08 13:39:31', 1, 'GASOLINA'),
(91, 'TOYOTA', 2000, 'VERDE', 24, 0, 1, 49, 'ACTIVO', '2026-01-08 13:42:57', '2026-01-08 13:42:57', 1, 'GASOLINA'),
(92, 'AC9N64P', 2000, 'VERDE', 3, 0, 36, 55, 'ACTIVO', '2026-01-09 07:38:10', '2026-01-09 07:38:10', 1, 'GASOLINA'),
(93, 'AP1J444', 2000, 'BLANCA', 20, 0, 26, 7, 'ACTIVO', '2026-01-09 07:39:12', '2026-01-09 07:39:12', 1, 'GASOLINA'),
(94, 'JAC30', 2000, 'AMARILLO', 6, 0, 23, 65, 'ACTIVO', '2026-01-09 08:09:09', '2026-01-09 08:09:09', 1, 'GASOIL'),
(95, '160H', 2000, 'AMARILLO', 4, 0, 23, 66, 'ACTIVO', '2026-01-09 08:14:08', '2026-01-09 08:14:08', 1, 'GASOIL'),
(96, '05', 2000, 'NEGRO', 22, 0, 36, 67, 'ACTIVO', '2026-01-09 09:44:32', '2026-01-09 09:44:32', 1, 'GASOLINA'),
(97, 'LW300006', 2000, 'AMARILLO', 4, 0, 23, 68, 'ACTIVO', '2026-01-11 15:31:45', '2026-01-11 15:31:45', 1, 'GASOIL'),
(98, 'A42AU1D', 2000, 'AZUL', 4, 0, 27, 10, 'ACTIVO', '2026-01-11 15:36:16', '2026-01-11 15:36:16', 1, 'GASOIL'),
(99, 'A36AC40', 2000, 'AZUL', 4, 0, 1, 69, 'ACTIVO', '2026-01-11 15:43:31', '2026-01-11 15:43:31', 1, 'GASOIL'),
(100, '16', 2000, 'NEGRO', 22, 0, 2, 70, 'ACTIVO', '2026-01-11 16:20:07', '2026-01-11 16:20:07', 1, 'GASOLINA'),
(101, 'A94BB3P', 2000, 'AMARILLO', 23, 0, 9, 45, 'ACTIVO', '2026-01-11 16:42:52', '2026-01-11 16:42:52', 1, 'GASOLINA'),
(102, 'AD837YS', 2000, 'NEGRO', 10, 0, 16, 54, 'ACTIVO', '2026-01-11 17:10:38', '2026-01-11 17:10:38', 1, 'GASOLINA'),
(103, 'AA881DA', 2000, 'VERDE', 11, 0, 9, 71, 'ACTIVO', '2026-01-11 17:39:44', '2026-01-11 17:39:44', 1, 'GASOLINA'),
(104, '00AA0LL', 2000, 'AMARILLO', 11, 0, 43, 72, 'ACTIVO', '2026-01-11 17:54:27', '2026-01-11 17:54:27', 1, 'GASOLINA'),
(105, '56CKAMN', 2000, 'VERDE', 1, 0, 8, 73, 'ACTIVO', '2026-01-11 18:26:10', '2026-01-11 18:26:10', 1, 'GASOIL'),
(106, 'JBC', 2000, 'AMARILLO', 4, 0, 23, 4, 'ACTIVO', '2026-01-11 18:41:30', '2026-01-11 18:41:30', 1, 'GASOIL'),
(107, 'A46BO5M', 2000, 'BLANCO', 4, 0, 18, 63, 'ACTIVO', '2026-01-12 07:26:50', '2026-01-12 07:26:50', 1, 'GASOLINA'),
(108, 'AMOH71K', 2000, 'BLANCO', 6, 0, 26, 31, 'ACTIVO', '2026-01-12 07:35:14', '2026-01-12 07:35:14', 1, 'GASOLINA'),
(109, 'AA4C85C', 2000, 'NEGRO', 17, 0, 36, 55, 'ACTIVO', '2026-01-12 08:24:42', '2026-01-12 08:24:42', 1, 'GASOLINA'),
(110, 'AB189UF', 2000, 'NEGRO', 1, 0, 15, 74, 'ACTIVO', '2026-01-12 08:41:26', '2026-01-12 08:41:26', 1, 'GASOLINA');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `almacenistas`
--
ALTER TABLE `almacenistas`
  ADD PRIMARY KEY (`id_almacenista`),
  ADD UNIQUE KEY `cedula` (`cedula`),
  ADD UNIQUE KEY `cedula_2` (`cedula`),
  ADD UNIQUE KEY `cedula_3` (`cedula`),
  ADD UNIQUE KEY `cedula_4` (`cedula`),
  ADD UNIQUE KEY `cedula_5` (`cedula`),
  ADD UNIQUE KEY `cedula_6` (`cedula`),
  ADD UNIQUE KEY `cedula_7` (`cedula`),
  ADD UNIQUE KEY `cedula_8` (`cedula`),
  ADD UNIQUE KEY `cedula_9` (`cedula`),
  ADD UNIQUE KEY `cedula_10` (`cedula`),
  ADD UNIQUE KEY `cedula_11` (`cedula`),
  ADD UNIQUE KEY `cedula_12` (`cedula`),
  ADD UNIQUE KEY `cedula_13` (`cedula`),
  ADD UNIQUE KEY `cedula_14` (`cedula`),
  ADD UNIQUE KEY `cedula_15` (`cedula`),
  ADD UNIQUE KEY `cedula_16` (`cedula`),
  ADD UNIQUE KEY `cedula_17` (`cedula`),
  ADD UNIQUE KEY `cedula_18` (`cedula`),
  ADD UNIQUE KEY `cedula_19` (`cedula`),
  ADD UNIQUE KEY `cedula_20` (`cedula`),
  ADD UNIQUE KEY `cedula_21` (`cedula`),
  ADD UNIQUE KEY `cedula_22` (`cedula`),
  ADD UNIQUE KEY `cedula_23` (`cedula`),
  ADD UNIQUE KEY `cedula_24` (`cedula`),
  ADD UNIQUE KEY `cedula_25` (`cedula`),
  ADD UNIQUE KEY `cedula_26` (`cedula`),
  ADD UNIQUE KEY `cedula_27` (`cedula`),
  ADD UNIQUE KEY `cedula_28` (`cedula`),
  ADD UNIQUE KEY `cedula_29` (`cedula`),
  ADD UNIQUE KEY `cedula_30` (`cedula`),
  ADD UNIQUE KEY `cedula_31` (`cedula`),
  ADD UNIQUE KEY `cedula_32` (`cedula`),
  ADD UNIQUE KEY `cedula_33` (`cedula`),
  ADD UNIQUE KEY `cedula_34` (`cedula`),
  ADD UNIQUE KEY `cedula_35` (`cedula`),
  ADD UNIQUE KEY `cedula_36` (`cedula`),
  ADD UNIQUE KEY `cedula_37` (`cedula`),
  ADD UNIQUE KEY `cedula_38` (`cedula`),
  ADD UNIQUE KEY `cedula_39` (`cedula`),
  ADD UNIQUE KEY `cedula_40` (`cedula`),
  ADD UNIQUE KEY `cedula_41` (`cedula`),
  ADD UNIQUE KEY `cedula_42` (`cedula`),
  ADD UNIQUE KEY `cedula_43` (`cedula`),
  ADD UNIQUE KEY `cedula_44` (`cedula`),
  ADD UNIQUE KEY `cedula_45` (`cedula`),
  ADD UNIQUE KEY `cedula_46` (`cedula`),
  ADD UNIQUE KEY `cedula_47` (`cedula`),
  ADD UNIQUE KEY `cedula_48` (`cedula`),
  ADD UNIQUE KEY `cedula_49` (`cedula`),
  ADD UNIQUE KEY `cedula_50` (`cedula`),
  ADD UNIQUE KEY `cedula_51` (`cedula`),
  ADD UNIQUE KEY `cedula_52` (`cedula`),
  ADD UNIQUE KEY `cedula_53` (`cedula`),
  ADD UNIQUE KEY `cedula_54` (`cedula`),
  ADD UNIQUE KEY `cedula_55` (`cedula`),
  ADD UNIQUE KEY `cedula_56` (`cedula`),
  ADD UNIQUE KEY `cedula_57` (`cedula`),
  ADD UNIQUE KEY `cedula_58` (`cedula`),
  ADD UNIQUE KEY `cedula_59` (`cedula`),
  ADD UNIQUE KEY `cedula_60` (`cedula`),
  ADD UNIQUE KEY `cedula_61` (`cedula`),
  ADD UNIQUE KEY `cedula_62` (`cedula`),
  ADD UNIQUE KEY `cedula_63` (`cedula`);

--
-- Indices de la tabla `cargas_cisterna`
--
ALTER TABLE `cargas_cisterna`
  ADD PRIMARY KEY (`id_carga`),
  ADD UNIQUE KEY `numero_guia` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_2` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_3` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_4` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_5` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_6` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_7` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_8` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_9` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_10` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_11` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_12` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_13` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_14` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_15` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_16` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_17` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_18` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_19` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_20` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_21` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_22` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_23` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_24` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_25` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_26` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_27` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_28` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_29` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_30` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_31` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_32` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_33` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_34` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_35` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_36` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_37` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_38` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_39` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_40` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_41` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_42` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_43` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_44` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_45` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_46` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_47` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_48` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_49` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_50` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_51` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_52` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_53` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_54` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_55` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_56` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_57` (`numero_guia`),
  ADD UNIQUE KEY `numero_guia_58` (`numero_guia`),
  ADD KEY `id_vehiculo` (`id_vehiculo`),
  ADD KEY `id_tanque` (`id_tanque`),
  ADD KEY `id_almacenista` (`id_almacenista`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_cierre` (`id_cierre`);

--
-- Indices de la tabla `choferes`
--
ALTER TABLE `choferes`
  ADD PRIMARY KEY (`id_chofer`),
  ADD UNIQUE KEY `cedula` (`cedula`),
  ADD UNIQUE KEY `cedula_2` (`cedula`),
  ADD UNIQUE KEY `cedula_3` (`cedula`),
  ADD UNIQUE KEY `cedula_4` (`cedula`),
  ADD UNIQUE KEY `cedula_5` (`cedula`),
  ADD UNIQUE KEY `cedula_6` (`cedula`),
  ADD UNIQUE KEY `cedula_7` (`cedula`),
  ADD UNIQUE KEY `cedula_8` (`cedula`),
  ADD UNIQUE KEY `cedula_9` (`cedula`),
  ADD UNIQUE KEY `cedula_10` (`cedula`),
  ADD UNIQUE KEY `cedula_11` (`cedula`),
  ADD UNIQUE KEY `cedula_12` (`cedula`),
  ADD UNIQUE KEY `cedula_13` (`cedula`),
  ADD UNIQUE KEY `cedula_14` (`cedula`),
  ADD UNIQUE KEY `cedula_15` (`cedula`),
  ADD UNIQUE KEY `cedula_16` (`cedula`),
  ADD UNIQUE KEY `cedula_17` (`cedula`),
  ADD UNIQUE KEY `cedula_18` (`cedula`),
  ADD UNIQUE KEY `cedula_19` (`cedula`),
  ADD UNIQUE KEY `cedula_20` (`cedula`),
  ADD UNIQUE KEY `cedula_21` (`cedula`),
  ADD UNIQUE KEY `cedula_22` (`cedula`),
  ADD UNIQUE KEY `cedula_23` (`cedula`),
  ADD UNIQUE KEY `cedula_24` (`cedula`),
  ADD UNIQUE KEY `cedula_25` (`cedula`),
  ADD UNIQUE KEY `cedula_26` (`cedula`),
  ADD UNIQUE KEY `cedula_27` (`cedula`),
  ADD UNIQUE KEY `cedula_28` (`cedula`),
  ADD UNIQUE KEY `cedula_29` (`cedula`),
  ADD UNIQUE KEY `cedula_30` (`cedula`),
  ADD UNIQUE KEY `cedula_31` (`cedula`),
  ADD UNIQUE KEY `cedula_32` (`cedula`),
  ADD UNIQUE KEY `cedula_33` (`cedula`),
  ADD UNIQUE KEY `cedula_34` (`cedula`),
  ADD UNIQUE KEY `cedula_35` (`cedula`),
  ADD UNIQUE KEY `cedula_36` (`cedula`),
  ADD UNIQUE KEY `cedula_37` (`cedula`),
  ADD UNIQUE KEY `cedula_38` (`cedula`),
  ADD UNIQUE KEY `cedula_39` (`cedula`),
  ADD UNIQUE KEY `cedula_40` (`cedula`),
  ADD UNIQUE KEY `cedula_41` (`cedula`),
  ADD UNIQUE KEY `cedula_42` (`cedula`),
  ADD UNIQUE KEY `cedula_43` (`cedula`),
  ADD UNIQUE KEY `cedula_44` (`cedula`),
  ADD UNIQUE KEY `cedula_45` (`cedula`),
  ADD UNIQUE KEY `cedula_46` (`cedula`),
  ADD UNIQUE KEY `cedula_47` (`cedula`),
  ADD UNIQUE KEY `cedula_48` (`cedula`),
  ADD UNIQUE KEY `cedula_49` (`cedula`),
  ADD UNIQUE KEY `cedula_50` (`cedula`),
  ADD UNIQUE KEY `cedula_51` (`cedula`),
  ADD UNIQUE KEY `cedula_52` (`cedula`),
  ADD UNIQUE KEY `cedula_53` (`cedula`),
  ADD UNIQUE KEY `cedula_54` (`cedula`),
  ADD UNIQUE KEY `cedula_55` (`cedula`),
  ADD UNIQUE KEY `cedula_56` (`cedula`),
  ADD UNIQUE KEY `cedula_57` (`cedula`),
  ADD UNIQUE KEY `cedula_58` (`cedula`),
  ADD UNIQUE KEY `cedula_59` (`cedula`),
  ADD UNIQUE KEY `cedula_60` (`cedula`),
  ADD UNIQUE KEY `cedula_61` (`cedula`),
  ADD UNIQUE KEY `cedula_62` (`cedula`),
  ADD UNIQUE KEY `cedula_63` (`cedula`);

--
-- Indices de la tabla `cierres_inventario`
--
ALTER TABLE `cierres_inventario`
  ADD PRIMARY KEY (`id_cierre`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_tanque` (`id_tanque`);

--
-- Indices de la tabla `despachos`
--
ALTER TABLE `despachos`
  ADD PRIMARY KEY (`id_despacho`),
  ADD UNIQUE KEY `numero_ticket` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_21` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_22` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_23` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_24` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_25` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_26` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_27` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_28` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_29` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_30` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_31` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_32` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_33` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_34` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_35` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_36` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_37` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_38` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_39` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_40` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_41` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_42` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_43` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_44` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_45` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_46` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_47` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_48` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_49` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_50` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_51` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_52` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_53` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_54` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_55` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_56` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_2` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_3` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_4` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_5` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_6` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_7` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_8` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_9` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_10` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_11` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_12` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_13` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_14` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_15` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_16` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_17` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_18` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_19` (`numero_ticket`),
  ADD UNIQUE KEY `numero_ticket_20` (`numero_ticket`),
  ADD KEY `id_dispensador` (`id_dispensador`),
  ADD KEY `id_vehiculo` (`id_vehiculo`),
  ADD KEY `id_chofer` (`id_chofer`),
  ADD KEY `id_gerencia` (`id_gerencia`),
  ADD KEY `id_almacenista` (`id_almacenista`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_cierre` (`id_cierre`);

--
-- Indices de la tabla `dispensadores`
--
ALTER TABLE `dispensadores`
  ADD PRIMARY KEY (`id_dispensador`),
  ADD KEY `id_tanque_asociado` (`id_tanque_asociado`);

--
-- Indices de la tabla `gerencias`
--
ALTER TABLE `gerencias`
  ADD PRIMARY KEY (`id_gerencia`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD UNIQUE KEY `nombre_2` (`nombre`),
  ADD UNIQUE KEY `nombre_3` (`nombre`),
  ADD UNIQUE KEY `nombre_4` (`nombre`),
  ADD UNIQUE KEY `nombre_5` (`nombre`),
  ADD UNIQUE KEY `nombre_6` (`nombre`),
  ADD UNIQUE KEY `nombre_7` (`nombre`),
  ADD UNIQUE KEY `nombre_8` (`nombre`),
  ADD UNIQUE KEY `nombre_9` (`nombre`),
  ADD UNIQUE KEY `nombre_10` (`nombre`),
  ADD UNIQUE KEY `nombre_11` (`nombre`),
  ADD UNIQUE KEY `nombre_12` (`nombre`),
  ADD UNIQUE KEY `nombre_13` (`nombre`),
  ADD UNIQUE KEY `nombre_14` (`nombre`),
  ADD UNIQUE KEY `nombre_15` (`nombre`),
  ADD UNIQUE KEY `nombre_16` (`nombre`),
  ADD UNIQUE KEY `nombre_17` (`nombre`),
  ADD UNIQUE KEY `nombre_18` (`nombre`),
  ADD UNIQUE KEY `nombre_19` (`nombre`),
  ADD UNIQUE KEY `nombre_20` (`nombre`),
  ADD UNIQUE KEY `nombre_21` (`nombre`),
  ADD UNIQUE KEY `nombre_22` (`nombre`),
  ADD UNIQUE KEY `nombre_23` (`nombre`),
  ADD UNIQUE KEY `nombre_24` (`nombre`),
  ADD UNIQUE KEY `nombre_25` (`nombre`),
  ADD UNIQUE KEY `nombre_26` (`nombre`),
  ADD UNIQUE KEY `nombre_27` (`nombre`),
  ADD UNIQUE KEY `nombre_28` (`nombre`),
  ADD UNIQUE KEY `nombre_29` (`nombre`),
  ADD UNIQUE KEY `nombre_30` (`nombre`),
  ADD UNIQUE KEY `nombre_31` (`nombre`),
  ADD UNIQUE KEY `nombre_32` (`nombre`),
  ADD UNIQUE KEY `nombre_33` (`nombre`),
  ADD UNIQUE KEY `nombre_34` (`nombre`),
  ADD UNIQUE KEY `nombre_35` (`nombre`),
  ADD UNIQUE KEY `nombre_36` (`nombre`),
  ADD UNIQUE KEY `nombre_37` (`nombre`),
  ADD UNIQUE KEY `nombre_38` (`nombre`),
  ADD UNIQUE KEY `nombre_39` (`nombre`),
  ADD UNIQUE KEY `nombre_40` (`nombre`),
  ADD UNIQUE KEY `nombre_41` (`nombre`),
  ADD UNIQUE KEY `nombre_42` (`nombre`),
  ADD UNIQUE KEY `nombre_43` (`nombre`),
  ADD UNIQUE KEY `nombre_44` (`nombre`),
  ADD UNIQUE KEY `nombre_45` (`nombre`),
  ADD UNIQUE KEY `nombre_46` (`nombre`),
  ADD UNIQUE KEY `nombre_47` (`nombre`),
  ADD UNIQUE KEY `nombre_48` (`nombre`),
  ADD UNIQUE KEY `nombre_49` (`nombre`),
  ADD UNIQUE KEY `nombre_50` (`nombre`),
  ADD UNIQUE KEY `nombre_51` (`nombre`),
  ADD UNIQUE KEY `nombre_52` (`nombre`),
  ADD UNIQUE KEY `nombre_53` (`nombre`),
  ADD UNIQUE KEY `nombre_54` (`nombre`),
  ADD UNIQUE KEY `nombre_55` (`nombre`),
  ADD UNIQUE KEY `nombre_56` (`nombre`),
  ADD UNIQUE KEY `nombre_57` (`nombre`),
  ADD UNIQUE KEY `nombre_58` (`nombre`),
  ADD UNIQUE KEY `nombre_59` (`nombre`),
  ADD UNIQUE KEY `nombre_60` (`nombre`),
  ADD UNIQUE KEY `nombre_61` (`nombre`),
  ADD UNIQUE KEY `nombre_62` (`nombre`),
  ADD UNIQUE KEY `nombre_63` (`nombre`);

--
-- Indices de la tabla `marcas`
--
ALTER TABLE `marcas`
  ADD PRIMARY KEY (`id_marca`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD UNIQUE KEY `nombre_2` (`nombre`),
  ADD UNIQUE KEY `nombre_3` (`nombre`),
  ADD UNIQUE KEY `nombre_4` (`nombre`),
  ADD UNIQUE KEY `nombre_5` (`nombre`),
  ADD UNIQUE KEY `nombre_6` (`nombre`),
  ADD UNIQUE KEY `nombre_7` (`nombre`),
  ADD UNIQUE KEY `nombre_8` (`nombre`),
  ADD UNIQUE KEY `nombre_9` (`nombre`),
  ADD UNIQUE KEY `nombre_10` (`nombre`),
  ADD UNIQUE KEY `nombre_11` (`nombre`),
  ADD UNIQUE KEY `nombre_12` (`nombre`),
  ADD UNIQUE KEY `nombre_13` (`nombre`),
  ADD UNIQUE KEY `nombre_14` (`nombre`),
  ADD UNIQUE KEY `nombre_15` (`nombre`),
  ADD UNIQUE KEY `nombre_16` (`nombre`),
  ADD UNIQUE KEY `nombre_17` (`nombre`),
  ADD UNIQUE KEY `nombre_18` (`nombre`),
  ADD UNIQUE KEY `nombre_19` (`nombre`),
  ADD UNIQUE KEY `nombre_20` (`nombre`),
  ADD UNIQUE KEY `nombre_21` (`nombre`),
  ADD UNIQUE KEY `nombre_22` (`nombre`),
  ADD UNIQUE KEY `nombre_23` (`nombre`),
  ADD UNIQUE KEY `nombre_24` (`nombre`),
  ADD UNIQUE KEY `nombre_25` (`nombre`),
  ADD UNIQUE KEY `nombre_26` (`nombre`),
  ADD UNIQUE KEY `nombre_27` (`nombre`),
  ADD UNIQUE KEY `nombre_28` (`nombre`),
  ADD UNIQUE KEY `nombre_29` (`nombre`),
  ADD UNIQUE KEY `nombre_30` (`nombre`),
  ADD UNIQUE KEY `nombre_31` (`nombre`),
  ADD UNIQUE KEY `nombre_32` (`nombre`),
  ADD UNIQUE KEY `nombre_33` (`nombre`),
  ADD UNIQUE KEY `nombre_34` (`nombre`),
  ADD UNIQUE KEY `nombre_35` (`nombre`),
  ADD UNIQUE KEY `nombre_36` (`nombre`),
  ADD UNIQUE KEY `nombre_37` (`nombre`),
  ADD UNIQUE KEY `nombre_38` (`nombre`),
  ADD UNIQUE KEY `nombre_39` (`nombre`),
  ADD UNIQUE KEY `nombre_40` (`nombre`),
  ADD UNIQUE KEY `nombre_41` (`nombre`),
  ADD UNIQUE KEY `nombre_42` (`nombre`),
  ADD UNIQUE KEY `nombre_43` (`nombre`),
  ADD UNIQUE KEY `nombre_44` (`nombre`),
  ADD UNIQUE KEY `nombre_45` (`nombre`),
  ADD UNIQUE KEY `nombre_46` (`nombre`),
  ADD UNIQUE KEY `nombre_47` (`nombre`),
  ADD UNIQUE KEY `nombre_48` (`nombre`),
  ADD UNIQUE KEY `nombre_49` (`nombre`),
  ADD UNIQUE KEY `nombre_50` (`nombre`),
  ADD UNIQUE KEY `nombre_51` (`nombre`),
  ADD UNIQUE KEY `nombre_52` (`nombre`),
  ADD UNIQUE KEY `nombre_53` (`nombre`),
  ADD UNIQUE KEY `nombre_54` (`nombre`),
  ADD UNIQUE KEY `nombre_55` (`nombre`),
  ADD UNIQUE KEY `nombre_56` (`nombre`),
  ADD UNIQUE KEY `nombre_57` (`nombre`),
  ADD UNIQUE KEY `nombre_58` (`nombre`),
  ADD UNIQUE KEY `nombre_59` (`nombre`),
  ADD UNIQUE KEY `nombre_60` (`nombre`),
  ADD UNIQUE KEY `nombre_61` (`nombre`),
  ADD UNIQUE KEY `nombre_62` (`nombre`),
  ADD UNIQUE KEY `nombre_63` (`nombre`);

--
-- Indices de la tabla `mediciones_tanques`
--
ALTER TABLE `mediciones_tanques`
  ADD PRIMARY KEY (`id_medicion`),
  ADD KEY `id_tanque` (`id_tanque`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_cierre` (`id_cierre`);

--
-- Indices de la tabla `modelos`
--
ALTER TABLE `modelos`
  ADD PRIMARY KEY (`id_modelo`),
  ADD KEY `id_marca` (`id_marca`);

--
-- Indices de la tabla `tanques`
--
ALTER TABLE `tanques`
  ADD PRIMARY KEY (`id_tanque`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD UNIQUE KEY `codigo_2` (`codigo`),
  ADD UNIQUE KEY `codigo_3` (`codigo`),
  ADD UNIQUE KEY `codigo_4` (`codigo`),
  ADD UNIQUE KEY `codigo_5` (`codigo`),
  ADD UNIQUE KEY `codigo_6` (`codigo`),
  ADD UNIQUE KEY `codigo_7` (`codigo`),
  ADD UNIQUE KEY `codigo_8` (`codigo`),
  ADD UNIQUE KEY `codigo_9` (`codigo`),
  ADD UNIQUE KEY `codigo_10` (`codigo`),
  ADD UNIQUE KEY `codigo_11` (`codigo`),
  ADD UNIQUE KEY `codigo_12` (`codigo`),
  ADD UNIQUE KEY `codigo_13` (`codigo`),
  ADD UNIQUE KEY `codigo_14` (`codigo`),
  ADD UNIQUE KEY `codigo_15` (`codigo`),
  ADD UNIQUE KEY `codigo_16` (`codigo`),
  ADD UNIQUE KEY `codigo_17` (`codigo`),
  ADD UNIQUE KEY `codigo_18` (`codigo`),
  ADD UNIQUE KEY `codigo_19` (`codigo`),
  ADD UNIQUE KEY `codigo_20` (`codigo`),
  ADD UNIQUE KEY `codigo_21` (`codigo`),
  ADD UNIQUE KEY `codigo_22` (`codigo`),
  ADD UNIQUE KEY `codigo_23` (`codigo`),
  ADD UNIQUE KEY `codigo_24` (`codigo`),
  ADD UNIQUE KEY `codigo_25` (`codigo`),
  ADD UNIQUE KEY `codigo_26` (`codigo`),
  ADD UNIQUE KEY `codigo_27` (`codigo`),
  ADD UNIQUE KEY `codigo_28` (`codigo`),
  ADD UNIQUE KEY `codigo_29` (`codigo`),
  ADD UNIQUE KEY `codigo_30` (`codigo`),
  ADD UNIQUE KEY `codigo_31` (`codigo`),
  ADD UNIQUE KEY `codigo_32` (`codigo`),
  ADD UNIQUE KEY `codigo_33` (`codigo`),
  ADD UNIQUE KEY `codigo_34` (`codigo`),
  ADD UNIQUE KEY `codigo_35` (`codigo`),
  ADD UNIQUE KEY `codigo_36` (`codigo`),
  ADD UNIQUE KEY `codigo_37` (`codigo`),
  ADD UNIQUE KEY `codigo_38` (`codigo`),
  ADD UNIQUE KEY `codigo_39` (`codigo`),
  ADD UNIQUE KEY `codigo_40` (`codigo`),
  ADD UNIQUE KEY `codigo_41` (`codigo`),
  ADD UNIQUE KEY `codigo_42` (`codigo`),
  ADD UNIQUE KEY `codigo_43` (`codigo`),
  ADD UNIQUE KEY `codigo_44` (`codigo`),
  ADD UNIQUE KEY `codigo_45` (`codigo`),
  ADD UNIQUE KEY `codigo_46` (`codigo`),
  ADD UNIQUE KEY `codigo_47` (`codigo`),
  ADD UNIQUE KEY `codigo_48` (`codigo`),
  ADD UNIQUE KEY `codigo_49` (`codigo`),
  ADD UNIQUE KEY `codigo_50` (`codigo`),
  ADD UNIQUE KEY `codigo_51` (`codigo`),
  ADD UNIQUE KEY `codigo_52` (`codigo`),
  ADD UNIQUE KEY `codigo_53` (`codigo`),
  ADD UNIQUE KEY `codigo_54` (`codigo`),
  ADD UNIQUE KEY `codigo_55` (`codigo`),
  ADD UNIQUE KEY `codigo_56` (`codigo`),
  ADD UNIQUE KEY `codigo_57` (`codigo`),
  ADD UNIQUE KEY `codigo_58` (`codigo`),
  ADD UNIQUE KEY `codigo_59` (`codigo`),
  ADD UNIQUE KEY `codigo_60` (`codigo`),
  ADD UNIQUE KEY `codigo_61` (`codigo`),
  ADD UNIQUE KEY `codigo_62` (`codigo`),
  ADD UNIQUE KEY `codigo_63` (`codigo`);

--
-- Indices de la tabla `transferencias_internas`
--
ALTER TABLE `transferencias_internas`
  ADD PRIMARY KEY (`id_transferencia`),
  ADD KEY `id_tanque_origen` (`id_tanque_origen`),
  ADD KEY `id_tanque_destino` (`id_tanque_destino`),
  ADD KEY `id_almacenista` (`id_almacenista`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `cedula` (`cedula`),
  ADD UNIQUE KEY `cedula_2` (`cedula`),
  ADD UNIQUE KEY `cedula_3` (`cedula`),
  ADD UNIQUE KEY `cedula_4` (`cedula`),
  ADD UNIQUE KEY `cedula_5` (`cedula`),
  ADD UNIQUE KEY `cedula_6` (`cedula`),
  ADD UNIQUE KEY `cedula_7` (`cedula`),
  ADD UNIQUE KEY `cedula_8` (`cedula`),
  ADD UNIQUE KEY `cedula_9` (`cedula`),
  ADD UNIQUE KEY `cedula_10` (`cedula`),
  ADD UNIQUE KEY `cedula_11` (`cedula`),
  ADD UNIQUE KEY `cedula_12` (`cedula`),
  ADD UNIQUE KEY `cedula_13` (`cedula`),
  ADD UNIQUE KEY `cedula_14` (`cedula`),
  ADD UNIQUE KEY `cedula_15` (`cedula`),
  ADD UNIQUE KEY `cedula_16` (`cedula`),
  ADD UNIQUE KEY `cedula_17` (`cedula`),
  ADD UNIQUE KEY `cedula_18` (`cedula`),
  ADD UNIQUE KEY `cedula_19` (`cedula`),
  ADD UNIQUE KEY `cedula_20` (`cedula`),
  ADD UNIQUE KEY `cedula_21` (`cedula`),
  ADD UNIQUE KEY `cedula_22` (`cedula`),
  ADD UNIQUE KEY `cedula_23` (`cedula`),
  ADD UNIQUE KEY `cedula_24` (`cedula`),
  ADD UNIQUE KEY `cedula_25` (`cedula`),
  ADD UNIQUE KEY `cedula_26` (`cedula`),
  ADD UNIQUE KEY `cedula_27` (`cedula`),
  ADD UNIQUE KEY `cedula_28` (`cedula`),
  ADD UNIQUE KEY `cedula_29` (`cedula`),
  ADD UNIQUE KEY `cedula_30` (`cedula`),
  ADD UNIQUE KEY `cedula_31` (`cedula`),
  ADD UNIQUE KEY `cedula_32` (`cedula`),
  ADD UNIQUE KEY `cedula_33` (`cedula`),
  ADD UNIQUE KEY `cedula_34` (`cedula`),
  ADD UNIQUE KEY `cedula_35` (`cedula`),
  ADD UNIQUE KEY `cedula_36` (`cedula`),
  ADD UNIQUE KEY `cedula_37` (`cedula`),
  ADD UNIQUE KEY `cedula_38` (`cedula`),
  ADD UNIQUE KEY `cedula_39` (`cedula`),
  ADD UNIQUE KEY `cedula_40` (`cedula`),
  ADD UNIQUE KEY `cedula_41` (`cedula`),
  ADD UNIQUE KEY `cedula_42` (`cedula`),
  ADD UNIQUE KEY `cedula_43` (`cedula`),
  ADD UNIQUE KEY `cedula_44` (`cedula`),
  ADD UNIQUE KEY `cedula_45` (`cedula`),
  ADD UNIQUE KEY `cedula_46` (`cedula`),
  ADD UNIQUE KEY `cedula_47` (`cedula`),
  ADD UNIQUE KEY `cedula_48` (`cedula`),
  ADD UNIQUE KEY `cedula_49` (`cedula`),
  ADD UNIQUE KEY `cedula_50` (`cedula`),
  ADD UNIQUE KEY `cedula_51` (`cedula`),
  ADD UNIQUE KEY `cedula_52` (`cedula`),
  ADD UNIQUE KEY `cedula_53` (`cedula`),
  ADD UNIQUE KEY `cedula_54` (`cedula`),
  ADD UNIQUE KEY `cedula_55` (`cedula`),
  ADD UNIQUE KEY `cedula_56` (`cedula`),
  ADD UNIQUE KEY `cedula_57` (`cedula`),
  ADD UNIQUE KEY `cedula_58` (`cedula`),
  ADD UNIQUE KEY `cedula_59` (`cedula`),
  ADD UNIQUE KEY `cedula_60` (`cedula`),
  ADD UNIQUE KEY `cedula_61` (`cedula`),
  ADD UNIQUE KEY `cedula_62` (`cedula`),
  ADD UNIQUE KEY `cedula_63` (`cedula`);

--
-- Indices de la tabla `vehiculos`
--
ALTER TABLE `vehiculos`
  ADD PRIMARY KEY (`id_vehiculo`),
  ADD UNIQUE KEY `placa` (`placa`),
  ADD UNIQUE KEY `placa_2` (`placa`),
  ADD UNIQUE KEY `placa_3` (`placa`),
  ADD UNIQUE KEY `placa_4` (`placa`),
  ADD UNIQUE KEY `placa_5` (`placa`),
  ADD UNIQUE KEY `placa_6` (`placa`),
  ADD UNIQUE KEY `placa_7` (`placa`),
  ADD UNIQUE KEY `placa_8` (`placa`),
  ADD UNIQUE KEY `placa_9` (`placa`),
  ADD UNIQUE KEY `placa_10` (`placa`),
  ADD UNIQUE KEY `placa_11` (`placa`),
  ADD UNIQUE KEY `placa_12` (`placa`),
  ADD UNIQUE KEY `placa_13` (`placa`),
  ADD UNIQUE KEY `placa_14` (`placa`),
  ADD UNIQUE KEY `placa_15` (`placa`),
  ADD UNIQUE KEY `placa_16` (`placa`),
  ADD UNIQUE KEY `placa_17` (`placa`),
  ADD UNIQUE KEY `placa_18` (`placa`),
  ADD UNIQUE KEY `placa_19` (`placa`),
  ADD UNIQUE KEY `placa_20` (`placa`),
  ADD UNIQUE KEY `placa_21` (`placa`),
  ADD UNIQUE KEY `placa_22` (`placa`),
  ADD UNIQUE KEY `placa_23` (`placa`),
  ADD UNIQUE KEY `placa_24` (`placa`),
  ADD UNIQUE KEY `placa_25` (`placa`),
  ADD UNIQUE KEY `placa_26` (`placa`),
  ADD UNIQUE KEY `placa_27` (`placa`),
  ADD UNIQUE KEY `placa_28` (`placa`),
  ADD UNIQUE KEY `placa_29` (`placa`),
  ADD UNIQUE KEY `placa_30` (`placa`),
  ADD UNIQUE KEY `placa_31` (`placa`),
  ADD UNIQUE KEY `placa_32` (`placa`),
  ADD UNIQUE KEY `placa_33` (`placa`),
  ADD UNIQUE KEY `placa_34` (`placa`),
  ADD UNIQUE KEY `placa_35` (`placa`),
  ADD UNIQUE KEY `placa_36` (`placa`),
  ADD UNIQUE KEY `placa_37` (`placa`),
  ADD UNIQUE KEY `placa_38` (`placa`),
  ADD UNIQUE KEY `placa_39` (`placa`),
  ADD UNIQUE KEY `placa_40` (`placa`),
  ADD UNIQUE KEY `placa_41` (`placa`),
  ADD UNIQUE KEY `placa_42` (`placa`),
  ADD UNIQUE KEY `placa_43` (`placa`),
  ADD UNIQUE KEY `placa_44` (`placa`),
  ADD UNIQUE KEY `placa_45` (`placa`),
  ADD UNIQUE KEY `placa_46` (`placa`),
  ADD UNIQUE KEY `placa_47` (`placa`),
  ADD UNIQUE KEY `placa_48` (`placa`),
  ADD UNIQUE KEY `placa_49` (`placa`),
  ADD UNIQUE KEY `placa_50` (`placa`),
  ADD UNIQUE KEY `placa_51` (`placa`),
  ADD UNIQUE KEY `placa_52` (`placa`),
  ADD UNIQUE KEY `placa_53` (`placa`),
  ADD UNIQUE KEY `placa_54` (`placa`),
  ADD UNIQUE KEY `placa_55` (`placa`),
  ADD UNIQUE KEY `placa_56` (`placa`),
  ADD UNIQUE KEY `placa_57` (`placa`),
  ADD UNIQUE KEY `placa_58` (`placa`),
  ADD UNIQUE KEY `placa_59` (`placa`),
  ADD UNIQUE KEY `placa_60` (`placa`),
  ADD KEY `id_gerencia` (`id_gerencia`),
  ADD KEY `id_marca` (`id_marca`),
  ADD KEY `id_modelo` (`id_modelo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `almacenistas`
--
ALTER TABLE `almacenistas`
  MODIFY `id_almacenista` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `cargas_cisterna`
--
ALTER TABLE `cargas_cisterna`
  MODIFY `id_carga` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `choferes`
--
ALTER TABLE `choferes`
  MODIFY `id_chofer` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT de la tabla `cierres_inventario`
--
ALTER TABLE `cierres_inventario`
  MODIFY `id_cierre` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=731;

--
-- AUTO_INCREMENT de la tabla `despachos`
--
ALTER TABLE `despachos`
  MODIFY `id_despacho` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=278;

--
-- AUTO_INCREMENT de la tabla `dispensadores`
--
ALTER TABLE `dispensadores`
  MODIFY `id_dispensador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `gerencias`
--
ALTER TABLE `gerencias`
  MODIFY `id_gerencia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT de la tabla `marcas`
--
ALTER TABLE `marcas`
  MODIFY `id_marca` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT de la tabla `mediciones_tanques`
--
ALTER TABLE `mediciones_tanques`
  MODIFY `id_medicion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT de la tabla `modelos`
--
ALTER TABLE `modelos`
  MODIFY `id_modelo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT de la tabla `tanques`
--
ALTER TABLE `tanques`
  MODIFY `id_tanque` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `transferencias_internas`
--
ALTER TABLE `transferencias_internas`
  MODIFY `id_transferencia` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `vehiculos`
--
ALTER TABLE `vehiculos`
  MODIFY `id_vehiculo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cargas_cisterna`
--
ALTER TABLE `cargas_cisterna`
  ADD CONSTRAINT `cargas_cisterna_ibfk_1286` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id_vehiculo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cargas_cisterna_ibfk_1287` FOREIGN KEY (`id_tanque`) REFERENCES `tanques` (`id_tanque`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cargas_cisterna_ibfk_1288` FOREIGN KEY (`id_almacenista`) REFERENCES `almacenistas` (`id_almacenista`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cargas_cisterna_ibfk_1289` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cargas_cisterna_ibfk_1290` FOREIGN KEY (`id_cierre`) REFERENCES `cierres_inventario` (`id_cierre`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `cierres_inventario`
--
ALTER TABLE `cierres_inventario`
  ADD CONSTRAINT `cierres_inventario_ibfk_566` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cierres_inventario_ibfk_567` FOREIGN KEY (`id_tanque`) REFERENCES `tanques` (`id_tanque`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `despachos`
--
ALTER TABLE `despachos`
  ADD CONSTRAINT `despachos_ibfk_1849` FOREIGN KEY (`id_dispensador`) REFERENCES `dispensadores` (`id_dispensador`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `despachos_ibfk_1850` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id_vehiculo`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `despachos_ibfk_1851` FOREIGN KEY (`id_chofer`) REFERENCES `choferes` (`id_chofer`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `despachos_ibfk_1852` FOREIGN KEY (`id_gerencia`) REFERENCES `gerencias` (`id_gerencia`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `despachos_ibfk_1853` FOREIGN KEY (`id_almacenista`) REFERENCES `almacenistas` (`id_almacenista`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `despachos_ibfk_1854` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `despachos_ibfk_1855` FOREIGN KEY (`id_cierre`) REFERENCES `cierres_inventario` (`id_cierre`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `dispensadores`
--
ALTER TABLE `dispensadores`
  ADD CONSTRAINT `dispensadores_ibfk_1` FOREIGN KEY (`id_tanque_asociado`) REFERENCES `tanques` (`id_tanque`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `mediciones_tanques`
--
ALTER TABLE `mediciones_tanques`
  ADD CONSTRAINT `mediciones_tanques_ibfk_769` FOREIGN KEY (`id_tanque`) REFERENCES `tanques` (`id_tanque`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `mediciones_tanques_ibfk_770` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `mediciones_tanques_ibfk_771` FOREIGN KEY (`id_cierre`) REFERENCES `cierres_inventario` (`id_cierre`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `modelos`
--
ALTER TABLE `modelos`
  ADD CONSTRAINT `modelos_ibfk_1` FOREIGN KEY (`id_marca`) REFERENCES `marcas` (`id_marca`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `transferencias_internas`
--
ALTER TABLE `transferencias_internas`
  ADD CONSTRAINT `transferencias_internas_ibfk_441` FOREIGN KEY (`id_tanque_origen`) REFERENCES `tanques` (`id_tanque`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transferencias_internas_ibfk_442` FOREIGN KEY (`id_tanque_destino`) REFERENCES `tanques` (`id_tanque`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transferencias_internas_ibfk_443` FOREIGN KEY (`id_almacenista`) REFERENCES `almacenistas` (`id_almacenista`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transferencias_internas_ibfk_444` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `vehiculos`
--
ALTER TABLE `vehiculos`
  ADD CONSTRAINT `vehiculos_ibfk_855` FOREIGN KEY (`id_gerencia`) REFERENCES `gerencias` (`id_gerencia`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `vehiculos_ibfk_856` FOREIGN KEY (`id_marca`) REFERENCES `marcas` (`id_marca`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `vehiculos_ibfk_857` FOREIGN KEY (`id_modelo`) REFERENCES `modelos` (`id_modelo`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
