public with sharing class CNS_LWC_HelperClass {
    @AuraEnabled(cacheable=true)
    public static Decimal getTotalActiveBalanceLoan() {
        AggregateResult accounts = [SELECT SUM(Balance__c) FROM Account WHERE Type != 'Other'];
        Decimal totalAmt = (Decimal) accounts.get('expr0');
        return totalAmt;
    }
    @AuraEnabled(cacheable=true)
    public static Decimal getTotalSharesCount() {
        AggregateResult result = [SELECT SUM(SharesCount__c) FROM Shares__C];
        Decimal total = (Decimal) result.get('expr0');
        return total;
    }
    @AuraEnabled(cacheable=true)
    public static Decimal getSangamMembersCount() {
        AggregateResult result = [SELECT COUNT(Id) FROM Contact WHERE Total_Shares__c >0];
        Integer totalMembers = (Integer) result.get('expr0');
        return Decimal.valueOf(totalMembers);
    }
    @AuraEnabled(cacheable=true)
    public static Decimal getSangamTotalExpenses() {
        AggregateResult result = [SELECT SUM(Amount__c) FROM Expense__c ];
        Decimal totalSpent = (Decimal) result.get('expr0');
        return totalSpent;
    }
    @AuraEnabled(cacheable=true)
    public static List<Account> getActiveLoans() {
        return [SELECT Id, Name, Loan_Amount__c, Balance__c FROM Account ];
    }
}

