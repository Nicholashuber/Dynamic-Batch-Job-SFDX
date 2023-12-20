global class DynamicIntervalBatchJob implements Database.Batchable<sObject>, Schedulable {

    private String sObjectType;
    private Integer intervalMinutes;

    // Constructor to set the sObject type and interval
    global DynamicIntervalBatchJob(String sObjectType, Integer intervalMinutes) {
        this.sObjectType = sObjectType;
        this.intervalMinutes = intervalMinutes;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query;
        // Use switch statement to determine the query
        switch on sObjectType {
            when 'Account' {
                query = 'SELECT Id FROM Account LIMIT 1';
            }
            when 'Contact' {
                query = 'SELECT Id FROM Contact LIMIT 1';
            }
            // Add more cases for other sObject types as needed
            when else {
                throw new IllegalArgumentException('Invalid sObject type');
            }
        }

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        // Use switch statement for type-specific processing
        switch on sObjectType {
            when 'Account' {
                DynamicBatchAccountHandler.process(scope);
            }
            when 'Contact' {
                //DynamicBatchContactHandler.process(scope);
            }
            // Add more cases for other sObject types as needed
        }
    }

    global void finish(Database.BatchableContext BC) {
        // Get the current time and add the interval
        Datetime now = Datetime.now();
        Datetime nextRun = now.addMinutes(intervalMinutes);

        // Construct the cron expression for the next run
        String cronExp = '0 ' + nextRun.minute() + ' ' + nextRun.hour() + ' * * ?';

        // Schedule the job with the same sObjectType and interval
        System.schedule('DynamicIntervalBatchJob ' + sObjectType + ' ' + String.valueOf(now.getTime()), cronExp, new DynamicIntervalBatchJob(sObjectType, intervalMinutes));
    }

    global void execute(SchedulableContext SC) {
        Database.executeBatch(new DynamicIntervalBatchJob(this.sObjectType, this.intervalMinutes));
    }
}
