-- Post-deployment scripts for indexing, permissions, etc.
-- For example, creating a non-clustered index for performance.

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'ix_sales_order_date' AND object_id = OBJECT_ID('dbo.sales'))
BEGIN
    CREATE NONCLUSTERED INDEX ix_sales_order_date ON dbo.sales(order_date);
END

PRINT 'Post-deployment scripts executed successfully.';
