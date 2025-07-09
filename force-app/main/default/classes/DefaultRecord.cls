// ✅ Overview:
// This class creates a parent Account record named 'Total Accounts' for loan applications.
// It looks for contacts named 'ADMIN1' and 'ADMIN2' and assigns them to custom fields on the Account.
// If those contacts don’t exist, it creates them dynamically.


public with sharing class DefaultRecord {
    public static ID accountFetch(String AccountName){
        //String AccountName = 'Expenses Account';
        List<Account> AccountList = [Select Id,Name, Loan_Amount__c,Balance__c,Interest_Paid_A__c,state__C,Type ,Type__C,Contact__c,Advance_Deduction__c from Account WHERE Type = 'Other' ]; 
        id AID = null;
        id ReturnId = null;
        Integer index = 0;
        Set<String> DefaultAccountNames = new Set<String>{'Expenses Account', 'Donation Account', 'Available Balance','Loan Accounts','Loan Interest','Share Amount'};
        if(DefaultAccountNames.size() > AccountList.size()) {// not all default accounts are created
            System.debug('not all default accounts are created | '+ DefaultAccountNames.size() + ' > ' + AccountList.size());
            List<String> nameList = new List<String>();
            for (Account acc : accountList) {
                nameList.add(acc.Name);
                if(AccountName == acc.Name )
                    ReturnId = Acc.Id;
            }
            for( String A: DefaultAccountNames) {
                if(nameList.contains(A)) {
                    System.debug('Account with name ' + A + ' already exists.');                    
                }else{
                    System.debug('Account with name ' + A + ' DOESNOT exists.');
                    AID = (ID)DefaultRecord.AccountCreate(A);
                    System.debug('Account with name ' +A + ' Created with ID: ' + AID);
                    if(AccountName == A)
                        ReturnId = AID;
                }
            }
        }
        else if(DefaultAccountNames.size() == AccountList.size()) {
            System.debug('All default accounts were Present | '+ DefaultAccountNames.size() + ' = ' + AccountList.size());
            for( Account Acc : AccountList) {
                if(AccountName == Acc.Name) {
                    ReturnId = Acc.Id;
                    System.debug('Account with name ' + Acc.Name + ' already exists with ID: ' + ReturnId);
                }
            }
        }
        return ReturnId;
    }
    @future
    public static void accountRefresh(){
        //Getting the Account List again after creation of missing accounts
        List<Account> AccountList = [Select Id,Name, Loan_Amount__c,Balance__c,Interest_Paid_A__c,state__C,Type ,Type__C,Contact__c,Advance_Deduction__c from Account WHERE Type = 'Other' ]; 
        for( Account Acc : AccountList) {
            switch on Acc.Name {
                when 'Expenses Account' {
                    Acc.Loan_Amount__c = CNS_LWC_HelperClass.getSangamTotalExpenses(); 
                }
                when 'Donation Account' {
                    Acc.Loan_Amount__c = CNS_LWC_HelperClass.getSangamTotalDonation(); 
                }
                when 'Available Balance' {
                    Acc.Loan_Amount__c = 0 + CNS_LWC_HelperClass.getSangamTotalDonation() - CNS_LWC_HelperClass.getTotalActiveBalanceLoan() + (CNS_LWC_HelperClass.getTotalSharesCount()*50) + CNS_LWC_HelperClass.getTotalInterestReceived()- CNS_LWC_HelperClass.getSangamTotalExpenses(); 
                }
                when 'Loan Interest' {
                    Acc.Loan_Amount__c = 0 + CNS_LWC_HelperClass.getTotalInterestReceived();
                }
            }
        } update AccountList;
    }
    public static ID AccountCreate(String accountName) {
        Account acc = new Account();
        acc.Name = accountName;
        acc.Type__C = 'Other';    
        acc.Type = 'Other';    
        acc.Description = 'This is a parent account';
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