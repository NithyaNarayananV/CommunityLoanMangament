// ✅ Overview:
// This class creates a parent Account record named 'Total Accounts' for loan applications.
// It looks for contacts named 'ADMIN1' and 'ADMIN2' and assigns them to custom fields on the Account.
// If those contacts don’t exist, it creates them dynamically.


public with sharing class DefaultRecord {
    public static ID AccountCreate(String accountName) {
        Account acc = new Account();
        acc.Name = accountName;
        acc.Type__C = 'Other';    
        acc.Type = 'Other';    
        acc.Description = 'This is a parent account for all loan applications.';
        acc.Loan_Amount__c=0;
        List<Contact> adminContacts = [SELECT Id, Name FROM Contact WHERE Name like '%Admin%' LIMIT 2];

        Id admin1Id, admin2Id;

        for (Contact admin : adminContacts) {
            if (admin.get('Name') == 'ADMIN1') {
                admin1Id = (Id)admin.get('Id');
            } else if (admin.get('Name') == 'ADMIN2') {
                admin2Id = (Id)admin.get('Id');
            }
        }

        acc.Contact__C = admin1Id != null ? admin1Id : ContactCreate('ADMIN1');
        acc.Security_Contact__c = admin2Id != null ? admin2Id : ContactCreate('ADMIN2');

        try {
            insert acc;
            return acc.Id;
        } catch (Exception e) {
            System.debug('Error creating parent account: ' + e.getMessage());
            return null;
        }
    }
    public static Id ContactCreate(String contactName) {
        Contact newContact = new Contact();
        newContact.LastName = contactName;
        newContact.Total_Shares__c = 0;
        try {
            insert newContact;
            return newContact.Id;
        } catch (Exception e) {
            System.debug('Error creating contact: ' + e.getMessage());
            return null;
        }
    }
}