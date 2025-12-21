-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-12-2025 a las 20:44:59
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

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_generar_despacho_prueb` (IN `p_id_dispensador` INT, IN `p_litros` DECIMAL(12,2), IN `p_tipo_destino` VARCHAR(20), IN `p_id_referencia` INT, IN `p_fecha_hora` DATETIME)   BEGIN
    -- Declaración de variables
    DECLARE v_ticket VARCHAR(50);
    DECLARE v_id_almacenista INT;
    DECLARE v_id_usuario INT DEFAULT 1; 
    DECLARE v_odometro_inicial DECIMAL(12,2);
    DECLARE v_odometro_final DECIMAL(12,2);
    DECLARE v_id_tanque INT;
    DECLARE v_id_chofer INT DEFAULT NULL;
    DECLARE v_destino_real ENUM('VEHICULO', 'BIDON');
    DECLARE v_id_vehiculo INT DEFAULT NULL;
    DECLARE v_id_gerencia INT DEFAULT NULL;

    -- Generar Ticket
    SET v_ticket = CONCAT('TEST-', FLOOR(RAND() * 900000) + 100000);

    -- Almacenista Random
    SELECT id_almacenista INTO v_id_almacenista 
    FROM almacenistas 
    WHERE estado = 'ACTIVO' 
    ORDER BY RAND() LIMIT 1;

    -- Datos Dispensador
    SELECT odometro_actual, id_tanque_asociado 
    INTO v_odometro_inicial, v_id_tanque
    FROM dispensadores 
    WHERE id_dispensador = p_id_dispensador;

    SET v_odometro_final = v_odometro_inicial + p_litros;

    -- Lógica Vehículo/Bidón
    IF p_tipo_destino = 'BIDON' THEN
        SET v_destino_real = 'BIDON';
        SET v_id_gerencia = p_id_referencia;
        SET v_id_vehiculo = NULL;
        SET v_id_chofer = NULL;
    ELSE
        SET v_destino_real = 'VEHICULO';
        SET v_id_vehiculo = p_id_referencia;
        SET v_id_gerencia = NULL; 
        
        SELECT id_chofer INTO v_id_chofer 
        FROM choferes 
        WHERE estado = 'ACTIVO' 
        ORDER BY RAND() LIMIT 1;
    END IF;

    -- Insertar Despacho
    INSERT INTO despachos (
        numero_ticket, fecha_hora, id_dispensador, odometro_previo, 
        odometro_final, cantidad_solicitada, cantidad_despachada, 
        tipo_destino, id_vehiculo, id_chofer, id_gerencia, 
        observacion, id_almacenista, id_usuario, estado
    ) VALUES (
        v_ticket, p_fecha_hora, p_id_dispensador, v_odometro_inicial,
        v_odometro_final, p_litros, p_litros,
        v_destino_real, v_id_vehiculo, v_id_chofer, v_id_gerencia,
        'Prueba de inserción automática', v_id_almacenista, v_id_usuario, 'PROCESADO'
    );

    -- Actualizar Dispensador
    UPDATE dispensadores 
    SET odometro_actual = v_odometro_final 
    WHERE id_dispensador = p_id_dispensador;

    -- Actualizar Tanque
    UPDATE tanques 
    SET nivel_actual = nivel_actual - p_litros 
    WHERE id_tanque = v_id_tanque;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_generar_despacho_prueba` (IN `p_litros` DECIMAL(10,2), IN `p_id_dispensador` INT, IN `p_tipo_destino` VARCHAR(20), IN `p_id_referencia` INT, IN `p_fecha_hora` DATETIME)   BEGIN
    -- Declaración de variables
    DECLARE v_ticket VARCHAR(50);
    DECLARE v_id_almacenista INT;
    DECLARE v_id_usuario INT DEFAULT 1; -- Usuario fijo 01
    DECLARE v_odometro_inicial DECIMAL(12,2);
    DECLARE v_odometro_final DECIMAL(12,2);
    DECLARE v_id_tanque INT;
    DECLARE v_id_chofer INT DEFAULT NULL;
    DECLARE v_destino_real ENUM('VEHICULO', 'BIDON');
    DECLARE v_id_vehiculo INT DEFAULT NULL;
    DECLARE v_id_gerencia INT DEFAULT NULL;

    -- 1. Generar Ticket Aleatorio (Prefijo TEST + numeros al azar para evitar duplicados)
    SET v_ticket = CONCAT('TEST-', FLOOR(RAND() * 900000) + 100000);

    -- 2. Seleccionar un Almacenista Aleatorio que esté ACTIVO
    SELECT id_almacenista INTO v_id_almacenista 
    FROM almacenistas 
    WHERE estado = 'ACTIVO' 
    ORDER BY RAND() 
    LIMIT 1;

    -- 3. Obtener datos del dispensador (Lectura actual y tanque asociado)
    SELECT odometro_actual, id_tanque_asociado 
    INTO v_odometro_inicial, v_id_tanque
    FROM dispensadores 
    WHERE id_dispensador = p_id_dispensador;

    -- Calcular la lectura final del surtidor
    SET v_odometro_final = v_odometro_inicial + p_litros;

    -- 4. Lógica según el tipo (Vehiculo/Generador vs Bidon)
    IF p_tipo_destino = 'BIDON' THEN
        SET v_destino_real = 'BIDON';
        SET v_id_gerencia = p_id_referencia; -- En caso de bidón, el parametro es la gerencia
        SET v_id_vehiculo = NULL;
        SET v_id_chofer = NULL;
    ELSE
        -- Caso VEHICULO o GENERADOR (Ambos van a la columna id_vehiculo)
        SET v_destino_real = 'VEHICULO';
        SET v_id_vehiculo = p_id_referencia; -- En caso de vehiculo, el parametro es id_vehiculo
        SET v_id_gerencia = NULL; 
        
        -- Seleccionar un Chofer Aleatorio para el vehículo
        SELECT id_chofer INTO v_id_chofer 
        FROM choferes 
        WHERE estado = 'ACTIVO' 
        ORDER BY RAND() 
        LIMIT 1;
    END IF;

    -- 5. Insertar el Despacho
    INSERT INTO despachos (
        numero_ticket,
        fecha_hora,
        id_dispensador,
        odometro_previo,
        odometro_final,
        cantidad_solicitada,
        cantidad_despachada,
        tipo_destino,
        id_vehiculo,
        id_chofer,
        id_gerencia,
        observacion,
        id_almacenista,
        id_usuario,
        estado
    ) VALUES (
        v_ticket,
        p_fecha_hora,
        p_id_dispensador,
        v_odometro_inicial,
        v_odometro_final,
        p_litros,      -- Solicitada
        p_litros,      -- Despachada (Asumimos que es igual para la prueba)
        v_destino_real,
        v_id_vehiculo,
        v_id_chofer,
        v_id_gerencia,
        'Prueba de inserción automática',
        v_id_almacenista,
        v_id_usuario,
        'PROCESADO'
    );

    -- 6. Actualizar el Odómetro del Dispensador
    UPDATE dispensadores 
    SET odometro_actual = v_odometro_final 
    WHERE id_dispensador = p_id_dispensador;

    -- 7. Descontar inventario del Tanque
    UPDATE tanques 
    SET nivel_actual = nivel_actual - p_litros 
    WHERE id_tanque = v_id_tanque;

END$$

