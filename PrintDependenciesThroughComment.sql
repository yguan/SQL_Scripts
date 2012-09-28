-- drop proc PrintDependenciesThroughComment

/*
  author:		Yong Guan
  date:			01/18/2012
  description:	generate dependency graph for any tables that depend on the target table
  limitation:	this stored procedure will create dependency for any tables list in the comments
  usage:		exec PrintDependenciesThroughComment 'tartgetTableName', 'tartgetTableName'
  result:
	table1 -> table2
	table2 -> table3
	table3 -> targetTable
  visualize the dependency graph:
	go to http://arborjs.org/halfviz/# to paste the generated output the left pane of the page
*/

CREATE PROCEDURE PrintDependenciesThroughComment
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
	SELECT DISTINCT o.name, @referenced_entity_name
	FROM syscomments c
	INNER JOIN sysobjects o ON c.id=o.id
	WHERE c.TEXT LIKE '%' + @referenced_entity_name + '%'
		and o.name <> @referenced_entity_name
OPEN myCursor
FETCH NEXT FROM myCursor INTO @sub_obj_name_1, @sub_obj_name_2
WHILE @@FETCH_STATUS = 0 BEGIN 
    EXEC PrintDependencies @sub_obj_name_1, @sub_obj_name_2
    FETCH NEXT FROM myCursor INTO @sub_obj_name_1, @sub_obj_name_2
END
CLOSE myCursor
DEALLOCATE myCursor
GO

