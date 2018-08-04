SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [ods].[vw_TM_CustMember_Active]
AS
SELECT cm.*
FROM ods.TM_CustMember cm
	LEFT JOIN (SELECT acct_id
					, membership_name
					, reason_desc 
					, RANK() OVER(PARTITION BY acct_id, membership_name ORDER BY add_datetime DESC) rnk
			   FROM ods.TM_CustMember
			   )rtn ON rtn.acct_id = cm.acct_id
			   		   AND rtn.membership_name = cm.membership_name
					   AND rtn.rnk = 1
					   AND ISNULL(rtn.reason_desc,'') = 'RETURNED'
WHERE rtn.acct_id IS NULL
	  AND ISNULL(cm.reason_desc,'') <> 'RETURNED'
GO
