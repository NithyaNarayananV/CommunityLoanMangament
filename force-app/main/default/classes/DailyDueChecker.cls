global class DailyDueChecker implements Schedulable {
    global void execute(SchedulableContext SC) {
        // Your logic here
        System.debug('Scheduled job is running.');
    }
}
