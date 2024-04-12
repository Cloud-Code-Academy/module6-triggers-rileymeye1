/**
 * @description       : 
 * @Riley Meyer            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OpportunityTriggerHandler {

    public static void beforeUpdate(List<Opportunity> updatedOpportunities) {
        for (Opportunity opp : updatedOpportunities) {
            if (opp.Amount < 5000) {
                opp.addError('Opportunity amount must be greater than 5000');
            }
        }
    }
}