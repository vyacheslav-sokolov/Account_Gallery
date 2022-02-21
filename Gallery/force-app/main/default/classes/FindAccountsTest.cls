@IsTest
private class FindAccountsTest {
    private static final String PROSPECT_TYPE = 'Prospect';
    private static final String OTHER_TYPE = 'Other';
    private static final String ACCOUNT_NAME = 'Test AccName';
    private static final String EMPTY_STRING = '';

    @IsTest
    static void getProspectAccountsTest() {
        List<Account> accsToInsert = new List<Account>();
        Account prospectAcc = new Account(Name = ACCOUNT_NAME, Type = PROSPECT_TYPE, Budget__c = 100);
        accsToInsert.add(prospectAcc);

        Account otherAcc = new Account(Name = ACCOUNT_NAME, Type = OTHER_TYPE);
        accsToInsert.add(otherAcc);
        insert accsToInsert;

        FindAccounts.AccountWithBudget accountWithBudget = new FindAccounts.AccountWithBudget();
        accountWithBudget = FindAccounts.getAccounts(PROSPECT_TYPE);
        System.assertEquals(1, accountWithBudget.accounts.size());
        System.assertEquals(PROSPECT_TYPE, accountWithBudget.accounts[0].Type);
        System.assertEquals(100, accountWithBudget.totalBudgetAPEX);
        System.assertEquals(100, accountWithBudget.totalBudgetSOQL);
    }

    @IsTest
    static void getAccountsTest() {
        List<Account> accsToInsert = new List<Account>();
        Account prospectAcc = new Account(Name = ACCOUNT_NAME, Type = PROSPECT_TYPE, Budget__c = 100);
        accsToInsert.add(prospectAcc);

        Account otherAcc = new Account(Name = ACCOUNT_NAME, Type = OTHER_TYPE, Budget__c = 100);
        accsToInsert.add(otherAcc);
        insert accsToInsert;

        FindAccounts.AccountWithBudget accountWithBudget = new FindAccounts.AccountWithBudget();
        accountWithBudget = FindAccounts.getAccounts(EMPTY_STRING);
        System.assertEquals(2, accountWithBudget.accounts.size());
        System.assertEquals(200, accountWithBudget.totalBudgetAPEX);
        System.assertEquals(200, accountWithBudget.totalBudgetSOQL);
    }

    @IsTest
    static void getAccountDetailsTest() {
        Account prospectAcc = new Account(Name = ACCOUNT_NAME, Type = PROSPECT_TYPE);
        insert prospectAcc;

        Account acc = FindAccounts.getAccountDetails(prospectAcc.Id);
        System.assertEquals(prospectAcc.Id, acc.Id);
    }
}