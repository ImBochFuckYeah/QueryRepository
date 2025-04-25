USE DB_22_DELPUEBLO;
--
SELECT CardCode, CardName, DocTotal, STRING_AGG(DocEntry, ', ') AS documentos
FROM OINV
WHERE CAST(DocDate AS DATE) = '20250309' AND DocStatus = 'O'
GROUP BY CardCode, CardName, DocTotal
HAVING COUNT(*) > 1;