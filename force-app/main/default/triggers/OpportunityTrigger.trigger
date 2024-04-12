/**
 * @description       : 
 * @Riley Meyer            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger OpportunityTrigger on Opportunity (before update) {

  if (Trigger.isUpdate) {
    if (Trigger.isBefore) {
      OpportunityTriggerHandler.beforeUpdate(Trigger.new);
    }
  }
}