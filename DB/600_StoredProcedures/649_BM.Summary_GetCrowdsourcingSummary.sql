USE [FPCAPPS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gurpreet Singh
-- Create date: 08/07/19
-- Description:	Get Crowdsourcing Summary
-- =============================================
CREATE
	OR

ALTER PROCEDURE [BM].[Summary_GetCrowdsourcingSummary] (
	@UserId VARCHAR(100)
	,@UserRole VARCHAR(100)
	)
AS
BEGIN
	IF (@UserRole = 'RegionalUser')
	BEGIN
		SET @UserRole = (
				SELECT TOP 1 [Role]
				FROM FPCAPPS.PEM.UserHierarchy
				WHERE UserId = @UserId
				)

		SELECT Bid.[BidId]
			,Bid.[BidStatus]
			,Bid.[BidName]
			,Bid.[DueDate]
			,Bid.[Rank]
			,Bid.[BidType]
			,COUNT(DISTINCT BidPartId) AS UploadPartCount
			,SUM(CASE 
					WHEN BP.IsCrowdSourcingEligible = 1
						THEN 1
					ELSE 0
					END) AS CrowdSourcingPartCount
			,SUM(CASE 
					WHEN BP.IsSubmitted = 1
						THEN 1
					ELSE 0
					END) AS UserSubmittedPartCount
			,SUM(CASE 
					WHEN BP.IsValidated = 1
						THEN 1
					ELSE 0
					END) AS ValidatedPartCount
		FROM BM.Bid AS Bid  (nolock)
		INNER JOIN BM.BidPart AS BP (nolock) ON Bid.BidId = BP.BidId
		WHERE Bid.BidType = 'Regional'
			AND (
				(
					(
						@UserRole <> 'RVP'
						OR @UserRole IS NULL
						)
					AND Bid.CreatedBy = @UserId
					)
				OR (@UserRole = 'RVP')
				)
		GROUP BY Bid.BidId
			,Bid.[BidStatus]
			,Bid.[BidName]
			,Bid.[DueDate]
			,Bid.[Rank]
			,Bid.[BidType]
	END
	ELSE
	BEGIN
		SELECT Bid.[BidId]
			,Bid.[BidStatus]
			,Bid.[BidName]
			,Bid.[DueDate]
			,Bid.[Rank]
			,Bid.[BidType]
			,COUNT(DISTINCT BidPartId) AS UploadPartCount
			,SUM(CASE 
					WHEN BP.IsCrowdSourcingEligible = 1
						THEN 1
					ELSE 0
					END) AS CrowdSourcingPartCount
			,SUM(CASE 
					WHEN BP.IsSubmitted = 1
						THEN 1
					ELSE 0
					END) AS UserSubmittedPartCount
			,SUM(CASE 
					WHEN BP.IsValidated = 1
						THEN 1
					ELSE 0
					END) AS ValidatedPartCount
		FROM BM.Bid AS Bid
		INNER JOIN BM.BidPart AS BP ON Bid.BidId = BP.BidId
		WHERE (
				@UserRole = 'NAM'
				AND Bid.BidType = 'National'
				AND (
					Bid.CreatedBy = @UserId
					OR Bid.NAMUserId = @UserId
					)
				)
			OR (
				@UserRole IN (
					'NAMSupervisor'
					,'NAMValidator'
					)
				AND Bid.BidType = 'National'
				)
			OR (
				@UserRole = 'SuperUser'
				AND Bid.BidType IN (
					'National'
					,'Regional'
					)
				)
			OR (
				@UserRole = 'PricingTeam'
				AND Bid.BidStatus = 'PricingTeam'
				)
			OR (
				@UserRole = 'CategoryManager'
				AND Bid.BidStatus = 'CategoryManager'
				)
		GROUP BY Bid.BidId
			,Bid.[BidStatus]
			,Bid.[BidName]
			,Bid.[DueDate]
			,Bid.[Rank]
			,Bid.[BidType]
	END
END
