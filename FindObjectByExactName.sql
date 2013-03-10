/*
  author:       Yong Guan
  date:         01/20/2012
  description:  Find a object by name across all tables in a database. The object can be table, sproc, function, and anything else.
  limitation:   May skip database because sp_MSForEachDB is used. 
  usage:        exec FindObjectByExactName 'tartgetObjectName'
  result:
    {object name} is found in {number} database(s)
      [database name 1]
      [database name 2]
*/
IF OBJECT_ID('FindObjectByExactName') IS NOT NULL
    DROP PROC FindObjectByExactName
GO

CREATE PROCEDURE FindObjectByExactName
(
    @name nvarchar(300)
)
AS
SET NOCOUNT ON

CREATE TABLE #db (name nvarchar(300))

DECLARE
     @command nvarchar(max)
    ,@dbCount int
    ,@dbNames nvarchar(max)
    ,@message nvarchar(300)

SET @command = 'USE ? 
IF OBJECT_ID(''[object name]'') IS NOT NULL
    INSERT INTO #db VALUES(''?'')
'

SET @command =  REPLACE(@command, '[object name]', @name)

EXEC sp_MSForEachDB @command

SELECT @dbCount = COUNT(1)
FROM #db

SELECT @dbNames = COALESCE(@dbNames + char(13), '') + name
FROM #db
ORDER BY name ASC

SET @message = '{[object name]} is found in {[db count]} database(s)' + char(13) + char(13)
SET @message = REPLACE(@message, '[object name]', @name)
SET @message = REPLACE(@message, '[db count]', COALESCE(@dbCount, 0))

PRINT @message + COALESCE(@dbNames, '')

GO