# Dynamic-Batch-Job-SFDX

## Usage
To execute the `DynamicIntervalBatchJob` from the Salesforce Apex Execute Anonymous Window, follow these steps:

1. **Open Developer Console**: In Salesforce, go to `Setup` and open the `Developer Console`.
2. **Open Execute Anonymous Window**: In the Developer Console, navigate to `Debug` > `Open Execute Anonymous Window`.
3. **Prepare the Apex Script**: In the Execute Anonymous Window, enter the Apex code to schedule the batch job. For example:

   ```apex
   // Schedule a batch job for 'Account' sObject type to run every 30 minutes
   DynamicIntervalBatchJob batchJob = new DynamicIntervalBatchJob('Account', 30);
   Database.executeBatch(batchJob, 1);

   // Note: Replace 'Account' with your desired sObject type and 30 with your desired interval in minutes.
   ```


### Execution Flow
When you execute the `DynamicIntervalBatchJob`, it follows this workflow:

1. **Initialization**: Upon execution, the batch job is initialized with the specified sObject type (e.g., 'Account') and the interval (in minutes) at which it should run. This initialization happens when you execute the provided Apex script in the Salesforce Execute Anonymous Window.

2. **Batch Processing**: 
   - The `start` method is invoked first, determining which records to process based on the sObject type. It constructs a SOQL query dynamically based on the sObject type provided during initialization.
   - Next, the `execute` method is called with the records returned by the query. Here, specific logic for each sObject type is applied (e.g., updating fields on Account records).

3. **Rescheduling**: 
   - After the `execute` method completes for all batches, the `finish` method is invoked.
   - In the `finish` method, the job schedules itself to run again. It calculates the next run time by adding the originally specified interval to the current time.
   - This rescheduling is done using a cron expression that specifies when the job should run next, ensuring that it continues to execute at the set interval.

### Dynamic Scheduling
The dynamic aspect of the `DynamicIntervalBatchJob` comes from its ability to automatically reschedule itself:

- **Self-Rescheduling**: After each execution cycle, the job uses the interval specified at the start to determine the next execution time. This means that once started, the batch job continues to run at regular intervals without any further manual intervention.

- **Flexibility**: The interval is not hardcoded but passed as a parameter. This allows for great flexibility, as different instances of the job can be scheduled to run at different intervals depending on the requirements.

- **Consistent Interval**: The job maintains the interval set during the initial scheduling. For example, if it’s scheduled to run every 15 minutes, it will continue to do so unless modified.
