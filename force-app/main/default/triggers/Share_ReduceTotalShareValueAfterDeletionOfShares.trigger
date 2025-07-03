trigger Share_ReduceTotalShareValueAfterDeletionOfShares on Shares__C (before delete) {

    Shares__c S = [Select Id, ContactName__c, SharesCount__c, Details__c, Member_Number__c from Shares__c where Id IN :Trigger.old];
    String ID = ''+S.get('ContactName__c');
    System.debug(S);
    Contact C = Database.query('Select id, Total_Shares__c,Share_Value__c, oldid__C from Contact where Id = \''+ID+'\'' );
    //String CountString  = '' + S.get('SharesCount__c');
    //Decimal Count = Decimal(CountString);
    
    C.Total_Shares__c -= S.SharesCount__c;
    C.Share_Value__c = C.Total_Shares__c *  50;
    Account A = [Select Loan_Amount__c,Balance__c,Interest_Paid_A__c,state__C,Type__c ,Contact__c,Advance_Deduction__c from Account WHERE Id  = '0012w00001Kv7dcAAB']; 
    A.Loan_Amount__c -= S.SharesCount__c * 50;
    update A;
    if( C.Total_Shares__c <=0)    
    {
        S.ContactName__c='003Ig000003ovcrIAA';
        try{Update S;}
        catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        //Delete C;
    } 
    else
		Update C;
    //Delete S;
    
}