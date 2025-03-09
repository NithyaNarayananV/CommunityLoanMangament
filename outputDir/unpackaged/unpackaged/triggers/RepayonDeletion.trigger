trigger RepayonDeletion on Loan__c (before Delete) {
    
        //System.debug('Start Loan');
    	for ( Loan__c LoanC :Trigger.old){
   
            //Loan__c LoanC  = [Select CreatedDate,Loan_Account__c, Action__c, Repay_Amount__c from Loan__c WHERE Id in :Trigger.old];
            String AccountId = ''+LoanC.get('Loan_Account__c');
            Account Ac = Database.query('select Active__c,Balance_Loan__c,Interest_Paid__c,state__C,Contact__c,Advance_Deduction__c,Loan_Amount__c from Account WHERE Id  = \'' +AccountId +'\'');
            
            if(LoanC.Action__c !='Interest')
                Ac.Balance_Loan__c += LoanC.Repay_Amount__c;
            else if(LoanC.Action__c =='Interest')
                Ac.Interest_Paid__c -=LoanC.Repay_Amount__c;
            //Ac.Interest_Paid__c -=LoanC.Repay_Amount__c;
            if(Ac.Balance_Loan__c == 0)
            {
                Ac.State__C='Closed';
            }
            else
            {
                Ac.State__C='InProgress';
            }
            try {
                //update LoanUser;
                update Ac;
            } catch (DmlException e) {
                system.debug(e);// Process exception here
          	}   
    	}
    
}