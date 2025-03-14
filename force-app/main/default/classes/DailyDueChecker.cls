global class DailyDueChecker implements Schedulable {
    global void execute(SchedulableContext SC) {
        // Your logic here
        list<Loan__c> LoanCList  = [SELECT Id,  Name, Loan_Account__c,  Action__c,  Repay_Date__c,  State__c  FROM loan__C where Repay_Date__c = Today AND Action__c = 'Installment'];
        //list<Account> AL = []
        List<String> AccList = new List<String>();
        for(Loan__c loan : LoanCList){
            loan.State__c = 'Due';
            //loan.Loan_Account__r.State__c = 'Due';
            system.debug('Account State is: ' + loan.Loan_Account__c);
            AccList.add(''+loan.Loan_Account__c);
        }
        list<Account> AL = [Select name, State__c from Account where ID IN :AccList];
        for(Account acc : AL){
            system.debug('Account State is: ' + acc.State__c);
            acc.State__c = 'Due';
        }
        update LoanCList;
        update AL;
        System.debug('Scheduled job is running.');

    }
}