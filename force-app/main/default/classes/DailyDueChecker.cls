global class DailyDueChecker implements Schedulable {
    global void execute(SchedulableContext SC) {
        // Your logic here
        list<Loan__c> LoanCList  = [SELECT Id,  Name,   Action__c,  Repay_Date__c,  State__c  FROM loan__C where Repay_Date__c = Today AND Action__c = 'Installment'];
        for(Loan__c loan : LoanCList){
            loan.State__c = 'Due';
        }
        update LoanCList;
        System.debug('Scheduled job is running.');

    }
}
