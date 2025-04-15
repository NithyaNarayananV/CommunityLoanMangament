trigger sendEmailOnChatCreation on FeedItem ( after insert) {
/*
    if (Trigger.isInsert) {
        String TableX='';
        TableX += 'Created !';
        //[SELECT Id,(SELECT Id FROM Opportunities) FROM Account WHERE Id IN :Trigger.new]);
        List<FeedItem> FeedItem  = [select CreatedDate, Body, CommentCount,  LikeCount, LinkUrl,ParentId, RelatedRecordId, Title from FeedItem WHERE Id IN :Trigger.new];
        String CommentedId = ''+FeedItem[0].get('ParentId');
        List<User> NameItem = [Select name from user where Id = :CommentedId ];
        TableX = '<tr><td>'+FeedItem[0].get('CreatedDate')+'</td><td>'+NameItem[0].get('Name')+'</td><td>'+FeedItem[0].get('Body')+'</td></tr>';
        
        //++++++++++++++++++ Adding a Record in Account Object+++++++++++++++++++++++++
        String BodyS = ''+FeedItem[0].get('Body');
        List<String> BodyList = BodyS.split(',');
        String NameS = ''+NameItem[0].get('Name');
        
        // Add account and related contact
        Account acct = new Account(
            Name=NameS,
            //Phone=BodyList[1],
            //NumberOfEmployees=BodyList[2],
            BillingCity=BodyList[0],
            OwnerId = '0052w00000ES7WiAAL'
        );
        insert acct;
        // Once the account is inserted, the sObject will be 
        // populated with an ID.
        // Get this ID.

        //------------------ Adding a Record in Account Object--------------------------
        
        
        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
        String[] toaddresses = new String[]{'cvrnishanth@gmail.com'};
        mymail.setToAddresses(toaddresses);
        mymail.setSubject('Salesforce | Chat Update | Loan | '+System.now().format());        
        mymail.setPlainTextBody('This has sent via Apex');  
        mymail.setHtmlBody(TableX);
        OrgWideEmailAddress owea = new OrgWideEmailAddress();
        owea = [ SELECT id FROM OrgWideEmailAddress];
        mymail.setOrgWideEmailAddressId(owea.Id);        
        Messaging.sendEmail(new Messaging.SingleEMailMEssage[]{mymail});//List<Messaging.Email> emailMessages);
        
    }
   */
}