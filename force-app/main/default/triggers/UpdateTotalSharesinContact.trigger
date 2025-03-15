/*
    On Share Record Creation :
        For Record Created in Salesfroce - Member Id WILL NOT be Present
            1. Update the Total Shares and Share Value of the Contact.
            2. Update the Loan Amount of the Shares Amount In Account Object.
        For Record Created in Salesforce - Member Id WILL be Present
            1. Update the Total Shares and Share Value of the Contact.
            //2. Update the Loan Amount of the Shares Amount In Account Object.
        
    Note : While Deplying to new Org Manke Sure to Create a Record in Account Object named 'Shares Amount' with Loan Amount = 0.
*/


trigger UpdateTotalSharesinContact on Shares__c (after insert) {
	List<Shares__c> SL = [Select Id, ContactName__c, SharesCount__c, Details__c, Member_Number__c from Shares__c where Id IN :Trigger.new];
    for (Shares__c S:SL){

        if (S.Member_Number__c == null) // Records Created in Salesforce (Not Bulk Updated)
        {
            String ID = ''+S.get('ContactName__c');
            System.debug(S);
            
            if( S.get('Details__c')  !='INITIAL SHARE')
            {
                Contact C = Database.query('Select id, Total_Shares__c,Share_Value__c, oldid__C from Contact where Id = \''+ID+'\'' );
                //String CountString  = '' + S.get('SharesCount__c');
                //Decimal Count = Decimal(CountString);
                C.Total_Shares__c += S.SharesCount__c;
                C.Share_Value__c = C.Total_Shares__c*50;
                //0012w00001Kv7dcAAB	
                update C;    
            }
            try{
                Account A = [Select Loan_Amount__c,Balance_Loan__c,Interest_Paid__c,state__C,Type ,Contact__c,Advance_Deduction__c from Account WHERE Name = 'Shares Amount' limit 1 ];//Id  = '0012w00001Kv7dcAAB']; 
                A.Loan_Amount__c += S.SharesCount__c * 50;
                update A;
            }
            catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
        else // Member Number Present | Usually Initial Bulk Upload.
        {
            //List<Contact> CL = [Select id, Total_Shares__c, oldid__C from Contact ];
            //Database.query('Select id, Total_Shares__c from Contact where oldid__C = '+ID);
            //String Type = ''+S.get('Details__c');
            try {
                //if( S.get('Details__c')  !='INITIAL SHARE')
                //for(Shares__C S :SL)
                //{
                    //for( Contact C: CL)
                    //{
                        String SID = '' + S.get('Member_Number__c');
                        //String CID = '' + C.get('oldid__C');
                        Contact C = Database.query('Select id, Total_Shares__c from Contact where oldid__C = '+SID);
                        //if (CID==SID)
                        //{
                            S.ContactName__c=''+C.get('Id');
                            if (C.Total_Shares__c == null)
                                C.Total_Shares__c = 0;
                            C.Total_Shares__c +=S.SharesCount__c;
                        //}
                    //}
                    update C;
                    update S; 
                    //if( Type  !='INITIAL SHARE')
                    //{
                        //if (Decimal(C.get('Total_Shares__c')) !>0.0)
                        //   C.Total_Shares__c = 0;
                    //}
               // }
            }
            catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
         
        }
        
        //}
        
    }
    
}