public with sharing class FindAccounts {

    public class AccountWithBudget {
        @AuraEnabled
        public List<Account> accounts;
        @AuraEnabled
        public Decimal totalBudgetSOQL = 0;
        @AuraEnabled
        public Decimal totalBudgetAPEX = 0;
    }

    @AuraEnabled
    public static AccountWithBudget getAccounts(String type) {
        AccountWithBudget accountWithBudget = new AccountWithBudget();
        List<Account> accounts = new List<Account>();
        if (!String.isEmpty(type)) {
            accounts = [SELECT Id, Name, Owner.Name, Type, Budget__c, Number_of_Employees__c FROM Account WHERE Type = :type];
            if (!accounts.isEmpty()) {
                for (AggregateResult aggregateResult : [SELECT SUM(Budget__c) total FROM Account WHERE Type = :type]) {
                    accountWithBudget.totalBudgetSOQL = (Decimal) aggregateResult.get('total');
                }
            }
        } else {
            accounts = [SELECT Id, Name, Owner.Name, Type, Budget__c, Number_of_Employees__c FROM Account];
            if (!accounts.isEmpty()) {
                for (AggregateResult aggregateResult : [SELECT SUM(Budget__c) total FROM Account]) {
                    accountWithBudget.totalBudgetSOQL = (Decimal) aggregateResult.get('total');
                }
            }
        }
        for (Account acc : accounts) {
            if (acc.Budget__c != null) {
                accountWithBudget.totalBudgetAPEX += acc.Budget__c;
            }
        }
        accountWithBudget.accounts = accounts;
        return accountWithBudget;
    }

    @AuraEnabled
    public static Account getAccountDetails(String accountId) {
        return [SELECT Id, Name, Type, Budget__c, Industry, Description FROM Account WHERE Id = :accountId];
    }
}