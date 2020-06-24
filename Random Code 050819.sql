SELECT *
INTO #VF
FROM RNCVoterSnapshot.dbo.USVoterFile (NOLOCK)
WHERE State = 'MO' 
GO

SELECT State, RNC_RegID, TurnoutGeneral
INTO #VS_Feb
FROM (
	SELECT CONVERT(UNIQUEIDENTIFIER,REPLACE(REPLACE([RNC_RegID],'}',''),'{','')) RNC_RegID
		, CONVERT(VARCHAR(2),[State]) State
		, CONVERT(DECIMAL(8,6),[TurnoutGeneral_RNC_2_17]) TurnoutGeneral
	FROM [voterscores_staging].[dbo].[Scores_Reporting_Feb]
	WHERE State = 'MO'
) a

SELECT State, RNC_RegID, RBallot, DBallot, (RBallot - DBallot) NetBallot
INTO #VS_6
FROM (
	SELECT CONVERT(UNIQUEIDENTIFIER,REPLACE(REPLACE([RNC_RegID],'}',''),'{','')) RNC_RegID
		, CONVERT(VARCHAR(2),[State]) State
		, CONVERT(DECIMAL(8,6),[DBallot_RNCw_R6]) DBallot
		, CONVERT(DECIMAL(8,6),[RBallot_RNCw_R6]) RBallot
	FROM [voterscores_staging].[dbo].[Scores_Reporting_Rd6]
	WHERE State = 'MO'
) a


SELECT b.*, TurnoutGeneral
INTO #VS
FROM #VS_Feb a
JOIN #VS_6 b ON a.RNC_RegID = b.RNC_RegID
GO

DROP TABLE #VS_Feb
DROP TABLE #VS_6

--------------------------------------------------------------------------------------------------------------------------------------------------


SELECT 'GOTV Tier 1' Univ, COUNT(a.RNC_RegID) Voters, COUNT(DISTINCT HHSEQ) Households, AVG(RBallot) AvgRBal, AVG(DBallot) AvgDBal, AVG(TurnoutGeneral) AvgTO
FROM #VF a
	JOIN #VS b ON a.RNC_RegID = b.RNC_RegID
WHERE NetBallot >= .4 AND TurnoutGeneral BETWEEN .35 AND .8
UNION ALL
SELECT 'GOTV Tier 2' Univ, COUNT(a.RNC_RegID) Voters, COUNT(DISTINCT HHSEQ) Households, AVG(RBallot) AvgRBal, AVG(DBallot) AvgDBal, AVG(TurnoutGeneral) AvgTO
FROM #VF a
	JOIN #VS b ON a.RNC_RegID = b.RNC_RegID
WHERE NetBallot >= .3 AND TurnoutGeneral <= .35
UNION ALL
SELECT 'GOP Lean' Univ, COUNT(a.RNC_RegID) Voters, COUNT(DISTINCT HHSEQ) Households, AVG(RBallot) AvgRBal, AVG(DBallot) AvgDBal, AVG(TurnoutGeneral) AvgTO
FROM #VF a
	JOIN #VS b ON a.RNC_RegID = b.RNC_RegID
WHERE NetBallot BETWEEN .3 AND .4 AND TurnoutGeneral >= .35
UNION ALL
SELECT 'In The Bank' Univ, COUNT(a.RNC_RegID) Voters, COUNT(DISTINCT HHSEQ) Households, AVG(RBallot) AvgRBal, AVG(DBallot) AvgDBal, AVG(TurnoutGeneral) AvgTO
FROM #VF a
	JOIN #VS b ON a.RNC_RegID = b.RNC_RegID
WHERE NetBallot >= .4 AND TurnoutGeneral >= .8
UNION ALL
SELECT 'Swing' Univ, COUNT(a.RNC_RegID) Voters, COUNT(DISTINCT HHSEQ) Households, AVG(RBallot) AvgRBal, AVG(DBallot) AvgDBal, AVG(TurnoutGeneral) AvgTO
FROM #VF a
	JOIN #VS b ON a.RNC_RegID = b.RNC_RegID
WHERE NetBallot BETWEEN -.3 AND .3 AND TurnoutGeneral >= .4



