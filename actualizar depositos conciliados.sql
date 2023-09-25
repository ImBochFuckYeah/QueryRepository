USE PINULITO_DIVIDENDOS

--UPDATE PINULITO_DIVIDENDOS..tMovimientoBancario SET conciliado = 0 where idMovimientoBancario = 364385
--SELECT * FROM PINULITO_DIVIDENDOS..tMovimientoBancario T1 INNER JOIN PINULITO_PDV..tDeposito T2 ON T1.idBanco = T2.idBanco AND T1.documento = T2.noBoleta AND T2.estado IN ('NO CONCILIADO') AND T1.monto = T2.monto WHERE T1.conciliado = 1 AND T2.Anulado = 0 AND T1.fecha > '2023-02-01'
SELECT * FROM PINULITO_DIVIDENDOS..tMovimientoBancario WHERE documento = '77512'

USE PINULITO_PDV
--SELECT * FROM PINULITO_PDV..facAnuluraSap
SELECT * FROM PINULITO_PDV..tDeposito WHERE noboleta = '77512'
--UPDATE PINULITO_PDV..tDeposito SET idMovimientoBancario = 364385 WHERE idDeposito = 656886