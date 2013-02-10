/* create database testdb
go

use testdb
go

CREATE TABLE Person
(
P_Id int,
LastName varchar(255),
FirstName varchar(255),
Address varchar(255),
City varchar(255)
)
go

INSERT INTO Person
VALUES (4,'Nilsen', 'Johan', 'Bakken 2', 'Stavanger')
go

select * from person */

EXEC sp_MSForEachDB '
USE ? 
IF OBJECT_ID(''person'') IS NOT NULL
    PRINT ''Found in database ?''
'