SELECT 'GOTV1' Univ, a.RNC_RegID
INTO #UNIVERSES
FROM #VF a
	JOIN #VS b ON a.RNC_RegID = b.RNC_RegID
WHERE NetBallot >= .4 AND TurnoutGeneral BETWEEN .35 AND .8
UNION ALL
SELECT 'GOTV2' Univ, a.RNC_RegID
FROM #VF a
	JOIN #VS b ON a.RNC_RegID = b.RNC_RegID
WHERE NetBallot >= .3 AND TurnoutGeneral <= .35
UNION ALL
SELECT 'hGOP Lean' Univ, a.RNC_RegID
FROM #VF a
	JOIN #VS b ON a.RNC_RegID = b.RNC_RegID
WHERE NetBallot BETWEEN .3 AND .4 AND TurnoutGeneral >= .35
UNION ALL
SELECT 'ITB' Univ, a.RNC_RegID
FROM #VF a
	JOIN #VS b ON a.RNC_RegID = b.RNC_RegID
WHERE NetBallot >= .4 AND TurnoutGeneral >= .8
UNION ALL
SELECT 'SWING' Univ, a.RNC_RegID
FROM #VF a
	JOIN #VS b ON a.RNC_RegID = b.RNC_RegID
WHERE NetBallot BETWEEN -.3 AND .3 AND TurnoutGeneral >= .4


-----------------------------------------------------------------------------------------------------------------------


SELECT Univ, COUNT(DISTINCT a.RNC_RegID) Voters, COUNT(DISTINCT HHSEQ) Households, AVG(NetBallot) NetBallot, AVG(TurnoutGeneral) TurnoutGeneral, SUM(LEN(VH16G)) VH16G, SUM(LEN(VH16P)) VH16P, SUM(LEN(VH14G)) VH14G, SUM(LEN(VH14P)) VH14P
FROM #UNIVERSES a
	JOIN #VF b ON a.RNC_RegID = b.RNC_RegID
	JOIN #VS c ON a.RNC_RegID = c.RNC_RegID
GROUP BY Univ
ORDER BY Univ


SELECT FIPS, a.Univ, (Voters * 1.000) / (TotalUniv * 1.000) SOV
FROM (
	SELECT LEFT(Juriscode,5) FIPS, Univ, COUNT(*) Voters
	FROM #VF a
		JOIN #UNIVERSES b ON a.RNC_RegID = b.RNC_RegID
	GROUP BY LEFT(Juriscode,5), Univ
) a
	JOIN (
		SELECT Univ, COUNT(*) TotalUniv
		FROM #VF a
			JOIN #UNIVERSES b ON a.RNC_RegID = b.RNC_RegID
		GROUP BY Univ
	) b ON a.Univ = b.Univ


SELECT Univ, AgeRange, COUNT(*) Count
FROM #UNIVERSES a
	JOIN #VF b ON a.RNC_RegID = b.RNC_RegID
GROUP BY Univ, AgeRange
ORDER BY Univ, AgeRange

SELECT Univ, Sex, COUNT(*) Count
FROM #UNIVERSES a
	JOIN #VF b ON a.RNC_RegID = b.RNC_RegID
GROUP BY Univ, Sex
ORDER BY Univ, Sex

SELECT Univ, CASE WHEN RNCCalcParty IN (1,2) THEN 'GOP' WHEN RNCCalcParty = 3 THEN 'Other' WHEN RNCCalcParty IN (4,5) THEN 'Dem' END AS RNCCalcParty
	, COUNT(*) Count
FROM #UNIVERSES a
	JOIN #VF b ON a.RNC_RegID = b.RNC_RegID
GROUP BY Univ, CASE WHEN RNCCalcParty IN (1,2) THEN 'GOP' WHEN RNCCalcParty = 3 THEN 'Other' WHEN RNCCalcParty IN (4,5) THEN 'Dem' END 
ORDER BY Univ, CASE WHEN RNCCalcParty IN (1,2) THEN 'GOP' WHEN RNCCalcParty = 3 THEN 'Other' WHEN RNCCalcParty IN (4,5) THEN 'Dem' END 

SELECT Univ, Ethnicity_ModeledEthnicGroupName, COUNT(*) Count
FROM #UNIVERSES a
	JOIN #VF b ON a.RNC_RegID = b.RNC_RegID
