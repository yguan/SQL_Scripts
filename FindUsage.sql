/*
  author:       Yong Guan
  date:         03/05/2013
  description:  find the usage of any string that exists in syscomments. The string can be anything.
  limitation:   none?
  usage:        exec FindUsage 'target object', [0 or 1] 1 for showing the text for all the matched objects
  result:
    {target object} are used by {number} objects:
    sql object name
*/
IF OBJECT_ID('FindUsage') IS NOT NULL
    DROP PROC FindUsage
GO

CREATE PROCEDURE FindUsage
(
    @targetObject varchar(300),
    @showText bit = 0
)
AS
SET NOCOUNT ON

DECLARE @objectNames varchar(max), @message varchar(225), @count int

SELECT DISTINCT o.name, c.text
INTO #names
FROM syscomments c
INNER JOIN sysobjects o ON c.id = o.id
WHERE c.text LIKE '%' + @targetObject + '%'
    and o.name <> @targetObject
ORDER BY o.name ASC

SELECT @objectNames = COALESCE(@objectNames + char(13), '') + name
FROM #names

SELECT @count = COUNT(*) FROM #names

SET @message = '{[object name]} is used by {[count]} objects.' + char(13)
SET @message = REPLACE(@message, '[object name]', @targetObject)
SET @message = REPLACE(@message, '[count]', @count)

PRINT REPLACE(@message, '[object name]', @targetObject)
PRINT @objectNames

IF @showText = 1
BEGIN
    DECLARE @text varchar(max), @name varchar(max)
    
    DECLARE textCursor CURSOR FOR
    SELECT name, text
    FROM #names

    OPEN textCursor
    FETCH NEXT FROM textCursor INTO @name, @text

    WHILE (@@FETCH_STATUS = 0)  
    BEGIN
        PRINT char(13) + char(13) + '---------------------- ' + @name + ' ----------------------' + @text 

        FETCH NEXT FROM textCursor INTO @name, @text
    END

    CLOSE textCursor
    DEALLOCATE textCursor

END
    
GO
