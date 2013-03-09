# SQL Utility Scripts

This repository contains some useful SQL stored procedures and functions. Each file contains the usage information and output results.

`Most of the scripts can be easily modified to be used Oracle or MySQL.`

## Find Dependencies of A SQL object in A Database

The stored procedures described in this section allow you to find the objects that use the target object directly and indirectly. For example, if stored procedure 1 uses the target table, and stored procedure 2 use stored procedure 1, stored procedure 2 will be shown in the results.

`PrintDependencies.sql`
* It looks at sys.sql_expression_dependencies to figure out the dependencies, and it only support exact name search. It doesn't find the object used in dynamic SQL.

`PrintDependenciesThroughComment.sql`
* It looks at syscomments to figure out the dependencies, and even find the object even if it is used in dynamic SQL. It also supports partial name and wild card character (% or _) search.

The output of these stored procedures are in the format of `[object 1] -> [target object]`. It means that [object 1] uses [target object].

If you want to visualize the dependencies, you can copy the output, and paste it into [arbor.js's graph visualization page](http://arborjs.org/halfviz). You can add this color settings `{color:#b01700}` to the visualization page as a new line to make the text more readable.

## Find object across all databases in a database server

The stored procedures described in this section allow you to find the databases that contains the target object.

`FindObjectByExactName.sql`
* It only searches the target object by the exact name specifies in the parameter.

`FindObjectsByName.sql`
* It searches the target object with the LIKE clause, that is, partial name and wild card characters are supported.

## Find the Usage of A SQL Object in A Database

`FindUsage.sql`
* It find the objects that uses the target object directly.
* It support partial name and wild card characters.

## Generate All Views, Stored Procedures, and Functions for the Ease of Comparision

`listSprocText.sql`
* It is only a SQL script.
* It output the creation scripts for views, stored procedures, and functions order by name in group. It sort the script within each group.

If you're looking script to generate table creation script, here is the [stackoverflow post](http://stackoverflow.com/questions/21547/in-sql-server-how-do-i-generate-a-create-table-statement-for-a-given-table).

You can always use SQL Management Studio to generate the creation script for everything, and [here](http://stackoverflow.com/questions/11564219/generate-create-table-scripts-using-management-studio) is how to do it.
