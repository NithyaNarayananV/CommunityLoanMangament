trigger AccountB4LoanInsert on Account (before insert,before update) {
    /*  ````````````````` Security Validation On Account````````````````````
    *  1)  Security Contact SHOULD NOT be Same as Loan Contact.
    * 
    *  2)  Setting a Parent Account All Loan Account to "Account" [Ac.ParentId ='001Ig000008GpxKIAS']
    * 
    *  3)  Setting a 20% initial Interest Dedection for Regular Loan [Ac.Advance_Deduction__c = Ac.Loan_Amount__c * 0.20]
    * 
    *  4)  Repay Date Should be atlease 30 days of Loan Date
    */

    for(Account Ac:trigger.new) {

        if(Ac.contact__C== Ac.Security_Contact__c) 
            Ac.Security_Contact__c.adderror('Same Contact can\'t give Security to himself. Choose diffrent Contact.');

        if (Trigger.isInsert) {
            System.debug('This trigger is running for an INSERT operation.');
            if( Ac.Loan_Date__c.addDays(30) > Ac.SLAExpirationDate__c) 
                Ac.SLAExpirationDate__c.addError('Repay Date Should be atlease 30 days From Loan Date');

                List<Account> Ids = [Select id from Account where Name = 'Total Accounts' limit 1];
                ID parentId = Ids.size() > 0 ? Ids[0].Id : null;
                Ac.ParentId =parentId ; // '001Ig000008GpxKIAS'; //Select Item 4	Total Accounts
                //Add a condition to check if parentId is null... create a new parent account if it is null
        
            if (Ac.Type == 'Regular_Loan') {
                Ac.Advance_Deduction__c = Ac.Loan_Amount__c * 0.20;
            } else {
                Ac.Advance_Deduction__c = 0;
            }
        }
    }
 }