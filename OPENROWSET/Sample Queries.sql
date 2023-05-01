
/* OPENROWSET to a server that doesn't exist */
SELECT 
	a.*  
FROM OPENROWSET(
    'SQLNCLI11', 
    'Server=chihuahua;database=Superheroes;uid=andy_local;pwd=andy_local',
    'SELECT * FROM dbo.Person Where Person_ID <= 11'
) AS a

/* Catch the error nicely */
DECLARE @SQL nvarchar(max)
BEGIN TRY 

SELECT @SQL = 'SELECT 
	a.*  
FROM OPENROWSET(
    ''SQLNCLI11'', 
    ''Server=chihuahua;database=Superheroes;uid=andy_local;pwd=andy_local'',
    ''SELECT * FROM dbo.Person Where Person_ID <= 11''
) AS a';  

EXECUTE sp_executesql @SQL

END TRY
BEGIN CATCH
	
	SELECT 'Cannot access Chihuahua'

END CATCH
GO

/* add insert statement */
CREATE TABLE #Person (Person_First_Name varchar(50), Person_Last_Name varchar(50))
DECLARE @SQL nvarchar(max)
BEGIN TRY 
	SELECT @SQL = 'SELECT 
		a.*  
	FROM OPENROWSET(
		''SQLNCLI11'', 
		''Server=chihuahua;database=Superheroes;uid=andy_local;pwd=andy_local'',
		''SELECT First_Name, Last_Name FROM dbo.Person Where Person_ID <= 11''
	) AS a';  

	INSERT INTO #Person
	EXECUTE sp_executesql @SQL
END TRY
BEGIN CATCH
	
	SELECT 'Cannot access Chihuahua'

END CATCH
GO

/* cursor for all servers */
DROP TABLE IF EXISTS #Person
CREATE TABLE #Person (Servername nvarchar(128), Person_First_Name varchar(50), Person_Last_Name varchar(50))
DECLARE @SQL nvarchar(max), @servername varchar(50)

DECLARE server_cursor SCROLL CURSOR FOR
SELECT *
FROM (VALUES ('chihuahua'), ('labrador')
	) as dogs(servername)

OPEN server_cursor

FETCH FIRST FROM server_cursor INTO @servername

WHILE @@FETCH_STATUS = 0
BEGIN 

	BEGIN TRY 
		SELECT @SQL = 'SELECT 
			a.*  
		FROM OPENROWSET(
			''SQLNCLI11'', 
			''Server=' + @servername + ';database=Superheroes_Test;uid=andy_local;pwd=andy_local'',
			''SELECT @@servername, First_Name, Last_Name FROM Villain.Person Where Person_ID <= 11''
		) AS a';  

		INSERT INTO #Person
		EXECUTE sp_executesql @SQL
	END TRY
	BEGIN CATCH
	
		SELECT 'Cannot access ' + @servername + ': ' + ERROR_MESSAGE()

	END CATCH

	FETCH NEXT FROM server_cursor INTO @servername
END

CLOSE server_cursor
DEALLOCATE server_cursor

SELECT * FROM #Person
GO

