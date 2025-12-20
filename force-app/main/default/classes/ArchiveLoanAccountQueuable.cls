/**
* @File Name : ArchiveLoanAccountQueuable.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : December 20, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 20, 2025 |   | Initial Version
**/

public class ArchiveLoanAccountQueuable implements Queueable  {
    private Account loanAccount;

    // Constructor to pass parameters
    public ArchiveLoanAccountQueuable(Account loanAccount) {
        this.loanAccount = loanAccount;
    }

    // This runs asynchronously
    public void execute(QueueableContext context) {
        //Account loanAccount = [SELECT Id, Status__c FROM Account WHERE Id = :loanId];
        //loan.Status__c = 'Archived';
        //update loan;
		// DELECT Id, Name, Type, ParentId, Phone, AccountNumber, 
		//Description, OwnerId, CreatedDate, Repaid__c, SLA__c, 
		//Active__c, Balance__c, Interest_Paid_A__c, SLASerialNumber__c, 
		//SLAExpirationDate__c, Loan_Date__c, Contact__c, Security_Contact__c,
		// Account_Id__c, Loan_Amount__c, Advance_Deduction__c, State__c, Type__c 

		//select Id, CreatedById, CreatedDate, SystemModstamp, Name__c, Contact__c, 
		//Contact_Name__c, Loan_Type__c, Loan_Amount__c, Account_Number__c, Details__c from Load_Account__b 
		Load_Account__b newLoanAccount = new Load_Account__b();
		newLoanAccount.Name__c = loanAccount.Name;
		newLoanAccount.Contact__c = loanAccount.Contact__c;
		newLoanAccount.Security_Contact__c = loanAccount.Security_Contact__c;
		newLoanAccount.Loan_Amount__c = loanAccount.Loan_Amount__c;
		newLoanAccount.Balance_Loan_Amount__c = loanAccount.Balance__c;
		newLoanAccount.State__c = loanAccount.State__c;
		newLoanAccount.Account_Number__c = 1234;
		newLoanAccount.Details__c = 'TEST';
		System.debug(newLoanAccount);
		Database.insertImmediate(newLoanAccount);
		
    }
}