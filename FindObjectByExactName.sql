/*
  author:       Yong Guan
  date:         01/20/2012
  description:  Find a object by name across all tables in a database. The object can be table, sproc, function, and anything else.
  limitation:   May skip database because sp_MSForEachDB is used. 
  usage:        exec FindObjectByExactName 'tartgetObjectName'
  result:
    {object name} found in database
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

DECLARE @command nvarchar(300)

SET @command = 'USE ? 
IF OBJECT_ID(''[object name]'') IS NOT NULL
    PRINT '' ?''
'

SET @command =  REPLACE(@command, '[object name]', @name);

PRINT '{' + @name + '} found in database '
EXEC sp_MSForEachDB @command

GO

