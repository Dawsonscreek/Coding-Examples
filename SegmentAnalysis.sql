

---- FIND FEB/SEPT Models


-- Feb - 20160219
-- Sept - 20160917

---- PULL FEBRUARY 2016 NATIONAL SCORES
	SELECT a.RNC_REGID, RBallot, NetBallot, RParty, NetParty, TurnoutGeneral
	INTO #VSFeb
	FROM voterscores_staging.dbo.VoterScoresProd_Election a 
		JOIN RNCVoterSnapshot.dbo.USVoterFile (nolock) b ON a.RNC_RegID = b.RNC_RegID
	WHERE statekey = 54 and b.state = 'WV' and ModelDatekey = 20160219

---- PULL SEPTEMBER 2016 NATIONAL SCORES

	SELECT a.RNC_REGID, RBallot, NetBallot, RParty, Netparty, TurnoutGeneral
	INTO #VSSept
		FROM voterscores_staging.dbo.VoterScoresProd_Election a 
		JOIN RNCVoterSnapshot.dbo.USVoterFile (nolock) b ON a.RNC_RegID = b.RNC_RegID
	WHERE statekey = 54  and b.state = 'WV' and ModelDatekey = 20160917

---- Transformers Combine -----

	SELECT a.ModelDateKey, a.RNC_RegID, RBallot, NetBallot, RParty, NetParty, TurnoutGeneral
	INTO #VS
	FROM voterscores_staging.dbo.VoterScoresProd_Election (NOLOCK) A
		JOIN RNCVoterSnapshot.dbo.USVoterFile (NOLOCK) B on A.RNC_RegId = B.RNC_RegId
	WHERE	StateKey = 54 AND B.State = 'WV'


---- PULL DOWNSHIFTERS 

Select a.RNC_RegID, a.RBallot
INTO #PartyDownshifters
FROM #VSFeb a	
	JOIN #VSSept b ON a.RNC_RegID = b.RNC_RegID
Where (b.RBallot+.15) <= a.RBallot and a.NetBallot >= .3
Order by a.RBallot DESC


