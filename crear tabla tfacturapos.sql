SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tFacturaPos](
	[idFactura] [int] IDENTITY(1,1) NOT NULL,
	[empresa] [nvarchar](5) NOT NULL,
	[tienda] [nvarchar](5) NOT NULL,
	[idFacturaPOS] [int] NOT NULL,
	[nit] [nvarchar](32) NOT NULL,
	[nombre] [nvarchar](128) NOT NULL,
	[total] [decimal](10, 2) NOT NULL,
	[fechaHora] [datetime] NOT NULL,
	[canal] [nvarchar](16) NOT NULL,
	[anulada] [bit] NOT NULL,
	[contingencia] [bit] NOT NULL,
	[notaCredito] [bit] NULL,
	[noContingencia] [int] NULL,
	[serie] [nvarchar](20) NULL,
	[numero] [nvarchar](20) NULL,
	[uuidFactura] [nvarchar](64) NULL,
	[fechaCertificacion] [nvarchar](32) NULL,
	[uuidAnulacion] [nvarchar](64) NULL,
	[fechaAnulacion] [nvarchar](32) NULL,
	[uuidNotaCredito] [nvarchar](32) NULL,
	[fechaNotaCredito] [datetime] NULL,
	[dispositivoUpdate] [nvarchar](32) NULL,
	[observaciones] [nvarchar](max) NULL,
	[numSAP] [int] NULL,
	[detallePago] [nvarchar](512) NULL,
	[comentario] [nvarchar](4000) NULL,
	[fechaEmisionFel] [datetime] NULL,
	[sincronizado] [bit] NULL,
	[indendificador] [nvarchar](250) NOT NULL,
UNIQUE NONCLUSTERED 
(
	[indendificador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tFacturaPos] ADD  DEFAULT (NULL) FOR [notaCredito]
GO
