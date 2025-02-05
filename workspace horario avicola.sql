/* 
    [DATABASE: PINULITO_NOMINA]
    por Josué Boch
    el 18 de noviembre de 2024
*/

CREATE TABLE tHorarioAvicola (
    idHorarioAvicola INT IDENTITY(1,1) PRIMARY KEY, -- Llave primaria con auto-incremento
    diaSemana TINYINT NOT NULL UNIQUE CHECK (diaSemana BETWEEN 1 AND 7), -- Día de la semana con valores permitidos entre 0 y 7
    horario TIME NOT NULL, -- Horario límite
    horarioEspecial TIME NULL, -- Horario especial, permite valores NULL
    ultimaActualizacion DATETIME NOT NULL DEFAULT GETDATE(), -- Fecha y hora de la última actualización, con valor predeterminado
    actualizadoPor INT NOT NULL, -- Código del empleado que actualizó
    CONSTRAINT FK_Empleado FOREIGN KEY (actualizadoPor) REFERENCES tEmpleado(codEmpleado) -- Llave foránea a la tabla tEmpleado
);

-- Insertar horario para lunes a viernes (día 1 al 5)
INSERT INTO tHorarioAvicola (diaSemana, horario, horarioEspecial, actualizadoPor)
VALUES 
(1, '16:00', '17:00', 4403), -- Lunes
(2, '16:00', '17:00', 4403), -- Martes
(3, '16:00', '17:00', 4403), -- Miércoles
(4, '16:00', '17:00', 4403), -- Jueves
(5, '16:00', '17:00', 4403); -- Viernes

-- Insertar horario para sábados y domingos (día 6 y 7)
INSERT INTO tHorarioAvicola (diaSemana, horario, horarioEspecial, actualizadoPor)
VALUES 
(6, '10:00', '11:00', 4403), -- Sábado
(7, '10:00', '11:00', 4403); -- Domingo