/**
 * @description      : 
 * @Riley Meyer            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger AccountTrigger on Account (before insert, after insert) {
  if (Trigger.isInsert) {
    if (Trigger.isBefore) {
      AccountTriggerHandler.beforeInsert(Trigger.new);
    } else if (Trigger.isAfter) {
      AccountTriggerHandler.afterInsert(Trigger.new);
    }
  }
}