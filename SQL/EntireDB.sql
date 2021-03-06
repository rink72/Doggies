USE [master]
GO
/****** Object:  Database [Racing]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE DATABASE [Racing]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Racing', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Racing.mdf' , SIZE = 5096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Racing_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Racing_log.ldf' , SIZE = 512KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Racing] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Racing].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Racing] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Racing] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Racing] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Racing] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Racing] SET ARITHABORT OFF 
GO
ALTER DATABASE [Racing] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Racing] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Racing] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Racing] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Racing] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Racing] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Racing] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Racing] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Racing] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Racing] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Racing] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Racing] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Racing] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Racing] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Racing] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Racing] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Racing] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Racing] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Racing] SET  MULTI_USER 
GO
ALTER DATABASE [Racing] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Racing] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Racing] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Racing] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Racing] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Racing', N'ON'
GO
USE [Racing]
GO
/****** Object:  Table [dbo].[ARCHIVERACES]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARCHIVERACES](
	[RACEID] [int] NULL,
	[DATE] [date] NULL,
	[TRACKID] [int] NULL,
	[DOGID] [int] NULL,
	[BOX] [int] NULL,
	[PREDICTION] [int] NULL,
	[ACTUALRESULT] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CONFIG]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CONFIG](
	[CONFIGITEM] [nvarchar](255) NULL,
	[CONFIGVALUE] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DOGS]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DOGS](
	[DOGID] [int] IDENTITY(1,1) NOT NULL,
	[DOGNAME] [varchar](255) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FEATURES_DETAIL]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FEATURES_DETAIL](
	[NNID] [nvarchar](255) NULL,
	[FEATURE] [nvarchar](255) NULL,
	[DESCRIPTION] [nvarchar](255) NULL,
	[VALUE] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FUTUREDATA]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FUTUREDATA](
	[RACEID] [int] NULL,
	[DOGID] [int] NULL,
	[D_1_M] [float] NULL,
	[D_2_M] [float] NULL,
	[D_3_M] [float] NULL,
	[D_1_6M] [float] NULL,
	[D_2_6M] [float] NULL,
	[D_3_6M] [float] NULL,
	[D_1D_A] [float] NULL,
	[D_2D_A] [float] NULL,
	[D_3D_A] [float] NULL,
	[D_P_A] [float] NULL,
	[D_P_M] [float] NULL,
	[D_PT_A] [float] NULL,
	[D_PB_A] [float] NULL,
	[D_R_M] [float] NULL,
	[D_PWC_A] [float] NULL,
	[D_PTC_A] [float] NULL,
	[D_1MBREAK] [int] NULL,
	[D_6MBREAK] [int] NULL,
	[AD_AVGPP_M] [float] NULL,
	[AD_AVGPP_A] [float] NULL,
	[AD_AVGFP_M] [float] NULL,
	[AD_AVGFP_A] [float] NULL,
	[D_1_M1] [float] NULL,
	[D_2_M1] [float] NULL,
	[D_3_M1] [float] NULL,
	[D_1D_A1] [float] NULL,
	[D_2D_A1] [float] NULL,
	[D_3D_A1] [float] NULL,
	[D_P_A1] [float] NULL,
	[D_P_M1] [float] NULL,
	[D_PT_A1] [float] NULL,
	[D_PB_A1] [float] NULL,
	[D_PWC_A1] [float] NULL,
	[D_PTC_A1] [float] NULL,
	[D_1_M2] [float] NULL,
	[D_2_M2] [float] NULL,
	[D_3_M2] [float] NULL,
	[D_1D_A2] [float] NULL,
	[D_2D_A2] [float] NULL,
	[D_3D_A2] [float] NULL,
	[D_P_A2] [float] NULL,
	[D_P_M2] [float] NULL,
	[D_PT_A2] [float] NULL,
	[D_PB_A2] [float] NULL,
	[D_PWC_A2] [float] NULL,
	[D_PTC_A2] [float] NULL,
	[D_1_M3] [float] NULL,
	[D_2_M3] [float] NULL,
	[D_3_M3] [float] NULL,
	[D_1D_A3] [float] NULL,
	[D_2D_A3] [float] NULL,
	[D_3D_A3] [float] NULL,
	[D_P_A3] [float] NULL,
	[D_P_M3] [float] NULL,
	[D_PT_A3] [float] NULL,
	[D_PB_A3] [float] NULL,
	[D_PWC_A3] [float] NULL,
	[D_PTC_A3] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FUTUREPREDICTIONS]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FUTUREPREDICTIONS](
	[rownames] [varchar](255) NULL,
	[RACEID] [int] NULL,
	[DOGID] [int] NULL,
	[nnID] [varchar](255) NULL,
	[PredictedResults] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FUTURERESULTS]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FUTURERESULTS](
	[RACEID] [int] NULL,
	[DOGID] [int] NULL,
	[BOX] [int] NULL,
	[PREDICTION] [int] NULL,
	[ACTUALRESULT] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MEETS]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MEETS](
	[MEETID] [int] IDENTITY(1,1) NOT NULL,
	[BETSLIP] [nvarchar](255) NULL,
	[CODE] [nvarchar](255) NULL,
	[COUNTRY] [nvarchar](255) NULL,
	[DATE] [date] NULL,
	[NAME] [nvarchar](255) NULL,
	[NUMBER] [int] NULL,
	[STATUS] [nvarchar](255) NULL,
	[TYPE] [nvarchar](255) NULL,
	[VENUE] [nvarchar](255) NULL,
	[PROCESSED] [int] NULL,
	[PROCESSDATE] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NETWORKDETAILS]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NETWORKDETAILS](
	[rownames] [varchar](255) NULL,
	[query] [varchar](2048) NULL,
	[error] [varchar](255) NULL,
	[traininglines] [varchar](255) NULL,
	[neurons] [varchar](255) NULL,
	[nnfilename] [varchar](255) NULL,
	[id] [varchar](255) NULL,
	[PredictionType] [varchar](255) NULL,
	[ActivationFunction] [varchar](255) NULL,
	[NNAlgorithm] [varchar](255) NULL,
	[Normalised] [varchar](255) NULL,
	[Scaled] [varchar](255) NULL,
	[Track] [int] NULL,
	[Month] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NETWORKDETAILS_old]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NETWORKDETAILS_old](
	[rownames] [varchar](255) NULL,
	[query] [varchar](2048) NULL,
	[error] [varchar](255) NULL,
	[traininglines] [varchar](255) NULL,
	[neurons] [varchar](255) NULL,
	[nnfilename] [varchar](255) NULL,
	[id] [varchar](255) NULL,
	[PredictionType] [varchar](255) NULL,
	[ActivationFunction] [varchar](255) NULL,
	[NNAlgorithm] [varchar](255) NULL,
	[Normalised] [varchar](255) NULL,
	[Scaled] [varchar](255) NULL,
	[Track] [int] NULL,
	[Month] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NETWORKRESULTS]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NETWORKRESULTS](
	[NNID] [nvarchar](255) NULL,
	[FIRSTPRCNT] [float] NULL,
	[FIRSTPAY] [float] NULL,
	[PLACEPRCNT] [float] NULL,
	[PLACEPAY] [float] NULL,
	[QUINPRCNT] [float] NULL,
	[QUINPAY] [float] NULL,
	[TRIFECTAPRCNT] [float] NULL,
	[TRIFECTAPAY] [float] NULL,
	[NUMBETS] [int] NULL,
	[Comments] [nvarchar](255) NULL,
	[BOXQ_4PRCNT] [float] NULL,
	[BOXQ_4PAY] [float] NULL,
	[BOXQ_3PRCNT] [float] NULL,
	[BOXQ_3PAY] [float] NULL,
	[BOXT_4PRCNT] [float] NULL,
	[BOXT_4PAY] [float] NULL,
	[BOXT_3PRCNT] [float] NULL,
	[BOXT_3PAY] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NETWORKRESULTS_old]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NETWORKRESULTS_old](
	[NNID] [nvarchar](255) NULL,
	[FIRSTPRCNT] [float] NULL,
	[FIRSTPAY] [float] NULL,
	[PLACEPRCNT] [float] NULL,
	[PLACEPAY] [float] NULL,
	[QUINPRCNT] [float] NULL,
	[QUINPAY] [float] NULL,
	[TRIFECTAPRCNT] [float] NULL,
	[TRIFECTAPAY] [float] NULL,
	[NUMBETS] [int] NULL,
	[Comments] [nvarchar](255) NULL,
	[BOXQ_4PRCNT] [float] NULL,
	[BOXQ_4PAY] [float] NULL,
	[BOXQ_3PRCNT] [float] NULL,
	[BOXQ_3PAY] [float] NULL,
	[BOXT_4PRCNT] [float] NULL,
	[BOXT_4PAY] [float] NULL,
	[BOXT_3PRCNT] [float] NULL,
	[BOXT_3PAY] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PREDICTEDRESULTS]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PREDICTEDRESULTS](
	[rownames] [varchar](255) NULL,
	[nnid] [varchar](255) NULL,
	[RACEID] [int] NULL,
	[DOGID] [int] NULL,
	[PredictedResults] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PREDICTEDRESULTS_old]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PREDICTEDRESULTS_old](
	[rownames] [varchar](255) NULL,
	[nnid] [varchar](255) NULL,
	[RACEID] [int] NULL,
	[DOGID] [int] NULL,
	[PredictedResults] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RACES]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RACES](
	[RACEID] [int] IDENTITY(1,1) NOT NULL,
	[MEETID] [int] NULL,
	[TRACKID] [int] NULL,
	[NAME] [nvarchar](255) NULL,
	[STARTTIME] [datetime] NULL,
	[DISTANCE] [int] NULL,
	[TRACKCONDITION] [nvarchar](255) NULL,
	[WEATHER] [nvarchar](255) NULL,
	[RACENUMBER] [int] NULL,
	[WINPAYING] [float] NULL,
	[PLACEPAYING] [float] NULL,
	[TWOPLACE] [float] NULL,
	[THREEPLACE] [float] NULL,
	[QUINELLAPAYING] [float] NULL,
	[TRIFECTAPAYING] [float] NULL,
	[FIRST4PAYING] [float] NULL,
	[STATUS] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RESULTS]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RESULTS](
	[RACEID] [int] NULL,
	[TRACKID] [int] NULL,
	[DOGID] [int] NULL,
	[BOX] [int] NULL,
	[RESULT] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[STATISTICS]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STATISTICS](
	[TRACKID] [int] NULL,
	[TRACKLOCATION] [nvarchar](255) NULL,
	[DATE] [date] NULL,
	[TOTALRACES] [int] NULL,
	[SFIRSTS] [int] NULL,
	[SFPRCNT] [float] NULL,
	[SFPAY] [float] NULL,
	[SPLACES] [int] NULL,
	[SPPRCNT] [float] NULL,
	[SPPAY] [float] NULL,
	[SQUIN] [int] NULL,
	[SQPRNCT] [float] NULL,
	[SQPAY] [float] NULL,
	[STRI] [int] NULL,
	[STPRCNT] [float] NULL,
	[STPAY] [float] NULL,
	[PLACERACES] [int] NULL,
	[PFIRSTS] [int] NULL,
	[PFPRCNT] [float] NULL,
	[PFPAY] [float] NULL,
	[PPLACES] [int] NULL,
	[PPPRCNT] [float] NULL,
	[PPPAY] [float] NULL,
	[PQUIN] [int] NULL,
	[PQPRCNT] [float] NULL,
	[PQPAY] [float] NULL,
	[PTRI] [int] NULL,
	[PTPRCNT] [float] NULL,
	[PTPAY] [float] NULL,
	[QUINRACES] [int] NULL,
	[QFIRSTS] [int] NULL,
	[QFPRCNT] [float] NULL,
	[QFPAY] [float] NULL,
	[QPLACES] [int] NULL,
	[QPPRCNT] [float] NULL,
	[QPPAY] [float] NULL,
	[QQUIN] [int] NULL,
	[QQPRNCT] [float] NULL,
	[QQPAY] [float] NULL,
	[QTRI] [int] NULL,
	[QTPRCNT] [float] NULL,
	[QTPAY] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TEMP_RACEDATA]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEMP_RACEDATA](
	[RACEID] [int] NULL,
	[DOGID] [int] NULL,
	[BOX] [int] NULL,
	[RESULT] [int] NULL,
	[STARTTIME] [datetime] NULL,
	[DISTANCE] [int] NULL,
	[TRACKID] [int] NULL,
	[WEATHER] [nvarchar](255) NULL,
	[TRACKCONDITION] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TESTINGSTATISTICS]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TESTINGSTATISTICS](
	[NNID] [nvarchar](255) NULL,
	[MONTH] [int] NULL,
	[TRACKID] [int] NULL,
	[TOTALRACES] [int] NULL,
	[FIRSTS] [int] NULL,
	[FPRCNT] [float] NULL,
	[FPAY] [float] NULL,
	[PLACES] [int] NULL,
	[PPRCNT] [float] NULL,
	[PPAY] [float] NULL,
	[QUIN] [int] NULL,
	[QPRNCT] [float] NULL,
	[QPAY] [float] NULL,
	[TRI] [int] NULL,
	[TPRCNT] [float] NULL,
	[TPAY] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TRACKS]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRACKS](
	[TRACKID] [int] IDENTITY(1,1) NOT NULL,
	[TRACKNAME] [nvarchar](255) NULL,
	[TRACKLOCATION] [nvarchar](50) NULL,
	[PREDICT] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TRAININGDATA]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRAININGDATA](
	[RACEID] [int] NULL,
	[DOGID] [int] NULL,
	[D_1_M] [float] NULL,
	[D_2_M] [float] NULL,
	[D_3_M] [float] NULL,
	[D_1_6M] [float] NULL,
	[D_2_6M] [float] NULL,
	[D_3_6M] [float] NULL,
	[D_1D_A] [float] NULL,
	[D_2D_A] [float] NULL,
	[D_3D_A] [float] NULL,
	[D_P_A] [float] NULL,
	[D_P_M] [float] NULL,
	[D_PT_A] [float] NULL,
	[D_PB_A] [float] NULL,
	[D_R_M] [float] NULL,
	[D_PWC_A] [float] NULL,
	[D_PTC_A] [float] NULL,
	[D_1MBREAK] [int] NULL,
	[D_6MBREAK] [int] NULL,
	[AD_AVGPP_M] [float] NULL,
	[AD_AVGPP_A] [float] NULL,
	[AD_AVGFP_M] [float] NULL,
	[AD_AVGFP_A] [float] NULL,
	[RESULT] [int] NULL,
	[DATATYPE] [nvarchar](50) NULL,
	[D_1_M1] [float] NULL,
	[D_2_M1] [float] NULL,
	[D_3_M1] [float] NULL,
	[D_1D_A1] [float] NULL,
	[D_2D_A1] [float] NULL,
	[D_3D_A1] [float] NULL,
	[D_P_A1] [float] NULL,
	[D_P_M1] [float] NULL,
	[D_PT_A1] [float] NULL,
	[D_PB_A1] [float] NULL,
	[D_PWC_A1] [float] NULL,
	[D_PTC_A1] [float] NULL,
	[D_1_M2] [float] NULL,
	[D_2_M2] [float] NULL,
	[D_3_M2] [float] NULL,
	[D_1D_A2] [float] NULL,
	[D_2D_A2] [float] NULL,
	[D_3D_A2] [float] NULL,
	[D_P_A2] [float] NULL,
	[D_P_M2] [float] NULL,
	[D_PT_A2] [float] NULL,
	[D_PB_A2] [float] NULL,
	[D_PWC_A2] [float] NULL,
	[D_PTC_A2] [float] NULL,
	[D_1_M3] [float] NULL,
	[D_2_M3] [float] NULL,
	[D_3_M3] [float] NULL,
	[D_1D_A3] [float] NULL,
	[D_2D_A3] [float] NULL,
	[D_3D_A3] [float] NULL,
	[D_P_A3] [float] NULL,
	[D_P_M3] [float] NULL,
	[D_PT_A3] [float] NULL,
	[D_PB_A3] [float] NULL,
	[D_PWC_A3] [float] NULL,
	[D_PTC_A3] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Index [INDEX2]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE CLUSTERED INDEX [INDEX2] ON [dbo].[TRAININGDATA]
(
	[D_P_M] ASC,
	[DOGID] ASC,
	[RACEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [INDEX1]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE NONCLUSTERED INDEX [INDEX1] ON [dbo].[DOGS]
(
	[DOGNAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [NonClusteredIndex-20140924-084308]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20140924-084308] ON [dbo].[FEATURES_DETAIL]
(
	[NNID] ASC,
	[FEATURE] ASC,
	[DESCRIPTION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [INDEX1]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE NONCLUSTERED INDEX [INDEX1] ON [dbo].[PREDICTEDRESULTS]
(
	[nnid] ASC,
	[RACEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [INDEX1]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE NONCLUSTERED INDEX [INDEX1] ON [dbo].[PREDICTEDRESULTS_old]
(
	[nnid] ASC,
	[RACEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [INDEX1]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE NONCLUSTERED INDEX [INDEX1] ON [dbo].[RACES]
(
	[MEETID] ASC,
	[RACENUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [INDEX2]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE NONCLUSTERED INDEX [INDEX2] ON [dbo].[RACES]
(
	[STARTTIME] ASC
)
INCLUDE ( 	[RACEID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [INDEX3]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE NONCLUSTERED INDEX [INDEX3] ON [dbo].[RACES]
(
	[STARTTIME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [INDEX4]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE NONCLUSTERED INDEX [INDEX4] ON [dbo].[RACES]
(
	[TRACKID] ASC
)
INCLUDE ( 	[RACEID],
	[STARTTIME],
	[WINPAYING],
	[PLACEPAYING],
	[QUINELLAPAYING],
	[TRIFECTAPAYING],
	[FIRST4PAYING]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [INDEX5]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE NONCLUSTERED INDEX [INDEX5] ON [dbo].[RACES]
(
	[RACEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [INDEX1]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE NONCLUSTERED INDEX [INDEX1] ON [dbo].[RESULTS]
(
	[RACEID] ASC,
	[TRACKID] ASC,
	[DOGID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [INDEX1]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE NONCLUSTERED INDEX [INDEX1] ON [dbo].[TEMP_RACEDATA]
(
	[DOGID] ASC,
	[RESULT] ASC,
	[RACEID] ASC,
	[STARTTIME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [INDEX2]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE NONCLUSTERED INDEX [INDEX2] ON [dbo].[TEMP_RACEDATA]
(
	[RACEID] ASC,
	[DOGID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [INDEX]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE NONCLUSTERED INDEX [INDEX] ON [dbo].[TRAININGDATA]
(
	[RACEID] ASC,
	[DOGID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [INDEX1]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE NONCLUSTERED INDEX [INDEX1] ON [dbo].[TRAININGDATA]
(
	[DATATYPE] ASC
)
INCLUDE ( 	[RACEID],
	[DOGID],
	[D_1_M],
	[D_2_M],
	[D_3_M],
	[D_1_6M],
	[D_2_6M],
	[D_3_6M],
	[D_1D_A],
	[D_2D_A],
	[D_3D_A],
	[D_P_M],
	[D_PB_A],
	[D_PWC_A],
	[D_1MBREAK],
	[RESULT],
	[D_1_M1],
	[D_2_M1],
	[D_3_M1],
	[D_1D_A1],
	[D_2D_A1],
	[D_3D_A1],
	[D_P_A1],
	[D_P_M1],
	[D_PT_A1],
	[D_PB_A1],
	[D_PWC_A1],
	[D_PTC_A1],
	[D_1_M2],
	[D_2_M2],
	[D_3_M2],
	[D_1D_A2],
	[D_2D_A2],
	[D_3D_A2],
	[D_P_A2],
	[D_P_M2],
	[D_PT_A2],
	[D_PB_A2],
	[D_PWC_A2],
	[D_PTC_A2],
	[D_1_M3],
	[D_2_M3],
	[D_3_M3],
	[D_1D_A3],
	[D_2D_A3],
	[D_3D_A3],
	[D_P_A3],
	[D_P_M3],
	[D_PT_A3],
	[D_PB_A3],
	[D_PWC_A3],
	[D_PTC_A3]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [INDEX3]    Script Date: 25/09/2014 4:49:23 p.m. ******/