DELIMITER ;

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
(1, 'RAMON', 'BOLIVAR', '123456', 'ALMACENISTA 01', '2233333333', 'ACTIVO', '2025-11-23 12:58:56', '2025-12-03 16:02:39', 1),
(2, 'NOLAN', 'VELASQUEZ', '2222222', 'ALMACENISTA 01', '333333', 'ACTIVO', '2025-11-23 12:59:57', '2025-12-03 16:02:42', 1),
(3, 'JEAN FRANCO', 'DI GEMMA', '1234565', 'Almacenista 02', '435435435', 'ACTIVO', '2025-11-24 08:11:12', '2025-12-03 16:02:45', 1),
(4, 'Leonel', 'Granado', '1234567', 'Almacen', '04242334223', 'ACTIVO', '2025-12-07 15:37:29', '2025-12-07 15:37:29', 1),
(5, 'JHON', 'GARCIA', '3333333', 'ALMACENISTA 01', '222222', 'ACTIVO', '2025-12-08 14:22:58', '2025-12-08 14:22:58', 1);

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
(34, '123131', 24, 6, 5, 0.00, 1.53, 0.02, 24692.48, 24692.46, NULL, NULL, 24897.00, 204.54, '', 1, 'PROCESADO', '2025-12-09 11:53:49', 253, '2025-12-09 11:48:00', 4, '2025-12-09', '2025-12-09', 'GASOLINA', 10000.00, 5000.00, 5000.00, '08:00:00', '09:00:00', 60),
(35, '2423423', 24, 1, 5, 12.00, 50.00, 3627.00, 28627.00, 25000.00, NULL, NULL, 25000.00, 0.00, '', 1, 'PROCESADO', '2025-12-11 10:50:14', 261, '2025-12-11 10:49:00', 13, '2025-12-11', '2025-12-11', 'GASOIL', 1.00, 1.00, 0.00, '08:00:00', '09:00:00', 60);

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
(31, 'LEONARDO', 'MEDINA', '21110594', 'ACTIVO', '2025-12-09 16:39:46', '2025-12-09 16:39:46', 1);

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
(199, '8ca5f08e-4265-492c-9f52-bf16f1b53d54', 'GASOIL', 'NOCTURNO', '2025-12-03 06:30:00', 1, 1, 25584.00, 0.00, 1937.00, 340.00, 25584.00, '{\"vehiculos\":340,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(200, '8ca5f08e-4265-492c-9f52-bf16f1b53d54', 'GASOLINA', 'NOCTURNO', '2025-12-03 06:30:00', 1, 2, 5975.00, 0.00, 17.00, 160.00, 5975.00, '{\"vehiculos\":160,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(201, '8ca5f08e-4265-492c-9f52-bf16f1b53d54', 'GASOIL', 'NOCTURNO', '2025-12-03 06:30:00', 1, 3, 523.00, 0.00, 0.00, 0.00, 523.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(202, '8ca5f08e-4265-492c-9f52-bf16f1b53d54', 'GASOIL', 'NOCTURNO', '2025-12-03 06:30:00', 1, 4, 4192.00, 0.00, 0.00, 0.00, 4192.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(203, '8ca5f08e-4265-492c-9f52-bf16f1b53d54', 'GASOLINA', 'NOCTURNO', '2025-12-03 06:30:00', 1, 6, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(204, 'fd74b50c-3069-46fd-acf9-f8f00282170d', 'GASOIL', 'DIURNO', '2025-12-03 15:59:00', 1, 1, 25584.00, 36728.00, 3936.00, 1245.00, 57131.00, '{\"vehiculos\":1245,\"generadores\":2000,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(205, 'fd74b50c-3069-46fd-acf9-f8f00282170d', 'GASOLINA', 'DIURNO', '2025-12-03 15:59:00', 1, 2, 5975.00, 0.00, 112.00, 310.00, 5553.00, '{\"vehiculos\":310,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(206, 'fd74b50c-3069-46fd-acf9-f8f00282170d', 'GASOIL', 'DIURNO', '2025-12-03 15:59:00', 1, 3, 523.00, 0.00, 0.00, 0.00, 523.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(207, 'fd74b50c-3069-46fd-acf9-f8f00282170d', 'GASOIL', 'DIURNO', '2025-12-03 15:59:00', 1, 4, 4192.00, 0.00, 0.00, 0.00, 4192.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(208, 'fd74b50c-3069-46fd-acf9-f8f00282170d', 'GASOLINA', 'DIURNO', '2025-12-03 15:59:00', 1, 6, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(209, '3f8c35ed-db63-4bb1-b5b0-1865b6a8d05a', 'GASOIL', 'NOCTURNO', '2025-12-03 07:00:00', 1, 1, 57131.00, 0.00, 6084.00, 640.00, 50407.00, '{\"vehiculos\":640,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(210, '3f8c35ed-db63-4bb1-b5b0-1865b6a8d05a', 'GASOLINA', 'NOCTURNO', '2025-12-03 07:00:00', 1, 2, 5553.00, 0.00, -52.00, 261.00, 5344.00, '{\"vehiculos\":261,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(211, '3f8c35ed-db63-4bb1-b5b0-1865b6a8d05a', 'GASOIL', 'NOCTURNO', '2025-12-03 07:00:00', 1, 3, 523.00, 0.00, 0.00, 0.00, 523.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(212, '3f8c35ed-db63-4bb1-b5b0-1865b6a8d05a', 'GASOIL', 'NOCTURNO', '2025-12-03 07:00:00', 1, 4, 4192.00, 0.00, 0.00, 0.00, 4192.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(213, '3f8c35ed-db63-4bb1-b5b0-1865b6a8d05a', 'GASOLINA', 'NOCTURNO', '2025-12-03 07:00:00', 1, 6, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(219, '700bc73c-504b-4770-a3da-c645a2aea89c', 'GASOIL', 'DIURNO', '2025-12-04 18:00:00', 1, 1, 50407.00, 0.00, 1381.00, 920.00, 48106.00, '{\"vehiculos\":920,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(220, '700bc73c-504b-4770-a3da-c645a2aea89c', 'GASOLINA', 'DIURNO', '2025-12-04 18:00:00', 1, 2, 5344.00, 0.00, 28.00, 339.00, 5005.00, '{\"vehiculos\":339,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(221, '700bc73c-504b-4770-a3da-c645a2aea89c', 'GASOIL', 'DIURNO', '2025-12-04 18:00:00', 1, 3, 523.00, 0.00, 0.00, 0.00, 523.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(222, '700bc73c-504b-4770-a3da-c645a2aea89c', 'GASOIL', 'DIURNO', '2025-12-04 18:00:00', 1, 4, 4192.00, 0.00, 0.00, 0.00, 4192.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(223, '700bc73c-504b-4770-a3da-c645a2aea89c', 'GASOLINA', 'DIURNO', '2025-12-04 18:00:00', 1, 6, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(224, '5940a5a3-88cb-4867-abe7-f2951fd7cf4c', 'GASOIL', 'NOCTURNO', '2025-12-05 06:30:00', 1, 1, 48106.00, 0.00, 7503.00, 290.00, 40313.00, '{\"vehiculos\":290,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(225, '5940a5a3-88cb-4867-abe7-f2951fd7cf4c', 'GASOLINA', 'NOCTURNO', '2025-12-05 06:30:00', 1, 2, 5005.00, 0.00, 4.00, 70.00, 4931.00, '{\"vehiculos\":70,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(226, '5940a5a3-88cb-4867-abe7-f2951fd7cf4c', 'GASOIL', 'NOCTURNO', '2025-12-05 06:30:00', 1, 3, 523.00, 0.00, 0.00, 0.00, 523.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(227, '5940a5a3-88cb-4867-abe7-f2951fd7cf4c', 'GASOIL', 'NOCTURNO', '2025-12-05 06:30:00', 1, 4, 4192.00, 0.00, 0.00, 0.00, 4192.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(228, '5940a5a3-88cb-4867-abe7-f2951fd7cf4c', 'GASOLINA', 'NOCTURNO', '2025-12-05 06:30:00', 1, 6, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(229, '035b82ea-01c6-40e0-a862-4571c150de6d', 'GASOIL', 'DIURNO', '2025-12-05 18:00:00', 1, 1, 40313.00, 0.00, 6861.00, 1740.00, 31712.00, '{\"vehiculos\":1740,\"generadores\":2000,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', 'Tanque 02 de Gasolina 0.65 cm = 4.727 lts, se observo 22 lts positivos.'),
(230, '035b82ea-01c6-40e0-a862-4571c150de6d', 'GASOLINA', 'DIURNO', '2025-12-05 18:00:00', 1, 2, 4931.00, 0.00, -22.10, 226.00, 4705.00, '{\"vehiculos\":226,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', 'Tanque 02 de Gasolina 0.65 cm = 4.727 lts, se observo 22 lts positivos.'),
(231, '035b82ea-01c6-40e0-a862-4571c150de6d', 'GASOIL', 'DIURNO', '2025-12-05 18:00:00', 1, 3, 523.00, 0.00, 0.00, 0.00, 523.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', 'Tanque 02 de Gasolina 0.65 cm = 4.727 lts, se observo 22 lts positivos.'),
(232, '035b82ea-01c6-40e0-a862-4571c150de6d', 'GASOIL', 'DIURNO', '2025-12-05 18:00:00', 1, 4, 4192.00, 0.00, 0.00, 0.00, 4192.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', 'Tanque 02 de Gasolina 0.65 cm = 4.727 lts, se observo 22 lts positivos.'),
(233, '035b82ea-01c6-40e0-a862-4571c150de6d', 'GASOLINA', 'DIURNO', '2025-12-05 18:00:00', 1, 6, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', 'Tanque 02 de Gasolina 0.65 cm = 4.727 lts, se observo 22 lts positivos.'),
(234, '52ba5679-1418-42d4-a922-99669ff64524', 'GASOIL', 'NOCTURNO', '2025-12-06 06:00:00', 1, 1, 31712.00, 0.00, 4351.00, 262.00, 27099.00, '{\"vehiculos\":262,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(235, '52ba5679-1418-42d4-a922-99669ff64524', 'GASOLINA', 'NOCTURNO', '2025-12-06 06:00:00', 1, 2, 4705.00, 0.00, 2.92, 177.00, 4528.00, '{\"vehiculos\":177,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(236, '52ba5679-1418-42d4-a922-99669ff64524', 'GASOIL', 'NOCTURNO', '2025-12-06 06:00:00', 1, 3, 523.00, 0.00, 0.00, 0.00, 523.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(237, '52ba5679-1418-42d4-a922-99669ff64524', 'GASOIL', 'NOCTURNO', '2025-12-06 06:00:00', 1, 4, 4192.00, 0.00, 0.00, 0.00, 4192.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(238, '52ba5679-1418-42d4-a922-99669ff64524', 'GASOLINA', 'NOCTURNO', '2025-12-06 06:00:00', 1, 6, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(239, 'a7a799f3-2787-404b-b129-e3836f157ca5', 'GASOIL', 'DIURNO', '2025-12-06 18:00:00', 1, 1, 27099.00, 0.00, 4400.00, 838.00, 21861.00, '{\"vehiculos\":838,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(240, 'a7a799f3-2787-404b-b129-e3836f157ca5', 'GASOLINA', 'DIURNO', '2025-12-06 18:00:00', 1, 2, 4528.00, 0.00, -4.10, 405.00, 4123.00, '{\"vehiculos\":405,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(241, 'a7a799f3-2787-404b-b129-e3836f157ca5', 'GASOIL', 'DIURNO', '2025-12-06 18:00:00', 1, 3, 523.00, 0.00, 0.00, 0.00, 523.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(242, 'a7a799f3-2787-404b-b129-e3836f157ca5', 'GASOIL', 'DIURNO', '2025-12-06 18:00:00', 1, 4, 4192.00, 0.00, 0.00, 0.00, 4192.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(243, 'a7a799f3-2787-404b-b129-e3836f157ca5', 'GASOLINA', 'DIURNO', '2025-12-06 18:00:00', 1, 6, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(244, '83d9a191-a0d6-44a0-a91d-f1915bc77ad5', 'GASOIL', 'NOCTURNO', '2025-12-07 06:30:00', 1, 1, 21861.00, 0.00, 6644.00, 418.00, 14799.00, '{\"vehiculos\":418,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(245, '83d9a191-a0d6-44a0-a91d-f1915bc77ad5', 'GASOLINA', 'NOCTURNO', '2025-12-07 06:30:00', 1, 2, 4123.00, 0.00, 3.76, 56.00, 4067.00, '{\"vehiculos\":56,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(246, '83d9a191-a0d6-44a0-a91d-f1915bc77ad5', 'GASOIL', 'NOCTURNO', '2025-12-07 06:30:00', 1, 3, 523.00, 0.00, 0.00, 0.00, 523.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(247, '83d9a191-a0d6-44a0-a91d-f1915bc77ad5', 'GASOIL', 'NOCTURNO', '2025-12-07 06:30:00', 1, 4, 4192.00, 0.00, 0.00, 0.00, 4192.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(248, '83d9a191-a0d6-44a0-a91d-f1915bc77ad5', 'GASOLINA', 'NOCTURNO', '2025-12-07 06:30:00', 1, 6, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"NOLAN\",\"apellido\":\"VELASQUEZ\",\"cedula\":\"2222222\"}}', ''),
(249, 'c030509c-9285-4c87-aa6f-8200243e3a05', 'GASOIL', 'NOCTURNO', '2025-12-09 11:59:00', 1, 1, 14799.00, 0.00, 10098.00, 3936.00, 4701.00, '{\"vehiculos\":3466,\"generadores\":0,\"bidones\":470,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JHON\",\"apellido\":\"GARCIA\",\"cedula\":\"3333333\"}}', ''),
(250, 'c030509c-9285-4c87-aa6f-8200243e3a05', 'GASOLINA', 'NOCTURNO', '2025-12-09 11:59:00', 1, 2, 4067.00, 0.00, 0.00, 123.00, 3944.00, '{\"vehiculos\":63,\"generadores\":0,\"bidones\":60,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JHON\",\"apellido\":\"GARCIA\",\"cedula\":\"3333333\"}}', ''),
(251, 'c030509c-9285-4c87-aa6f-8200243e3a05', 'GASOIL', 'NOCTURNO', '2025-12-09 11:59:00', 1, 3, 523.00, 0.00, 0.00, 0.00, 523.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JHON\",\"apellido\":\"GARCIA\",\"cedula\":\"3333333\"}}', ''),
(252, 'c030509c-9285-4c87-aa6f-8200243e3a05', 'GASOIL', 'NOCTURNO', '2025-12-09 11:59:00', 1, 4, 4192.00, 0.00, 0.00, 0.00, 4192.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JHON\",\"apellido\":\"GARCIA\",\"cedula\":\"3333333\"}}', ''),
(253, 'c030509c-9285-4c87-aa6f-8200243e3a05', 'GASOLINA', 'NOCTURNO', '2025-12-09 11:59:00', 1, 6, 0.00, 24692.46, 204.54, 0.00, 24692.48, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JHON\",\"apellido\":\"GARCIA\",\"cedula\":\"3333333\"}}', ''),
(254, 'c030509c-9285-4c87-aa6f-8200243e3a05', 'GASOLINA', 'NOCTURNO', '2025-12-09 11:59:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"JHON\",\"apellido\":\"GARCIA\",\"cedula\":\"3333333\"}}', ''),
(255, '0e36dad5-10ad-4160-b11f-13f85dbbdf84', 'GASOIL', 'NOCTURNO', '2025-12-08 06:20:00', 1, 1, 4701.00, 0.00, 6790.00, 220.00, 1691.00, '{\"vehiculos\":220,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(256, '0e36dad5-10ad-4160-b11f-13f85dbbdf84', 'GASOLINA', 'NOCTURNO', '2025-12-08 06:20:00', 1, 2, 3944.00, 0.00, 9.19, 115.00, 3829.00, '{\"vehiculos\":115,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(257, '0e36dad5-10ad-4160-b11f-13f85dbbdf84', 'GASOIL', 'NOCTURNO', '2025-12-08 06:20:00', 1, 3, 523.00, 0.00, 0.00, 0.00, 523.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(258, '0e36dad5-10ad-4160-b11f-13f85dbbdf84', 'GASOIL', 'NOCTURNO', '2025-12-08 06:20:00', 1, 4, 4192.00, 0.00, 0.00, 0.00, 4192.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(259, '0e36dad5-10ad-4160-b11f-13f85dbbdf84', 'GASOLINA', 'NOCTURNO', '2025-12-08 06:20:00', 1, 6, 24692.48, 0.00, 0.00, 0.00, 24692.48, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(260, '0e36dad5-10ad-4160-b11f-13f85dbbdf84', 'GASOLINA', 'NOCTURNO', '2025-12-08 06:20:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(261, 'a19c4505-3a8f-4e53-a4a2-0b418a0fc056', 'GASOIL', 'DIURNO', '2025-09-08 18:30:00', 1, 1, 1691.00, 25000.00, 4255.00, 834.00, 25584.00, '{\"vehiculos\":834,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(262, 'a19c4505-3a8f-4e53-a4a2-0b418a0fc056', 'GASOLINA', 'DIURNO', '2025-09-08 18:30:00', 1, 2, 3829.00, 0.00, 9.80, 1126.00, 2703.00, '{\"vehiculos\":421,\"generadores\":0,\"bidones\":705,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(263, 'a19c4505-3a8f-4e53-a4a2-0b418a0fc056', 'GASOIL', 'DIURNO', '2025-09-08 18:30:00', 1, 3, 523.00, 0.00, 0.00, 0.00, 523.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(264, 'a19c4505-3a8f-4e53-a4a2-0b418a0fc056', 'GASOIL', 'DIURNO', '2025-09-08 18:30:00', 1, 4, 4192.00, 0.00, 0.00, 0.00, 4192.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(265, 'a19c4505-3a8f-4e53-a4a2-0b418a0fc056', 'GASOLINA', 'DIURNO', '2025-09-08 18:30:00', 1, 6, 24692.48, 0.00, 0.00, 0.00, 24692.48, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', ''),
(266, 'a19c4505-3a8f-4e53-a4a2-0b418a0fc056', 'GASOLINA', 'DIURNO', '2025-09-08 18:30:00', 1, 7, 0.00, 0.00, 0.00, 0.00, 0.00, '{\"vehiculos\":0,\"generadores\":0,\"bidones\":0,\"usuario\":{\"nombre\":\"María\",\"apellido\":\"González\",\"cedula\":\"12345678\"},\"almacenista\":{\"nombre\":\"Leonel\",\"apellido\":\"Granado\",\"cedula\":\"1234567\"}}', '');

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
  `id_cierre` int(11) DEFAULT NULL COMMENT 'ID del cierre de inventario que procesó este movimiento'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `despachos`
--

INSERT INTO `despachos` (`id_despacho`, `numero_ticket`, `fecha_hora`, `id_dispensador`, `odometro_previo`, `odometro_final`, `cantidad_solicitada`, `cantidad_despachada`, `tipo_destino`, `id_vehiculo`, `id_chofer`, `id_gerencia`, `observacion`, `id_almacenista`, `id_usuario`, `estado`, `id_cierre`) VALUES
(202, '28228', '2025-12-02 15:40:00', 3, 0.00, 70.00, 70.00, 70.00, 'VEHICULO', 12, 8, NULL, NULL, 2, 1, 'PROCESADO', 199),
(203, '3827@', '2025-12-02 15:41:00', 3, 70.00, 140.00, 70.00, 70.00, 'VEHICULO', 7, 8, NULL, NULL, 2, 1, 'PROCESADO', 199),
(204, '38282', '2025-12-02 15:41:00', 3, 140.00, 340.00, 200.00, 200.00, 'VEHICULO', 4, 8, NULL, NULL, 2, 1, 'PROCESADO', 199),
(205, '4282', '2025-12-02 15:42:00', 4, 0.00, 90.00, 90.00, 90.00, 'VEHICULO', 12, 8, NULL, NULL, 2, 1, 'PROCESADO', 200),
(206, '47272', '2025-12-02 15:42:00', 4, 90.00, 160.00, 70.00, 70.00, 'VEHICULO', 7, 8, NULL, NULL, 2, 1, 'PROCESADO', 200),
(207, '48383', '2025-12-03 15:46:00', 3, 340.00, 390.00, 50.00, 50.00, 'VEHICULO', 19, 2, NULL, NULL, 2, 1, 'PROCESADO', 204),
(208, '38383', '2025-12-03 15:48:00', 3, 390.00, 460.00, 70.00, 70.00, 'VEHICULO', 7, 2, NULL, NULL, 2, 1, 'PROCESADO', 204),
(209, '3833', '2025-12-03 15:48:00', 3, 460.00, 1260.00, 800.00, 800.00, 'VEHICULO', 7, 8, NULL, NULL, 2, 1, 'PROCESADO', 204),
(210, '483383', '2025-12-03 04:10:00', 3, 1260.00, 3260.00, 2000.00, 2000.00, 'VEHICULO', 2, 2, NULL, NULL, 2, 1, 'PROCESADO', 204),
(211, '5382', '2025-12-03 15:50:00', 3, 3260.00, 3285.00, 40.00, 25.00, 'VEHICULO', 19, 2, NULL, NULL, 2, 1, 'PROCESADO', 204),
(212, '4327', '2025-12-03 15:51:00', 3, 3285.00, 3585.00, 300.00, 300.00, 'VEHICULO', 19, 8, NULL, NULL, 2, 1, 'PROCESADO', 204),
(213, '53812', '2025-12-03 15:54:00', 4, 160.00, 200.00, 40.00, 40.00, 'VEHICULO', 19, 8, NULL, NULL, 2, 1, 'PROCESADO', 205),
(214, '52281', '2025-12-03 15:54:00', 4, 200.00, 250.00, 50.00, 50.00, 'VEHICULO', 7, 8, NULL, NULL, 2, 1, 'PROCESADO', 205),
(215, '3222', '2025-12-05 15:55:00', 4, 250.00, 270.00, 20.00, 20.00, 'VEHICULO', 12, 2, NULL, NULL, 2, 1, 'PROCESADO', 205),
(216, '42821', '2025-12-03 15:56:00', 4, 270.00, 310.00, 45.00, 40.00, 'VEHICULO', 19, 2, NULL, NULL, 2, 1, 'PROCESADO', 205),
(217, '74499', '2025-12-03 15:56:00', 4, 310.00, 330.00, 20.00, 20.00, 'VEHICULO', 7, 8, NULL, NULL, 2, 1, 'PROCESADO', 205),
(218, '54749', '2025-12-03 15:57:00', 4, 330.00, 400.00, 70.00, 70.00, 'VEHICULO', 12, 8, NULL, NULL, 2, 1, 'PROCESADO', 205),
(219, '64483', '2025-12-03 15:57:00', 4, 400.00, 450.00, 50.00, 50.00, 'VEHICULO', 4, 2, NULL, NULL, 2, 1, 'PROCESADO', 205),
(220, '59449', '2025-12-03 15:58:00', 4, 450.00, 470.00, 20.00, 20.00, 'VEHICULO', 4, 2, NULL, NULL, 2, 1, 'PROCESADO', 205),
(227, '43732', '2025-12-03 19:32:00', 4, 470.00, 545.00, 75.00, 75.00, 'VEHICULO', 7, 8, NULL, NULL, 2, 1, 'PROCESADO', 210),
(228, '43737', '2025-12-03 19:33:00', 4, 545.00, 590.00, 45.00, 45.00, 'VEHICULO', 7, 8, NULL, NULL, 2, 1, 'PROCESADO', 210),
(229, '58333', '2025-12-03 19:35:00', 4, 590.00, 670.00, 80.00, 80.00, 'VEHICULO', 4, 2, NULL, NULL, 2, 1, 'PROCESADO', 210),
(230, '539338', '2025-12-03 19:34:00', 4, 670.00, 678.00, 10.00, 8.00, 'VEHICULO', 19, 8, NULL, NULL, 2, 1, 'PROCESADO', 210),
(231, '53838', '2025-12-03 19:35:00', 4, 678.00, 683.00, 10.00, 5.00, 'VEHICULO', 19, 3, NULL, NULL, 2, 1, 'PROCESADO', 210),
(232, '538282', '2025-12-03 19:37:00', 4, 683.00, 731.00, 50.00, 48.00, 'VEHICULO', 7, 8, NULL, NULL, 2, 1, 'PROCESADO', 210),
(233, '53833', '2025-12-03 19:45:00', 3, 3846.00, 3916.00, 70.00, 70.00, 'VEHICULO', 19, 2, NULL, NULL, 2, 1, 'PROCESADO', 209),
(234, '53832', '2025-12-03 19:46:00', 3, 3916.00, 4416.00, 500.00, 500.00, 'VEHICULO', 19, 8, NULL, NULL, 2, 1, 'PROCESADO', 209),
(235, '538381', '2025-12-03 19:49:00', 3, 4416.00, 4486.00, 70.00, 70.00, 'VEHICULO', 19, 8, NULL, NULL, 2, 1, 'PROCESADO', 209),
(236, 'DG-041224-001', '2025-12-04 07:15:00', 3, 4486.00, 4556.00, 70.00, 70.00, 'VEHICULO', 4, 2, NULL, NULL, 2, 1, 'PROCESADO', 219),
(237, 'DG-041224-002', '2025-12-04 08:30:00', 3, 4556.00, 4626.00, 70.00, 70.00, 'VEHICULO', 12, 8, NULL, NULL, 2, 1, 'PROCESADO', 219),
(238, 'DG-041224-003', '2025-12-04 09:45:00', 3, 4626.00, 4826.00, 200.00, 200.00, 'VEHICULO', 18, 4, NULL, NULL, 2, 1, 'PROCESADO', 219),
(239, 'DG-041224-004', '2025-12-04 10:20:00', 3, 4826.00, 5026.00, 200.00, 200.00, 'VEHICULO', 19, 1, NULL, NULL, 2, 1, 'PROCESADO', 219),
(240, 'DG-041224-005', '2025-12-04 11:00:00', 3, 5026.00, 5126.00, 100.00, 100.00, 'VEHICULO', 21, 3, NULL, NULL, 2, 1, 'PROCESADO', 219),
(241, 'DG-041224-006', '2025-12-04 13:30:00', 3, 5126.00, 5206.00, 80.00, 80.00, 'VEHICULO', 24, 5, NULL, NULL, 2, 1, 'PROCESADO', 219),
(242, 'DG-041224-007', '2025-12-04 15:00:00', 3, 5206.00, 5406.00, 200.00, 200.00, 'VEHICULO', 22, 6, NULL, NULL, 2, 1, 'PROCESADO', 219),
(243, 'GS-041224-001', '2025-12-04 07:30:00', 4, 731.00, 788.00, 57.00, 57.00, 'VEHICULO', 7, 5, NULL, NULL, 2, 1, 'PROCESADO', 220),
(244, 'GS-041224-002', '2025-12-04 08:00:00', 4, 788.00, 838.00, 50.00, 50.00, 'VEHICULO', 10, 2, NULL, NULL, 2, 1, 'PROCESADO', 220),
(245, 'GS-041224-003', '2025-12-04 08:45:00', 4, 838.00, 846.00, 8.00, 8.00, 'VEHICULO', 7, 8, NULL, NULL, 2, 1, 'PROCESADO', 220),
(246, 'GS-041224-004', '2025-12-04 09:15:00', 4, 846.00, 879.00, 33.00, 33.00, 'VEHICULO', 3, 1, NULL, NULL, 2, 1, 'PROCESADO', 220),
(247, 'GS-041224-005', '2025-12-04 10:00:00', 4, 879.00, 886.00, 7.00, 7.00, 'VEHICULO', 6, 4, NULL, NULL, 2, 1, 'PROCESADO', 220),
(248, 'GS-041224-006', '2025-12-04 10:45:00', 4, 886.00, 906.00, 20.00, 20.00, 'VEHICULO', 8, 3, NULL, NULL, 2, 1, 'PROCESADO', 220),
(249, 'GS-041224-007', '2025-12-04 11:30:00', 4, 906.00, 956.00, 50.00, 50.00, 'VEHICULO', 15, 6, NULL, NULL, 2, 1, 'PROCESADO', 220),
(250, 'GS-041224-008', '2025-12-04 12:15:00', 4, 956.00, 966.00, 10.00, 10.00, 'VEHICULO', 7, 7, NULL, NULL, 2, 1, 'PROCESADO', 220),
(251, 'GS-041224-009', '2025-12-04 14:00:00', 4, 966.00, 1035.00, 69.00, 69.00, 'VEHICULO', 16, 2, NULL, NULL, 2, 1, 'PROCESADO', 220),
(252, 'GS-041224-010', '2025-12-04 14:30:00', 4, 1035.00, 1045.00, 10.00, 10.00, 'VEHICULO', 17, 8, NULL, NULL, 2, 1, 'PROCESADO', 220),
(253, 'GS-041224-011', '2025-12-04 15:15:00', 4, 1045.00, 1065.00, 20.00, 20.00, 'VEHICULO', 10, 1, NULL, NULL, 2, 1, 'PROCESADO', 220),
(254, 'GS-041224-012', '2025-12-04 16:00:00', 4, 1065.00, 1070.00, 5.00, 5.00, 'VEHICULO', 7, 5, NULL, NULL, 2, 1, 'PROCESADO', 220),
(255, 'GS-041225-001', '2025-12-04 15:19:00', 4, 1070.00, 1120.00, 50.00, 50.00, 'VEHICULO', 10, 1, NULL, NULL, 2, 1, 'PROCESADO', 225),
(256, 'GS-041225-002', '2025-12-04 08:23:00', 4, 1120.00, 1130.00, 10.00, 10.00, 'VEHICULO', 8, 8, NULL, NULL, 2, 1, 'PROCESADO', 225),
(257, 'GS-041225-003', '2025-12-04 12:34:00', 4, 1130.00, 1140.00, 10.00, 10.00, 'VEHICULO', 6, 3, NULL, NULL, 2, 1, 'PROCESADO', 225),
(258, 'DG-041225-001', '2025-12-04 17:41:00', 3, 5406.00, 5506.00, 100.00, 100.00, 'VEHICULO', 4, 6, NULL, NULL, 2, 1, 'PROCESADO', 224),
(259, 'DG-041225-002', '2025-12-04 08:15:00', 3, 5506.00, 5576.00, 70.00, 70.00, 'VEHICULO', 6, 7, NULL, NULL, 2, 1, 'PROCESADO', 224),
(260, 'DG-041225-003', '2025-12-04 13:49:00', 3, 5576.00, 5626.00, 50.00, 50.00, 'VEHICULO', 17, 2, NULL, NULL, 2, 1, 'PROCESADO', 224),
(261, 'DG-041225-004', '2025-12-04 11:11:00', 3, 5626.00, 5696.00, 70.00, 70.00, 'VEHICULO', 11, 8, NULL, NULL, 2, 1, 'PROCESADO', 224),
(262, 'DG-051225-001', '2025-12-05 15:34:00', 3, 5696.00, 5766.00, 70.00, 70.00, 'VEHICULO', 7, 8, NULL, NULL, 2, 1, 'PROCESADO', 229),
(263, 'DG-051225-002', '2025-12-05 07:03:00', 3, 5766.00, 5846.00, 80.00, 80.00, 'VEHICULO', 3, 5, NULL, NULL, 2, 1, 'PROCESADO', 229),
(264, 'DG-051225-003', '2025-12-05 09:42:00', 3, 5846.00, 5926.00, 80.00, 80.00, 'VEHICULO', 8, 4, NULL, NULL, 2, 1, 'PROCESADO', 229),
(265, 'DG-051225-004', '2025-12-05 13:50:00', 3, 5926.00, 6076.00, 150.00, 150.00, 'VEHICULO', 16, 2, NULL, NULL, 2, 1, 'PROCESADO', 229),
(266, 'DG-051225-005', '2025-12-05 17:08:00', 3, 6076.00, 6276.00, 200.00, 200.00, 'VEHICULO', 22, 4, NULL, NULL, 2, 1, 'PROCESADO', 229),
(267, 'DG-051225-006', '2025-12-05 09:48:00', 3, 6276.00, 6356.00, 80.00, 80.00, 'VEHICULO', 13, 4, NULL, NULL, 2, 1, 'PROCESADO', 229),
(268, 'DG-051225-007', '2025-12-05 10:14:00', 3, 6356.00, 6436.00, 80.00, 80.00, 'VEHICULO', 22, 5, NULL, NULL, 2, 1, 'PROCESADO', 229),
(269, 'DG-051225-008', '2025-12-05 14:33:00', 3, 6436.00, 6516.00, 80.00, 80.00, 'VEHICULO', 15, 6, NULL, NULL, 2, 1, 'PROCESADO', 229),
(270, 'DG-051225-009', '2025-12-05 16:10:00', 3, 6516.00, 6596.00, 80.00, 80.00, 'VEHICULO', 5, 8, NULL, NULL, 2, 1, 'PROCESADO', 229),
(271, 'DG-051225-010', '2025-12-05 11:04:00', 3, 6596.00, 6676.00, 80.00, 80.00, 'VEHICULO', 13, 1, NULL, NULL, 2, 1, 'PROCESADO', 229),
(272, 'DG-051225-011', '2025-12-05 11:12:00', 3, 6676.00, 6756.00, 80.00, 80.00, 'VEHICULO', 23, 6, NULL, NULL, 2, 1, 'PROCESADO', 229),
(273, 'DG-051225-012', '2025-12-05 11:02:00', 3, 6756.00, 6836.00, 80.00, 80.00, 'VEHICULO', 17, 2, NULL, NULL, 2, 1, 'PROCESADO', 229),
(274, 'DG-051225-013', '2025-12-05 11:20:00', 3, 6836.00, 7036.00, 200.00, 200.00, 'VEHICULO', 4, 7, NULL, NULL, 2, 1, 'PROCESADO', 229),
(275, 'DG-051225-014', '2025-12-05 07:26:00', 3, 7036.00, 7076.00, 40.00, 40.00, 'VEHICULO', 3, 3, NULL, NULL, 2, 1, 'PROCESADO', 229),
(276, 'DG-051225-015', '2025-12-05 17:47:00', 3, 7076.00, 9076.00, 2000.00, 2000.00, 'VEHICULO', 1, 8, NULL, NULL, 2, 1, 'PROCESADO', 229),
(277, 'DG-051225-016', '2025-12-05 10:19:00', 3, 9076.00, 9156.00, 80.00, 80.00, 'VEHICULO', 24, 6, NULL, NULL, 2, 1, 'PROCESADO', 229),
(278, 'DG-051225-017', '2025-12-05 13:42:00', 3, 9156.00, 9356.00, 200.00, 200.00, 'VEHICULO', 13, 5, NULL, NULL, 2, 1, 'PROCESADO', 229),
(279, 'DG-051225-018', '2025-12-05 15:07:00', 3, 9356.00, 9436.00, 80.00, 80.00, 'VEHICULO', 18, 1, NULL, NULL, 2, 1, 'PROCESADO', 229),
(280, 'GS-051225-001', '2025-12-05 10:26:00', 4, 1140.00, 1190.00, 50.00, 50.00, 'VEHICULO', 8, 1, NULL, NULL, 2, 1, 'PROCESADO', 230),
(281, 'GS-051225-002', '2025-12-05 09:33:00', 4, 1190.00, 1200.00, 10.00, 10.00, 'VEHICULO', 16, 4, NULL, NULL, 2, 1, 'PROCESADO', 230),
(282, 'GS-051225-003', '2025-12-05 13:51:00', 4, 1200.00, 1208.00, 8.00, 8.00, 'VEHICULO', 18, 8, NULL, NULL, 2, 1, 'PROCESADO', 230),
(283, 'GS-051225-004', '2025-12-05 11:39:00', 4, 1208.00, 1216.00, 8.00, 8.00, 'VEHICULO', 20, 8, NULL, NULL, 2, 1, 'PROCESADO', 230),
(284, 'GS-051225-005', '2025-12-05 09:40:00', 4, 1216.00, 1226.00, 10.00, 10.00, 'VEHICULO', 20, 7, NULL, NULL, 2, 1, 'PROCESADO', 230),
(285, 'GS-051225-006', '2025-12-05 10:11:00', 4, 1226.00, 1246.00, 20.00, 20.00, 'VEHICULO', 9, 4, NULL, NULL, 2, 1, 'PROCESADO', 230),
(286, 'GS-051225-007', '2025-12-05 16:11:00', 4, 1246.00, 1306.00, 60.00, 60.00, 'VEHICULO', 8, 5, NULL, NULL, 2, 1, 'PROCESADO', 230),
(287, 'GS-051225-008', '2025-12-05 12:34:00', 4, 1306.00, 1326.00, 20.00, 20.00, 'VEHICULO', 19, 1, NULL, NULL, 2, 1, 'PROCESADO', 230),
(288, 'GS-051225-009', '2025-12-05 07:36:00', 4, 1326.00, 1366.00, 40.00, 40.00, 'VEHICULO', 19, 4, NULL, NULL, 2, 1, 'PROCESADO', 230),
(289, 'DG-051225-019', '2025-12-05 14:23:00', 3, 9436.00, 9506.00, 70.00, 70.00, 'VEHICULO', 3, 2, NULL, NULL, 2, 1, 'PROCESADO', 234),
(290, 'DG-051225-020', '2025-12-05 13:58:00', 3, 9506.00, 9698.00, 192.00, 192.00, 'VEHICULO', 19, 5, NULL, NULL, 2, 1, 'PROCESADO', 234),
(291, 'GS-051225-010', '2025-12-05 09:08:00', 4, 1366.00, 1414.00, 48.00, 48.00, 'VEHICULO', 26, 5, NULL, NULL, 2, 1, 'PROCESADO', 235),
(292, 'GS-051225-011', '2025-12-05 09:16:00', 4, 1414.00, 1454.00, 40.00, 40.00, 'VEHICULO', 4, 8, NULL, NULL, 2, 1, 'PROCESADO', 235),
(293, 'GS-051225-012', '2025-12-05 13:42:00', 4, 1454.00, 1490.00, 36.00, 36.00, 'VEHICULO', 12, 7, NULL, NULL, 2, 1, 'PROCESADO', 235),
(294, 'GS-051225-013', '2025-12-05 07:07:00', 4, 1490.00, 1543.00, 53.00, 53.00, 'VEHICULO', 19, 1, NULL, NULL, 2, 1, 'PROCESADO', 235),
(295, 'DG-061225-001', '2025-12-06 07:55:00', 3, 9698.00, 9768.00, 70.00, 70.00, 'VEHICULO', 12, 3, NULL, NULL, 2, 1, 'PROCESADO', 239),
(296, 'DG-061225-002', '2025-12-06 08:54:00', 3, 9768.00, 9868.00, 100.00, 100.00, 'VEHICULO', 3, 2, NULL, NULL, 2, 1, 'PROCESADO', 239),
(297, 'DG-061225-003', '2025-12-06 09:25:00', 3, 9868.00, 9908.00, 40.00, 40.00, 'VEHICULO', 25, 2, NULL, NULL, 2, 1, 'PROCESADO', 239),
(298, 'DG-061225-004', '2025-12-06 07:19:00', 3, 9908.00, 9988.00, 80.00, 80.00, 'VEHICULO', 22, 7, NULL, NULL, 2, 1, 'PROCESADO', 239),
(299, 'DG-061225-005', '2025-12-06 13:22:00', 3, 9988.00, 10138.00, 150.00, 150.00, 'VEHICULO', 22, 4, NULL, NULL, 2, 1, 'PROCESADO', 239),
(300, 'DG-061225-006', '2025-12-06 08:08:00', 3, 10138.00, 10198.00, 60.00, 60.00, 'VEHICULO', 26, 5, NULL, NULL, 2, 1, 'PROCESADO', 239),
(301, 'DG-061225-007', '2025-12-06 09:14:00', 3, 10198.00, 10386.00, 188.00, 188.00, 'VEHICULO', 5, 4, NULL, NULL, 2, 1, 'PROCESADO', 239),
(302, 'DG-061225-008', '2025-12-06 15:07:00', 3, 10386.00, 10536.00, 150.00, 150.00, 'VEHICULO', 11, 5, NULL, NULL, 2, 1, 'PROCESADO', 239),
(303, 'GS-061225-001', '2025-12-06 09:30:00', 4, 1543.00, 1583.00, 40.00, 40.00, 'VEHICULO', 3, 8, NULL, NULL, 2, 1, 'PROCESADO', 240),
(304, 'GS-061225-002', '2025-12-06 08:51:00', 4, 1583.00, 1588.00, 5.00, 5.00, 'VEHICULO', 16, 6, NULL, NULL, 2, 1, 'PROCESADO', 240),
(305, 'GS-061225-003', '2025-12-06 12:39:00', 4, 1588.00, 1648.00, 60.00, 60.00, 'VEHICULO', 14, 8, NULL, NULL, 2, 1, 'PROCESADO', 240),
(306, 'GS-061225-004', '2025-12-06 10:24:00', 4, 1648.00, 1668.00, 20.00, 20.00, 'VEHICULO', 21, 7, NULL, NULL, 2, 1, 'PROCESADO', 240),
(307, 'GS-061225-005', '2025-12-06 14:30:00', 4, 1668.00, 1755.00, 87.00, 87.00, 'VEHICULO', 14, 1, NULL, NULL, 2, 1, 'PROCESADO', 240),
(308, 'GS-061225-006', '2025-12-06 16:32:00', 4, 1755.00, 1775.00, 20.00, 20.00, 'VEHICULO', 23, 7, NULL, NULL, 2, 1, 'PROCESADO', 240),
(309, 'GS-061225-007', '2025-12-06 16:46:00', 4, 1775.00, 1805.00, 30.00, 30.00, 'VEHICULO', 20, 4, NULL, NULL, 2, 1, 'PROCESADO', 240),
(310, 'GS-061225-008', '2025-12-06 17:55:00', 4, 1805.00, 1810.00, 5.00, 5.00, 'VEHICULO', 6, 4, NULL, NULL, 2, 1, 'PROCESADO', 240),
(311, 'GS-061225-009', '2025-12-06 10:31:00', 4, 1810.00, 1870.00, 60.00, 60.00, 'VEHICULO', 23, 2, NULL, NULL, 2, 1, 'PROCESADO', 240),
(312, 'GS-061225-010', '2025-12-06 09:11:00', 4, 1870.00, 1878.00, 8.00, 8.00, 'VEHICULO', 4, 5, NULL, NULL, 2, 1, 'PROCESADO', 240),
(313, 'GS-061225-011', '2025-12-06 11:22:00', 4, 1878.00, 1943.00, 65.00, 65.00, 'VEHICULO', 15, 5, NULL, NULL, 2, 1, 'PROCESADO', 240),
(314, 'GS-061225-012', '2025-12-06 11:58:00', 4, 1943.00, 1948.00, 5.00, 5.00, 'VEHICULO', 15, 5, NULL, NULL, 2, 1, 'PROCESADO', 240),
(315, 'DG-061225-009', '2025-12-06 11:49:00', 3, 10536.00, 10616.00, 80.00, 80.00, 'VEHICULO', 12, 5, NULL, NULL, 2, 1, 'PROCESADO', 244),
(316, 'DG-061225-010', '2025-12-06 11:20:00', 3, 10616.00, 10686.00, 70.00, 70.00, 'VEHICULO', 11, 3, NULL, NULL, 2, 1, 'PROCESADO', 244),
(317, 'DG-061225-011', '2025-12-06 10:38:00', 3, 10686.00, 10786.00, 100.00, 100.00, 'VEHICULO', 13, 7, NULL, NULL, 2, 1, 'PROCESADO', 244),
(318, 'DG-061225-012', '2025-12-06 12:07:00', 3, 10786.00, 10886.00, 100.00, 100.00, 'VEHICULO', 25, 5, NULL, NULL, 2, 1, 'PROCESADO', 244),
(319, 'DG-061225-013', '2025-12-06 08:25:00', 3, 10886.00, 10954.00, 68.00, 68.00, 'VEHICULO', 24, 1, NULL, NULL, 2, 1, 'PROCESADO', 244),
(320, 'GS-061225-013', '2025-12-06 07:45:00', 4, 1948.00, 1994.00, 46.00, 46.00, 'VEHICULO', 11, 3, NULL, NULL, 2, 1, 'PROCESADO', 245),
(321, 'GS-061225-014', '2025-12-06 08:48:00', 4, 1994.00, 2004.00, 10.00, 10.00, 'VEHICULO', 5, 7, NULL, NULL, 2, 1, 'PROCESADO', 245),
(324, '02153', '2025-12-07 07:08:00', 3, 10998.00, 11098.00, 100.00, 100.00, 'VEHICULO', 6, 9, NULL, 'Autorizado por Mauriny villegas ', 4, 1, 'PROCESADO', 249),
(325, '02150', '2025-12-07 07:05:00', 3, 11098.00, 11168.00, 70.00, 70.00, 'VEHICULO', 17, 10, NULL, NULL, 1, 1, 'PROCESADO', 249),
(326, '02152', '2025-12-07 08:05:00', 3, 11168.00, 11268.00, 100.00, 100.00, 'VEHICULO', 8, 11, NULL, NULL, 1, 1, 'PROCESADO', 249),
(327, '01518', '2025-12-07 08:30:00', 3, 11268.00, 11348.00, 80.00, 80.00, 'VEHICULO', 26, 12, NULL, NULL, 1, 1, 'PROCESADO', 249),
(328, '01515', '2025-12-07 08:23:00', 3, 11348.00, 11428.00, 80.00, 80.00, 'VEHICULO', 27, 13, NULL, NULL, 1, 1, 'PROCESADO', 249),
(329, '01516', '2025-12-07 08:23:00', 3, 11428.00, 11508.00, 80.00, 80.00, 'VEHICULO', 28, 14, NULL, NULL, 1, 1, 'PROCESADO', 249),
(330, '01514', '2025-12-07 08:30:00', 3, 11508.00, 11588.00, 80.00, 80.00, 'VEHICULO', 21, 15, NULL, NULL, 4, 1, 'PROCESADO', 249),
(331, '01517', '2025-12-07 08:33:00', 3, 11588.00, 11668.00, 80.00, 80.00, 'VEHICULO', 22, 16, NULL, NULL, 4, 1, 'PROCESADO', 249),
(332, '01519', '2025-12-07 08:35:00', 3, 11668.00, 11748.00, 80.00, 78.00, 'VEHICULO', 24, 17, NULL, NULL, 4, 1, 'PROCESADO', 249),
(333, '01523', '2025-12-07 08:39:00', 3, 11748.00, 11828.00, 80.00, 80.00, 'VEHICULO', 20, 18, NULL, NULL, 4, 1, 'PROCESADO', 249),
(335, '01513', '2025-12-07 08:51:00', 3, 12128.00, 12428.00, 300.00, 300.00, 'BIDON', NULL, NULL, 4, NULL, 4, 1, 'PROCESADO', 249),
(336, '01512', '2025-12-07 13:13:00', 3, 12428.00, 12628.00, 200.00, 200.00, 'VEHICULO', 13, 19, NULL, NULL, 4, 1, 'PROCESADO', 249),
(337, '01520', '2025-12-07 08:33:00', 3, 12628.00, 12708.00, 80.00, 80.00, 'VEHICULO', 30, 16, NULL, NULL, 4, 1, 'PROCESADO', 249),
(338, '01524', '2025-12-07 10:38:00', 3, 12708.00, 12808.00, 100.00, 100.00, 'BIDON', NULL, NULL, 4, 'Autorizador Miguel Olivero, Trabajador Diego Gallo 29.895.427', 4, 1, 'PROCESADO', 249),
(339, '01521', '2025-12-07 10:33:00', 3, 12808.00, 12888.00, 80.00, 80.00, 'VEHICULO', 31, 20, NULL, 'Autorizado Miguel Olivero', 4, 1, 'PROCESADO', 249),
(340, '01525', '2025-12-07 10:47:00', 3, 12888.00, 12998.00, 200.00, 110.00, 'VEHICULO', 32, 21, NULL, 'Aut. Miguel Olivero ', 4, 1, 'PROCESADO', 249),
(341, '01526', '2025-12-07 10:52:00', 3, 12998.00, 13126.00, 150.00, 128.00, 'VEHICULO', 33, 18, NULL, 'Aut. Miguel Oliveros ', 4, 1, 'PROCESADO', 249),
(342, '01527', '2025-12-07 10:57:00', 3, 13126.00, 13206.00, 80.00, 80.00, 'VEHICULO', 34, 23, NULL, 'Aut. Miguel Oliveros ', 4, 1, 'PROCESADO', 249),
(343, '00002', '2025-12-07 10:57:00', 3, 13206.00, 13276.00, 70.00, 70.00, 'BIDON', NULL, NULL, 8, 'Aut. Cesar Jaime', 4, 1, 'PROCESADO', 249),
(344, '01522', '2025-12-07 10:58:00', 3, 13276.00, 13476.00, 200.00, 200.00, 'VEHICULO', 13, 4, NULL, NULL, 3, 1, 'PROCESADO', 249),
(345, '00795', '2025-12-07 14:28:00', 3, 13476.00, 15076.00, 1600.00, 1600.00, 'VEHICULO', 25, 22, NULL, NULL, 4, 1, 'PROCESADO', 249),
(346, '01530', '2025-12-07 14:38:00', 3, 15076.00, 15156.00, 80.00, 80.00, 'VEHICULO', 35, 19, NULL, NULL, 4, 1, 'PROCESADO', 249),
(347, '01532', '2025-12-07 14:39:00', 3, 15156.00, 15236.00, 80.00, 80.00, 'VEHICULO', 36, 25, NULL, NULL, 5, 1, 'PROCESADO', 249),
(348, '00263', '2025-12-07 08:50:00', 4, 2004.00, 2024.00, 20.00, 20.00, 'BIDON', NULL, NULL, 7, 'Aut. Pedro González ', 4, 1, 'PROCESADO', 250),
(349, '02906', '2025-12-07 12:04:00', 4, 2024.00, 2031.00, 7.00, 7.00, 'VEHICULO', 37, 1, NULL, NULL, 4, 1, 'PROCESADO', 250),
(350, '00143', '2025-12-07 12:10:00', 4, 2031.00, 2051.00, 20.00, 20.00, 'BIDON', NULL, NULL, 9, NULL, 5, 1, 'PROCESADO', 250),
(351, '00014', '2025-12-07 12:09:00', 4, 2051.00, 2059.00, 10.00, 8.00, 'VEHICULO', 40, 20, NULL, NULL, 4, 1, 'PROCESADO', 250),
(352, '01528', '2025-12-07 12:13:00', 4, 2059.00, 2069.00, 10.00, 10.00, 'VEHICULO', 41, 19, NULL, NULL, 5, 1, 'PROCESADO', 250),
(353, '01531', '2025-12-07 12:12:00', 4, 2069.00, 2089.00, 20.00, 20.00, 'BIDON', NULL, NULL, 4, NULL, 4, 1, 'PROCESADO', 250),
(354, '00147', '2025-12-07 12:13:00', 4, 2089.00, 2099.00, 10.00, 10.00, 'VEHICULO', 38, 19, NULL, NULL, 4, 1, 'PROCESADO', 250),
(355, '00146', '2025-12-07 12:15:00', 4, 2099.00, 2109.00, 10.00, 10.00, 'VEHICULO', 42, 19, NULL, NULL, 4, 1, 'PROCESADO', 250),
(356, '00145', '2025-12-07 12:15:00', 4, 2109.00, 2119.00, 10.00, 10.00, 'VEHICULO', 43, 4, NULL, NULL, 4, 1, 'PROCESADO', 250),
(357, '01533', '2025-12-07 12:26:00', 4, 2119.00, 2127.00, 10.00, 8.00, 'VEHICULO', 41, 19, NULL, NULL, 4, 1, 'PROCESADO', 250),
(358, '01535', '2025-12-07 07:19:00', 3, 15236.00, 15316.00, 80.00, 80.00, 'VEHICULO', 4, 4, NULL, NULL, 5, 1, 'PROCESADO', 255),
(359, '02156', '2025-12-07 19:20:00', 3, 15316.00, 15386.00, 70.00, 70.00, 'VEHICULO', 28, 19, NULL, NULL, 4, 1, 'PROCESADO', 255),
(360, '02158', '2025-12-07 19:31:00', 3, 15386.00, 15456.00, 70.00, 70.00, 'VEHICULO', 36, 19, NULL, NULL, 4, 1, 'PROCESADO', 255),
(361, '01534', '2025-12-08 19:15:00', 4, 2127.00, 2187.00, 60.00, 60.00, 'VEHICULO', 44, 26, NULL, NULL, 4, 1, 'PROCESADO', 256),
(362, '01529', '2025-12-08 18:09:00', 4, 2187.00, 2242.00, 60.00, 55.00, 'VEHICULO', 45, 26, NULL, NULL, 4, 1, 'PROCESADO', 256),
(363, '02160', '2025-12-08 07:50:00', 3, 15456.00, 15526.00, 70.00, 70.00, 'VEHICULO', 17, 5, NULL, NULL, 3, 1, 'PROCESADO', 261),
(364, '01537', '2025-12-08 13:22:00', 3, 15526.00, 15726.00, 200.00, 200.00, 'VEHICULO', 13, 4, NULL, NULL, 5, 1, 'PROCESADO', 261),
(365, '01543', '2025-12-08 15:20:00', 3, 15726.00, 16026.00, 300.00, 300.00, 'VEHICULO', 46, 8, NULL, NULL, 5, 1, 'PROCESADO', 261),
(366, '01551', '2025-12-08 17:30:00', 3, 16026.00, 16140.00, 200.00, 114.00, 'VEHICULO', 32, 22, NULL, NULL, 5, 1, 'PROCESADO', 261),
(367, '01550', '2025-12-08 16:38:00', 3, 16140.00, 16220.00, 80.00, 80.00, 'VEHICULO', 28, 14, NULL, NULL, 5, 1, 'PROCESADO', 261),
(368, '01009', '2025-12-08 17:28:00', 3, 16220.00, 16290.00, 70.00, 70.00, 'VEHICULO', 47, 1, NULL, NULL, 5, 1, 'PROCESADO', 261),
(369, '02908', '2025-12-08 08:30:00', 4, 2242.00, 2284.00, 45.00, 42.00, 'VEHICULO', 49, 27, NULL, NULL, 5, 1, 'PROCESADO', 262),
(370, '01008', '2025-12-08 16:49:00', 4, 2284.00, 2340.00, 70.00, 56.00, 'VEHICULO', 54, 17, NULL, NULL, 5, 1, 'PROCESADO', 262),
(371, '00796', '2025-12-08 08:11:00', 4, 2340.00, 2398.00, 60.00, 58.00, 'VEHICULO', 50, 28, NULL, NULL, 4, 1, 'PROCESADO', 262),
(372, '00797', '2025-12-08 11:51:00', 4, 2398.00, 2478.00, 80.00, 80.00, 'VEHICULO', 51, 15, NULL, NULL, 4, 1, 'PROCESADO', 262),
(373, '03287', '2025-12-08 14:53:00', 4, 2478.00, 2538.00, 60.00, 60.00, 'VEHICULO', 52, 30, NULL, NULL, 4, 1, 'PROCESADO', 262),
(374, '01546', '2025-12-08 15:55:00', 4, 2538.00, 2558.00, 20.00, 20.00, 'BIDON', NULL, NULL, 4, NULL, 5, 1, 'PROCESADO', 262),
(375, '00047', '2025-12-09 16:56:00', 4, 2558.00, 2603.00, 45.00, 45.00, 'VEHICULO', 53, 31, NULL, NULL, 5, 1, 'PROCESADO', 262),
(376, '01552', '2025-12-08 18:55:00', 4, 2603.00, 2623.00, 20.00, 20.00, 'BIDON', NULL, NULL, 4, NULL, 5, 1, 'PROCESADO', 262),
(377, '00063', '2025-12-08 15:31:00', 4, 2623.00, 2823.00, 200.00, 200.00, 'BIDON', NULL, NULL, 14, NULL, 5, 1, 'PROCESADO', 262),
(378, '00021', '2025-12-08 15:13:00', 4, 2823.00, 3023.00, 200.00, 200.00, 'BIDON', NULL, NULL, 15, NULL, 5, 1, 'PROCESADO', 262),
(379, '01544', '2025-12-08 16:12:00', 4, 3023.00, 3043.00, 20.00, 20.00, 'BIDON', NULL, NULL, 4, NULL, 5, 1, 'PROCESADO', 262),
(380, '02910', '2025-12-08 16:06:00', 4, 3043.00, 3088.00, 45.00, 45.00, 'BIDON', NULL, NULL, 2, NULL, 4, 1, 'PROCESADO', 262),
(381, '02907', '2025-12-08 17:03:00', 4, 3088.00, 3123.00, 35.00, 35.00, 'VEHICULO', 48, 27, NULL, NULL, 5, 1, 'PROCESADO', 262),
(382, '02909', '2025-12-08 16:07:00', 4, 3123.00, 3168.00, 45.00, 45.00, 'VEHICULO', 55, 27, NULL, NULL, 5, 1, 'PROCESADO', 262),
(383, '10063', '2025-12-08 16:45:00', 4, 3168.00, 3368.00, 200.00, 200.00, 'BIDON', NULL, NULL, 13, NULL, 5, 1, 'PROCESADO', 262),
(384, 'TEST-766184', '2025-12-08 22:23:00', 4, 3368.00, 3374.00, 6.00, 6.00, 'VEHICULO', 56, 14, NULL, 'Prueba de inserción automática', 1, 1, 'PROCESADO', NULL),
(397, 'TEST-607167', '2025-12-08 19:10:00', 4, 3974.00, 4174.00, 200.00, 200.00, 'BIDON', NULL, NULL, 16, 'Prueba de inserción automática', 5, 1, 'PROCESADO', NULL),
(398, 'TEST-170317', '2025-12-08 17:40:00', 4, 4174.00, 4207.00, 33.00, 33.00, 'VEHICULO', 54, 26, NULL, 'Prueba de inserción automática', 2, 1, 'PROCESADO', NULL),
(399, 'TEST-898315', '2025-12-08 20:00:00', 4, 4207.00, 4257.00, 50.00, 50.00, 'VEHICULO', 54, 30, NULL, 'Prueba de inserción automática', 2, 1, 'PROCESADO', NULL),
(400, '02163', '2025-12-08 19:00:00', 3, 16290.00, 16360.00, 70.00, 70.00, 'VEHICULO', 6, 13, NULL, NULL, 4, 1, 'PROCESADO', NULL),
(401, '01553', '2025-12-08 19:10:00', 3, 16360.00, 16436.00, 80.00, 76.00, 'VEHICULO', 4, 27, NULL, NULL, 4, 1, 'PROCESADO', NULL),
(402, '01101', '2025-12-08 19:14:00', 3, 16436.00, 16446.00, 10.00, 10.00, 'VEHICULO', 47, 19, NULL, NULL, 4, 1, 'PROCESADO', NULL),
(403, '01549', '2025-12-08 19:41:00', 3, 16446.00, 16526.00, 80.00, 80.00, 'VEHICULO', 21, 19, NULL, NULL, 5, 1, 'PROCESADO', NULL);

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
(3, 'SURTIDOR GASOIL 01', 16526.00, 1, 'ACTIVO', 1, '2025-11-23 13:24:37', '2025-12-07 07:37:01'),
(4, 'SURTIDOR GASOLINA 01', 4257.00, 2, 'ACTIVO', 1, '2025-11-25 17:13:26', '2025-12-07 07:37:02');

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
(16, 'BETA PUNTO DORADO', '12345678', 'JOSE ', 'BORDONES', '0000000000', '', 'ACTIVO', '2025-12-11 15:11:17', '2025-12-11 15:11:17', 1);

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
(38, 'DONGFENG', 'ACTIVO', '2025-12-09 16:19:27', '2025-12-09 16:19:27', 1);

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
(99, 6, 1, '2025-12-09 11:48:00', 4067.00, 0.00, 0.00, 0.02, 204.54, 'Medición Automática por Recepción de Cisterna (Guía: 123131). Faltantes de transporte: 204.54 L. ', 'PROCESADO', '2025-12-09 11:53:49', 253, 0.02, 'MANUAL'),
(100, 1, 1, '2025-12-09 11:59:00', 14799.00, 14.00, 0.00, 4701.00, 10098.00, '', 'PROCESADO', '2025-12-09 11:59:31', 249, NULL, 'AFORO'),
(101, 1, 1, '2025-12-09 12:30:00', 8481.00, 7.00, 0.00, 1691.00, 6790.00, '', 'PROCESADO', '2025-12-09 12:31:37', 255, NULL, 'AFORO'),
(102, 2, 1, '2025-12-09 14:26:00', 3829.00, 0.56, 0.00, 3819.81, 9.19, '', 'PROCESADO', '2025-12-09 14:37:35', 256, NULL, 'AFORO'),
(103, 1, 1, '2025-12-11 10:49:00', 4839.00, 50.00, 0.00, 28627.00, 1212.00, 'Medición Automática por Recepción de Cisterna (Guía: 2423423). Consumo de planta: 1212.00 L. Nivel final: 28627.00 L. ', 'PROCESADO', '2025-12-11 10:50:14', 261, NULL, 'AFORO'),
(104, 1, 1, '2025-12-11 10:50:00', 28627.00, 46.00, 0.00, 25584.00, 3043.00, '', 'PROCESADO', '2025-12-11 10:50:42', 261, NULL, 'AFORO'),
(105, 2, 1, '2025-12-11 10:50:00', 2703.00, 0.44, 0.00, 2693.20, 9.80, '', 'PROCESADO', '2025-12-11 10:54:48', 262, NULL, 'AFORO');

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
(50, 'BURBUJA', 1, 'ACTIVO', '2025-12-09 16:42:18', '2025-12-09 16:42:18', 1);

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
  `longitud` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tanques`
--

INSERT INTO `tanques` (`id_tanque`, `codigo`, `nombre`, `tabla_aforo`, `unidad_medida`, `ubicacion`, `tipo_combustible`, `capacidad_maxima`, `nivel_actual`, `nivel_alarma`, `estado`, `tipo_jerarquia`, `fecha_registro`, `fecha_modificacion`, `registrado_por`, `radio`, `largo`, `longitud`) VALUES
(1, 'TQ01', 'TANQUE PRINCIPAL', '{\"1\":93,\"2\":261,\"3\":479,\"4\":736,\"5\":1026,\"6\":1346,\"7\":1691,\"8\":2061,\"9\":2454,\"10\":2867,\"11\":3299,\"12\":3750,\"13\":4217,\"14\":4701,\"15\":5200,\"16\":5714,\"17\":6242,\"18\":6783,\"19\":7337,\"20\":7903,\"21\":8480,\"22\":9006,\"23\":9668,\"24\":10278,\"25\":10897,\"26\":11526,\"27\":12164,\"28\":12810,\"29\":13465,\"30\":14128,\"31\":14799,\"32\":15476,\"33\":16161,\"34\":16853,\"35\":17551,\"36\":18256,\"37\":18966,\"38\":19682,\"39\":20403,\"40\":21130,\"41\":21861,\"42\":22597,\"43\":23338,\"44\":24083,\"45\":24831,\"46\":25584,\"47\":26340,\"48\":27099,\"49\":27861,\"50\":28627,\"51\":29395,\"52\":30165,\"53\":30938,\"54\":31712,\"55\":32486,\"56\":33267,\"57\":34047,\"58\":34825,\"59\":35610,\"60\":36393,\"61\":37176,\"62\":37950,\"63\":38745,\"64\":39529,\"65\":40313,\"66\":41097,\"67\":41880,\"68\":42662,\"69\":43445,\"70\":44226,\"71\":45005,\"72\":45783,\"73\":46559,\"74\":47333,\"75\":48106,\"76\":48875,\"77\":49643,\"78\":50407,\"79\":51169,\"80\":51928,\"81\":52683,\"82\":53435,\"83\":54182,\"84\":54926,\"85\":55666,\"86\":56401,\"87\":57131,\"88\":57856,\"89\":58577,\"90\":59291,\"91\":60000,\"92\":60703,\"93\":61400,\"94\":62090,\"95\":62773,\"96\":63450,\"97\":64118,\"98\":64779,\"99\":65432,\"100\":66077,\"101\":66713,\"102\":67340,\"103\":67957,\"104\":68564,\"105\":69161,\"106\":69747,\"107\":70322,\"108\":70889,\"109\":71443,\"110\":71984,\"111\":72512,\"112\":73026,\"113\":73525,\"114\":74009,\"115\":74476,\"116\":74927,\"117\":75369,\"118\":75782,\"119\":76175,\"120\":76545,\"121\":76890,\"122\":77210,\"123\":77490,\"124\":77747,\"125\":77965,\"126\":78133,\"127\":78226}', 'PULGADAS', 'PATIO PRINCIPAL', 'GASOIL', 78226.00, 25348.00, 500.00, 'ACTIVO', 'PRINCIPAL', '2025-11-23 11:46:58', '2025-12-11 10:50:42', 1, NULL, NULL, NULL),
(2, 'TQG02', 'TANQUE Nª 02', NULL, 'CM', 'PATIO PRINCIPAL', 'GASOLINA', 20000.00, 2414.00, 1001.00, 'ACTIVO', 'AUXILIAR', '2025-11-25 17:10:37', '2025-12-11 10:54:48', 1, 1.15, 4.90, NULL),
(3, 'T03', 'TANQUE Nª 03', NULL, 'PULGADAS', 'PLANTA ARRIBA', 'GASOIL', 10000.00, 523.00, 500.00, 'ACTIVO', 'AUXILIAR', '2025-11-27 13:18:38', '2025-12-05 13:25:47', 1, NULL, NULL, NULL),
(4, 'TQ04', 'TANQUE Nª 04', NULL, 'PULGADAS', 'ZONA ARRIBA TANQUE', 'GASOIL', 10000.00, 4192.00, 1000.00, 'ACTIVO', 'AUXILIAR', '2025-11-27 13:19:39', '2025-12-05 13:26:19', 1, NULL, NULL, NULL),
(6, 'TQG01', 'TANQUE Nª 01', NULL, 'CM', 'PATIO PRINCIPAL', 'GASOLINA', 36000.00, 24692.48, 1000.00, 'ACTIVO', 'AUXILIAR', '2025-12-05 12:01:11', '2025-12-09 11:53:49', 1, 1.19, 8.15, 2.00),
(7, 'TQG03', 'TANQUE Nª 03', NULL, 'CM', 'PATIO PRINCIPAL', 'GASOLINA', 15000.00, 0.00, 1000.00, 'ACTIVO', 'AUXILIAR', '2025-12-08 10:53:08', '2025-12-08 10:53:08', 1, 0.98, 4.96, NULL);

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
(1, 'ADMIN', 'María', 'González', '12345678', '$2a$10$JDEm4cUMTzU3W.LkaIvKpOeEd4RqGnllntsF1lvhWYuAEu.tsfAzK', 'ACTIVO', '2025-11-19 10:15:00', '2025-12-11 15:35:05', '2025-11-24 15:02:52', 1),
(2, 'ADMIN', 'Pedro', 'Peres', 'V123456', '$2a$10$W0nLuD4p0xPzfJPO.p.X.ONyxsQE/O4Dr4An69//wEdde/e8Rk0Wy', 'ACTIVO', '2025-11-19 10:15:00', '2025-11-19 14:20:00', '2025-11-23 11:39:23', 1),
(3, 'INSPECTOR', 'LEONARDO', 'ESPINA', '18073921', '$2a$10$8oDojCQJ3xmKW7916129MeCad3kJgeFuCxTYTqI2/bdiCXQY./Zgy', 'ACTIVO', '2025-12-04 08:39:53', '2025-12-04 10:31:41', '2025-12-04 08:39:53', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vehiculos`
--

CREATE TABLE `vehiculos` (
  `id_vehiculo` int(11) NOT NULL,
  `placa` varchar(10) NOT NULL,
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
(2, 'KVA-300', 2000, 'AMARILLO', 3, 1, 22, 3, 'ACTIVO', '2025-11-23 12:57:26', '2025-11-26 16:53:28', 1, 'GASOIL'),
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
(14, 'SMPB0062', 2000, 'AMATRILLO', 3, 0, 23, 11, 'ACTIVO', '2025-11-27 13:24:42', '2025-11-27 13:24:42', 1, 'GASOIL'),
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
(25, 'SPMB0062', 2000, 'AMARILLO', 3, 0, 23, 11, 'ACTIVO', '2025-11-27 13:49:42', '2025-11-27 13:49:42', 1, 'GASOIL'),
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
(43, 'AN4X17N', 2000, 'GRIS', 9, 0, 33, 22, 'ACTIVO', '2025-12-08 16:36:13', '2025-12-08 16:36:13', 1, 'GASOIL'),
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
(57, 'A55AE6R', 2000, 'BLANCA', 10, 0, 1, 49, 'ACTIVO', '2025-12-11 15:07:48', '2025-12-11 15:07:48', 1, 'GASOLINA');

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
  MODIFY `id_almacenista` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `cargas_cisterna`
--
ALTER TABLE `cargas_cisterna`
  MODIFY `id_carga` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT de la tabla `choferes`
--
ALTER TABLE `choferes`
  MODIFY `id_chofer` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de la tabla `cierres_inventario`
--
ALTER TABLE `cierres_inventario`
  MODIFY `id_cierre` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=267;

--
-- AUTO_INCREMENT de la tabla `despachos`
--
ALTER TABLE `despachos`
  MODIFY `id_despacho` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=404;

--
-- AUTO_INCREMENT de la tabla `dispensadores`
--
ALTER TABLE `dispensadores`
  MODIFY `id_dispensador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `gerencias`
--
ALTER TABLE `gerencias`
  MODIFY `id_gerencia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `marcas`
--
ALTER TABLE `marcas`
  MODIFY `id_marca` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT de la tabla `mediciones_tanques`
--
ALTER TABLE `mediciones_tanques`
  MODIFY `id_medicion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT de la tabla `modelos`
--
ALTER TABLE `modelos`
  MODIFY `id_modelo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT de la tabla `tanques`
--
ALTER TABLE `tanques`
  MODIFY `id_tanque` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `vehiculos`
--
ALTER TABLE `vehiculos`
  MODIFY `id_vehiculo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cargas_cisterna`
--
ALTER TABLE `cargas_cisterna`
  ADD CONSTRAINT `cargas_cisterna_ibfk_696` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id_vehiculo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cargas_cisterna_ibfk_697` FOREIGN KEY (`id_tanque`) REFERENCES `tanques` (`id_tanque`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cargas_cisterna_ibfk_698` FOREIGN KEY (`id_almacenista`) REFERENCES `almacenistas` (`id_almacenista`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cargas_cisterna_ibfk_699` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cargas_cisterna_ibfk_700` FOREIGN KEY (`id_cierre`) REFERENCES `cierres_inventario` (`id_cierre`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `cierres_inventario`
--
ALTER TABLE `cierres_inventario`
  ADD CONSTRAINT `cierres_inventario_ibfk_318` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cierres_inventario_ibfk_319` FOREIGN KEY (`id_tanque`) REFERENCES `tanques` (`id_tanque`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `despachos`
--
ALTER TABLE `despachos`
  ADD CONSTRAINT `despachos_ibfk_1000` FOREIGN KEY (`id_chofer`) REFERENCES `choferes` (`id_chofer`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `despachos_ibfk_1001` FOREIGN KEY (`id_gerencia`) REFERENCES `gerencias` (`id_gerencia`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `despachos_ibfk_1002` FOREIGN KEY (`id_almacenista`) REFERENCES `almacenistas` (`id_almacenista`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `despachos_ibfk_1003` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `despachos_ibfk_1004` FOREIGN KEY (`id_cierre`) REFERENCES `cierres_inventario` (`id_cierre`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `despachos_ibfk_998` FOREIGN KEY (`id_dispensador`) REFERENCES `dispensadores` (`id_dispensador`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `despachos_ibfk_999` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id_vehiculo`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `dispensadores`
--
ALTER TABLE `dispensadores`
  ADD CONSTRAINT `dispensadores_ibfk_1` FOREIGN KEY (`id_tanque_asociado`) REFERENCES `tanques` (`id_tanque`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `mediciones_tanques`
--
ALTER TABLE `mediciones_tanques`
  ADD CONSTRAINT `mediciones_tanques_ibfk_415` FOREIGN KEY (`id_tanque`) REFERENCES `tanques` (`id_tanque`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `mediciones_tanques_ibfk_416` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `mediciones_tanques_ibfk_417` FOREIGN KEY (`id_cierre`) REFERENCES `cierres_inventario` (`id_cierre`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `modelos`
--
ALTER TABLE `modelos`
  ADD CONSTRAINT `modelos_ibfk_1` FOREIGN KEY (`id_marca`) REFERENCES `marcas` (`id_marca`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `vehiculos`
--
ALTER TABLE `vehiculos`
  ADD CONSTRAINT `vehiculos_ibfk_475` FOREIGN KEY (`id_gerencia`) REFERENCES `gerencias` (`id_gerencia`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `vehiculos_ibfk_476` FOREIGN KEY (`id_marca`) REFERENCES `marcas` (`id_marca`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `vehiculos_ibfk_477` FOREIGN KEY (`id_modelo`) REFERENCES `modelos` (`id_modelo`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
