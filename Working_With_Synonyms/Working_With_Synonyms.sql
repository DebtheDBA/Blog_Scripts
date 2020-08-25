/* These examples are created by Deb the DBA for her blog post, Working with Synonym*/

/**********************************************************************/
/* Scenario One: Create Synonym for Non existing Object */

-- Confirm none of the objects exist:
IF NOT EXISTS (SELECT * FROM sys.synonyms WHERE name = 'NonexistingObject')
DROP SYNONYM NonexistingObject;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'NonexistingObject')
DROP TABLE NonexistingObject;
GO

-- Create the synonym for the nonexisting table:
IF NOT EXISTS (SELECT * FROM sys.synonyms WHERE name = 'NonexistingObject')
CREATE SYNONYM NonexistingObject FOR dbo.NonexistingObject
GO

-- Select from the synonym:
SELECT * FROM NonexistingObject
GO

-- Now create the synonym:
CREATE TABLE dbo.NonexistingObject
	(PrimaryKeyCol	int IDENTITY(1,1) NOT NULL
		CONSTRAINT pk_NonexistingObject PRIMARY KEY CLUSTERED,
	FakeColumnOne		varchar(10)	NOT NULL,
	AnotherFakeColumn	varchar(10)	NULL
	)
GO

-- Now try to select from the synonym:
SELECT * FROM NonexistingObject
GO

-- Can't have two objects in the same schema and same name in the database - even if they are different types of objects.
DROP SYNONYM NonexistingObject
GO


/**********************************************************************/
/* Scenario Two: Set the names differently 
Same as the first but setting up with different names
*/

-- confirm the referencing table isn't there.
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'NonexistingTable')
DROP TABLE dbo.NonexistingTable
GO

IF EXISTS (SELECT * FROM sys.synonyms WHERE name = 'NonexistingSynonym')
DROP SYNONYM NonexistingSynonym;
GO

-- create synonym
IF NOT EXISTS (SELECT * FROM sys.synonyms WHERE name = 'NonexistingSynonym')
CREATE SYNONYM NonexistingSynonym FOR dbo.NonexistingTable
GO

-- Select from the synonym:
SELECT * FROM NonexistingSynonym
GO

-- Now create the table:
CREATE TABLE dbo.NonexistingTable
	(PrimaryKeyCol	int IDENTITY(1,1) NOT NULL
		CONSTRAINT pk_NonexistingTable PRIMARY KEY CLUSTERED,
	FakeColumnOne		varchar(10)	NOT NULL,
	AnotherFakeColumn	varchar(10)	NULL
	)
GO

-- Select from the synonym:
SELECT * FROM NonexistingSynonym

-- Now what happens if we modify the table:
ALTER TABLE dbo.NonexistingTable
ADD YetAnotherColumn	varchar(10) NULL
GO

-- Select from the synonym:
SELECT * FROM NonexistingSynonym
GO

-- Now we can clean up:
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'NonexistingTable')
DROP TABLE dbo.NonexistingTable
GO

IF EXISTS (SELECT * FROM sys.synonyms WHERE name = 'NonexistingSynonym')
DROP SYNONYM NonexistingSynonym
GO

/**********************************************************************/
/* Scenario Three: Referencing the synonym before the object is there */

-- confirm that nothing exists 
IF EXISTS (SELECT * FROM sys.objects WHERE Name = 'TableStillNotHere')
DROP TABLE TableStillNotHere
IF EXISTS (SELECT * FROM sys.objects WHERE Name = 'vStillNotHere')
DROP VIEW vStillNotHere
IF EXISTS (SELECT * FROM sys.objects WHERE Name = 'pr_StillNotHere')
DROP PROC pr_StillNotHere
IF EXISTS (SELECT * FROM sys.synonyms WHERE name = 'StillNotHere')
DROP SYNONYM StillNotHere
GO

-- Create the synonym for the non-existant table:
CREATE SYNONYM StillNotHere for dbo.TableStillNotHere
GO

-- Create the stored proc referencing the synonym:
CREATE PROCEDURE pr_StillNotHere 
	@FilterMe bit
AS
	SELECT * 
	FROM StillNotHere
	WHERE isDataProperlyFiltered = @FilterMe
GO

-- Create the veiw over the synonym:
CREATE VIEW vStillNotHere
AS 
SELECT *
FROM StillNotHere
WHERE isDataProperlyFiltered = 1
GO

-- Create the table so we can create the view:
CREATE TABLE dbo.TableStillNotHere
	(ID	int IDENTITY(1,1) NOT NULL
		CONSTRAINT PK_TableStillNotHere PRIMARY KEY CLUSTERED,
	isDataProperlyFiltered bit NOT NULL
	)
GO

-- Now create the view:
CREATE VIEW vStillNotHere
AS 
SELECT *
FROM StillNotHere
WHERE isDataProperlyFiltered = 1
GO

-- Test the view by SELECTing from it:
SELECT * FROM vStillNotHere

-- Now let's modify the table to see what happens:
ALTER TABLE TableStillNotHere
ADD NewColumn int 
GO

-- Is there a difference between the view and the table?
SELECT * FROM vStillNotHere
SELECT * FROM StillNotHere
GO

-- Refresh the view and then redo your SELECT:
EXEC sp_refreshview vStillNotHere
GO

SELECT * FROM vStillNotHere
GO

-- Let's modify that column to change the data type:
ALTER TABLE TableStillNotHere
ALTER COLUMN NewColumn varchar(20)
GO

-- Now let's look at the meta data for the change:
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('TableStillNotHere', 'vStillNotHere')
AND COLUMN_NAME = 'NewColumn'

-- What happens when we insert data:
INSERT INTO TableStillNotHere (isDataProperlyFiltered, NewColumn)
VALUES (1, 'Varchar data')

SELECT * 
FROM vStillNotHere


-- Now that we've cleared that up, let's clean up our test objects.
IF EXISTS (SELECT * FROM sys.objects WHERE Name = 'TableStillNotHere')
DROP TABLE TableStillNotHere
IF EXISTS (SELECT * FROM sys.objects WHERE Name = 'vStillNotHere')
DROP VIEW vStillNotHere
IF EXISTS (SELECT * FROM sys.objects WHERE Name = 'pr_StillNotHere')
DROP PROC pr_StillNotHere
IF EXISTS (SELECT * FROM sys.synonyms WHERE name = 'StillNotHere')
DROP SYNONYM StillNotHere
GO
