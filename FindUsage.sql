/*
  author:       Yong Guan
  date:         03/05/2013
  description:  find the usage of any string that exists in syscomments. The string can be anything.
  limitation:   none?
  usage:        exec FindUsage 'target object'
  result:
    {target object} are used by {number} objects:
    sql object name
*/
IF OBJECT_ID('FindUsage') IS NOT NULL
    DROP PROC FindUsage
GO

CREATE PROCEDURE FindUsage
(
    @targetObject varchar(300)
)
AS
SET NOCOUNT ON

DECLARE @objectNames VARCHAR(MAX), @message VARCHAR(225), @count int

SELECT DISTINCT o.name
INTO #names
FROM syscomments c
INNER JOIN sysobjects o ON c.id = o.id
WHERE c.TEXT LIKE '%' + @targetObject + '%'
    and o.name <> @targetObject

SELECT @objectNames = COALESCE(@objectNames + char(13), '') + name
FROM #names
ORDER BY name ASC

SELECT @count = COUNT(*) FROM #names

SET @message = '{[object name]} is used by {[count]} objects.' + char(13)
SET @message = REPLACE(@message, '[object name]', @targetObject)
SET @message = REPLACE(@message, '[count]', @count)

PRINT REPLACE(@message, '[object name]', @targetObject)
PRINT @objectNames
    
GO
