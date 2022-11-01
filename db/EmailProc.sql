/****** Create a Database Account  ******/
EXEC msdb.dbo.sysmail_add_account_sp
    @account_name = 'SendEmailSqlDA'
  , @description = 'Sending SMTP mails to students'
  , @email_address = 'admin.dept@gmail.com'
  , @display_name = 'School AdminStudent attendance management system'
  , @replyto_address = 'admin.dept@gmail.com'
  , @mailserver_name = 'smtp.gmail.com'
  , @port = 587
  , @username = 'Communication4Student'
  , @password = 'TsDnSP&45'
Go

/* Add to the profile*

EXEC msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'AMSEP'
  , @description = 'For Attendance management system'
Go

/*The next step is to map the account to the profile*/

EXEC msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'AMSEP'
  , @account_name = 'SendEmailSqlDA'
  , @sequence_number = 1
GO


CREATE TRIGGER [dbo].[Attendance_INSERT_Notification]
       ON [dbo].[Attendance]
AFTER INSERT
AS
BEGIN
       SET NOCOUNT ON;
 
       DECLARE @att_stud_id INT
 
       SELECT @att_stud_id = INSERTED.att_stud_id      
       FROM Attendance
       declare @body varchar(500) = 'Attendance for Student ID : ' + CAST(@att_stud_id AS VARCHAR(5)) + ' inserted.'
       declare @student1email = select to from where @att_stud_id=INSERTED.att_stud_id
       EXEC msdb.dbo.sp_send_dbmail
            @profile_name = 'AMSEP'
           ,@recipients = @student1email
           ,@subject = 'Attendance Alert'
           ,@body = @body
           ,@importance ='HIGH'
END