GROUP BY Univ, Ethnicity_ModeledEthnicGroupName
ORDER BY Univ, Ethnicity_ModeledEthnicGroupName

SELECT Univ, CASE WHEN VoterStatus IN ('A','I') THEN VoterStatus ELSE 'Unknown' END VoterStatus
	, COUNT(*) Count
FROM #UNIVERSES a
	JOIN #VF b ON a.RNC_RegID = b.RNC_RegID
GROUP BY Univ, CASE WHEN VoterStatus IN ('A','I') THEN VoterStatus ELSE 'Unknown' END
ORDER BY Univ, CASE WHEN VoterStatus IN ('A','I') THEN VoterStatus ELSE 'Unknown' END


SELECT Univ, CASE WHEN LEN(AreaCode) + LEN(TelephoneNum) = 10 AND TelReliability BETWEEN 7 AND 9 THEN 'TRC 7-9'
			WHEN LEN(AreaCode) + LEN(TelephoneNum) = 10 AND TelReliability <= 6 THEN 'TRC 3-6'
			WHEN LEN(AreaCode) + LEN(TelephoneNum) <> 10 THEN 'No Phone' END TRC, COUNT(*) Count
FROM #UNIVERSES a
	JOIN #VF b ON a.RNC_RegID = b.RNC_RegID
GROUP BY Univ, CASE WHEN LEN(AreaCode) + LEN(TelephoneNum) = 10 AND TelReliability BETWEEN 7 AND 9 THEN 'TRC 7-9'
			WHEN LEN(AreaCode) + LEN(TelephoneNum) = 10 AND TelReliability <= 6 THEN 'TRC 3-6'
			WHEN LEN(AreaCode) + LEN(TelephoneNum) <> 10 THEN 'No Phone' END
ORDER BY Univ, CASE WHEN LEN(AreaCode) + LEN(TelephoneNum) = 10 AND TelReliability BETWEEN 7 AND 9 THEN 'TRC 7-9'
			WHEN LEN(AreaCode) + LEN(TelephoneNum) = 10 AND TelReliability <= 6 THEN 'TRC 3-6'
			WHEN LEN(AreaCode) + LEN(TelephoneNum) <> 10 THEN 'No Phone' END


SELECT Univ, CONVERT(VARCHAR(2),LEN(VH16G)+LEN(VH14G)+LEN(VH12G)+LEN(VH10G)) + ' of 4' AS VH_G, COUNT(*) Count
FROM #UNIVERSES a
	JOIN #VF b ON a.RNC_RegID = b.RNC_RegID
GROUP BY Univ, CONVERT(VARCHAR(2),LEN(VH16G)+LEN(VH14G)+LEN(VH12G)+LEN(VH10G)) + ' of 4'
ORDER BY Univ, CONVERT(VARCHAR(2),LEN(VH16G)+LEN(VH14G)+LEN(VH12G)+LEN(VH10G)) + ' of 4'


-- Total Reg By County
SELECT Jurisname, COUNT(*) TotalReg
FROM [dbo].[VF_CO_20180315]
GROUP BY Jurisname
ORDER BY TotalReg DESC


-- Total Reg By County and Party
SELECT Jurisname, CASE WHEN OfficialParty = 'R' then 'R' WHEN OfficialParty = 'D' then 'D' ELSE 'O' END Party, COUNT(*) TotalReg
FROM [dbo].[VF_CO_20180315]
GROUP BY Jurisname, CASE WHEN OfficialParty = 'R' then 'R' WHEN OfficialParty = 'D' then 'D' ELSE 'O' END
ORDER BY TotalReg DESC


-- Total Reg By County, RNCCalcParty, and Vote History
SELECT Jurisname, RNCCalcParty, LEN(replace(replace(vh10g,'0','')+replace(vh12g,'0','')+replace(vh14g,'0','')+replace(vh16g,'0',''),' ','')) as vh, COUNT(*) Total
FROM [dbo].[VF_CO_20180315]
GROUP BY Jurisname, RNCCalcParty, LEN(replace(replace(vh10g,'0','')+replace(vh12g,'0','')+replace(vh14g,'0','')+replace(vh16g,'0',''),' ',''))
