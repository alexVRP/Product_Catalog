trigger Order on Order__c (after insert, after update) {

    if (Trigger.isUpdate || Trigger.isInsert) {
        OrderTriggerHandler.handleAfterInsertUpdate(Trigger.new, Trigger.newMap);
    }
}