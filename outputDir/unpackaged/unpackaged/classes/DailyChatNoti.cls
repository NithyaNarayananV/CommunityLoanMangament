global class DailyChatNoti implements Schedulable {

global void execute(SchedulableContext sc) {
        ///*
        	
    	//*/
    	String TableHead ='<h1> Chat report of Yesterday and Today </h1>';
    	TableHead +='<table border="1" style="border-collapse: collapse"><tr><th>Time</th><th>From</th><th>Message</th></tr>';
        
        String TableX='';
    	String CommentedName = '';
    	String CommentedId = '';
        List<FeedItem> FeedItem  = [select CreatedDate, Body, CommentCount,  LikeCount, LinkUrl,ParentId, RelatedRecordId, Title from FeedItem WHERE Type = 'TextPost' And (CreatedDate = Today or CreatedDate = Yesterday)] ;
    	List<User> NameItem= new List<User>();    
        for(FeedItem s:FeedItem)
        {
            System.debug('FeedItem'+s);//[select Id, Body, CommentCount, CreatedDate, LikeCount, LinkUrl, ParentId, RelatedRecordId, Title, Type from FeedItem]);// WHERE Type = 'TextPost']);
            //18:43:12:013 USER_DEBUG [19]|DEBUG|FeedItemFeedItem:{CreatedDate=2024-08-10 07:14:55, Body=Vanakam. I can now post, CommentCount=0, LikeCount=1, ParentId=0052w00000ES7WiAAL, Id=0D5Ig00000EwAlaKAF, IsRichText=false}
            CommentedId = ''+s.get('ParentId');
            NameItem = [Select name from user where Id = :CommentedId ];
            //NameItem=NameItem[0];
            //System.debug(NameItem[0].get('Name'));
            TableX = '<tr><td>'+s.get('CreatedDate')+'</td><td>'+NameItem[0].get('Name')+'</td><td>'+s.get('Body')+'</td></tr>';
            System.debug(TableX);
            TableHead += TableX;
        }
        TableHead += '</table>';
        
                
        // /*
        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
        String[] toaddresses = new String[]{'cvrnishanth@gmail.com'};
        mymail.setToAddresses(toaddresses);
        mymail.setSubject('Salesforce | Chat Update | Loan | '+System.now().format());        
        mymail.setPlainTextBody('This has sent via Apex'); 	
        mymail.setHtmlBody(TableHead);
        OrgWideEmailAddress owea = new OrgWideEmailAddress();
        owea = [ SELECT id FROM OrgWideEmailAddress];
		mymail.setOrgWideEmailAddressId(owea.Id);        
        Messaging.sendEmail(new Messaging.SingleEMailMEssage[]{mymail});//List<Messaging.Email> emailMessages);
        //*/
    System.debug('End');
    }


}