---- PULL FEB NATIONAL SCORES
SELECT CONVERT(UNIQUEIDENTIFIER,REPLACE(REPLACE(RNC_RegID,'}',''),'{','')) RNC_REGID
      ,[State]
      ,Convert(decimal(8,6),[CrimeSafetyInvestOppose_RNC_2_17])[CrimeSafetyInvestOppose_RNC_2_17]
      ,Convert(decimal(8,6),[CrimeSafetyInvestSupport_RNC_2_17])[CrimeSafetyInvestSupport_RNC_2_17]
      ,Convert(decimal(8,6),[DBallot2018_RNC_2_17])[DBallot2018_RNC_2_17]
      ,Convert(decimal(8,6),[DefeatTerroristOppose_RNC_2_17])[DefeatTerroristOppose_RNC_2_17]
      ,Convert(decimal(8,6),[DefeatTerroristSupport_RNC_2_17])[DefeatTerroristSupport_RNC_2_17]
      ,Convert(decimal(8,6),[DemFav_RNC_2_17])[DemFav_RNC_2_17]
      ,Convert(decimal(8,6),[DemsCheckRepublicans_RNC_2_17])[DemsCheckRepublicans_RNC_2_17]
      ,Convert(decimal(8,6),[DemUnFav_RNC_2_17])[DemUnFav_RNC_2_17]
      ,Convert(decimal(8,6),[DJTAgendaNotWorking_RNC_2_17])[DJTAgendaNotWorking_RNC_2_17]
      ,Convert(decimal(8,6),[DJTAgendaTooEarly_RNC_2_17])[DJTAgendaTooEarly_RNC_2_17]
      ,Convert(decimal(8,6),[DJTAgendaWorking_RNC_2_17])[DJTAgendaWorking_RNC_2_17]
      ,Convert(decimal(8,6),[DJTApprove_RNC_2_17])[DJTApprove_RNC_2_17]
      ,Convert(decimal(8,6),[DJTDisapprove_RNC_2_17])[DJTDisapprove_RNC_2_17]
      ,Convert(decimal(8,6),[DJTFav_RNC_2_17])[DJTFav_RNC_2_17]
      ,Convert(decimal(8,6),[DJTUnFav_RNC_2_17])[DJTUnFav_RNC_2_17]
      ,Convert(decimal(8,6),[DontTrustMedia_RNC_2_17])[DontTrustMedia_RNC_2_17]
      ,Convert(decimal(8,6),[DParty_RNC_2_17])[DParty_RNC_2_17]
      ,Convert(decimal(8,6),[EnergyKeystoneOppose_RNC_2_17])[EnergyKeystoneOppose_RNC_2_17]
      ,Convert(decimal(8,6),[EnergyKeystoneSupport_RNC_2_17])[EnergyKeystoneSupport_RNC_2_17]
      ,Convert(decimal(8,6),[GOPFav_RNC_2_17])[GOPFav_RNC_2_17]
      ,Convert(decimal(8,6),[GOPHelpsAgenda_RNC_2_17])[GOPHelpsAgenda_RNC_2_17]
      ,Convert(decimal(8,6),[GOPUnFav_RNC_2_17])[GOPUnFav_RNC_2_17]
      ,Convert(decimal(8,6),[GorsuchOppose_RNC_2_17])[GorsuchOppose_RNC_2_17]
      ,Convert(decimal(8,6),[GorsuchSupport_RNC_2_17])[GorsuchSupport_RNC_2_17]
      ,Convert(decimal(8,6),[IncreaseMilSpendOppose_RNC_2_17])[IncreaseMilSpendOppose_RNC_2_17]
      ,Convert(decimal(8,6),[IncreaseMilSpendSupport_RNC_2_17])[IncreaseMilSpendSupport_RNC_2_17]
      ,Convert(decimal(8,6),[InfraInvestOppose_RNC_2_17])[InfraInvestOppose_RNC_2_17]
      ,Convert(decimal(8,6),[InfraInvestSupport_RNC_2_17])[InfraInvestSupport_RNC_2_17]
      ,Convert(decimal(8,6),[LikeDJTPoliciesNotStyle_RNC_2_17])[LikeDJTPoliciesNotStyle_RNC_2_17]
      ,Convert(decimal(8,6),[LikeDJTStyleAndPolicy_RNC_2_17])[LikeDJTStyleAndPolicy_RNC_2_17]
      ,Convert(decimal(8,6),[McConnellFav_RNC_2_17])[McConnellFav_RNC_2_17]
      ,Convert(decimal(8,6),[McConnellUnFav_RNC_2_17])[McConnellUnFav_RNC_2_17]
      ,Convert(decimal(8,6),[NoJobsOverseasOppose_RNC_2_17])[NoJobsOverseasOppose_RNC_2_17]
      ,Convert(decimal(8,6),[NoJobsOverseasSupport_RNC_2_17])[NoJobsOverseasSupport_RNC_2_17]
      ,Convert(decimal(8,6),[ObjectDJTStyleAndPolicy_RNC_2_17])[ObjectDJTStyleAndPolicy_RNC_2_17]
      ,Convert(decimal(8,6),[RBallot2018_RNC_2_17])[RBallot2018_RNC_2_17]
      ,Convert(decimal(8,6),[RepealOcareOppose_RNC_2_17])[RepealOcareOppose_RNC_2_17]
      ,Convert(decimal(8,6),[RepealOcareSupport_RNC_2_17])[RepealOcareSupport_RNC_2_17]
      ,Convert(decimal(8,6),[RParty_RNC_2_17])[RParty_RNC_2_17]
      ,Convert(decimal(8,6),[RyanFav_RNC_2_17])[RyanFav_RNC_2_17]
      ,Convert(decimal(8,6),[RyanUnFav_RNC_2_17])[RyanUnFav_RNC_2_17]
      ,Convert(decimal(8,6),[SchoolChoiceOppose_RNC_2_17])[SchoolChoiceOppose_RNC_2_17]
      ,Convert(decimal(8,6),[SchoolChoiceSupport_RNC_2_17])[SchoolChoiceSupport_RNC_2_17]
      ,Convert(decimal(8,6),[StrongImmigrationPolicyOppose_RNC_2_17])[StrongImmigrationPolicyOppose_RNC_2_17]
      ,Convert(decimal(8,6),[StrongImmigrationPolicySupport_RNC_2_17])[StrongImmigrationPolicySupport_RNC_2_17]
      ,Convert(decimal(8,6),[TaxReformOppose_RNC_2_17])[TaxReformOppose_RNC_2_17]
      ,Convert(decimal(8,6),[TaxReformSupport_RNC_2_17])[TaxReformSupport_RNC_2_17]
      ,Convert(decimal(8,6),[TrustMedia_RNC_2_17])[TrustMedia_RNC_2_17]
      ,Convert(decimal(8,6),[TurnoutGeneral_RNC_2_17])[TurnoutGeneral_RNC_2_17]
      ,Convert(decimal(8,6),[TurnoutHistorical_RNC_2_17])[TurnoutHistorical_RNC_2_17]
      ,Convert(decimal(8,6),[TurnoutSurvey_RNC_2_17])[TurnoutSurvey_RNC_2_17]
      ,Convert(decimal(8,6),[WarrenFav_RNC_2_17])[WarrenFav_RNC_2_17]
      ,Convert(decimal(8,6),[WarrenUnFav_RNC_2_17])[WarrenUnFav_RNC_2_17]
  INTO #scores2017
  FROM [voterscores_staging].[dbo].[Scores_Reporting_Feb] (nolock)
  Where state = 'WV'


  ---- PULL TABLE OF CONSUMER DATA
		SELECT [RNC_RegID]
			  ,[State]
			  ,[StateKey]
			  ,[Veteran_ibe]
			  ,[OccupationDetail_ibe]
			  ,[RaceCode_ibe]
			  ,[IncomeEstimatedHousehold_ibe]
			  ,[HouseholdNumberOfChildren_ibe]
			  ,[HouseholdMaritalStatus_ibe]
			  ,[Occupation_ibe]
			  ,[EducationInputIndividual_ibe]
		INTO #TEMPConsumer
		FROM [Fluffy_stg].[dbo].[RNCConsumer2016_ExternalLayout_IBE] (NOLOCK)
		WHERE State = 'WV'

