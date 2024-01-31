$Parameters = @{
FromAddress = "Example@example.com"
ToAddress = "Example1@example.com","Example2@example.com"
#CCAddress = "Example4@example.com"
Subject = "SendGrid example"
Body = "This is a plain text email"
Token = ""
FromName = ""
ToName ="Jayendra","Mishra"
}
Send-PSSendGridMail @Parameters