CREATE NONCLUSTERED INDEX [INDEX3] ON [dbo].[TRAININGDATA]
(
	[D_1_M] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[AddMeet]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddMeet]
	-- Add the parameters for the stored procedure here
	@BETSLIP nvarchar(255),
	@CODE nvarchar(255),
	@COUNTRY nvarchar(255),
	@DATE date,
	@NAME nvarchar(255),
	@NUMBER int,
	@STATUS nvarchar(255),
	@TYPE nvarchar(255),
	@VENUE nvarchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO MEETS (BETSLIP, CODE, COUNTRY, DATE, NAME, NUMBER, STATUS, TYPE, VENUE) SELECT @BETSLIP, @CODE, @COUNTRY, @DATE, @NAME, @NUMBER, @STATUS, @TYPE, @VENUE
	WHERE NOT EXISTS ( SELECT MEETID FROM MEETS WHERE DATE = @DATE AND NAME = @NAME )


END

GO
/****** Object:  StoredProcedure [dbo].[AddRaceDetails]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddRaceDetails] 
	-- Add the parameters for the stored procedure here
	@MEETID int,
	@TRACKID int,
	@NAME nvarchar(255),
	@STARTTIME datetime,
	@DISTANCE int,
	@TRACKCONDITION nvarchar(255),
	@WEATHER nvarchar(255),
	@RACENUMBER int,
	@WINPAYING nvarchar(255) = NULL,
	@PLACEPAYING nvarchar(255) = NULL,
	@2PLACE float = NULL,
	@3PLACE float = NULL,
	@QUINELLAPAYING nvarchar(255) = NULL,
	@TRIFECTAPAYING nvarchar(255) = NULL,
	@FIRST4PAYING nvarchar(255) = NULL,
	@STATUS int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS ( SELECT 1 FROM [RACES] WHERE MEETID = @MEETID AND RACENUMBER = @RACENUMBER )
		UPDATE RACES SET TRACKID = @TRACKID, NAME = @NAME, STARTTIME = @STARTTIME, DISTANCE = @DISTANCE, TRACKCONDITION = @TRACKCONDITION, WEATHER = @WEATHER, WINPAYING = @WINPAYING, PLACEPAYING = @PLACEPAYING, QUINELLAPAYING = @QUINELLAPAYING, TRIFECTAPAYING = @TRIFECTAPAYING, FIRST4PAYING = @FIRST4PAYING, TWOPLACE = @2PLACE, THREEPLACE = @3PLACE, STATUS = @STATUS WHERE MEETID = @MEETID AND RACENUMBER = @RACENUMBER
	ELSE
		INSERT INTO [RACES] (MEETID, TRACKID, NAME, STARTTIME, DISTANCE, TRACKCONDITION, WEATHER, RACENUMBER, WINPAYING, PLACEPAYING, QUINELLAPAYING, TRIFECTAPAYING, FIRST4PAYING, TWOPLACE, THREEPLACE, STATUS) 
			SELECT @MEETID, @TRACKID, @NAME, @STARTTIME, @DISTANCE, @TRACKCONDITION, @WEATHER, @RACENUMBER, @WINPAYING, @PLACEPAYING, @QUINELLAPAYING, @TRIFECTAPAYING, @FIRST4PAYING, @2PLACE, @3PLACE, @STATUS
END

GO
/****** Object:  StoredProcedure [dbo].[AddRaceResult]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddRaceResult] 
	-- Add the parameters for the stored procedure here
	@TRACKID int,
	@RACEID int,
	@DOGID int,
	@BOX int,
	@RESULT int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [RESULTS] (RACEID, TRACKID, DOGID, BOX, RESULT)
	SELECT @RACEID, @TRACKID, @DOGID, @BOX, @RESULT
	WHERE NOT EXISTS ( SELECT 1 FROM [RESULTS] WHERE TRACKID = @TRACKID AND RACEID = @RACEID AND DOGID = @DOGID)
END

GO
/****** Object:  StoredProcedure [dbo].[AddRacingDownload]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddRacingDownload]
	-- Add the parameters for the stored procedure here
	@MEET_NO int = NULL,
	@URL nvarchar(255),
	@RACEDATE date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [DOWNLOADS] (MEET_NO, URL, RACEDATE) SELECT @MEET_NO, @URL, @RACEDATE
	WHERE NOT EXISTS ( SELECT [URL] FROM [DOWNLOADS] WHERE URL = @URL )


END

GO
/****** Object:  StoredProcedure [dbo].[ArchiveRaceData]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ArchiveRaceData]
	-- Add the parameters for the stored procedure here
	@RACEID [int],
	@DOGID [int]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ACTUALRESULT [int]
	DECLARE @TRACKID [int]
	DECLARE @BOX [int]
	DECLARE @PREDICTION [int]
	DECLARE @DATE [date]

    -- Insert statements for procedure here
	SET @ACTUALRESULT = (SELECT RESULT FROM RESULTS WHERE RACEID = @RACEID AND DOGID = @DOGID)
	SET @TRACKID = (SELECT TRACKID FROM RACES WHERE RACEID = @RACEID)
	SET @BOX = (SELECT BOX FROM FUTURERESULTS WHERE RACEID = @RACEID AND DOGID = @DOGID)
	SET @PREDICTION = (SELECT PREDICTION FROM FUTURERESULTS WHERE RACEID = @RACEID AND DOGID = @DOGID)
	SET @DATE = (SELECT STARTTIME FROM RACES WHERE RACEID = @RACEID)

	IF EXISTS (SELECT 1 FROM ARCHIVERACES WHERE RACEID = @RACEID AND DOGID = @DOGID)
		UPDATE ARCHIVERACES SET RACEID = @RACEID, DATE = @DATE, TRACKID = @TRACKID, DOGID = @DOGID, BOX = @BOX, PREDICTION = @PREDICTION, ACTUALRESULT = @ACTUALRESULT WHERE RACEID = @RACEID AND DOGID = @DOGID
	ELSE
		INSERT INTO ARCHIVERACES (RACEID, DATE, TRACKID, DOGID, BOX, PREDICTION, ACTUALRESULT) VALUES (@RACEID, @DATE, @TRACKID, @DOGID, @BOX, @PREDICTION, @ACTUALRESULT)

END

GO
/****** Object:  StoredProcedure [dbo].[CalcDogBoxPlacePrcnt]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create STARTTIME: <Create STARTTIME,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalcDogBoxPlacePrcnt]
	-- Add the parameters for the stored procedure here
	@DOGID [int],
	@RACEID [int],
	@RACEDATE [date],
	@BOX [int],
	@RESULT [float] OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @racespos float
	DECLARE @totalraces float
		
	SET @racespos = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID AND RESULT in ('1','2','3')
						AND BOX = @BOX
						AND STARTTIME < @RACEDATE
						AND RACEID <> @RACEID)

	
	SET @totalraces = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID
						AND BOX = @BOX
						AND STARTTIME < @RACEDATE
						AND RACEID <> @RACEID)
	
	
	
	IF @totalraces > 0
		SET @RESULT = @racespos / @totalraces
	ELSE
		SET @RESULT = 0
	
	RETURN

END

GO
/****** Object:  StoredProcedure [dbo].[CalcDogDistPosPrcnt]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create STARTTIME: <Create STARTTIME,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalcDogDistPosPrcnt]
	-- Add the parameters for the stored procedure here
	@DOGID [int],
	@RACEID [int],
	@RACEDATE [date],
	@POSITION [varchar](50),
	@DISTANCE [varchar](50),
	@RESULT [float] OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @racespos float
	DECLARE @totalraces float

	
	SET @racespos = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID 
						AND RESULT = @POSITION
						AND DISTANCE = @DISTANCE
						AND STARTTIME < @RACEDATE
						AND RACEID <> @RACEID)
	
	SET @totalraces = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID
						AND STARTTIME < @RACEDATE
						AND RACEID <> @RACEID)

	IF @totalraces > 0
		SET @RESULT = @racespos / @totalraces
	ELSE
		SET @RESULT = 0

	RETURN

END

GO
/****** Object:  StoredProcedure [dbo].[CalcDogPlacePrcnt]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create STARTTIME: <Create STARTTIME,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalcDogPlacePrcnt]
	-- Add the parameters for the stored procedure here
	@DOGID [int],
	@RACEID [int],
	@RACEDATE [date],
	@RESULT [float] OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @racespos float
	DECLARE @totalraces float
		
	SET @racespos = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID AND RESULT in ('1','2','3')
						AND STARTTIME < @RACEDATE
						AND RACEID <> @RACEID)

	
	SET @totalraces = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID
						AND STARTTIME < @RACEDATE
						AND RACEID <> @RACEID)
	
	
	
	IF @totalraces > 0
		SET @RESULT = @racespos / @totalraces
	ELSE
		SET @RESULT = 0
	
	RETURN

END

GO
/****** Object:  StoredProcedure [dbo].[CalcDogPlacePrcntTime]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create STARTTIME: <Create STARTTIME,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalcDogPlacePrcntTime]
	-- Add the parameters for the stored procedure here
	@DOGID [int],
	@RACEID [int],
	@RACEDATE [date],
	@MONTHS [int],
	@RESULT [float] OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @racespos float
	DECLARE @totalraces float
		
	SET @racespos = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID AND RESULT in ('1','2','3')
						AND STARTTIME >= DATEADD(MONTH, -@MONTHS, @racedate)
						AND STARTTIME <= @RACEDATE
						AND RACEID <> @RACEID)
	
	SET @totalraces = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID
						AND STARTTIME >= DATEADD(MONTH, -@MONTHS, @racedate)
						AND STARTTIME <= @RACEDATE
						AND RACEID <> @RACEID)

	IF @totalraces > 0
		SET @RESULT = @racespos / @totalraces
	ELSE
		SET @RESULT = 0

	RETURN

END

GO
/****** Object:  StoredProcedure [dbo].[CalcDogPosPrcntMonth]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create STARTTIME: <Create STARTTIME,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalcDogPosPrcntMonth]
	-- Add the parameters for the stored procedure here
	@DOGID [int],
	@RACEID [int],
	@RACEDATE [date],
	@POSITION int,
	@RESULT [float] OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @racespos float
	DECLARE @totalraces float
	
	SET @racespos = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID AND RESULT = @POSITION
						AND STARTTIME >= DATEADD(MONTH, -1, @racedate)
						AND STARTTIME <= @RACEDATE
						AND RACEID <> @RACEID)
	
	SET @totalraces = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID
						AND STARTTIME >= DATEADD(MONTH, -1, @racedate)
						AND STARTTIME <= @RACEDATE
						AND RACEID <> @RACEID)

	IF @totalraces > 0
		SET @RESULT = @racespos / @totalraces
	ELSE
		SET @RESULT = 0

	RETURN

END

GO
/****** Object:  StoredProcedure [dbo].[CalcDogPosPrcntTime]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create STARTTIME: <Create STARTTIME,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalcDogPosPrcntTime]
	-- Add the parameters for the stored procedure here
	@DOGID [int],
	@RACEID [int],
	@RACEDATE [date],
	@POSITION int,
	@MONTHS int, 
	@RESULT [float] OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @racespos float
	DECLARE @totalraces float
	
	SET @racespos = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID AND RESULT = @POSITION
						AND STARTTIME >= DATEADD(MONTH, -@MONTHS, @racedate)
						AND STARTTIME <= @RACEDATE
						AND RACEID <> @RACEID)
	
	SET @totalraces = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID
						AND STARTTIME >= DATEADD(MONTH, -@MONTHS, @racedate)
						AND STARTTIME <= @RACEDATE
						AND RACEID <> @RACEID)

	IF @totalraces > 0
		SET @RESULT = @racespos / @totalraces
	ELSE
		SET @RESULT = 0

	RETURN

END

GO
/****** Object:  StoredProcedure [dbo].[CalcDogTCondPlacePrcnt]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create STARTTIME: <Create STARTTIME,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalcDogTCondPlacePrcnt]
	-- Add the parameters for the stored procedure here
	@DOGID [int],
	@RACEID [int],
	@RACEDATE [date],
	@TRACKC [varchar](255),
	@RESULT [float] OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @racespos float
	DECLARE @totalraces float
		
	SET @racespos = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID AND RESULT in ('1','2','3')
						AND TRACKCONDITION = @TRACKC
						AND STARTTIME < @RACEDATE
						AND RACEID <> @RACEID)

	
	SET @totalraces = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID
						AND TRACKCONDITION = @TRACKC
						AND STARTTIME < @RACEDATE
						AND RACEID <> @RACEID)
	
	
	
	IF @totalraces > 0
		SET @RESULT = @racespos / @totalraces
	ELSE
		SET @RESULT = 0
	
	RETURN

END

GO
/****** Object:  StoredProcedure [dbo].[CalcDogTrackPlacePrcnt]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create STARTTIME: <Create STARTTIME,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalcDogTrackPlacePrcnt]
	-- Add the parameters for the stored procedure here
	@DOGID [int],
	@RACEID [int],
	@RACEDATE [date],
	@TRACKID [int],
	@RESULT [float] OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @racespos float
	DECLARE @totalraces float
		
	SET @racespos = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID AND RESULT in ('1','2','3')
						AND TRACKID = @TRACKID
						AND STARTTIME < @RACEDATE
						AND RACEID <> @RACEID)

	
	SET @totalraces = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID
						AND TRACKID = @TRACKID
						AND STARTTIME < @RACEDATE
						AND RACEID <> @RACEID)
	
	
	
	IF @totalraces > 0
		SET @RESULT = @racespos / @totalraces
	ELSE
		SET @RESULT = 0
	
	RETURN

END

GO
/****** Object:  StoredProcedure [dbo].[CalcDogWeatherPlacePrcnt]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create STARTTIME: <Create STARTTIME,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalcDogWeatherPlacePrcnt]
	-- Add the parameters for the stored procedure here
	@DOGID [int],
	@RACEID [int],
	@RACEDATE [date],
	@WEATHER [varchar](255),
	@RESULT [float] OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @racespos float
	DECLARE @totalraces float
		
	SET @racespos = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID AND RESULT in ('1','2','3')
						AND WEATHER = @WEATHER
						AND STARTTIME < @RACEDATE
						AND RACEID <> @RACEID)

	
	SET @totalraces = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID = @DOGID
						AND WEATHER = @WEATHER
						AND STARTTIME < @RACEDATE
						AND RACEID <> @RACEID)
	
	
	
	IF @totalraces > 0
		SET @RESULT = @racespos / @totalraces
	ELSE
		SET @RESULT = 0
	
	RETURN

END

GO
/****** Object:  StoredProcedure [dbo].[CalcOtherDogFirstPrcnt]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create STARTTIME: <Create STARTTIME,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalcOtherDogFirstPrcnt]
	-- Add the parameters for the stored procedure here
	@DOGID [int],
	@RACEID [int],
	@RACEDATE [date],
	@MONTH [int],
	@RESULT [float] OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @racespos float
	DECLARE @totalraces float
		
	SET @racespos = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID in (SELECT DOGID FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID <> @DOGID)
						AND RESULT = 1
						AND STARTTIME >= DATEADD(MONTH, -@MONTH, @racedate)
						AND STARTTIME <= @RACEDATE
						AND RACEID <> @RACEID)
	
	SET @totalraces = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID in (SELECT DOGID FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID <> @DOGID)
						AND STARTTIME >= DATEADD(MONTH, -@MONTH, @racedate)
						AND STARTTIME <= @RACEDATE
						AND RACEID <> @RACEID)

	IF @totalraces > 0
		SET @RESULT = @racespos / @totalraces
	ELSE
		SET @RESULT = 0

	RETURN

END

GO
/****** Object:  StoredProcedure [dbo].[CalcOtherDogPlacePrcnt]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create STARTTIME: <Create STARTTIME,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalcOtherDogPlacePrcnt]
	-- Add the parameters for the stored procedure here
	@DOGID [int],
	@RACEID [int],
	@RACEDATE [date],
	@MONTH [int],
	@RESULT [float] OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @racespos float
	DECLARE @totalraces float
		
	SET @racespos = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID in (SELECT DOGID FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID <> @DOGID)
						AND RESULT in ('1','2','3')
						AND STARTTIME >= DATEADD(MONTH, -@MONTH, @racedate)
						AND STARTTIME <= @RACEDATE
						AND RACEID <> @RACEID)
	
	SET @totalraces = (SELECT Count(RESULT) FROM TEMP_RACEDATA 
						WHERE DOGID in (SELECT DOGID FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID <> @DOGID)
						AND STARTTIME >= DATEADD(MONTH, -@MONTH, @racedate)
						AND STARTTIME <= @RACEDATE
						AND RACEID <> @RACEID)

	IF @totalraces > 0
		SET @RESULT = @racespos / @totalraces
	ELSE
		SET @RESULT = 0

	RETURN

END

GO
/****** Object:  StoredProcedure [dbo].[CleanFutureRaces]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CleanFutureRaces]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM FUTURERESULTS WHERE RACEID in 
		( SELECT RACEID FROM RACES WHERE MEETID in
			( SELECT MEETID FROM MEETS WHERE DATE < convert(date, getdate()))
		)


END

GO
/****** Object:  StoredProcedure [dbo].[CLEANPREDICTEDRESULTS]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CLEANPREDICTEDRESULTS]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @MINPERCENT int = 58

    -- Insert statements for procedure here
	DELETE FROM PREDICTEDRESULTS WHERE NNID in ( SELECT NNID FROM NETWORKRESULTS WHERE PLACEPRCNT < @MINPERCENT)
	DELETE FROM FEATURES_DETAIL WHERE NNID in ( SELECT NNID FROM NETWORKRESULTS WHERE PLACEPRCNT < @MINPERCENT)

END

GO
/****** Object:  StoredProcedure [dbo].[CreateTempRaceData]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CreateTempRaceData] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

IF (SELECT 1 
           FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_TYPE='BASE TABLE' 
           AND TABLE_NAME='TEMP_RACEDATA') is not NULL
	DROP TABLE TEMP_RACEDATA

TRUNCATE TABLE FUTUREDATA
TRUNCATE TABLE FUTUREPREDICTIONS

SELECT a.[RACEID], a.[DOGID], a.[BOX], a.[RESULT], b.[STARTTIME], b.[DISTANCE], b.[TRACKID], b.[WEATHER], b.[TRACKCONDITION]
INTO TEMP_RACEDATA
	FROM RESULTS a
	INNER JOIN RACES b
	ON a.RACEID = b.RACEID

CREATE NONCLUSTERED INDEX [INDEX1]
ON [dbo].[TEMP_RACEDATA] ([DOGID],[RESULT],[RACEID],[STARTTIME])

CREATE NONCLUSTERED INDEX [INDEX2]
ON [dbo].[TEMP_RACEDATA] ([RACEID],[DOGID])


END

GO
/****** Object:  StoredProcedure [dbo].[GenerateAccuracyReport]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GenerateAccuracyReport] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- floaterfering with SELECT statements.
	SET NOCOUNT ON;

SELECT a.RACEID, a.DATE, a.DOGID, a.PLACE, a.PLACEREC, a.QUINREC, a.ACTUALRESULT, b.WINPAYING, b.PLACEPAYING, b.QUINELLAPAYING, b.TRIFECTAPAYING, b.FIRST4PAYING
INTO #TempReport
FROM ARCHIVERESULTS a
	INNER JOIN RACES b on a.RACEID = b.RACEID

-- Get all time stats
DECLARE @AllTimeRaces [float]
DECLARE @FirstAT_STAND [float]
DECLARE @FirstAT_PLACE [float]
DECLARE @FirstAT_QUIN [float]
DECLARE @PlaceAT_STAND [float]
DECLARE @PlaceAT_PLACE [float]
DECLARE @PlaceAT_QUIN [float]
DECLARE @PLACE_RACES [float]
DECLARE @QUIN_RACES [float]
DECLARE @FirstPrcntAT_STAND [float]
DECLARE @PlacePrcntAT_STAND [float]
DECLARE @FirstPrcntAT_PLACE [float]
DECLARE @PlacePrcntAT_PLACE [float]
DECLARE @FirstPrcntAT_QUIN [float]
DECLARE @PlacePrcntAT_QUIN [float]
DECLARE @FirstPayAT_STAND [float]
DECLARE @PlacePayAT_STAND [float]
DECLARE @FirstPayAT_PLACE [float]
DECLARE @PlacePayAT_PLACE [float]
DECLARE @FirstPayAT_QUIN [float]
DECLARE @PlacePayAT_QUIN [float]


SET @AllTimeRaces = (SELECT count(DISTINCT RACEID) FROM #TempReport)
SET @FirstAT_STAND = (SELECT count(DISTINCT RACEID) FROM #TempReport WHERE PLACE = 1 and ACTUALRESULT = 1)
SET @FirstPayAT_STAND = (SELECT sum(convert(float,winpaying)) FROM #TempReport WHERE PLACE = 1 and ACTUALRESULT = 1) - @AllTimeRaces
SET @PlaceAT_STAND = (SELECT count(DISTINCT RACEID) FROM #TempReport WHERE PLACE = 1 and ACTUALRESULT < 4)
SET @PlacePayAT_STAND = (SELECT sum(convert(float,PLACEPAYING)) FROM #TempReport WHERE PLACE = 1 and ACTUALRESULT < 4) - @AllTimeRaces
SET @PLACE_RACES = (SELECT count(DISTINCT RACEID) FROM #TempReport WHERE PLACEREC is not NULL)
SET @FirstAT_PLACE = (SELECT count(DISTINCT RACEID) FROM #TempReport WHERE PLACEREC = 1 and ACTUALRESULT = 1)
SET @FirstPayAT_PLACE = (SELECT sum(convert(float,winpaying)) FROM #TempReport WHERE PLACEREC = 1 and ACTUALRESULT = 1) - @PLACE_RACES
SET @PlaceAT_PLACE = (SELECT count(DISTINCT RACEID) FROM #TempReport WHERE PLACEREC = 1 and ACTUALRESULT < 4)
SET @PlacePayAT_PLACE = (SELECT sum(convert(float,PLACEPAYING)) FROM #TempReport WHERE PLACEREC = 1 and ACTUALRESULT < 4) - @PLACE_RACES
SET @QUIN_RACES = (SELECT count(DISTINCT RACEID) FROM #TempReport WHERE QUINREC is not NULL)
SET @FirstAT_QUIN = (SELECT count(DISTINCT RACEID) FROM #TempReport WHERE PLACE = 1 and ACTUALRESULT = 1)
SET @FirstPayAT_QUIN = (SELECT sum(convert(float,winpaying)) FROM #TempReport WHERE QUINREC = 1 and ACTUALRESULT = 1) - @QUIN_RACES
SET @PlaceAT_QUIN = (SELECT count(DISTINCT RACEID) FROM #TempReport WHERE PLACE = 1 and ACTUALRESULT < 4)
SET @PlacePayAT_QUIN = (SELECT sum(convert(float,winpaying)) FROM #TempReport WHERE QUINREC = 1 and ACTUALRESULT = 1) - @QUIN_RACES

SET @FirstPrcntAT_STAND = (@FirstAT_STAND / @AllTimeRaces) * 100
SET @PlacePrcntAT_STAND = (@PlaceAT_STAND / @AllTimeRaces) * 100
SET @FirstPrcntAT_PLACE = (@FirstAT_PLACE / @PLACE_RACES) * 100
SET @PlacePrcntAT_PLACE = (@PlaceAT_PLACE / @PLACE_RACES) * 100
SET @FirstPrcntAT_QUIN = (@FirstAT_QUIN / @QUIN_RACES) * 100
SET @PlacePrcntAT_QUIN = (@PlaceAT_QUIN / @QUIN_RACES) * 100

-- Get Monthly stats
DECLARE @MonthlyRaces [float]
SET @MonthlyRaces = (SELECT count(DISTINCT RACEID) FROM #TempReport WHERE DATE > DATEADD(month, -1, convert(date, getdate())))


-- Get Weekly stats
DECLARE @WeeklyRaces [float]
SET @WeeklyRaces = (SELECT count(DISTINCT RACEID) FROM #TempReport WHERE DATE > DATEADD(week, -1, convert(date, getdate())))

SELECT	@AllTimeRaces AS 'Number of Races'
		,@FirstPrcntAT_STAND AS '% First (STAND)'
		,@FirstPayAT_STAND AS 'Pay First (STAND)'
		,@PlacePrcntAT_STAND AS '% Place (STAND)'  
		,@FirstPrcntAT_PLACE AS '% First (PLACE)'
		,@FirstPayAT_PLACE AS 'First Pay (PLACE)'
		,@PlacePrcntAT_PLACE AS '% Place (PLACE)'
		,@FirstPrcntAT_QUIN AS '% First (QUIN)'
		,@FirstPayAT_QUIN AS 'First Pay (QUIN)'
		,@PlacePrcntAT_QUIN AS '% Place (QUIN)'
		
INTO #TEMPOUTPUT

SELECT * FROM #TEMPOUTPUT

DROP TABLE #TempReport
DROP TABLE #TEMPOUTPUT


END

GO
/****** Object:  StoredProcedure [dbo].[GenerateFutureLine]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GenerateFutureLine]
	-- Add the parameters for the stored procedure here
	@DOGID  [int],
	@RACEID [int]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @D1M float
	DECLARE @D2M float
	DECLARE @D3M float
	DECLARE @D1_6M float
	DECLARE @D2_6M float
	DECLARE @D3_6M float
	DECLARE @D1DA float
	DECLARE @D2DA float
	DECLARE @D3DA float
	DECLARE @DPA float
	DECLARE @DPM float
	DECLARE @DPTA float
	DECLARE @D1BA float
	DECLARE @D2BA float
	DECLARE @D3BA float
	DECLARE @DPBA float
	DECLARE @DSA float
	DECLARE @RM int
	DECLARE @R6M int
	DECLARE @RA int
	DECLARE @RESULT int
	DECLARE @DPWCA float
	DECLARE @DPTCA float
	DECLARE @D_1M_BREAK int
	DECLARE @D_6M_BREAK int
	DECLARE @AD_AVGPP_M float
	DECLARE @AD_AVGPP_A float
	DECLARE @AD_AVGFP_M float
	DECLARE @AD_AVGFP_A float

	DECLARE @racedate date
	DECLARE @distance int
	DECLARE @trackid int
	DECLARE @box int
	DECLARE @weather varchar(50)
	DECLARE @trackc varchar(50)

	SET @racedate = (SELECT STARTTIME FROM RACES WHERE RACEID = @RACEID )
	SET @distance = (SELECT DISTANCE FROM RACES WHERE RACEID = @RACEID)
	SET @trackid = (SELECT TRACKID FROM RACES WHERE RACEID = @RACEID)
	SET @box = (SELECT BOX FROM FUTURERESULTS WHERE RACEID = @RACEID AND DOGID = @DOGID)
	SET @weather = (SELECT WEATHER FROM RACES WHERE RACEID = @RACEID)
	SET @trackc = (SELECT TRACKCONDITION FROM RACES WHERE RACEID = @RACEID)

	-- Calculate position percentages for last month
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '1', 1, @D1M OUTPUT
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '2', 1, @D2M OUTPUT
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '3', 1, @D3M OUTPUT

	-- Calculate position percentages for last six month
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '1', 6, @D1_6M OUTPUT
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '2', 6, @D2_6M OUTPUT
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '3', 6, @D3_6M OUTPUT
	
	-- Calculate position percentages for last month at this distance
	EXEC CalcDogDistPosPrcnt @DOGID, @RACEID, @racedate, '1', @distance, @D1DA OUTPUT
	EXEC CalcDogDistPosPrcnt @DOGID, @RACEID, @racedate, '2', @distance, @D2DA OUTPUT
	EXEC CalcDogDistPosPrcnt @DOGID, @RACEID, @racedate, '3', @distance, @D3DA OUTPUT
	
	-- Calculate placing percentages for last month and all time
	EXEC CalcDogPlacePrcntTime @DOGID, @RACEID, @racedate, 1, @DPM OUTPUT
	EXEC CalcDogPlacePrcntTime @DOGID, @RACEID, @racedate, 900, @DPA OUTPUT

	-- Calculate placing position percentages for this track and this box
	EXEC CalcDogTrackPlacePrcnt @DOGID, @RACEID, @racedate, @trackid, @DPTA OUTPUT
	EXEC CalcDogBoxPlacePrcnt @DOGID, @RACEID, @racedate, @box, @DPBA OUTPUT

	-- Calcualte number of races in last month, six months and all time
	SET @RM = (SELECT Count(DOGID) FROM TEMP_RACEDATA 
				WHERE DOGID = @DOGID 
				AND STARTTIME >= DATEADD(MONTH, -1, @racedate)
				AND STARTTIME < @racedate
				AND RACEID <> @RACEID)
	
	SET @R6M = (SELECT Count(DOGID) FROM TEMP_RACEDATA 
				WHERE DOGID = @DOGID 
				AND STARTTIME >= DATEADD(MONTH, -6, @racedate)
				AND STARTTIME < @racedate
				AND RACEID <> @RACEID)

	SET @RA = (SELECT Count(DOGID) FROM TEMP_RACEDATA 
				WHERE DOGID = @DOGID
				AND STARTTIME < @racedate
				AND RACEID <> @RACEID)
	
	-- Calculate placing percentages for weather and track conditions
	EXEC CalcDogWeatherPlacePrcnt @DOGID, @RACEID, @racedate, @weather, @DPWCA OUTPUT
	EXEC CalcDogTCondPlacePrcnt @DOGID, @RACEID, @racedate, @trackc, @DPTCA OUTPUT

	-- Calculate if a dog has not raced in last month or six months
	IF @RM = 0 SET @D_1M_BREAK = 1 ELSE SET @D_1M_BREAK = 0
	IF @R6M = 0 SET @D_6M_BREAK = 1 ELSE SET @D_6M_BREAK = 0

	-- Calculate Placing Percentages for all other dogs in race
	EXEC CalcOtherDogPlacePrcnt @DOGID, @RACEID, @racedate, 1, @AD_AVGPP_M OUTPUT
	EXEC CalcOtherDogPlacePrcnt @DOGID, @RACEID, @racedate, 900, @AD_AVGPP_A OUTPUT

	-- Calculate First Percentages for all other dogs in race
	EXEC CalcOtherDogFirstPrcnt @DOGID, @RACEID, @racedate, 1, @AD_AVGFP_M OUTPUT
	EXEC CalcOtherDogFirstPrcnt @DOGID, @RACEID, @racedate, 900, @AD_AVGFP_A OUTPUT



	INSERT INTO FUTUREDATA ([RACEID]
      ,[DOGID]
      ,[D_1_M]
      ,[D_2_M]
      ,[D_3_M]
      ,[D_1_6M]
      ,[D_2_6M]
      ,[D_3_6M]
      ,[D_1D_A]
      ,[D_2D_A]
      ,[D_3D_A]
      ,[D_P_A]
      ,[D_P_M]
      ,[D_PT_A]
      ,[D_PB_A]
      ,[D_R_M]
      ,[D_PWC_A]
      ,[D_PTC_A]
      ,[D_1MBREAK]
      ,[D_6MBREAK]
      ,[AD_AVGPP_M]
      ,[AD_AVGPP_A]
      ,[AD_AVGFP_M]
      ,[AD_AVGFP_A]
      ) 
	  
	  VALUES (@RACEID, @DOGID, @D1M, @D2M, @D3M, @D1_6M, @D2_6M, @D3_6M, @D1DA, @D2DA, @D3DA, @DPA, @DPM, @DPTA, @DPBA, @RM, @DPWCA, @DPTCA, @D_1M_BREAK, @D_6M_BREAK, @AD_AVGPP_M, @AD_AVGPP_A, @AD_AVGFP_M, @AD_AVGFP_A)
END

GO
/****** Object:  StoredProcedure [dbo].[GenerateTrackStats]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GenerateTrackStats] 

	@DATE  [date],
	@TRACKID [float]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- floaterfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @TRACKLOCATION nvarchar(255)
DECLARE @TRACKNAME nvarchar(255)
DECLARE @S_RACES float
DECLARE @S_FIRST float
DECLARE @S_FIRSTP float
DECLARE @S_FIRSTPAY float
DECLARE @S_PLACE float
DECLARE @S_PLACEP float
DECLARE @S_PLACE1PAY float
DECLARE @S_PLACE2PAY float
DECLARE @S_PLACE3PAY float
DECLARE @S_PLACEPAY float
DECLARE @S_QUIN float
DECLARE @S_QUINP float
DECLARE @S_QUINPAY float
DECLARE @P_RACES float
DECLARE @P_FIRST float
DECLARE @P_FIRSTP float
DECLARE @P_FIRSTPAY float
DECLARE @P_PLACE float
DECLARE @P_PLACEP float
DECLARE @P_PLACE1PAY float
DECLARE @P_PLACE2PAY float
DECLARE @P_PLACE3PAY float
DECLARE @P_PLACEPAY float
DECLARE @P_QUIN float
DECLARE @P_QUINP float
DECLARE @P_QUINPAY float
DECLARE @Q_RACES float
DECLARE @Q_FIRST float
DECLARE @Q_FIRSTP float
DECLARE @Q_FIRSTPAY float
DECLARE @Q_PLACE float
DECLARE @Q_PLACEP float
DECLARE @Q_PLACE1PAY float
DECLARE @Q_PLACE2PAY float
DECLARE @Q_PLACE3PAY float
DECLARE @Q_PLACEPAY float
DECLARE @Q_QUIN float
DECLARE @Q_QUINP float
DECLARE @Q_QUINPAY float


SELECT a.RACEID, a.TRACKID, c.TRACKNAME, c.TRACKLOCATION, a.DATE, a.PREDICTION, a.ACTUALRESULT, b.WINPAYING, b.PLACEPAYING, b.TWOPLACE, b.THREEPLACE, b.QUINELLAPAYING, b.TRIFECTAPAYING
INTO #TempReport
FROM ARCHIVERACES a
	INNER JOIN RACES b on a.RACEID = b.RACEID
	INNER JOIN TRACKS c on a.TRACKID = c.TRACKID
WHERE a.DATE = @DATE AND a.TRACKID = @TRACKID

-- General Info
	 SET @TRACKLOCATION = (SELECT DISTINCT TRACKLOCATION FROM #TempReport)
	 SET @TRACKNAME = (SELECT DISTINCT TRACKNAME FROM #TempReport)

-- Generate Standard Prediction Stats
	
	SET @S_RACES = (SELECT count(DISTINCT RACEID) FROM #TempReport)
	
	SET @S_FIRST = (SELECT COUNT(DISTINCT RACEID) FROM #TempReport WHERE PREDICTION = 1 AND ACTUALRESULT = 1)
	SET @S_FIRSTP = (@S_FIRST/@S_RACES)*100
	SET @S_FIRSTPAY = (SELECT SUM(WINPAYING) FROM RACES WHERE RACEID in (SELECT DISTINCT RACEID FROM #TempReport WHERE PREDICTION = 1 AND ACTUALRESULT = 1))
	SET @S_FIRSTPAY = isnull(@S_FIRSTPAY,0) - @S_RACES

	SET @S_PLACE = (SELECT count(DISTINCT RACEID) FROM #TempReport WHERE ACTUALRESULT < 4 AND PREDICTION = 1)
	SET @S_PLACEP = (@S_PLACE/@S_RACES)*100
	SET @S_PLACE1PAY = (SELECT SUM(PLACEPAYING) FROM RACES WHERE RACEID in (SELECT RACEID FROM #TempReport WHERE PREDICTION = 1 AND ACTUALRESULT = 1))
	SET @S_PLACE2PAY = (SELECT SUM(TWOPLACE) FROM RACES WHERE RACEID in (SELECT RACEID FROM #TempReport WHERE PREDICTION = 1 AND ACTUALRESULT = 2))
	SET @S_PLACE3PAY = (SELECT SUM(THREEPLACE) FROM RACES WHERE RACEID in (SELECT RACEID FROM #TempReport WHERE PREDICTION = 1 AND ACTUALRESULT = 3))
	SET @S_PLACEPAY = isnull(@S_PLACE1PAY,0) + isnull(@S_PLACE2PAY,0) + isnull(@S_PLACE3PAY,0) - @S_RACES

	SET @S_QUIN = ( SELECT COUNT(DISTINCT RACEID) FROM #TempReport WHERE RACEID IN (SELECT RACEID FROM #TempReport WHERE (PREDICTION = 1 AND (ACTUALRESULT = 1 OR ACTUALRESULT = 2)) OR (PREDICTION = 2 AND (ACTUALRESULT = 1 OR ACTUALRESULT = 2)) GROUP BY RACEID HAVING COUNT(RACEID) = 2) )
	SET @S_QUINP = (@S_QUIN/@S_RACES)*100
	SET @S_QUINPAY = ( SELECT SUM(QUINELLAPAYING) FROM RACES WHERE RACEID IN (SELECT RACEID FROM #TempReport WHERE (PREDICTION = 1 AND (ACTUALRESULT = 1 OR ACTUALRESULT = 2)) OR (PREDICTION = 2 AND (ACTUALRESULT = 1 OR ACTUALRESULT = 2)) GROUP BY RACEID HAVING COUNT(RACEID) = 2) )
	SET @S_QUINPAY = isnull(@S_QUINPAY,0) - @S_RACES

-- Generate Placing Reccomendation Stats
/*
	SET @P_RACES = (SELECT count(DISTINCT RACEID) FROM #TempReport WHERE PLACEREC = 1)
	
	SET @P_FIRST = (SELECT COUNT(DISTINCT RACEID) FROM #TempReport WHERE PLACEREC = 1 AND ACTUALRESULT = 1)
	IF @P_RACES = 0
		SET @P_FIRSTP = 0
	ELSE
		SET @P_FIRSTP = (isnull(@P_FIRST,0)/@P_RACES)*100
	SET @P_FIRSTPAY = (SELECT SUM(WINPAYING) FROM RACES WHERE RACEID in (SELECT DISTINCT RACEID FROM #TempReport WHERE PLACEREC = 1 AND ACTUALRESULT = 1))
	SET @P_FIRSTPAY = isnull(@P_FIRSTPAY,0) - @P_RACES

	SET @P_PLACE = (SELECT count(DISTINCT RACEID) FROM #TempReport WHERE ACTUALRESULT < 4 AND PLACEREC = 1)
	IF @P_RACES = 0
		SET @P_PLACEP = 0
	ELSE
		SET @P_PLACEP = (isnull(@P_PLACE,0)/@P_RACES)*100
	SET @P_PLACE1PAY = (SELECT SUM(PLACEPAYING) FROM RACES WHERE RACEID in (SELECT RACEID FROM #TempReport WHERE PLACEREC = 1 AND ACTUALRESULT = 1))
	SET @P_PLACE2PAY = (SELECT SUM(TWOPLACE) FROM RACES WHERE RACEID in (SELECT RACEID FROM #TempReport WHERE PLACEREC = 1 AND ACTUALRESULT = 2))
	SET @P_PLACE3PAY = (SELECT SUM(THREEPLACE) FROM RACES WHERE RACEID in (SELECT RACEID FROM #TempReport WHERE PLACEREC = 1 AND ACTUALRESULT = 3))
	SET @P_PLACEPAY = isnull(@P_PLACE1PAY,0) + isnull(@P_PLACE2PAY,0) + isnull(@P_PLACE3PAY,0) - @P_RACES 

	SET @P_QUIN = ( SELECT COUNT(DISTINCT RACEID) FROM #TempReport WHERE RACEID IN (SELECT RACEID FROM #TempReport WHERE (PLACEREC = 1 AND (ACTUALRESULT = 1 OR ACTUALRESULT = 2)) OR (PLACEREC = 2 AND (ACTUALRESULT = 1 OR ACTUALRESULT = 2)) GROUP BY RACEID HAVING COUNT(RACEID) = 2) )
	IF @P_RACES = 0
		SET @P_QUINP = 0
	ELSE
		SET @P_QUINP = (isnull(@P_QUIN,0)/@P_RACES)*100
	SET @P_QUINPAY = ( SELECT SUM(QUINELLAPAYING) FROM RACES WHERE RACEID IN (SELECT RACEID FROM #TempReport WHERE (PLACEREC = 1 AND (ACTUALRESULT = 1 OR ACTUALRESULT = 2)) OR (PLACEREC = 2 AND (ACTUALRESULT = 1 OR ACTUALRESULT = 2)) GROUP BY RACEID HAVING COUNT(RACEID) = 2) )
	SET @P_QUINPAY = isnull(@P_QUINPAY,0) - @P_RACES

-- Generate Quinella Reccomendation Stats

	SET @Q_RACES = (SELECT count(DISTINCT RACEID) FROM #TempReport WHERE QUINREC = 1)
	
	SET @Q_FIRST = (SELECT COUNT(DISTINCT RACEID) FROM #TempReport WHERE QUINREC = 1 AND ACTUALRESULT = 1)
	IF @Q_RACES = 0
		SET @Q_FIRSTP = 0
	ELSE
		SET @Q_FIRSTP = (isnull(@Q_FIRST,0)/@Q_RACES)*100
	SET @Q_FIRSTPAY = (SELECT SUM(WINPAYING) FROM RACES WHERE RACEID in (SELECT DISTINCT RACEID FROM #TempReport WHERE QUINREC = 1 AND ACTUALRESULT = 1))
	SET @Q_FIRSTPAY = isnull(@Q_FIRSTPAY,0) - @Q_RACES

	SET @Q_PLACE = (SELECT count(DISTINCT RACEID) FROM #TempReport WHERE ACTUALRESULT < 4 AND QUINREC = 1)
	IF @Q_RACES = 0
		SET @Q_PLACEP = 0
	ELSE
		SET @Q_PLACEP = (isnull(@Q_PLACE,0)/@Q_RACES)*100
	SET @Q_PLACE1PAY = (SELECT SUM(convert(float, PLACEPAYING)) FROM RACES WHERE RACEID in (SELECT RACEID FROM #TempReport WHERE QUINREC = 1 AND ACTUALRESULT = 1))
	SET @Q_PLACE2PAY = (SELECT SUM(convert(float, TWOPLACE)) FROM RACES WHERE RACEID in (SELECT RACEID FROM #TempReport WHERE QUINREC = 1 AND ACTUALRESULT = 2))
	SET @Q_PLACE3PAY = (SELECT SUM(convert(float, THREEPLACE)) FROM RACES WHERE RACEID in (SELECT RACEID FROM #TempReport WHERE QUINREC = 1 AND ACTUALRESULT = 3))
	SET @Q_PLACEPAY = isnull(@Q_PLACE1PAY,0) + isnull(@Q_PLACE2PAY,0) + isnull(@Q_PLACE3PAY,0) - @Q_RACES 

	SET @Q_QUIN = ( SELECT COUNT(DISTINCT RACEID) FROM #TempReport WHERE RACEID IN (SELECT RACEID FROM #TempReport WHERE (QUINREC = 1 AND (ACTUALRESULT = 1 OR ACTUALRESULT = 2)) OR (QUINREC = 2 AND (ACTUALRESULT = 1 OR ACTUALRESULT = 2)) GROUP BY RACEID HAVING COUNT(RACEID) = 2) )
	IF @Q_RACES = 0
		SET @Q_QUINP = 0
	ELSE
		SET @Q_QUINP = (isnull(@Q_QUIN,0)/@Q_RACES)*100
	SET @Q_QUINPAY = ( SELECT SUM(QUINELLAPAYING) FROM #TempReport WHERE RACEID IN (SELECT RACEID FROM #TempReport WHERE (QUINREC = 1 AND (ACTUALRESULT = 1 OR ACTUALRESULT = 2)) OR (QUINREC = 2 AND (ACTUALRESULT = 1 OR ACTUALRESULT = 2)) GROUP BY RACEID HAVING COUNT(RACEID) = 2) )
	SET @Q_QUINPAY = isnull(@Q_QUINPAY,0) - @Q_RACES
*/
	IF EXISTS (SELECT 1 FROM [STATISTICS] WHERE TRACKID = @TRACKID AND DATE = @DATE)
		UPDATE [STATISTICS] SET [TRACKID] = @TRACKID,[TRACKLOCATION] = @TRACKLOCATION,[DATE] = @DATE,[TOTALRACES] = @S_RACES,[SFIRSTS] = @S_FIRST,[SFPRCNT] = @S_FIRSTP,[SFPAY]=@S_FIRSTPAY,[SPLACES] = @S_PLACE,[SPPRCNT] = @S_PLACEP,[SPPAY] = @S_PLACEPAY,[SQUIN] = @S_QUIN,[SQPRNCT]=@S_QUINP,[SQPAY]=@S_QUINPAY,[PLACERACES]=@P_RACES,[PFIRSTS]=@P_FIRST,[PFPRCNT]=@P_FIRSTP,[PFPAY]=@P_FIRSTPAY,[PPLACES]=@P_PLACE,[PPPRCNT]=@P_PLACEP,[PPPAY]=@P_PLACEPAY,[PQUIN]=@P_QUIN,[PQPRCNT]=@P_QUINP,[PQPAY]=@P_QUINPAY,[QUINRACES]=@Q_RACES,[QFIRSTS]=@Q_FIRST,[QFPRCNT]=@Q_FIRSTP,[QFPAY]=@Q_FIRSTPAY,[QPLACES]=@Q_PLACE,[QPPRCNT]=@Q_PLACEP,[QPPAY]=@Q_PLACEPAY,[QQUIN]=@Q_QUIN,[QQPRNCT]=@Q_QUINP,[QQPAY]=@Q_QUINPAY WHERE TRACKID = @TRACKID AND DATE = @DATE
	ELSE
		INSERT INTO [STATISTICS] ([TRACKID],[TRACKLOCATION],[DATE],[TOTALRACES],[SFIRSTS],[SFPRCNT],[SFPAY],[SPLACES],[SPPRCNT],[SPPAY],[SQUIN],[SQPRNCT],[SQPAY],[PLACERACES],[PFIRSTS],[PFPRCNT],[PFPAY],[PPLACES],[PPPRCNT],[PPPAY],[PQUIN],[PQPRCNT],[PQPAY],[QUINRACES],[QFIRSTS],[QFPRCNT],[QFPAY],[QPLACES],[QPPRCNT],[QPPAY],[QQUIN],[QQPRNCT],[QQPAY])
		VALUES (@TRACKID, @TRACKLOCATION, @DATE, @S_RACES, @S_FIRST, @S_FIRSTP, @S_FIRSTPAY, @S_PLACE, @S_PLACEP, @S_PLACEPAY, @S_QUIN, @S_QUINP, @S_QUINPAY, @P_RACES, @P_FIRST, @P_FIRSTP, @P_FIRSTPAY, @P_PLACE, @P_PLACEP, @P_PLACEPAY, @P_QUIN, @P_QUINP, @P_QUINPAY, @Q_RACES, @Q_FIRST, @Q_FIRSTP, @Q_FIRSTPAY, @Q_PLACE, @Q_PLACEP, @Q_PLACEPAY, @Q_QUIN, @Q_QUINP, @Q_QUINPAY)



