/* Create log table */

CREATE TABLE demo.AuditLog 
(	LogID	INT IDENTITY(1,1) NOT NULL
		CONSTRAINT PK_AuditLog PRIMARY KEY CLUSTERED,
	LogTime	DATETIME NOT NULL
		CONSTRAINT DF_AuditLog_LogTime DEFAULT GETDATE(),
	ProcessName	VARCHAR(30),
	ActionType	VARCHAR(30),
	RowAffected	INT,
	ErrorMsg	VARCHAR(500)
)

/* Insert initial base records */

INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Full Process','Start', NULL

INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process A','Start', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process A','Step 1', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process A','Step 1', 10000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process A','Step 2', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process A','Step 2', 15000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process A','Step 3', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process A','Step 3', 1000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process A','Step 4', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process A','Step 4', 20000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process A','Step 5', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process A','Step 5', 15000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process A','End', NULL

INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process B','Start', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process B','Step 1', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process B','Step 1', 1000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process B','Step 2', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process B','Step 2', 2000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process B','Step 3', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process B','Step 3', 3000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process B','End', NULL

INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Start', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Step 1', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Step 1', 10000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Step 2', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Step 2', 19000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Step 3', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Step 3', 9000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Step 4', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Step 4', 18000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Step 5', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Step 5', 7000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Step 6', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Step 6', 14000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Step 7', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Step 7', 10000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Step 8', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','Step 8', 15000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process C','End', NULL

INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process D','Start', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process D','Step 1', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process D','Step 1', 1000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process D','Step 2', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process D','Step 2', 2000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process D','Step 3', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process D','Step 3', 3000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process D','Step 4', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process D','Step 4', 4000 
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process D','Step 5', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process D','Step 5', 5000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process D','Step 6', NULL
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process D','Step 6', 6000
INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Process D','End', NULL

INSERT INTO demo.AuditLog (ProcessName, ActionType, RowAffected) SELECT 'Full Process','End', NULL

/* create dummy table for calculated rows and time parts */
CREATE TABLE #TimeTable (
	TimeTableID TINYINT IDENTITY(1,1),
	TimePart TIME,
	CalculatedRows INT
	)

/* create data from history table */
INSERT INTO #TimeTable
(
    TimePart,
    CalculatedRows
)
SELECT TOP 60
	CONVERT(TIME, TransactionDate), 12 * COUNT(*) * SUM(CONVERT(INT, TransactionDate))
FROM dbo.SalesHistory 
WHERE CONVERT(TIME, TransactionDate) > '00:00:00.000'
AND CONVERT(TIME, TransactionDate) < '05:00:00.000'
GROUP BY CONVERT(TIME, TransactionDate) 
ORDER BY CONVERT(TIME, TransactionDate) 

/* create update based on this first subset of data */
SELECT 
	LogID, 
    LogTime + CONVERT(DATETIME, SUBSTRING(CONVERT(VARCHAR(15), timepart), 4, 5) + ':00') AS LogTime,
    ProcessName,
    ActionType,
	CASE WHEN RowAffected IS NOT NULL THEN CalculatedRows ELSE NULL END AS RowAffected,
    ErrorMsg 
--UPDATE al SET al.LogTime = LogTime + CONVERT(DATETIME, SUBSTRING(CONVERT(VARCHAR(15), timepart), 4, 5) + ':00') ,
--	al.RowAffected = CASE WHEN RowAffected IS NOT NULL THEN CalculatedRows ELSE NULL END 
FROM demo.AuditLog AS al
	JOIN #TimeTable ON logid = TimeTableID

/* clear out the data */
TRUNCATE TABLE #TimeTable

/* create dummy data reversing the order */
INSERT INTO #TimeTable
(
    TimePart,
    CalculatedRows
)
SELECT TOP 60
	CONVERT(TIME, TransactionDate), 12 * COUNT(*) * SUM(CONVERT(INT, TransactionDate))
FROM dbo.SalesHistory 
WHERE CONVERT(TIME, TransactionDate) > '00:00:00.000'
AND CONVERT(TIME, TransactionDate) < '05:00:00.000'
GROUP BY CONVERT(TIME, TransactionDate) 
ORDER BY CONVERT(TIME, TransactionDate) DESC

