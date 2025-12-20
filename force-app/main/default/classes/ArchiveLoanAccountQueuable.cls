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
        List<Loan__c> repayLoanRecords = [SELECT Id, Name, PyamentDate__c, Action__c, Repay_Amount__c, Paid_To__c, Repay_Date__c, LoanerID__c, State__c, Description__c, Category__c, Loan_Account__c 
		FROM Loan__c  
		WHERE Loan_Account__c = :loanAccount.Id];
		String jsonOutput = JSON.serialize(repayLoanRecords);
		System.debug(jsonOutput);

		Load_Account__b newLoanAccount = new Load_Account__b();
		newLoanAccount.Name__c = loanAccount.Name;
		newLoanAccount.Contact__c = loanAccount.Contact__c;
		newLoanAccount.Security_Contact__c = loanAccount.Security_Contact__c;
		newLoanAccount.Loan_Amount__c = loanAccount.Loan_Amount__c;
		newLoanAccount.Balance_Loan_Amount__c = loanAccount.Balance__c;
		newLoanAccount.State__c = loanAccount.State__c;
		Datetime nowDt = Datetime.now();
		String formatted = nowDt.format('yyyyMMddHHmmss');
		Long numericDateTime = Long.valueOf(formatted);
		System.debug(numericDateTime); 
		newLoanAccount.Account_Number__c = numericDateTime;
		newLoanAccount.Details__c = jsonOutput;
		System.debug(newLoanAccount);
		Database.insertImmediate(newLoanAccount);
		
    }
}