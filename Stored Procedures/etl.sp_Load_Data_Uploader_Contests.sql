SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [etl].[sp_Load_Data_Uploader_Contests] AS

MERGE etl.Data_Uploader_Customer_Contests AS MyTarget
USING (SELECT * 
	   FROM (SELECT *
				   , ROW_NUMBER() OVER(PARTITION BY ContactHash ORDER BY Event_Date DESC)rnk
			 FROM EmailOutbound.Data_Uploader_Landing
			 WHERE Source = 'Contests'
			 )x
	   WHERE x.rnk = 1
	   ) MySource ON MySource.ContactHash = MyTarget.ContactHash

WHEN MATCHED THEN UPDATE SET  MyTarget.Email           = MySource.Email                          
							 ,MyTarget.First_Name      = MySource.First_Name                     
							 ,MyTarget.Last_Name       = MySource.Last_Name                      
							 ,MyTarget.Suffix          = MySource.Suffix                         
							 ,MyTarget.Gender          = MySource.Gender                         
							 ,MyTarget.Birth_Date      = MySource.Birth_Date                     
							 ,MyTarget.Address_Street  = MySource.Address_Street                 
							 ,MyTarget.Address_Suite   = MySource.Address_Suite                  
							 ,MyTarget.Address_City    = MySource.Address_City                   
							 ,MyTarget.Address_State   = MySource.Address_State                  
							 ,MyTarget.Address_Zip     = MySource.Address_Zip                    
							 ,MyTarget.Address_Country = MySource.Address_Country                
							 ,MyTarget.Phone_Primary   = MySource.Phone_Primary                  
							 ,MyTarget.Phone_Cell      = MySource.Phone_Cell                     
							 ,MyTarget.ETL_UpdatedDate = GETDATE()

WHEN NOT MATCHED THEN INSERT (
 Email                        
,First_Name                   
,Last_Name                    
,Suffix                       
,Gender                       
,Birth_Date                   
,Address_Street               
,Address_Suite                
,Address_City                 
,Address_State                
,Address_Zip                  
,Address_Country              
,Phone_Primary                
,Phone_Cell                   
,ContactHash                  
,ETL_CreatedDate              
,ETL_UpdatedDate              
)

VALUES (  MySource.Email                        
	     ,MySource.First_Name                   
	     ,MySource.Last_Name                    
	     ,MySource.Suffix                       
	     ,MySource.Gender                       
	     ,MySource.Birth_Date                   
	     ,MySource.Address_Street               
	     ,MySource.Address_Suite                
	     ,MySource.Address_City                 
	     ,MySource.Address_State                
	     ,MySource.Address_Zip                  
	     ,MySource.Address_Country              
	     ,MySource.Phone_Primary                
	     ,MySource.Phone_Cell                   
	     ,MySource.ContactHash                  
	     ,GETDATE()	--ETL_CreatedDate              
	     ,GETDATE()	--ETL_UpdatedDate 
		);
GO
