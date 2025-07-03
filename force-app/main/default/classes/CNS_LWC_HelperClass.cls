public with sharing class CNS_LWC_HelperClass {
    @AuraEnabled(cacheable=true)
    public static Decimal getTotalActiveBalanceLoan() {
        List<Account> accounts = [SELECT Balance__c FROM Account WHERE Type != 'Other'];
        Decimal totalAmt = 0;
        for (Account acc : accounts) {
            totalAmt += acc.Balance__c != null ? acc.Balance__c : 0;
        }
        return totalAmt;
    }
    @AuraEnabled(cacheable=true)
    public static Decimal getTotalSharesCount() {
        List<Shares__C> Shares = [SELECT SharesCount__c FROM Shares__C];
        Decimal total = 0;
        for (Shares__C sha : Shares) {
            total += sha.SharesCount__c != null ? sha.SharesCount__c : 0;
        }
        return total;
    }
}

