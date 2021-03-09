/*
Let's look at all the datetime options:
*/

SET NOCOUNT ON 

DECLARE @date date = getdate(),
    @time time = getdate(),
    @smalldatetime smalldatetime = getdate(),
    @datetime datetime = getdate(),
    @datetime2 datetime2 = getdate(),
    @datetimeoffset datetimeoffset = getdate()

SELECT @date as 'date'
SELECT @time as 'time'
SELECT @smalldatetime as 'smalldatetime'
SELECT @datetime as 'datetime'
SELECT @datetime2 as 'datetime2'
SELECT @datetimeoffset as 'datetimeoffset'    

GO

/*
Now let's see these as varbinary:
*/

DECLARE @date date = getdate(),
    @time time = getdate(),
    @smalldatetime smalldatetime = getdate(),
    @datetime datetime = getdate(),
    @datetime2 datetime2 = getdate(),
    @datetimeoffset datetimeoffset = getdate()

SELECT convert(varbinary(20), @date) as 'date'
SELECT convert(varbinary(20), @time) as 'time'
SELECT convert(varbinary(20), @smalldatetime) as 'smalldatetime'
SELECT convert(varbinary(20), @datetime) as 'datetime'
SELECT convert(varbinary(20), @datetime2) as 'datetime2'
SELECT convert(varbinary(20), @datetimeoffset) as 'datetimeoffset'    
