USE PINULITO_PDV

SELECT * FROM tSalaReserva
SELECT * FROM tSala

USE PINULITO_NOMINA

SELECT * FROM tSalaReserva

SELECT COUNT(necesitaProyector) proyectorDisponible
FROM tSalaReserva
	WHERE fechaReserva = '2023-04-21' AND necesitaProyector = 1
		AND (('10:00:00' BETWEEN HoraInicio AND HoraFin) 
			OR (HoraFin BETWEEN HoraInicio AND '18:00:00'))

SELECT * FROM tSalaReserva

SELECT COUNT(necesitaProyector) proyectorDisponible
FROM tSalaReserva
WHERE fechaReserva = '2023-04-21' 
  AND necesitaProyector = 1
  AND ((HoraInicio BETWEEN '16:00:00' AND HoraFin) 
           OR (HoraFin BETWEEN HoraInicio AND '18:00:00'))