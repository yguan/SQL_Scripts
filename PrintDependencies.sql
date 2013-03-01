/*
  author:       Yong Guan
  date:         01/18/2012
  description:  generate dependency graph for any tables that depend on the target table
  limitation:   this stored procedure cannot find dependency in dynamic SQL
  usage:        exec PrintDependencies 'tartgetTableName', 'tartgetTableName'
  result:
    table1 -> table2
    table2 -> table3
    table3 -> targetTable
  visualize the dependency graph:
    go to http://arborjs.org/halfviz/# to paste the generated output the left pane of the page
*/
IF OBJECT_ID('PrintDependencies') IS NOT NULL
    DROP PROC PrintDependencies
GO

CREATE PROCEDURE PrintDependencies
(
    @referenced_entity_name varchar(300),
    @previous_referenced_entity_name varchar(300)
)
AS
SET NOCOUNT ON
DECLARE @sub_obj_name_1 varchar(300)
DECLARE @sub_obj_name_2 varchar(300)

PRINT @referenced_entity_name + '->' + @previous_referenced_entity_name

DECLARE myCursor CURSOR LOCAL FOR 
    SELECT DISTINCT OBJECT_NAME(d.referencing_id), @referenced_entity_name
    FROM sys.sql_expression_dependencies d
    WHERE d.referenced_entity_name = @referenced_entity_name
OPEN myCursor
FETCH NEXT FROM myCursor INTO @sub_obj_name_1, @sub_obj_name_2
WHILE @@FETCH_STATUS = 0 BEGIN 
    EXEC PrintDependencies @sub_obj_name_1, @sub_obj_name_2
    FETCH NEXT FROM myCursor INTO @sub_obj_name_1, @sub_obj_name_2
END
CLOSE myCursor
DEALLOCATE myCursor
GO

