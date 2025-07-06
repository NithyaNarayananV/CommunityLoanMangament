trigger AccountAfterLoanInsert on Account (After insert) {
    /*
     * 	1) 	ReNaming Account based on type of loan & Updating the Account's Active filed -> Yes
     * 
     * 	2)	Setting 10 months Repayment date for RL Loan
     * 
     * 	3)	Updating Loan Amount in Respective Contact.
     * 
     *  
     */    
    /*
    06/07/2025
    * 4) Going to create a funtion which will create a parent account (Total Accouts) if it is null.
    * 5) Will create a funcation, if the 2 Admin contact are not present.
*/
    
    Account Ac = [Select  Active__C, Balance__c,Loan_Amount__c,CreatedDate, Loan_Date__c, Type,Advance_Deduction__c,Contact__c,Type__C from Account WHERE Id IN :Trigger.new];
    if(Ac.Type__C!='Other' && Ac.Type != 'Other'){

        
        String ContactId = ''+Ac.get('Contact__c');
        Contact Cc = Database.query('Select Name, Loan__c from Contact WHERE Id  = \'' +ContactId +'\'');

        //+++++++++++++++++1111111111111111111112222222+++++++++++++++++++++++++++++++++
        datetime myDate = Ac.Loan_Date__c;
        //Ac.Balance__c=Ac.Loan_Amount__c;
        if(Ac.Type == 'Regular_Loan' || Ac.Type__C == 'Regular_Loan')
        {
            Ac.Name= 'RL '+Cc.get('Name') + ' : ₹' + Ac.Loan_Amount__c;// + ' '+myDate  ;//Ac.Account_Id__c;
            Ac.Active__c = 'Yes';
            //+++++++++++++++++++++++++++222222222222222222222222222222222222222222++++++++++++++++++++++++++++++++++++++++
            Ac.SLAExpirationDate__c = date.newinstance(myDate.year(),myDate.month()+10,myDate.day());
            //------------------------------222222222222222222222222222222222222222222----------------------------------------
        }
        else if(Ac.Type == 'Annual_Loan' || Ac.Type == 'Annual_Loan')
            Ac.Name= 'AL '+Cc.get('Name') + ' : ₹' + Ac.Loan_Amount__c;
        else
            Ac.Name= 'UL '+Cc.get('Name') + ' : ₹' + Ac.Loan_Amount__c;

        //+++++++++++++++++++++++++++4444444444444444444444444444444444++++++++++++++++++++++++++++++++++++++++
        String AccountNameTotalAccount = 'Total Accounts';
        List<Account> Ids = [Select id from Account where Name = :AccountNameTotalAccount limit 1];
        ID parentId = Ids.size() > 0 ? (id)Ids[0].get('Id') : DefaultRecord.AccountCreate(AccountNameTotalAccount);
        Ac.ParentId =parentId ; // '001Ig000008GpxKIAS'; //Select Item 4	Total Accounts
        //Add a condition to check if parentId is null... create a new parent account if it is null
            
        //------------------------------4444444444444444444444444444444444444444444----------------------------------------
        update Ac;
        //--------------------------------11111111111111111111111111111112222------------------------------------
        //
        //++++++++++++++++++++++++++++++++33333333333333333333333333++++++++++++++++++++++++++++++++
        
        if (Cc.Loan__c == null)
            Cc.Loan__c=0;
        Cc.Loan__c += Ac.Loan_Amount__c;
        Update Cc;
        
        //------------------------------------33333333333333333333333-----------------------------        
    } 
}