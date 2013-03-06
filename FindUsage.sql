/*
  author:       Yong Guan
  date:         03/05/2013
  description:  find the usage of any string that exists in syscomments. The string can be anything.
  limitation:   none?
  usage:        exec FindUsage 'target object'
  result:
    {target object} are used by the following objects:
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

DECLARE @objectNames VARCHAR(MAX)

SELECT @objectNames = COALESCE(@objectNames + char(13), '') + o.name
FROM syscomments c
INNER JOIN sysobjects o ON c.id = o.id
WHERE c.TEXT LIKE '%' + @targetObject + '%'
    and o.name <> @targetObject

PRINT '{' + @targetObject + '} is used by the following objects:'
PRINT @objectNames
    
GO