--- PULL TEMP VF
		SELECT *
		INTO #TEMPVF
		FROM RNCVoterSnapshot.dbo.USVoterFile (NOLOCK)
		WHERE State = 'WV'


----------------------------
---- TOPLINES
----------------------------

--- All registered Voters
Select COUNT(a.RNC_REGID) as TotalVoters
	, AVG(c.[TurnoutGeneral_RNC_2_17]) as [Turnout2018]
	, AVG(a.RBallot) as AvgFebRBallot
	, AVG(b.RBallot) as AvgSeptRBallot
FROM #VSFeb a
	JOIN #VSSept b ON a.RNC_REGID = b.RNC_REGID
	JOIN #scores2017 c ON a.RNC_RegID = c.RNC_RegID


--- Downshifters
Select COUNT(a.RNC_REGID) as TotalVoters
	, AVG(e.[TurnoutGeneral_RNC_2_17]) as Turnout2018
	, AVG(b.RBallot) as AvgFebRBallot
	, AVG(c.RBallot) as AvgSeptRBallot
FROM #PartyDownshifters a
	JOIN #VSFeb b (nolock) ON a.RNC_REGID = b.RNC_RegID 
	JOIN #VSSept c (nolock) On a.RNC_RegID = c.RNC_REGID
	JOIN #scores2017 e (nolock) ON a.RNC_REGID = e.RNC_RegID

--------------------------------------------------
---- PULL ISSUE MODEL AVERAGES
--------------------------------------------------

