global class DailyContactLoanUpdateEmail implements Schedulable {

global void execute(SchedulableContext sc) {

        //List<Loan__c> LoanC  = [select CreatedDate, Loan_given_to__c, Action__c, Loan_Amount__c, Repay_Amount__c from Loan__c WHERE Id IN :Trigger.new];
        //String CommentedId = ''+FeedItem[0].get('ParentId');
        //List<User> NameItem = [Select name from user where Id = :CommentedId ];
        //String TableX = '';//<tr><td>'+LoanC[0].get('CreatedDate')+'</td><td>'+LoanC[0].get('Loan_Amount__c')+'</td><td>'+LoanC[0].get('Action__c')+'</td></tr>';
        List<Contact > UserList = [Select Id,Name, Loan__c From Contact];
        //++++++++++++++++++ Adding a Record in Account Object+++++++++++++++++++++++++
    Integer NetAmount=0;   
    for ( Contact u:UserList) 
       {
            String ID = ''+u.get('Id');
            System.debug(ID);
            List<Loan__c> LoanListUser  = Database.query('SELECT CreatedDate, Loan_given_to__c,ContactName__c, Action__c, Loan_Amount__c, Repay_Amount__c from Loan__c WHERE ContactName__c= \''+ID+'\'');
            NetAmount = 0;
            System.debug(LoanListUser);
            //String TableX=''
            for (Loan__c i : LoanListUser)
            {
                System.debug('In For Loop'+i);
                //TableX +=i;
                if(i.get('Action__c') == 'Loan')
                {
                    NetAmount += Integer.valueOf(i.get('Loan_Amount__c'));
                }
                else if(i.get('Action__c') == 'Repay')
                {
                    NetAmount =NetAmount - Integer.valueOf(i.get('Repay_Amount__c'));
                }
                //System.debug('#######');
            }
           //System.debug('Next User');
           u.Loan__c =NetAmount;
       }
        //List<user> UserCurrent = Database.query('SELECT NetAmount__c FROM User WHERE Id = \''+LoanC[0].get('Loan_given_to__c')+'\'');
        //UserCurrent.NetAmount__c =NetAmount;//Integer.valueOf(LoanC[0].get('Loan_Amount__c'));
        //System.debug(LoanC[0].get('Loan_Amount__c'));
        //update acct;
        
        try {
            update UserList;
        } catch (DmlException e) {
            system.debug(e);// Process exception here
        }   
       
    
    //Mailing Start
    Messaging.reserveSingleEmailCapacity(1);
    Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
    
    String[] toaddresses = new String[]{'cvrnishanth@gmail.com','nithyanarayanancvr@gmail.com'};
        
    OrgWideEmailAddress owea = new OrgWideEmailAddress();
    owea = [ SELECT id,Address, DisplayName FROM OrgWideEmailAddress];
    mymail.setToAddresses(toaddresses);
    mymail.setSubject('Salesforce | Loan Check | '+System.now());    
    mymail.setPlainTextBody('This has sent via Apex');
    //Mailing End
    
    String TableX ='<h1 style="color:blue;">Loan Health Check - Automated</h1>';
    //Outter Table 
    TableX +='<table border="1" style="border-collapse: collapse"><tr>';
     
    //User UserCurrent = Database.query('SELECT NetAmount__c FROM User WHERE Id = \''+LoanC[0].get('Loan_given_to__c')+'\'');
    //UserCurrent.NetAmount__c =NetAmount;//Integer.valueOf(LoanC[0].get('Loan_Amount__c'));

    
    //UserLicense-----------------------------------------------------------
    
    //System.debug(myList);
    TableX += '<br><h1>User </h1>';
    //String TableX='';
    //if(UserLicenseList.size()>0)
    //{
      
    //Opening User Licenses Table
    TableX +='<table border="1" style="border-collapse: collapse"><tr><th> Name </th><th> Loan Amount </th></tr>';
    for(Contact s:UserList)
    {
        
        TableX += '<tr><td>'+s.get('Name')+'</td><th>'+s.get('Loan__c')+'</th></tr>';
        //TableHead += TableX;
    }
    TableX += '</table>';//Closing User Licenses Table===========================
    //}
    TableX +='</tr><tr>';
    
    
    TableX += '</table>';//Outter Table Closing
    
    String Signature ='<br><br>Thanks & Regards';
    Signature += '<h5 style="color:blue;">Nithya Narayanan</h5><h5 style="color:blue;">Tata Consultancy Services - From Loan ORG - playful-wolf-6cstql-dev-ed.trailblaze.</h5>';
    
    TableX += Signature;
    
    //Messaging Start
    mymail.setHtmlBody(TableX);
    mymail.setOrgWideEmailAddressId(owea.Id);
    
    Messaging.sendEmail(new Messaging.SingleEMailMEssage[]{mymail});//List<Messaging.Email> emailMessages);
    //Messaging End
    System.debug('End');
    }

}