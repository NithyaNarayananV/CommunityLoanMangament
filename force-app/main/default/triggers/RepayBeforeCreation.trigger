trigger RepayBeforeCreation on Loan__c (before insert) {
    
        System.debug('Start Loan');
        //Loan__c LoanC  = [Select CreatedDate,Loan_Account__c, Action__c, Repay_Amount__c from Loan__c WHERE Id in :Trigger.new];
        for (Loan__c LoanC :Trigger.new)
        {
            //LoanC.Name='Repay';
            String AccountId = ''+LoanC.get('Loan_Account__c');
            Account Ac = Database.query('select Active__c,Balance__c,state__C,Contact__c,Advance_Deduction__c,Loan_Amount__c from Account WHERE Id  = \'' +AccountId +'\'');
            //Ac.Balance__c -= LoanC.Repay_Amount__c;
            if(Ac.Balance__c < 0 || LoanC.Repay_Amount__c <0)
            {
               LoanC.Repay_Amount__c.addError('Amount Invalid');
            }            //Repay_Amount__c 
        
        }
        /*
        String AccountId = ''+LoanC.get('Loan_Account__c');
        Account Ac = Database.query('select Active__c,Balance__c,state__C,Contact__c,Advance_Deduction__c,Loan_Amount__c from Account WHERE Id  = \'' +AccountId +'\'');
        
        if (Ac.Balance__c == null)
        {
            Ac.Balance__c = Ac.Loan_Amount__c;
        }
        Ac.Balance__c -= LoanC.Repay_Amount__c;
        if(Ac.Balance__c == 0)
        {
            Ac.State__C='Closed';
        }
        else if(Ac.Balance__c < 0)
        {
           LoanC.Repay_Amount__c.addError('Not Acceptable');
        }
        else
        {
            Ac.State__C='InProgress';
        }
        ///*
        //++++++++++++++++++ Adding Amount to Contacts +++++++++++++++++++++++++
        String AcNo = ''+LoanC.get('Loan_Account__c');
        Integer NetAmount = 0;
        Account AcDetail  = Database.query('select CreatedDate,ContactName__c,Loan_Start_date__c, Action__c, Loan_Amount__c, Repay_Amount__c from Loan__c WHERE Id IN :'+AcNo);
        if(LoanC.get('Action__c') == 'Installment')
           LoanC.Repay_Amount__c= AcDetail.Loan_Amount__c/10; // NetAmount += Integer.valueOf(LoanC[0].get('Loan_Amount__c'));
        
        //else if(LoanC.get('Action__c') == 'Installment')
        //    NetAmount -= Integer.valueOf(LoanC.get('Repay_Amount__c'));
        //LoanUser.Loan__c +=NetAmount;
        
        
        //LoanC[0].Loan_Start_date__c = date.valueOf(LoanC[0].get('CreatedDate'));
        //Loan_Start_date__c
         //*/
        /*
        try {
            //update LoanUser;
            update Ac;
        } catch (DmlException e) {
            system.debug(e);// Process exception here
        }   
        //Loan_Start_date__c
        */     
}