---- UNPIVOT SCORES TABLE
Select RNC_REGID, IssueModel, VoterScore
INTO #Unpivot
FROM 
(	Select [RNC_RegID]
      ,[State]
      ,[CrimeSafetyInvestOppose_RNC_2_17]
      ,[CrimeSafetyInvestSupport_RNC_2_17]
      ,[DefeatTerroristOppose_RNC_2_17]
      ,[DefeatTerroristSupport_RNC_2_17]
      ,[DemsCheckRepublicans_RNC_2_17]
      ,[DJTAgendaNotWorking_RNC_2_17]
      ,[DJTAgendaTooEarly_RNC_2_17]
      ,[DJTAgendaWorking_RNC_2_17]
      ,[DontTrustMedia_RNC_2_17]
      ,[EnergyKeystoneOppose_RNC_2_17]
      ,[EnergyKeystoneSupport_RNC_2_17]
      ,[GOPHelpsAgenda_RNC_2_17]
      ,[GorsuchOppose_RNC_2_17]
      ,[GorsuchSupport_RNC_2_17]
      ,[IncreaseMilSpendOppose_RNC_2_17]
      ,[IncreaseMilSpendSupport_RNC_2_17]
      ,[InfraInvestOppose_RNC_2_17]
      ,[InfraInvestSupport_RNC_2_17]
      ,[LikeDJTPoliciesNotStyle_RNC_2_17]
      ,[LikeDJTStyleAndPolicy_RNC_2_17]
      ,[NoJobsOverseasOppose_RNC_2_17]
      ,[NoJobsOverseasSupport_RNC_2_17]
      ,[ObjectDJTStyleAndPolicy_RNC_2_17]
      ,[RepealOcareOppose_RNC_2_17]
      ,[RepealOcareSupport_RNC_2_17]
      ,[RParty_RNC_2_17]
      ,[SchoolChoiceOppose_RNC_2_17]
      ,[SchoolChoiceSupport_RNC_2_17]
      ,[StrongImmigrationPolicyOppose_RNC_2_17]
      ,[StrongImmigrationPolicySupport_RNC_2_17]
      ,[TaxReformOppose_RNC_2_17]
      ,[TaxReformSupport_RNC_2_17]
      ,[TrustMedia_RNC_2_17]
FROM #scores2017) p
UNPIVOT
(VoterScore for IssueModel IN ([CrimeSafetyInvestOppose_RNC_2_17]
      ,[CrimeSafetyInvestSupport_RNC_2_17]
      ,[DefeatTerroristOppose_RNC_2_17]
      ,[DefeatTerroristSupport_RNC_2_17]
      ,[DemsCheckRepublicans_RNC_2_17]
      ,[DJTAgendaNotWorking_RNC_2_17]
      ,[DJTAgendaTooEarly_RNC_2_17]
      ,[DJTAgendaWorking_RNC_2_17]
      ,[DontTrustMedia_RNC_2_17]
      ,[EnergyKeystoneOppose_RNC_2_17]
      ,[EnergyKeystoneSupport_RNC_2_17]
      ,[GOPHelpsAgenda_RNC_2_17]
      ,[GorsuchOppose_RNC_2_17]
      ,[GorsuchSupport_RNC_2_17]
      ,[IncreaseMilSpendOppose_RNC_2_17]
      ,[IncreaseMilSpendSupport_RNC_2_17]
      ,[InfraInvestOppose_RNC_2_17]
      ,[InfraInvestSupport_RNC_2_17]
      ,[LikeDJTPoliciesNotStyle_RNC_2_17]
      ,[LikeDJTStyleAndPolicy_RNC_2_17]
      ,[NoJobsOverseasOppose_RNC_2_17]
      ,[NoJobsOverseasSupport_RNC_2_17]
      ,[ObjectDJTStyleAndPolicy_RNC_2_17]
      ,[RepealOcareOppose_RNC_2_17]
      ,[RepealOcareSupport_RNC_2_17]
      ,[RParty_RNC_2_17]
      ,[SchoolChoiceOppose_RNC_2_17]
      ,[SchoolChoiceSupport_RNC_2_17]
      ,[StrongImmigrationPolicyOppose_RNC_2_17]
      ,[StrongImmigrationPolicySupport_RNC_2_17]
      ,[TaxReformOppose_RNC_2_17]
      ,[TaxReformSupport_RNC_2_17]
      ,[TrustMedia_RNC_2_17] )) as unpvt


---- ISSUE MODELS -- TOTAL VOTERS

	  Select IssueModel, AVG(VoterScore) as AVGScore
	  FROM #Unpivot
	  Group by IssueModel
	  Order by IssueModel

-----  ISSUE MODELS -- DOWNSHIFTERS

	  Select IssueModel, AVG(VoterScore) as AVGScore
	  FROM #Unpivot a	
	  JOIN #PartyDownshifters b (nolock) ON a.RNC_REGID = b.RNC_RegID
	  Group by IssueModel
	  Order by IssueModel

----- Transformers Combine -----

	SELECT a.IssueModel, A.AVGScore, B.AVGScore2
	FROM (
			SELECT IssueModel, AVG(VoterScore) as AVGScore
			FROM #Unpivot 
			GROUP BY IssueModel ) as A
			JOIN (
			SELECT IssueModel, AVG(VoterScore) as AVGScore2
			FROM #Unpivot (NOLOCK) a
				JOIN #PartyDownshifters (NOLOCK) b on a.RNC_RegId = b.RNC_RegId
			GROUP BY IssueModel) as B 
			on A.IssueModel = B.IssueModel
	ORDER BY IssueModel
		
--------------------------------------------------
---- PULL DEMO BREAKDOWN
--------------------------------------------------

-----------  CREATE TEMP TABLE FOR COUNTS
	SELECT b.State, b.RNC_REGID, d.RBallot2018_RNC_2_17-d.DBallot2018_RNC_2_17 as NetBallot, d.RepealOcareSupport_RNC_2_17 as RepealOcareSupport, d.RepealOcareOppose_RNC_2_17 as RepealOcareOppose
		, CASE WHEN b.Sex = 'F' THEN 'Female' 
			WHEN b.Sex = 'M' THEN 'Male' ELSE 'Unknown' END AS Gender  
		, CASE WHEN b.IsPartyReg = 1 AND OfficialParty = 'R' THEN '(1) Rep'
			WHEN b.IsPartyReg = 1 AND OfficialParty = 'D' THEN '(2) Dem'
			WHEN b.IsPartyReg = 1 AND OfficialParty NOT IN ('D','R') THEN '(3) Oth'
			WHEN b.IsPartyReg = 0 AND RNCCalcParty IN (1,2) THEN '(1) Rep'
			WHEN b.IsPartyReg = 0 AND RNCCalcParty IN (4,5) THEN '(2) Dem'
			WHEN b.IsPartyReg = 0 AND RNCCalcParty IN (3) THEN '(3) Oth' ELSE '(4) Unknown' END AS Party
		, CASE   
			WHEN b.State IN ('NC', 'FL','GA','LA','MS','SC','TN') AND b.Ethnicity_Reported = 'A' THEN 'Asian'
			WHEN b.State IN ('NC', 'FL','GA','LA','MS','SC','TN') AND b.Ethnicity_Reported = 'B' THEN 'African American'
			WHEN b.State IN ('NC', 'FL','GA','LA','MS','SC','TN') AND b.Ethnicity_Reported = 'H' THEN 'Hispanic'
			WHEN b.State IN ('NC', 'FL','GA','LA','MS','SC','TN') AND b.Ethnicity_Reported = 'I' THEN 'Native American'
			WHEN b.State IN ('NC', 'FL','GA','LA','MS','SC','TN') AND b.Ethnicity_Reported = 'O' THEN 'Other'
			WHEN b.State IN ('NC', 'FL','GA','LA','MS','SC','TN') AND b.Ethnicity_Reported = 'W' THEN 'White'
			WHEN b.State IN ('NC', 'FL','GA','LA','MS','SC','TN') AND b.Ethnicity_Reported NOT IN ('A','B','H','I','O','W') THEN 'Unknown'
			WHEN b.State NOT IN ('NC', 'FL','GA','LA','MS','SC','TN') AND c.[RaceCode_ibe] = 'A' THEN 'Asian'
			WHEN b.State NOT IN ('NC', 'FL','GA','LA','MS','SC','TN') AND c.[RaceCode_ibe] = 'B' THEN 'African American'
			WHEN b.State NOT IN ('NC', 'FL','GA','LA','MS','SC','TN') AND c.[RaceCode_ibe] = 'H' THEN 'Hispanic'
			WHEN b.State NOT IN ('NC', 'FL','GA','LA','MS','SC','TN') AND c.[RaceCode_ibe] = 'W' THEN 'White' ELSE 'Other' END AS RaceCode
		, RTRIM(LTRIM(DMAName)) AS DMAName
		, CASE WHEN c.[EducationInputIndividual_ibe] IN ('2','3') THEN 'College Educated'  ELSE 'Not College Educated' END AS College 
		, CASE WHEN b.Sex = 'F' AND [HouseholdMaritalStatus_ibe] IN ('M', 'A') THEN 'Married Female'
			WHEN b.Sex = 'F' AND [HouseholdMaritalStatus_ibe] IN ('S', 'B') THEN 'Single Female'
			WHEN b.Sex = 'M' AND [HouseholdMaritalStatus_ibe] IN ('M', 'A') THEN 'Married Male'
			WHEN b.Sex = 'M' AND [HouseholdMaritalStatus_ibe] IN ('S', 'B') THEN 'Single Male'
			ELSE 'Unknown' END AS MaritalStatusGender
	INTO #PullFinalCountDownshifters
	FROM  #TEMPVF b
		JOIN #TEMPConsumer c (NOLOCK) ON b.RNC_REGID = c.RNC_REGID
		JOIN #scores2017 d (nolock) ON b.RNC_RegID = d.RNC_RegID


 SELECT *
  INTO #PullFinalCounts_FIRSTHALF
  FROM (
  		SELECT Type, State, CategoryOrder, Category 
			, COUNT(DISTINCT RNC_REGID) AS TotalVoters
			, AVG(NetBallot) AS NetBallot
			, AVG(RepealOcareSupport) AS RepealOcareSupport
			, AVG(RepealOcareOppose) AS RepealOcareOppose
		FROM (
		SELECT DISTINCT State, RNC_REGID, NetBallot, RepealOcareSupport, RepealOcareOppose, '(1) All Registered Voters' as Type,
			Party AS Category, 
			'(1) Party' AS CategoryOrder
		FROM #PullFinalCountDownshifters
			) z
		GROUP BY Type, State, Category, CategoryOrder
		UNION
  -------- GENDER
		SELECT Type, State, CategoryOrder, Category 
			, COUNT(DISTINCT RNC_REGID) AS TotalVoters
			, AVG(NetBallot) AS NetBallot
			, AVG(RepealOcareSupport) AS RepealOcareSupport
			, AVG(RepealOcareOppose) AS RepealOcareOppose
		FROM (
		SELECT DISTINCT State, RNC_REGID, NetBallot, RepealOcareSupport, RepealOcareOppose, '(1) All Registered Voters' as Type,
			Gender AS Category, 
			'(2) Gender' AS CategoryOrder
		FROM #PullFinalCountDownshifters
			) z
		GROUP BY Type, State, Category, CategoryOrder
		UNION
  -------- RACE 
 		SELECT Type, State, CategoryOrder, Category 
			, COUNT(DISTINCT RNC_REGID) AS TotalVoters
			, AVG(NetBallot) AS NetBallot
			, AVG(RepealOcareSupport) AS RepealOcareSupport
			, AVG(RepealOcareOppose) AS DemShouldntWorkWithTrump
		FROM (
		SELECT DISTINCT State, RNC_REGID, NetBallot, RepealOcareSupport, RepealOcareOppose,  '(1) All Registered Voters' as Type,
			RaceCode AS Category, 
			'(3) Race' AS CategoryOrder
		FROM #PullFinalCountDownshifters
			) z
		GROUP BY Type, State, CategoryOrder, Category
		UNION
  -------- EDUCATION
  		SELECT Type, State, CategoryOrder, Category 
			, COUNT(DISTINCT RNC_REGID) AS TotalVoters
			, AVG(NetBallot) AS NetBallot
			, AVG(RepealOcareSupport) AS RepealOcareSupport
			, AVG(RepealOcareOppose) AS DemShouldntWorkWithTrump
		FROM (
		SELECT DISTINCT State, RNC_REGID, NetBallot, RepealOcareSupport, RepealOcareOppose, '(1) All Registered Voters' as Type,
			College AS Category, 
			'(4) Education' AS CategoryOrder
		FROM #PullFinalCountDownshifters
			) z
		GROUP BY Type, State, Category, CategoryOrder
		UNION
  -------- MARITAL STATUS GENDER
		SELECT Type, State, CategoryOrder, Category 
			, COUNT(DISTINCT RNC_REGID) AS TotalVoters
			, AVG(NetBallot) AS NetBallot
			, AVG(RepealOcareSupport) AS RepealOcareSupport
			, AVG(RepealOcareOppose) AS DemShouldntWorkWithTrump
		FROM (
		SELECT DISTINCT State, RNC_REGID, NetBallot, RepealOcareSupport, RepealOcareOppose, '(1) All Registered Voters' as Type,
			MaritalStatusGender AS Category, 
			'(5) Marriage/Gender' AS CategoryOrder
		FROM #PullFinalCountDownshifters
			) z
		GROUP BY Type, State, Category, CategoryOrder
		UNION
  -------- MEDIA MARKET
  		SELECT Type, State, CategoryOrder, Category 
			, COUNT(DISTINCT RNC_REGID) AS TotalVoters
			, AVG(NetBallot) AS NetBallot
			, AVG(RepealOcareSupport) AS RepealOcareSupport
			, AVG(RepealOcareOppose) AS RepealOcareOppose
		FROM (
		SELECT DISTINCT State, RNC_REGID, NetBallot, RepealOcareSupport, RepealOcareOppose, '(1) All Registered Voters' as Type,
			DMAName AS Category, 
			'(6) Media Market' AS CategoryOrder
		FROM #PullFinalCountDownshifters
			) z
		GROUP BY Type, State, Category, CategoryOrder
		) zz

----- DOWNSHIFTER DEMO

		SELECT *
	FROM #PullFinalCounts_FIRSTHALF
	UNION	 
  -------- PARTY
  		SELECT Type, State, CategoryOrder, Category 
			, COUNT(DISTINCT RNC_REGID) AS TotalVoters
			, AVG(NetBallot) AS NetBallot
			, AVG(RepealOcareSupport) AS RepealOcareSupport
			, AVG(RepealOcareOppose) AS RepealOcareOppose
		FROM (
		SELECT DISTINCT A.State, A.RNC_REGID, NetBallot, RepealOcareSupport, RepealOcareOppose, '(2) '+'Downshifters'  as Type,
			Party AS Category, 
			'(1) Party' AS CategoryOrder
		FROM #PullFinalCountDownshifters A
			JOIN #PartyDownshifters b ON a.RNC_REGID = b.RNC_REGID
			) z
		GROUP BY Type, State, Category, CategoryOrder
		UNION
  -------- GENDER
		SELECT Type, State, CategoryOrder, Category 
			, COUNT(DISTINCT RNC_REGID) AS TotalVoters
			, AVG(NetBallot) AS NetBallot
			, AVG(RepealOcareSupport) AS RepealOcareSupport
			, AVG(RepealOcareOppose) AS RepealOcareOppose
		FROM (
		SELECT DISTINCT A.State, A.RNC_REGID, NetBallot, RepealOcareSupport, RepealOcareOppose, '(2) '+'Downshifters'  as Type,
			Gender AS Category, 
			'(2) Gender' AS CategoryOrder 
		FROM #PullFinalCountDownshifters A
			JOIN #PartyDownshifters b ON a.RNC_REGID = b.RNC_REGID
			) z
		GROUP BY Type, State, Category, CategoryOrder
		UNION
  -------- RACE 
 		SELECT Type, State, CategoryOrder, Category 
			, COUNT(DISTINCT RNC_REGID) AS TotalVoters
			, AVG(NetBallot) AS NetBallot
			, AVG(RepealOcareSupport) AS RepealOcareSupport
			, AVG(RepealOcareOppose) AS RepealOcareOppose
		FROM (
		SELECT DISTINCT A.State, A.RNC_REGID, NetBallot, RepealOcareSupport, RepealOcareOppose, '(2) '+'Downshifters' as Type,
			RaceCode AS Category, 
			'(3) Race' AS CategoryOrder
		FROM #PullFinalCountDownshifters A
			JOIN #PartyDownshifters b ON a.RNC_REGID = b.RNC_REGID
			) z
		GROUP BY Type, State, CategoryOrder, Category
		UNION
  -------- EDUCATION
  		SELECT Type, State, CategoryOrder, Category 
			, COUNT(DISTINCT RNC_REGID) AS TotalVoters
			, AVG(NetBallot) AS NetBallot
			, AVG(RepealOcareSupport) AS RepealOcareSupport
			, AVG(RepealOcareOppose) AS RepealOcareOppose
		FROM (
		SELECT DISTINCT A.State,  A.RNC_REGID, NetBallot, RepealOcareSupport, RepealOcareOppose,  '(2) '+'Downshifters'  as Type,
			College AS Category, 
			'(4) Education' AS CategoryOrder
		FROM #PullFinalCountDownshifters A
			JOIN #PartyDownshifters b ON a.RNC_REGID = b.RNC_REGID
			) z
		GROUP BY Type, State, Category, CategoryOrder
		UNION
  -------- MARITAL STATUS GENDER
		SELECT Type, State, CategoryOrder, Category 
			, COUNT(DISTINCT RNC_REGID) AS TotalVoters
			, AVG(NetBallot) AS NetBallot
			, AVG(RepealOcareSupport) AS RepealOcareSupport
			, AVG(RepealOcareOppose) AS RepealOcareOppose
		FROM (
		SELECT DISTINCT a.State, a.RNC_REGID, NetBallot, RepealOcareSupport, RepealOcareOppose, '(2) '+'Downshifters'  as Type,
			MaritalStatusGender AS Category, 
			'(5) Marriage/Gender' AS CategoryOrder
		FROM #PullFinalCountDownshifters A
			JOIN #PartyDownshifters b ON a.RNC_REGID = b.RNC_REGID
			) z
		GROUP BY Type, State, Category, CategoryOrder
		UNION
  -------- MEDIA MARKET
  		SELECT Type, State, CategoryOrder, Category 
			, COUNT(DISTINCT RNC_REGID) AS TotalVoters
			, AVG(NetBallot) AS NetBallot
			, AVG(RepealOcareSupport) AS RepealOcareSupport
			, AVG(RepealOcareOppose) AS RepealOcareOppose
		FROM (
		SELECT DISTINCT a.State, a.RNC_REGID, NetBallot, RepealOcareSupport, RepealOcareOppose,  '(2) '+'Downshifters' as Type,
			DMAName AS Category, 
			'(6) Media Market' AS CategoryOrder
		FROM #PullFinalCountDownshifters a
			JOIN #PartyDownshifters b ON a.RNC_REGID = b.RNC_REGID
			) z
		GROUP BY Type, State, Category, CategoryOrder



DROP TABLE #PartyDownshifters
DROP TABLE #VSFeb
DROP TABLE #VSSept
DROP TABLE #scores2017
DROP TABLE #Unpivot
DROP TABLE #TEMPVF
DROP TABLE #TEMPConsumer
DROP TABLE #PullFinalCountDownshifters
DROP TABLE #PullFinalCounts_FIRSTHALF
DROP TABLE #VS
