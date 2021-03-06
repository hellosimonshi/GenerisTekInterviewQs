USE [master]
GO
/****** Object:  Database [MillcreekCanyon ]    Script Date: 3/15/2021 7:16:17 PM ******/
CREATE DATABASE [MillcreekCanyon ]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MillcreekCanyon', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\MillcreekCanyon .mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MillcreekCanyon _log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\MillcreekCanyon _log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [MillcreekCanyon ] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MillcreekCanyon ].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MillcreekCanyon ] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET ARITHABORT OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MillcreekCanyon ] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MillcreekCanyon ] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MillcreekCanyon ] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MillcreekCanyon ] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MillcreekCanyon ] SET  MULTI_USER 
GO
ALTER DATABASE [MillcreekCanyon ] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MillcreekCanyon ] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MillcreekCanyon ] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MillcreekCanyon ] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MillcreekCanyon ] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MillcreekCanyon ] SET QUERY_STORE = OFF
GO
USE [MillcreekCanyon ]
GO
/****** Object:  UserDefinedFunction [dbo].[MostPopularDay]    Script Date: 3/15/2021 7:16:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[MostPopularDay]()
RETURNS date
AS
BEGIN
	return(
		Select av.AvailableDate
		FROM AvailableDates as av
		Where av.AvailableId =
		(
			select maxAId.AvailableId
			from
			(
				select top 1 a.AvailableId, Count(r.VistorId) as totalcount
				from AvailableDates as a
				Join Reservations as r
				ON a.AvailableId = r.AvailableId
				Group By a.AvailableId
				order by totalcount desc
			)
			AS maxAId
		)
)
END
GO
/****** Object:  Table [dbo].[CampSites]    Script Date: 3/15/2021 7:16:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CampSites](
	[CampSiteId] [int] IDENTITY(1,1) NOT NULL,
	[CampSiteName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CampSites] PRIMARY KEY CLUSTERED 
(
	[CampSiteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AvailableDates]    Script Date: 3/15/2021 7:16:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AvailableDates](
	[AvailableId] [int] IDENTITY(1,1) NOT NULL,
	[CampSiteId] [int] NOT NULL,
	[AvailableDate] [date] NOT NULL,
 CONSTRAINT [PK_AvailableDates] PRIMARY KEY CLUSTERED 
(
	[AvailableId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AvailableCampReservationDates]    Script Date: 3/15/2021 7:16:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AvailableCampReservationDates]
AS
SELECT        c.CampSiteName, a.AvailableDate
FROM            dbo.AvailableDates AS a INNER JOIN
                         dbo.CampSites AS c ON a.CampSiteId = c.CampSiteId
GO
/****** Object:  Table [dbo].[Reservations]    Script Date: 3/15/2021 7:16:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservations](
	[ReservationId] [int] IDENTITY(1,1) NOT NULL,
	[AvailableId] [int] NOT NULL,
	[VistorId] [int] NOT NULL,
 CONSTRAINT [PK_Reservations] PRIMARY KEY CLUSTERED 
(
	[ReservationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vistors]    Script Date: 3/15/2021 7:16:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vistors](
	[VistorId] [int] IDENTITY(1,1) NOT NULL,
	[VistorName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Vistors] PRIMARY KEY CLUSTERED 
(
	[VistorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AvailableDates]  WITH CHECK ADD  CONSTRAINT [FK_AvailableDates_CampSites] FOREIGN KEY([CampSiteId])
REFERENCES [dbo].[CampSites] ([CampSiteId])
GO
ALTER TABLE [dbo].[AvailableDates] CHECK CONSTRAINT [FK_AvailableDates_CampSites]
GO
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_AvailableDates] FOREIGN KEY([AvailableId])
REFERENCES [dbo].[AvailableDates] ([AvailableId])
GO
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_AvailableDates]
GO
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Vistors] FOREIGN KEY([VistorId])
REFERENCES [dbo].[Vistors] ([VistorId])
GO
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_Vistors]
GO
/****** Object:  StoredProcedure [dbo].[AddReservation]    Script Date: 3/15/2021 7:16:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddReservation] 
	-- Add the parameters for the stored procedure here
	@availableId int, 
	@visitorId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


    -- Insert statements for procedure here
	insert Reservations(AvailableId, VistorId) Values (@availableId, @visitorId)
END
GO
/****** Object:  StoredProcedure [dbo].[CancelReservation]    Script Date: 3/15/2021 7:16:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CancelReservation] 
	-- Add the parameters for the stored procedure here
	@availableId int, 
	@visitorId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


    -- Insert statements for procedure here
	Delete Reservations Where availableId = @availableId AND vistorId = @visitorId
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 102
               Right = 418
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AvailableCampReservationDates'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AvailableCampReservationDates'
GO
USE [master]
GO
ALTER DATABASE [MillcreekCanyon ] SET  READ_WRITE 
GO
