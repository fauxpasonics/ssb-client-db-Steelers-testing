SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[ods_Load_Online_Merch_Purchasers]
AS
BEGIN

	MERGE ods.Online_Merch_Purchasers AS T
	USING src.Online_Merch_Purchasers AS S
	ON (T.invoicenumber = S.invoicenumber
		AND T.userid = S.userid)
	WHEN MATCHED
		--AND S.last_modified < cast(DATEADD(DAY, -DATEPART(WEEKDAY, GETDATE())+2, GETDATE()) as date)
		AND T.HashKey != HASHBYTES('SHA2_256', 
			 ISNULL(S.date_start, 'NA') + '|'
			+ ISNULL(S.email, 'NA') + '|'
			+ ISNULL(S.cc_total, 'NA') + '|'
			+ ISNULL(S.gift_certificate, 'NA'))
		THEN
			UPDATE SET T.date_start = S.date_start
				, T.email = S.email
				, T.cc_total = S.cc_total
				, T.gift_certificate = S.gift_certificate
				, T.HashKey = HASHBYTES('SHA2_256', 
					ISNULL(S.date_start, 'NA') + '|'
					+ ISNULL(S.email, 'NA') + '|'
					+ ISNULL(S.cc_total, 'NA') + '|'
					+ ISNULL(S.gift_certificate, 'NA'))
			, ModifiedDate = GETDATE()
	WHEN NOT MATCHED BY TARGET 
		THEN
			INSERT (FileId, date_start, invoicenumber, email, userid, cc_total, gift_certificate, HashKey, InsertDate)
			VALUES (S.FileId, S.date_start, S.invoicenumber, S.email, S.userid, S.cc_total, S.gift_certificate
					,HASHBYTES('SHA2_256', 
						 ISNULL(S.date_start, 'NA') + '|'
						+ ISNULL(S.email, 'NA') + '|'
						+ ISNULL(S.cc_total, 'NA') + '|'
						+ ISNULL(S.gift_certificate, 'NA'))
					,GETDATE())
	WHEN NOT MATCHED BY SOURCE THEN
		DELETE;

END
GO
