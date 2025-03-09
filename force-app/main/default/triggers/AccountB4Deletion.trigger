trigger AccountB4Deletion on Account (before Delete) {
    
        //System.debug('Start Loan');
      for ( Account Ac :Trigger.old){
   
            //Loan__c LoanC  = [Select CreatedDate,Loan_Account__c, Action__c, Repay_Amount__c from Loan__c WHERE Id in :Trigger.old];
            String AccountId = ''+Ac.get('Id');
            List<Loan__c> LcList = Database.query('Select Id from Loan__c WHERE Loan_Account__c  = \'' +AccountId +'\'');
          	//for(Loan__c Lc: LcList)  
          	//	System.debug(Lc);
          	/*
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
			*/
          
            try {
                //update LoanUser;
                Delete LcList;
            } catch (DmlException e) {
                system.debug(e);// Process exception here
            }   
      }
    
}