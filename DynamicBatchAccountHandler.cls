public class DynamicBatchAccountHandler {
    public static void process(List<sObject> records) {
        List<Account> updatedAccounts = new List<Account>();
        for (sObject record : records) {
            Account accountRecord = (Account) record;
            // Modify accountRecord as needed
            updatedAccounts.add(accountRecord);
        }
        try {
            update updatedAccounts;
        } catch (DmlException e) {
            System.debug('Error updating accounts: ' + e.getMessage());
        }
    }
}
