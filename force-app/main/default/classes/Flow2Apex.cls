/**
* @File Name : Flow2Apex.cls
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

public class Flow2Apex {
	@AuraEnabled
	public static void LightningStudio(){
		System.debug('Lightning Studio');
	}
	@AuraEnabled(cacheable=true)
	public static List<Load_Account__b> getLoanData() {
		// Query Big Object (only indexed fields allowed in WHERE clause)
		List<Load_Account__b> loans = [
			SELECT Id, CreatedDate, Name__c, Contact__c, 
			Contact_Name__c, Loan_Type__c, Loan_Amount__c, 
			Account_Number__c, Details__c 
			FROM Load_Account__b
			LIMIT 50
		];
		return loans;
	}
	


	@InvocableMethod(label='ArchiveLoan')
	public static void ArchiveLoan(List<Id> loanIds){
		//ArchiveLoan related records
		//invoke a queuable job to add bigobjetct and delete the respective records
        for(Id input : loanIds) {
            // Example: fetch the record
            Account acc = [SELECT Id, MasterRecordId, Name, Type, ParentId, Phone, AccountNumber, Industry, AnnualRevenue, Ownership, Description, OwnerId, CreatedDate, AccountSource, Repaid__c, SLA__c, Active__c, Balance__c, Interest_Paid_A__c, SLASerialNumber__c, SLAExpirationDate__c, Loan_Date__c, Contact__c, Security_Contact__c, Account_Id__c, Loan_Amount__c, Advance_Deduction__c, State__c, Type__c 
			FROM Account 
			WHERE Id = :input];
            acc.Description = 'Updated via Flow → Apex';
            //update acc;
			System.debug(' Received the Account. account Details are below:');
			System.debug(acc);
			Id jobId = System.enqueueJob(new ArchiveLoanAccountQueuable(acc));
			System.debug('Job queued with Id: ' + jobId);
        }
    }
}