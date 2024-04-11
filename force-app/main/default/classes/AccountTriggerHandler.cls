/**
 * @description       : 
 * @Riley Meyer            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AccountTriggerHandler {

    public static void beforeInsert(List<Account> newAccounts) {
        for(Account acc : newAccounts) {
            if (acc.Type == null) {
                acc.Type = 'Prospect';
            }
        }
    }
}