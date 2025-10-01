-- Smoke test to ensure the sales table is not empty after data load.

DECLARE @row_count INT;
SELECT @row_count = COUNT(*) FROM dbo.sales;

IF @row_count > 0
BEGIN
    PRINT 'Row count check passed. Table is not empty.';
END
ELSE
BEGIN
    THROW 50000, 'Row count check failed. Table is empty.', 1;
END
