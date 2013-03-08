/*
  author:       Yong Guan
  date:         01/20/2012
  description:  Find objects by name across all tables in a database.
  limitation:   May skip database because sp_MSForEachDB is used. 
  usage:        exec FindObjectsByName 'partial/full object name'
  result:
    {number} objects are found in database {database name}
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
SET NOCOUNT ON

CREATE TABLE #dbCount (isFound int)
INSERT INTO #dbCount VALUES(0)

DECLARE @command nvarchar(max)

SET @command = 'USE ?

SET NOCOUNT ON

DECLARE @objectCount int

SELECT DISTINCT name
INTO #db
FROM sysobjects
WHERE name like ''%[object name]%''

SELECT @objectCount = COUNT(*)
FROM #db


IF @objectCount > 0
BEGIN
    UPDATE #dbCount SET isFound = 1
    
    DECLARE @objectNames nvarchar(max)
    
    SELECT @objectNames = COALESCE(@objectNames + char(13), '''') + name
    FROM #db
    
    PRINT REPLACE(''{[object count]} object(s) found in database {?}'', ''[object count]'', @objectCount)
    PRINT @objectNames + char(13) + char(13)
END'

SET @command =  REPLACE(@command, '[object name]', @name);

EXEC sp_MSForEachDB @command

IF EXISTS(SELECT 1 FROM #dbCount WHERE isFound = 0)
    PRINT '{' + @name + '} is not found'

GO
