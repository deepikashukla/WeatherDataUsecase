trigger ContactTrigger on Contact (after insert) {
	Switch on Trigger.operationType{
        when AFTER_INSERT {
            ContactTriggerHandler.onAfterInsert(Trigger.new);
        }
    }
}