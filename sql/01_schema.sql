IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sales]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[sales](
	[order_id] [varchar](50) NOT NULL,
	[order_date] [date] NOT NULL,
	[customer_id] [varchar](50) NOT NULL,
	[amount] [decimal](18, 2) NOT NULL,
	[currency] [varchar](3) NOT NULL,
	[channel] [varchar](50) NOT NULL
) ON [PRIMARY]
END