DROP TABLE #TempReport




END


GO
/****** Object:  StoredProcedure [dbo].[GenerateTrainingLine]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GenerateTrainingLine]
	-- Add the parameters for the stored procedure here
	@DOGID  [int],
	@RACEID [int]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @D1M float
	DECLARE @D2M float
	DECLARE @D3M float
	DECLARE @D1_6M float
	DECLARE @D2_6M float
	DECLARE @D3_6M float
	DECLARE @D1DA float
	DECLARE @D2DA float
	DECLARE @D3DA float
	DECLARE @DPA float
	DECLARE @DPM float
	DECLARE @DPTA float
	DECLARE @D1BA float
	DECLARE @D2BA float
	DECLARE @D3BA float
	DECLARE @DPBA float
	DECLARE @DSA float
	DECLARE @RM int
	DECLARE @R6M int
	DECLARE @RA int
	DECLARE @RESULT int
	DECLARE @DPWCA float
	DECLARE @DPTCA float
	DECLARE @D_1M_BREAK int
	DECLARE @D_6M_BREAK int
	DECLARE @AD_AVGPP_M float
	DECLARE @AD_AVGPP_A float
	DECLARE @AD_AVGFP_M float
	DECLARE @AD_AVGFP_A float

	DECLARE @racedate date
	DECLARE @distance int
	DECLARE @trackid int
	DECLARE @box int
	DECLARE @weather varchar(255)
	DECLARE @trackc varchar(255)

	SET @racedate = (SELECT STARTTIME FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID = @DOGID)
	SET @distance = (SELECT DISTANCE FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID = @DOGID)
	SET @trackid = (SELECT TRACKID FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID = @DOGID)
	SET @box = (SELECT BOX FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID = @DOGID)
	SET @result = (SELECT RESULT FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID = @DOGID)
	SET @weather = (SELECT WEATHER FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID = @DOGID)
	SET @trackc = (SELECT TRACKCONDITION FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID = @DOGID)

	-- Calculate position percentages for last month
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '1', 1, @D1M OUTPUT
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '2', 1, @D2M OUTPUT
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '3', 1, @D3M OUTPUT

	-- Calculate position percentages for last six month
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '1', 6, @D1_6M OUTPUT
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '2', 6, @D2_6M OUTPUT
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '3', 6, @D3_6M OUTPUT
	
	-- Calculate position percentages for last month at this distance
	EXEC CalcDogDistPosPrcnt @DOGID, @RACEID, @racedate, '1', @distance, @D1DA OUTPUT
	EXEC CalcDogDistPosPrcnt @DOGID, @RACEID, @racedate, '2', @distance, @D2DA OUTPUT
	EXEC CalcDogDistPosPrcnt @DOGID, @RACEID, @racedate, '3', @distance, @D3DA OUTPUT
	
	-- Calculate placing percentages for last month and all time
	EXEC CalcDogPlacePrcntTime @DOGID, @RACEID, @racedate, 1, @DPM OUTPUT
	EXEC CalcDogPlacePrcntTime @DOGID, @RACEID, @racedate, 900, @DPA OUTPUT

	-- Calculate placing position percentages for this track and this box
	EXEC CalcDogTrackPlacePrcnt @DOGID, @RACEID, @racedate, @trackid, @DPTA OUTPUT
	EXEC CalcDogBoxPlacePrcnt @DOGID, @RACEID, @racedate, @box, @DPBA OUTPUT

	-- Calcualte number of races in last month, six months and all time
	SET @RM = (SELECT Count(DOGID) FROM TEMP_RACEDATA 
				WHERE DOGID = @DOGID 
				AND STARTTIME >= DATEADD(MONTH, -1, @racedate)
				AND STARTTIME < @racedate
				AND RACEID <> @RACEID)
	
	SET @R6M = (SELECT Count(DOGID) FROM TEMP_RACEDATA 
				WHERE DOGID = @DOGID 
				AND STARTTIME >= DATEADD(MONTH, -6, @racedate)
				AND STARTTIME < @racedate
				AND RACEID <> @RACEID)

	SET @RA = (SELECT Count(DOGID) FROM TEMP_RACEDATA 
				WHERE DOGID = @DOGID
				AND STARTTIME < @racedate
				AND RACEID <> @RACEID)
	
	-- Calculate placing percentages for weather and track conditions
	EXEC CalcDogWeatherPlacePrcnt @DOGID, @RACEID, @racedate, @weather, @DPWCA OUTPUT
	EXEC CalcDogTCondPlacePrcnt @DOGID, @RACEID, @racedate, @trackc, @DPTCA OUTPUT

	-- Calculate if a dog has not raced in last month or six months
	IF @RM = 0 SET @D_1M_BREAK = 1 ELSE SET @D_1M_BREAK = 0
	IF @R6M = 0 SET @D_6M_BREAK = 1 ELSE SET @D_6M_BREAK = 0

	-- Calculate Placing Percentages for all other dogs in race
	EXEC CalcOtherDogPlacePrcnt @DOGID, @RACEID, @racedate, 1, @AD_AVGPP_M OUTPUT
	EXEC CalcOtherDogPlacePrcnt @DOGID, @RACEID, @racedate, 900, @AD_AVGPP_A OUTPUT

	-- Calculate First Percentages for all other dogs in race
	EXEC CalcOtherDogFirstPrcnt @DOGID, @RACEID, @racedate, 1, @AD_AVGFP_M OUTPUT
	EXEC CalcOtherDogFirstPrcnt @DOGID, @RACEID, @racedate, 900, @AD_AVGFP_A OUTPUT



	INSERT INTO TRAININGDATA ([RACEID]
      ,[DOGID]
      ,[D_1_M]
      ,[D_2_M]
      ,[D_3_M]
      ,[D_1_6M]
      ,[D_2_6M]
      ,[D_3_6M]
      ,[D_1D_A]
      ,[D_2D_A]
      ,[D_3D_A]
      ,[D_P_A]
      ,[D_P_M]
      ,[D_PT_A]
      ,[D_PB_A]
      ,[D_R_M]
      ,[D_PWC_A]
      ,[D_PTC_A]
      ,[D_1MBREAK]
      ,[D_6MBREAK]
      ,[AD_AVGPP_M]
      ,[AD_AVGPP_A]
      ,[AD_AVGFP_M]
      ,[AD_AVGFP_A]
      ,[RESULT]
      ,[DATATYPE]) 
	  
	  VALUES (@RACEID, @DOGID, @D1M, @D2M, @D3M, @D1_6M, @D2_6M, @D3_6M, @D1DA, @D2DA, @D3DA, @DPA, @DPM, @DPTA, @DPBA, @RM, @DPWCA, @DPTCA, @D_1M_BREAK, @D_6M_BREAK, @AD_AVGPP_M, @AD_AVGPP_A, @AD_AVGFP_M, @AD_AVGFP_A, @Result, 'TRAINING')

END

GO
/****** Object:  StoredProcedure [dbo].[GenerateTrainingLine2]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GenerateTrainingLine2]
	-- Add the parameters for the stored procedure here
	@DOGID  [int],
	@RACEID [int]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @D1M float
	DECLARE @D2M float
	DECLARE @D3M float
	DECLARE @D1_6M float
	DECLARE @D2_6M float
	DECLARE @D3_6M float
	DECLARE @D1DA float
	DECLARE @D2DA float
	DECLARE @D3DA float
	DECLARE @DPA float
	DECLARE @DPM float
	DECLARE @DPTA float
	DECLARE @D1BA float
	DECLARE @D2BA float
	DECLARE @D3BA float
	DECLARE @DPBA float
	DECLARE @DSA float
	DECLARE @RM int
	DECLARE @R6M int
	DECLARE @RA int
	DECLARE @RESULT int
	DECLARE @DPWCA float
	DECLARE @DPTCA float
	DECLARE @D_1M_BREAK int
	DECLARE @D_6M_BREAK int
	DECLARE @AD_AVGPP_M float
	DECLARE @AD_AVGPP_A float
	DECLARE @AD_AVGFP_M float
	DECLARE @AD_AVGFP_A float

	DECLARE @racedate date
	DECLARE @distance int
	DECLARE @trackid int
	DECLARE @box int
	DECLARE @weather varchar(255)
	DECLARE @trackc varchar(255)

	SET @racedate = (SELECT STARTTIME FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID = @DOGID)
	SET @distance = (SELECT DISTANCE FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID = @DOGID)
	SET @trackid = (SELECT TRACKID FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID = @DOGID)
	SET @box = (SELECT BOX FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID = @DOGID)
	SET @result = (SELECT RESULT FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID = @DOGID)
	SET @weather = (SELECT WEATHER FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID = @DOGID)
	SET @trackc = (SELECT TRACKCONDITION FROM TEMP_RACEDATA WHERE RACEID = @RACEID AND DOGID = @DOGID)

	-- Calculate position percentages for last month
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '1', 1, @D1M OUTPUT
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '2', 1, @D2M OUTPUT
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '3', 1, @D3M OUTPUT

	-- Calculate position percentages for last six month
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '1', 6, @D1_6M OUTPUT
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '2', 6, @D2_6M OUTPUT
	EXEC CalcDogPosPrcntTime @DOGID, @RACEID, @racedate, '3', 6, @D3_6M OUTPUT
	
	-- Calculate position percentages for last month at this distance
	EXEC CalcDogDistPosPrcnt @DOGID, @RACEID, @racedate, '1', @distance, @D1DA OUTPUT
	EXEC CalcDogDistPosPrcnt @DOGID, @RACEID, @racedate, '2', @distance, @D2DA OUTPUT
	EXEC CalcDogDistPosPrcnt @DOGID, @RACEID, @racedate, '3', @distance, @D3DA OUTPUT
	
	-- Calculate placing percentages for last month and all time
	EXEC CalcDogPlacePrcntTime @DOGID, @RACEID, @racedate, 1, @DPM OUTPUT
	EXEC CalcDogPlacePrcntTime @DOGID, @RACEID, @racedate, 900, @DPA OUTPUT

	-- Calculate placing position percentages for this track and this box
	EXEC CalcDogTrackPlacePrcnt @DOGID, @RACEID, @racedate, @trackid, @DPTA OUTPUT
	EXEC CalcDogBoxPlacePrcnt @DOGID, @RACEID, @racedate, @box, @DPBA OUTPUT

	-- Calcualte number of races in last month, six months and all time
	SET @RM = (SELECT Count(DOGID) FROM TEMP_RACEDATA 
				WHERE DOGID = @DOGID 
				AND STARTTIME >= DATEADD(MONTH, -1, @racedate)
				AND STARTTIME < @racedate
				AND RACEID <> @RACEID)
	
	SET @R6M = (SELECT Count(DOGID) FROM TEMP_RACEDATA 
				WHERE DOGID = @DOGID 
				AND STARTTIME >= DATEADD(MONTH, -6, @racedate)
				AND STARTTIME < @racedate
				AND RACEID <> @RACEID)

	SET @RA = (SELECT Count(DOGID) FROM TEMP_RACEDATA 
				WHERE DOGID = @DOGID
				AND STARTTIME < @racedate
				AND RACEID <> @RACEID)
	
	-- Calculate placing percentages for weather and track conditions
	EXEC CalcDogWeatherPlacePrcnt @DOGID, @RACEID, @racedate, @weather, @DPWCA OUTPUT
	EXEC CalcDogTCondPlacePrcnt @DOGID, @RACEID, @racedate, @trackc, @DPTCA OUTPUT

	-- Calculate if a dog has not raced in last month or six months
	IF @RM = 0 SET @D_1M_BREAK = 1 ELSE SET @D_1M_BREAK = 0
	IF @R6M = 0 SET @D_6M_BREAK = 1 ELSE SET @D_6M_BREAK = 0

	-- Calculate Placing Percentages for all other dogs in race
	EXEC CalcOtherDogPlacePrcnt @DOGID, @RACEID, @racedate, 1, @AD_AVGPP_M OUTPUT
	EXEC CalcOtherDogPlacePrcnt @DOGID, @RACEID, @racedate, 900, @AD_AVGPP_A OUTPUT

	-- Calculate First Percentages for all other dogs in race
	EXEC CalcOtherDogFirstPrcnt @DOGID, @RACEID, @racedate, 1, @AD_AVGFP_M OUTPUT
	EXEC CalcOtherDogFirstPrcnt @DOGID, @RACEID, @racedate, 900, @AD_AVGFP_A OUTPUT



	INSERT INTO TRAININGDATA ([RACEID]
      ,[DOGID]
      ,[D_1_M]
      ,[D_2_M]
      ,[D_3_M]
      ,[D_1_6M]
      ,[D_2_6M]
      ,[D_3_6M]
      ,[D_1D_A]
      ,[D_2D_A]
      ,[D_3D_A]
      ,[D_P_A]
      ,[D_P_M]
      ,[D_PT_A]
      ,[D_PB_A]
      ,[D_R_M]
      ,[D_PWC_A]
      ,[D_PTC_A]
      ,[D_1MBREAK]
      ,[D_6MBREAK]
      ,[AD_AVGPP_M]
      ,[AD_AVGPP_A]
      ,[AD_AVGFP_M]
      ,[AD_AVGFP_A]
      ,[RESULT]
      ,[DATATYPE]) 
	  
	  VALUES (@RACEID, @DOGID, @D1M, @D2M, @D3M, @D1_6M, @D2_6M, @D3_6M, @D1DA, @D2DA, @D3DA, @DPA, @DPM, @DPTA, @DPBA, @RM, @DPWCA, @DPTCA, @D_1M_BREAK, @D_6M_BREAK, @AD_AVGPP_M, @AD_AVGPP_A, @AD_AVGFP_M, @AD_AVGFP_A, @Result, 'TESTING')

END

GO
/****** Object:  StoredProcedure [dbo].[GetAllPredictions]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllPredictions] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.RACEID, b.TRACKNAME, a.RACENUMBER, a.STARTTIME, d.DOGNAME, c.PREDICTION, c.ACTUALRESULT FROM RACES a INNER JOIN TRACKS b on a.TRACKID = b.TRACKID INNER JOIN FUTURERESULTS c on a.RACEID = c.RACEID INNER JOIN DOGS d on c.DOGID = d.DOGID WHERE c.PREDICTION is not NULL ORDER BY a.STARTTIME, c.RACEID, c.PREDICTION
END

GO
/****** Object:  StoredProcedure [dbo].[GetCompletedRaces]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCompletedRaces] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [DOWNLOADID], [URL], [RACEDATE] FROM [dbo].[DOWNLOADS] WHERE [PROCESSSTATE] = 1
END

GO
/****** Object:  StoredProcedure [dbo].[GetDogID]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetDogID]
	-- Add the parameters for the stored procedure here
	@DOGNAME [varchar](255)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @CHECKDOG INT

	SET @CHECKDOG = (SELECT [DOGID] FROM [dbo].[DOGS] WHERE [DOGNAME] = @DOGNAME)

	IF @CHECKDOG is NULL
		INSERT INTO [dbo].[DOGS] ([DOGNAME]) VALUES (@DOGNAME);

	SELECT [DOGID] FROM [dbo].[DOGS] WHERE [DOGNAME] = @DOGNAME
END

GO
/****** Object:  StoredProcedure [dbo].[GetErrorRaces]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetErrorRaces] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [DOWNLOADID], [URL], [RACEDATE] FROM [dbo].[DOWNLOADS] WHERE [PROCESSSTATE] = 3
END

GO
/****** Object:  StoredProcedure [dbo].[GetFutureData]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetFutureData]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here[dbo].[GenerateTrainingLine3_TEST]
	SELECT [RACEID]
      ,[DOGID]
      ,[D_1_M]
      ,[D_2_M]
      ,[D_3_M]
      ,[D_1D_A]
      ,[D_2D_A]
      ,[D_3D_A]
      ,[D_P_A]
      ,[D_P_M]
      ,[D_PT_A]
      ,[D_PB_A]
      ,[D_R_M]
      --,[D_R_A]
  FROM [dbo].[FUTUREDATA]
END

GO
/****** Object:  StoredProcedure [dbo].[GetSingleUnprocessedRaces]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetSingleUnprocessedRaces] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @DOWNLOADID [int]
    -- Insert statements for procedure here
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

	BEGIN TRANSACTION

	
	SET @DOWNLOADID = (SELECT TOP 1 DOWNLOADID FROM DOWNLOADS WHERE ([PROCESSSTATE] is NULL or [PROCESSSTATE] = 0))
	UPDATE DOWNLOADS SET PROCESSSTATE = 4 WHERE DOWNLOADID = @DOWNLOADID

	SELECT TOP 1 [DOWNLOADID], [URL], [RACEDATE] FROM [dbo].[DOWNLOADS] WHERE DOWNLOADID = @DOWNLOADID
	COMMIT TRANSACTION

END

GO
/****** Object:  StoredProcedure [dbo].[GetTelevisedRaces]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTelevisedRaces] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [DOWNLOADID], [URL], [RACEDATE] FROM [dbo].[DOWNLOADS] WHERE [PROCESSSTATE] = 2
END

GO
/****** Object:  StoredProcedure [dbo].[GetTrackID]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTrackID]
	-- Add the parameters for the stored procedure here
	@TRACKNAME [nvarchar](255),
	@COUNTRYCODE [nvarchar](255)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @CHECKTRACK INT

	SET @CHECKTRACK = (SELECT [TRACKID] FROM [dbo].[TRACKS] WHERE [TRACKNAME] = @TRACKNAME)

	IF @CHECKTRACK is NULL
		INSERT INTO [dbo].[TRACKS] ([TRACKNAME], [TRACKLOCATION]) VALUES (@TRACKNAME, @COUNTRYCODE);

	SELECT [TRACKID] FROM [dbo].[TRACKS] WHERE [TRACKNAME] = @TRACKNAME
END

GO
/****** Object:  StoredProcedure [dbo].[GetTrainingData]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTrainingData]
	-- Add the parameters for the stored procedure here
	@NUMRECORDS [int]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here[dbo].[GenerateTrainingLine3_TEST]
	SELECT TOP (@NUMRECORDS) [RACEID]
      ,[DOGID]
      ,[D_1_M]
      ,[D_2_M]
      ,[D_3_M]
      ,[D_1D_A]
      ,[D_2D_A]
      ,[D_3D_A]
      ,[D_P_A]
      ,[D_P_M]
      ,[D_PT_A]
      ,[D_PB_A]
      ,[D_R_M]
      --,[D_R_A]
      ,[RESULT]
  FROM [dbo].[TRAININGDATA]
  ORDER BY newID()
END

GO
/****** Object:  StoredProcedure [dbo].[GetUnprocessedRaces]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetUnprocessedRaces] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [DOWNLOADID], [URL], [RACEDATE] FROM [dbo].[DOWNLOADS] WHERE ([PROCESSSTATE] is NULL or [PROCESSSTATE] = 0)
END

GO
/****** Object:  StoredProcedure [dbo].[SetFeature]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SetFeature] 
	-- Add the parameters for the stored procedure here
	@NNID nvarchar(255) NULL,
	@FEATURE nvarchar(255) NULL,
	@DESCRIPTION nvarchar(255) NULL,
	@VALUE float NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM FEATURES_DETAIL WHERE NNID = @NNID AND FEATURE = @FEATURE AND DESCRIPTION = @DESCRIPTION)
		UPDATE FEATURES_DETAIL SET NNID = @NNID, FEATURE = @FEATURE, DESCRIPTION = @DESCRIPTION, VALUE = @VALUE
	ELSE
		INSERT INTO FEATURES_DETAIL (NNID, FEATURE, DESCRIPTION, VALUE) VALUES (@NNID, @FEATURE, @DESCRIPTION, @VALUE)
END

GO
/****** Object:  StoredProcedure [dbo].[SetRaceComplete]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SetRaceComplete] 
	-- Add the parameters for the stored procedure here
	@RACEID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE RACES SET STATUS = 1 WHERE RACEID = @RACEID

END

GO
/****** Object:  StoredProcedure [dbo].[UpdateDogDetails]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateDogDetails] 
	-- Add the parameters for the stored procedure here
	@RACEID int,
	@DOGID int,
	@BOX int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS ( SELECT 1 FROM FUTURERESULTS WHERE RACEID = @RACEID AND DOGID = @DOGID )
		UPDATE FUTURERESULTS SET BOX = @BOX WHERE RACEID = @RACEID AND DOGID = @DOGID
	ELSE
		INSERT INTO FUTURERESULTS (RACEID, DOGID, BOX) SELECT @RACEID, @DOGID, @BOX

END

GO
/****** Object:  StoredProcedure [dbo].[UpdateDownloadDetails]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateDownloadDetails] 
	-- Add the parameters for the stored procedure here
	@DOWNLOADID int,
	@STATE int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[DOWNLOADS] SET [PROCESSSTATE] = @STATE WHERE [DOWNLOADID] = @DOWNLOADID
	UPDATE [dbo].[DOWNLOADS] SET [PROCESSDATE] = GETDATE() WHERE [DOWNLOADID] = @DOWNLOADID

END

GO
/****** Object:  StoredProcedure [dbo].[UpdateRaceDetails]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateRaceDetails] 
	-- Add the parameters for the stored procedure here
	@RACEID int,
	@TRACKCONDITION nvarchar(255),
	@WEATHER nvarchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE RACES SET TRACKCONDITION = @TRACKCONDITION, WEATHER = @WEATHER WHERE RACEID = @RACEID

END


GO
/****** Object:  StoredProcedure [dbo].[UpdateRacePayouts]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateRacePayouts] 
	-- Add the parameters for the stored procedure here
	@RACEID int NULL,
	@WINPAYING float = NULL,
	@PLACEPAYING float = NULL,
	@2PLACE float = NULL,
	@3PLACE float = NULL,
	@QUINELLAPAYING float = NULL,
	@TRIFECTAPAYING float = NULL,
	@FIRST4PAYING float = NULL,
	@STATUS int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS ( SELECT 1 FROM [RACES] WHERE RACEID = @RACEID )
		UPDATE RACES SET WINPAYING = @WINPAYING, PLACEPAYING = @PLACEPAYING, QUINELLAPAYING = @QUINELLAPAYING, TRIFECTAPAYING = @TRIFECTAPAYING, FIRST4PAYING = @FIRST4PAYING, TWOPLACE = @2PLACE, THREEPLACE = @3PLACE, STATUS = @STATUS WHERE RACEID = @RACEID
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateRaceResult]    Script Date: 25/09/2014 4:49:23 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateRaceResult] 
	-- Add the parameters for the stored procedure here
	@RACEID int,
	@DOGID int,
	@ACTUALRESULT int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS ( SELECT 1 FROM FUTURERESULTS WHERE RACEID = @RACEID AND DOGID = @DOGID )
		UPDATE FUTURERESULTS SET ACTUALRESULT = @ACTUALRESULT WHERE RACEID = @RACEID AND DOGID = @DOGID

END

GO
USE [master]
GO
ALTER DATABASE [Racing] SET  READ_WRITE 
GO
