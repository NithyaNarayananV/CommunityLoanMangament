trigger AccountNameUpdateTime on Account (before insert) {
  //List<Loan__c> LoanC  = [select  Loan_given_to__c,SecurityID__c from Loan__c WHERE Id IN :Trigger.new];
        //for(Account Ac:trigger.new) {datetime myDate = datetime.now();
      //  Ac.Name= 'L '+myDate ;//Ac.Account_Id__c;
    //}
}