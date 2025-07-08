trigger RepayBeforeCreation on Loan__c (before insert) {
    
    System.debug('Start Loan');
    //Loan__c LoanC  = [Select CreatedDate,Loan_Account__c, Action__c, Repay_Amount__c from Loan__c WHERE Id in :Trigger.new];
    for (Loan__c LoanC :Trigger.new)
    {
        //LoanC.Name='Repay';
        if(LoanC.Action__C =='Installation' || LoanC.Action__C =='Repayment'){
            String AccountId = ''+LoanC.get('Loan_Account__c');
        
            Account Ac = Database.query('select Active__c,Balance__c,state__C,Contact__c,Advance_Deduction__c,Loan_Amount__c from Account WHERE Id  = \'' +AccountId +'\'');
            //Ac.Balance__c -= LoanC.Repay_Amount__c;
            if(Ac.Balance__c < 0 || LoanC.Repay_Amount__c <0)
            {
            LoanC.Repay_Amount__c.addError('Amount Invalid');
            }            //Repay_Amount__c 
        }
        if( LoanC.Action__C =='Expense' )
        {
            System.debug('LoanC.Action__C == Expense');                //Expense
            LoanC.Name= ''+LoanC.Action__C +' - '+LoanC.get('Repay_Amount__c') ;//Ac.Account_Id__c;
            try{
                String AccountName = 'Expenses Account';
                LoanC.Loan_Account__c = DefaultRecord.accountFetch(AccountName);
                }catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
        if(  LoanC.Action__C =='Donation' ){
            System.debug('LoanC.Action__C == Donation');                //Expense
            LoanC.Name= ''+LoanC.Action__C +' - '+LoanC.get('Repay_Amount__c') ;//Ac.Account_Id__c;
            try{
                String AccountName = 'Donation Account';
                LoanC.Loan_Account__c = DefaultRecord.accountFetch(AccountName);                   
            }catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
    }
}