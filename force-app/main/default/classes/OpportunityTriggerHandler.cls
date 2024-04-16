/**
 * @Opportunity Trigger Handler Class       : 
 * @Riley Meyer            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-15-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OpportunityTriggerHandler {

    // Method to be called before updates happen to an Opportunity
    public static void beforeUpdate(List<Opportunity> updatedOpportunities) {
        // Check each opoortunity being updated to ensure the amount is greater than 5,000
        // If less than 5,000 throw an error
        for (Opportunity opp : updatedOpportunities) {
            if (opp.Amount < 5000) {
                opp.addError('Opportunity amount must be greater than 5000');
            }
        }
        
        // Check to see if the AccountId is set on each Opportunity and if it is set then add to the list
        List<Id> opportunityAccountIds = new List<Id>();
        for (Opportunity opp : updatedOpportunities) {
            if (opp.AccountId != null){
                opportunityAccountIds.add(opp.AccountId);
            }
        }

        // Check the list to ensure values were found before executiing this code.
        if (opportunityAccountIds.size() > 0) {
            // Retrieve Contacts that have the same AccountId as the ones in our List from the Opportunities and have a Title of 'CEO'
            List<Contact> foundContacts = [SELECT Id, AccountId, Title
                                            FROM Contact
                                            WHERE AccountId IN :opportunityAccountIds AND Title = 'CEO'
                                            WITH USER_MODE];

            // Create a Map of Account Id's and Contact objects
            Map<Id, Contact> accountIdContactMap = new Map<Id, Contact>();
            for (Contact con : foundContacts) {
                accountIdContactMap.put(con.AccountId, con);
            }

            // Find the Contact with the same Account as the Opportunity using the Account Id as the Key
            // Then update the Primary Contact on the Opportunity with the Value from the Map where the Key matched
            for (Opportunity opp : updatedOpportunities) {
                opp.Primary_Contact__c = accountIdContactMap.get(opp.AccountId).Id;
            }
        }
    }

    // Method to be called before deleting an Opportunity
    public static void beforeDelete(List<Opportunity> deletedOpportunities) {
        // Build sets of opportunity IDs and Account IDs that are the Opportunity is Closed Won
        Set<Id> closedWonOppsIds = new Set<Id>();
        SEt<Id> accountsToCheck = new Set<Id>();
        for (Opportunity opp : deletedOpportunities) {
            if (opp.IsWon && opp.StageName == 'Closed Won') {
                closedWonOppsIds.add(opp.Id);
                accountsToCheck.add(opp.AccountId);
            }
        }

        // Use the Account Id's Set to query Accounts that have an Industry of 'Banking' and store them in a Map
        Map<Id, Account> bankingAccountsMap = new Map<Id, Account>([SELECT Id, Industry
                                                                    FROM Account
                                                                    WHERE Id IN :accountsToCheck AND Industry = 'Banking'
                                                                    WITH USER_MODE]);

        // Use the Set of 'Closed Won' Opportunity IDs and the Map of 'Banking' Accounts to verify if the Opportunity can deleted or if an Error should be thrown
        for (Opportunity opp : deletedOpportunities) {
            if (closedWonOppsIds.contains(opp.Id) && bankingAccountsMap.containsKey(opp.AccountId)) {
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
    }
}