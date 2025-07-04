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
    
    Account Ac = [Select  Active__C, Balance__c,Loan_Amount__c,CreatedDate, Loan_Date__c, Type,Advance_Deduction__c,Contact__c from Account WHERE Id IN :Trigger.new];
    String ContactId = ''+Ac.get('Contact__c');
    Contact Cc = Database.query('Select Name, Loan__c from Contact WHERE Id  = \'' +ContactId +'\'');

    //+++++++++++++++++1111111111111111111112222222+++++++++++++++++++++++++++++++++
    datetime myDate = Ac.Loan_Date__c;
    //Ac.Balance__c=Ac.Loan_Amount__c;
    if(Ac.Type == 'Regular_Loan')
    {
        Ac.Name= 'RL '+Cc.get('Name') + ' : ₹' + Ac.Loan_Amount__c;// + ' '+myDate  ;//Ac.Account_Id__c;
        Ac.Active__c = 'Yes';
        //+++++++++++++++++++++++++++222222222222222222222222222222222222222222++++++++++++++++++++++++++++++++++++++++
        Ac.SLAExpirationDate__c = date.newinstance(myDate.year(),myDate.month()+10,myDate.day());
        //------------------------------222222222222222222222222222222222222222222----------------------------------------
    }
    else if(Ac.Type == 'Annual_Loan')
        Ac.Name= 'AL '+Cc.get('Name') + ' : ₹' + Ac.Loan_Amount__c;
    else
        Ac.Name= 'UL '+Cc.get('Name') + ' : ₹' + Ac.Loan_Amount__c;
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