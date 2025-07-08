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
            if( LoanC.Action__C =='Expense'  )
            {
                System.debug('LoanC.Action__C == Expense');
                //Expense
                LoanC.Name= 'Expense - '+LoanC.get('Repay_Amount__c') ;//Ac.Account_Id__c;
                // update the "Expense" Account with the Expense Amount
                //	Expenses
                try{
                    String AccountName = 'Expenses Account';
                    List<Account> ExpenseAccountList = [Select Loan_Amount__c,Balance__c,Interest_Paid_A__c,state__C,Type ,Type__C,Contact__c,Advance_Deduction__c from Account WHERE Name = :AccountName limit 1 ];//Id  = '0012w00001Kv7dcAAB']; 
                    if(ExpenseAccountList.size() == 0) {
                        id ExpenseAID = (ID)DefaultRecord.AccountCreate(AccountName);
                        LoanC.Loan_Account__c = ExpenseAID;
                        //ShareAccountList.add(new Account(Name = AccountName, Loan_Amount__c = 0, Type__C = 'Other', Type = 'Other', Description = 'This is a parent account for all share applications.',  Interest_Paid_A__c = 0, state__C = 'Active', Contact__c = ID, Advance_Deduction__c = 0));
                        ExpenseAccountList = [Select Loan_Amount__c,Balance__c,Interest_Paid_A__c,state__C,Type ,Type__C,Contact__c,Advance_Deduction__c from Account WHERE ID = :ExpenseAID limit 1 ];//Id  = '0012w00001Kv7dcAAB']; 
                    }
                    if(ExpenseAccountList.size() > 0 ){
                        ExpenseAccountList[0].Loan_Amount__c = CNS_LWC_HelperClass.getSangamTotalExpenses(); // As singlevalue of share is equvalent of ₹50/-
                        update ExpenseAccountList;
                    }
                }catch(DmlException e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                }
                try{
                    String AccountName = 'Donation Account';
                    List<Account> ExpenseAccountList = [Select Loan_Amount__c,Balance__c,Interest_Paid_A__c,state__C,Type ,Type__C,Contact__c,Advance_Deduction__c from Account WHERE Name = :AccountName limit 1 ];//Id  = '0012w00001Kv7dcAAB']; 
                    if(ExpenseAccountList.size() == 0) {
                        id ExpenseAID = (ID)DefaultRecord.AccountCreate(AccountName);
                        //ShareAccountList.add(new Account(Name = AccountName, Loan_Amount__c = 0, Type__C = 'Other', Type = 'Other', Description = 'This is a parent account for all share applications.',  Interest_Paid_A__c = 0, state__C = 'Active', Contact__c = ID, Advance_Deduction__c = 0));
                        ExpenseAccountList = [Select Loan_Amount__c,Balance__c,Interest_Paid_A__c,state__C,Type ,Type__C,Contact__c,Advance_Deduction__c from Account WHERE ID = :ExpenseAID limit 1 ];//Id  = '0012w00001Kv7dcAAB']; 
                    }
                    if(ExpenseAccountList.size() > 0 ){
                        ExpenseAccountList[0].Loan_Amount__c = CNS_LWC_HelperClass.getSangamTotalDonation(); // As singlevalue of share is equvalent of ₹50/-
                        update ExpenseAccountList;
                    }
                }catch(DmlException e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                }
                //Update LoanC;
            }
        
    
    }
}