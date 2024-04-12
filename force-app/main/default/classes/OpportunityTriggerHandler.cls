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

    public static void beforeDelete(List<Opportunity> deletedOpportunities) {
        Set<Id> closedWonOppsIds = new Set<Id>();
        SEt<Id> bankingAccountIds = new Set<Id>();

        for (Opportunity opp : deletedOpportunities) {
            if (opp.IsWon && opp.StageName == 'Closed Won') {
                closedWonOppsIds.add(opp.Id);
                bankingAccountIds.add(opp.AccountId);
            }
        }

        Map<Id, Account> bankingAccountsMap = new Map<Id, Account>([SELECT Id, Industry
                                                                    FROM Account
                                                                    WHERE Id IN :bankingAccountIds AND Industry = 'Banking']);

        for (Opportunity opp : deletedOpportunities) {
            if (closedWonOppsIds.contains(opp.Id) && bankingAccountsMap.containsKey(opp.AccountId)) {
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
    }
}