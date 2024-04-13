/**
 * @description       : 
 * @Riley Meyer            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-13-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AccountTriggerHandler {

    // Method to be called before inserting an Account
    public static void beforeInsert(List<Account> newAccounts) {
        // Ensure that each account has a Type, if no Type add a default value of 'Prospect'
        for(Account acc : newAccounts) {
            if (acc.Type == null) {
                acc.Type = 'Prospect';
            }

            // Check if the Shipping Address is null.
            if (acc.ShippingStreet != null && acc.ShippingCity != null && acc.ShippingState != null && acc.ShippingPostalCode != null && acc.ShippingCountry != null) {
                // If Shipping Address is populated set the Billing Address equal to the Shipping Address
                acc.BillingStreet = acc.ShippingStreet;
                acc.BillingCity = acc.ShippingCity;
                acc.BillingState = acc.ShippingState;
                acc.BillingPostalCode = acc.ShippingPostalCode;
                acc.BillingCountry = acc.ShippingCountry;
            }

            // Check if Phone, Website, and Fax are populated on the Account
            if (acc.Phone != null && acc.Website != null && acc.Fax != null) {
                // If all 3 are populated set the Rating to 'Hot'
                acc.Rating = 'Hot';
            }
        }
    }

    // Method to call after an Account is inserted
    public static void afterInsert(List<Account> newAccounts) {
        List<Contact> contactsToAdd = new List<Contact>();
        // For each account add a Default Contact
        for (Account acc : newAccounts) {
            contactsToAdd.add(new Contact(LastName = 'DefaultContact', Email = 'default@email.com', AccountId = acc.Id));
        }
        // Insert the Contacts to the database
        Database.insert(contactsToAdd, AccessLevel.USER_MODE);
    }
}