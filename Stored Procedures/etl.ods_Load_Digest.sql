SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[ods_Load_Digest]
AS
BEGIN

	MERGE ods.Digest AS T
	USING src.Digest AS S
	ON (HASHBYTES('SHA1', 
			'ST' + '|'
			+ ISNULL(LEFT(T.email, 10), '') + '|'
			+ ISNULL(T.name_first, '') + '|'
			+ ISNULL(T.name_last, '') + '|'
			+ ISNULL(T.street_addr_1, '') + '|'
			+ ISNULL(T.city, '') + '|'
			+ ISNULL(T.state, '') + '|'
			+ ISNULL(T.zip, '') + '|'
			+ ISNULL(T.order_date, '')) = 
		HASHBYTES('SHA1', 
			'ST' + '|'
			+ ISNULL(LEFT(S.email, 10), '') + '|'
			+ ISNULL(S.name_first, '') + '|'
			+ ISNULL(S.name_last, '') + '|'
			+ ISNULL(S.street_addr_1, '') + '|'
			+ ISNULL(S.city, '') + '|'
			+ ISNULL(S.state, '') + '|'
			+ ISNULL(S.zip, '') + '|'
			+ ISNULL(S.order_date, '')))
	WHEN MATCHED
		--AND S.last_modified < cast(DATEADD(DAY, -DATEPART(WEEKDAY, GETDATE())+2, GETDATE()) as date)
		AND T.HashKey != HASHBYTES('SHA2_256', 
			 ISNULL(S.email, 'NA') + '|'
			+ ISNULL(S.name_first, 'NA') + '|'
			+ ISNULL(S.name_last, 'NA') + '|'
			+ ISNULL(S.street_addr_1, 'NA') + '|'
			+ ISNULL(S.street_addr_2, 'NA') + '|'
			+ ISNULL(S.city, 'NA') + '|' 
			+ ISNULL(S.state, 'NA') + '|'
			+ ISNULL(S.zip, 'NA') + '|' 
			+ ISNULL(S.country, 'NA') + '|'
			+ ISNULL(cast(S.order_date as varchar(50)), 'NA'))
		THEN
			UPDATE SET T.email = S.email
				, T.name_first = S.name_first
				, T.name_last = S.name_last
				, T.street_addr_1 = S.street_addr_1
				, T.street_addr_2 = S.street_addr_2
				, T.city = S.city
				, T.state = S.state
				, T.zip = S.zip
				, T.country = S.country
				, T.order_date = S.order_date
				, T.HashKey = HASHBYTES('SHA2_256', 
					 ISNULL(S.email, 'NA') + '|'
					+ ISNULL(S.name_first, 'NA') + '|'
					+ ISNULL(S.name_last, 'NA') + '|'
					+ ISNULL(S.street_addr_1, 'NA') + '|'
					+ ISNULL(S.street_addr_2, 'NA') + '|'
					+ ISNULL(S.city, 'NA') + '|' 
					+ ISNULL(S.state, 'NA') + '|'
					+ ISNULL(S.zip, 'NA') + '|' 
					+ ISNULL(S.country, 'NA') + '|'
					+ ISNULL(cast(S.order_date as varchar(50)), 'NA'))
				, ModifiedDate = GETDATE()
	WHEN NOT MATCHED BY TARGET 
		THEN
			INSERT (FileId, email, name_first, name_last, street_addr_1, street_addr_2, city, state,zip, country
					,order_date, HashKey, InsertDate)
			VALUES (S.FileId, S.email, S.name_first, S.name_last, S.street_addr_1, S.street_addr_2
					,S.city, S.state, S.zip, S.country
					,S.order_date
					,HASHBYTES('SHA2_256', 
						 ISNULL(S.email, 'NA') + '|'
						+ ISNULL(S.name_first, 'NA') + '|'
						+ ISNULL(S.name_last, 'NA') + '|'
						+ ISNULL(S.street_addr_1, 'NA') + '|'
						+ ISNULL(S.street_addr_2, 'NA') + '|'
						+ ISNULL(S.city, 'NA') + '|' 
						+ ISNULL(S.state, 'NA') + '|'
						+ ISNULL(S.zip, 'NA') + '|' 
						+ ISNULL(S.country, 'NA') + '|'
						+ ISNULL(cast(S.order_date as varchar(50)), 'NA'))
					,GETDATE())
	WHEN NOT MATCHED BY SOURCE THEN
		DELETE;

END
GO