/* create a "second" run based on the initial data and the new dummy data set*/
INSERT INTO demo.AuditLog
(
    LogTime,
    ProcessName,
    ActionType,
    RowAffected,
    ErrorMsg
)
SELECT --al.LogID,
       DATEADD(HOUR, 3, LogTime) + CONVERT(DATETIME, '00:' + SUBSTRING(CONVERT(VARCHAR(15), timepart), 1, 5) ) AS LogTime,
       al.ProcessName,
       al.ActionType,
       al.RowAffected,
       al.ErrorMsg
FROM demo.AuditLog AS al
	JOIN #TimeTable ON logid = TimeTableID

/* create the report query */
-- step 1: confirm the matches
SELECT LogID,
	LogTime,
	ProcessName,
	ActionType,
	RowAffected,
	ErrorMsg,
	CASE WHEN ActionType = 'End' 
		THEN LAG(LogID, 1, NULL) 
				OVER(PARTITION BY ProcessName, 
					CASE WHEN ActionType IN ('Start', 'End') THEN 'Start/End' ELSE ActionType END 
				ORDER BY LogID)
		WHEN RowAffected IS NOT NULL
		THEN LAG(LogID, 1, NULL) OVER(PARTITION BY ProcessName ORDER BY LogID)
		ELSE LogID 
	END AS BeginningLogID,
	CASE WHEN ActionType = 'End' OR RowAffected IS NOT NULL
		THEN LogID 
		WHEN ActionType = 'Start' OR RowAffected IS NULL
		THEN LEAD(LogID, 1, NULL) 
			OVER(PARTITION BY ProcessName, 
					CASE WHEN ActionType IN ('Start', 'End') THEN 'Start/End' ELSE ActionType END 
				ORDER BY LogID)
		ELSE NULL
	END AS EndingLogID,
	LAG(LogID, 1, NULL) OVER(ORDER BY LogID) AS PreviousLogID,
	LAG(LogID, 1, NULL) OVER(PARTITION BY ProcessName ORDER BY LogID) AS PreviousGroupLogID,
	LEAD(LogID, 1, NULL) OVER(ORDER BY LogID) AS NexLogID,
	LEAD(LogID, 1, NULL) OVER(PARTITION BY ProcessName ORDER BY LogID) AS NextGroupLogID
FROM demo.AuditLog	

-- step 2: make the report

SELECT grp.BeginningLogID AS PairID,
	ProcessName, ActionType, 
	MAX(CASE WHEN LogID = grp.BeginningLogID THEN LogTime ELSE NULL END) AS StartTime,
	MAX(CASE WHEN LogID = grp.EndingLogID THEN LogTime ELSE NULL END) AS EndTime,
	DATEDIFF(SECOND, 
		MAX(CASE WHEN LogID = grp.BeginningLogID THEN LogTime ELSE NULL END),
		MAX(CASE WHEN LogID = grp.EndingLogID THEN LogTime ELSE NULL END)
	) AS Duration_Secs, 
	MAX(grp.RowAffected) AS RowsAffected,
	STRING_AGG(grp.ErrorMsg, '; ') AS ErrorMessages
FROM (
	SELECT LogID,
		LogTime,
		ProcessName,
		CASE WHEN ActionType IN ('Start', 'End') THEN 'Start/End' ELSE ActionType END AS ActionType,
		RowAffected,
		ErrorMsg,
		CASE WHEN ActionType = 'End' 
			THEN LAG(LogID, 1, NULL) 
					OVER(PARTITION BY ProcessName, 
						CASE WHEN ActionType IN ('Start', 'End') THEN 'Start/End' ELSE ActionType END 
					ORDER BY LogID)
			WHEN RowAffected IS NOT NULL
			THEN LAG(LogID, 1, NULL) OVER(PARTITION BY ProcessName ORDER BY LogID)
			ELSE LogID 
		END AS BeginningLogID,
		CASE WHEN ActionType = 'End' OR RowAffected IS NOT NULL
			THEN LogID 
			WHEN ActionType = 'Start' OR RowAffected IS NULL
			THEN LEAD(LogID, 1, NULL) 
				OVER(PARTITION BY ProcessName, 
						CASE WHEN ActionType IN ('Start', 'End') THEN 'Start/End' ELSE ActionType END 
					ORDER BY LogID)
			ELSE NULL
		END AS EndingLogID
	FROM demo.AuditLog	
	) AS grp
GROUP BY grp.BeginningLogID,
         grp.ProcessName,
         grp.ActionType
