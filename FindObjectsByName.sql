/*
  author:		Yong Guan
  date:			01/20/2012
  description:	Find objects by name across all tables in a database.
  limitation:	May skip database because sp_MSForEachDB is used. 
  usage:		exec FindObjectsByName 'partial/full object name'
  result:
	Objects found in database {database name}
	object name
*/
IF OBJECT_ID('FindObjectsByName') IS NOT NULL
	DROP PROC FindObjectsByName
GO

CREATE PROCEDURE FindObjectsByName
(
    @name nvarchar(300)
)
AS

DECLARE @command nvarchar(300)

SET @command = 'USE ?

DECLARE @names VARCHAR(MAX)
SELECT @names = COALESCE(@names + char(13),'''') + name
FROM dbo.sysobjects
WHERE name like ''%[object name]%''

IF @names IS NOT NULL
BEGIN
 PRINT ''Objects found in database {?}''
 PRINT @names + char(13) + char(13)
END'

SET @command =  REPLACE(@command, '[object name]', @name);

EXEC sp_MSForEachDB @command

GO

