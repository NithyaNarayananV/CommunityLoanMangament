trigger AccountAfterLoanInsert on Account (After insert) {
    /*
     * 	1) 	Remaning Account based on type of loan.
     * 
     * 	2)	Setting 10 months Repayment date for RL Loan
     * 
     * 	3)	Updating Loan Amount in Respective Contact.
     * 
     */
    
    
    Account Ac = [select  Balance_Loan__c,Loan_Amount__c,CreatedDate,Active__c, Loan_Date__c, Type,Advance_Deduction__c,Contact__c from Account WHERE Id IN :Trigger.new];
    String ContactId = ''+Ac.get('Contact__c');
    Contact Cc = Database.query('Select Name, Loan__c from Contact WHERE Id  = \'' +ContactId +'\'');

    //for(Account Ac:trigger.new) {
    //if(Ac.Advance_Deduction__c== ){
    //   Ac.Security_Contact__c.adderror('This email already exists. Msg from trigger.');
    //}
    //Ac.ParentId ='001Ig000008GpxKIAS';
    //date myDate = date.today.now();
    //+++++++++++++++++1111111111111111111112222222+++++++++++++++++++++++++++++++++
    datetime myDate = Ac.Loan_Date__c;
    Ac.Balance_Loan__c=Ac.Loan_Amount__c;//
    //- Ac.Advance_Deduction__c;
    
    if(Ac.Type == 'Regular_Loan')
    {
        //lastModDate=Datetime.valueOf(myDate);
        //sf.lastModifiedDate = );
        Ac.Name= 'RL '+Cc.get('Name') + ' : ₹' + Ac.Loan_Amount__c;// + ' '+myDate  ;//Ac.Account_Id__c;
        
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
    // for(Account Ac:trigger.new) {datetime myDate = datetime.now();
    //   Ac.Name= 'L '+myDate ;//Ac.Account_Id__c;
    
    //trigger AccountNameUpdateTime on Account (before insert) {
    //List<Loan__c> LoanC  = [select  Loan_given_to__c,SecurityID__c from Loan__c WHERE Id IN :Trigger.new];
    //for(Account Ac:trigger.new) {datetime myDate = datetime.now();
        
 }