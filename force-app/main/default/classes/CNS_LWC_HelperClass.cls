public class CNS_LWC_HelperClass {
    @AuraEnabled(cacheable=true)
    public static Decimal getTotalActiveBalanceLoan() {
        AggregateResult accounts = [SELECT SUM(Balance__c) FROM Account WHERE Type != 'Other'];
        Decimal totalAmt = (Decimal) accounts.get('expr0');
        return totalAmt!= null? totalAmt : 0;
    }
    @AuraEnabled(cacheable=true)
    public static Decimal getTotalSharesCount() {
        AggregateResult result = [SELECT SUM(SharesCount__c) FROM Shares__C];
        Decimal total = (Decimal) result.get('expr0');
        return total!= null? total : 0;
    }
    @AuraEnabled(cacheable=true)
    public static Decimal getSangamMembersCount() {
        AggregateResult result = [SELECT COUNT(Id) FROM Contact WHERE Shares__c >0];
        Integer totalMembers = (Integer) result.get('expr0');
        return Decimal.valueOf(totalMembers)!= null? Decimal.valueOf(totalMembers) : 0;
    }
    @AuraEnabled(cacheable=true)
    public static Decimal getSangamTotalExpenses() {
        AggregateResult result = [SELECT SUM(Repay_Amount__c) FROM Loan__c where Action__c ='Expense' and State__c like 'Paid%' ];//[SELECT SUM(Amount__c) FROM Expense__c ];
        Decimal totalSpent = (Decimal) result.get('expr0');
        return totalSpent!= null? totalSpent : 0;
    }
     @AuraEnabled(cacheable=true)
    public static Decimal getSangamTotalDonation() {
        AggregateResult result = [SELECT SUM(Repay_Amount__c) FROM Loan__c where Action__c ='Donation' and State__c like 'Paid%' ];//[SELECT SUM(Amount__c) FROM Expense__c ];
        Decimal totalSpent = (Decimal) result.get('expr0');
        return totalSpent!= null?  totalSpent : 0;
    }
    @AuraEnabled(cacheable=true)
    public static List<Account> getActiveLoans() {
        return [SELECT Id, Name, Loan_Amount__c, Balance__c FROM Account ];
    }
    @AuraEnabled(cacheable=true)
    public static Decimal getTotalInterestReceived() {
        AggregateResult interestReceved = [SELECT SUM(Repay_Amount__c) FROM Loan__c WHERE Action__C = 'Interest'];
        Decimal totalInterestRec = (Decimal) interestReceved.get('expr0');
        return totalInterestRec!= null? totalInterestRec : 0;
    }
}

