/*
  author:       Yong Guan
  date:         02/16/2012
  description:
    Generate the creation script for all views, functions, and stored procedures in a database
    and sort them by name ascending.
  use case:
    When comparing two version of database for database, a sorted order list make the comparision
    a lot easier.
*/

DECLARE @objectName nvarchar(200)

-- list all views
------------------------------------
DECLARE view_name_cursor CURSOR FOR 
SELECT name
FROM sys.views
ORDER BY name ASC

OPEN view_name_cursor

FETCH NEXT FROM view_name_cursor 
INTO @objectName

WHILE @@FETCH_STATUS = 0
BEGIN
    exec sp_helptext @objname = @objectName
    FETCH NEXT FROM view_name_cursor 
    INTO @objectName
END
CLOSE view_name_cursor
DEALLOCATE view_name_cursor

-- list all functions
------------------------------------
DECLARE function_name_cursor CURSOR FOR 
SELECT specific_name
FROM information_schema.routines
WHERE routine_type='function'
ORDER BY specific_name ASC

OPEN function_name_cursor

FETCH NEXT FROM function_name_cursor 
INTO @objectName

WHILE @@FETCH_STATUS = 0
BEGIN
    exec sp_helptext @objname = @objectName
    FETCH NEXT FROM function_name_cursor 
    INTO @objectName
END
CLOSE function_name_cursor
DEALLOCATE function_name_cursor

-- list all sprocs
------------------------------------
DECLARE sproc_name_cursor CURSOR FOR 
SELECT name
FROM sys.procedures
ORDER BY name ASC

OPEN sproc_name_cursor

FETCH NEXT FROM sproc_name_cursor 
INTO @objectName

WHILE @@FETCH_STATUS = 0
BEGIN
    exec sp_helptext @objname = @objectName
    FETCH NEXT FROM sproc_name_cursor 
    INTO @objectName
END
CLOSE sproc_name_cursor
DEALLOCATE sproc_name_cursor

