/**
 * @Account Trigger       : 
 * @Riley Meyer            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger AccountTrigger on Account (before insert) {
  if (Trigger.isInsert && Trigger.isBefore) {
    for (Account acc : Trigger.new) {
      if (acc.Type == null) {
        acc.Type = 'Prospect';
      }
    }
  }
}