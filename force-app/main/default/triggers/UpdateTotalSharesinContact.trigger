/*
    On Share Record Creation :
        For Record Created in Salesfroce - Member Id WILL NOT be Present
            2. Update the Loan Amount of the Shares Amount In Account Object.
        For Record Created in Salesforce - Member Id WILL be Present
            2. Update the Loan Amount of the Shares Amount In Account Object.
        
    Note : While Deplying to new Org Manke Sure to Create a Record in Account Object named 'Shares Amount' with Loan Amount = 0.
*/
trigger UpdateTotalSharesinContact on Shares__c (after insert) {
	List<Shares__c> SL = [Select Id, ContactName__c, SharesCount__c, Details__c, Member_Number__c from Shares__c where Id IN :Trigger.new];
    for (Shares__c S:SL){
        if (S.Member_Number__c == null){ // Records Created in Salesforce (Not Bulk Updated)       
            String ID = ''+S.get('ContactName__c');
            System.debug(S);
        }
        else{ // Member Number Present | Usually Initial Bulk Upload.        
            try {
                String SID = '' + S.get('Member_Number__c');
                Contact C = Database.query('Select id from Contact where oldid__C = '+SID);
                S.ContactName__c=''+C.get('Id');
                update S; 
            }
            catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
        try{
            String AccountName = 'Share Amount';
            List<Account> ShareAccountList = [Select Loan_Amount__c,Balance__c,Interest_Paid_A__c,state__C,Type ,Type__C,Contact__c,Advance_Deduction__c from Account WHERE Name = :AccountName limit 1 ];//Id  = '0012w00001Kv7dcAAB']; 
            if(ShareAccountList.size() == 0) {
                id ShareAID = (ID)DefaultRecord.AccountCreate('Share Accounts');
                //ShareAccountList.add(new Account(Name = AccountName, Loan_Amount__c = 0, Type__C = 'Other', Type = 'Other', Description = 'This is a parent account for all share applications.',  Interest_Paid_A__c = 0, state__C = 'Active', Contact__c = ID, Advance_Deduction__c = 0));
                ShareAccountList = [Select Loan_Amount__c,Balance__c,Interest_Paid_A__c,state__C,Type ,Type__C,Contact__c,Advance_Deduction__c from Account WHERE ID = :ShareAID limit 1 ];//Id  = '0012w00001Kv7dcAAB']; 
            }
            if(ShareAccountList.size() > 0 ){
                ShareAccountList[0].Loan_Amount__c = 50 * CNS_LWC_HelperClass.getTotalSharesCount(); // As singlevalue of share is equvalent of ₹50/-
                update ShareAccountList;
            }
        }catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
}