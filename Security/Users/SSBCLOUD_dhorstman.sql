IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'SSBCLOUD\dhorstman')
CREATE LOGIN [SSBCLOUD\dhorstman] FROM WINDOWS
GO
CREATE USER [SSBCLOUD\dhorstman] FOR LOGIN [SSBCLOUD\dhorstman]
GO
