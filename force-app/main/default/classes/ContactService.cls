public class ContactService {
    public static void createContact(List<Order__c> newOrders) {

        Set<String> phoneNumbers = new Set<String>();
        List<Order__c> ordersToUpdate = new List<Order__c>();
        List<Contact> contactsToInsert = new List<Contact>();

        for (Order__c newOrder : newOrders) {
            if (!String.isBlank(newOrder.Phone__c)) {
                phoneNumbers.add(newOrder.Phone__c);
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Phone cannot be blank.'));
            }
        }

        if (!phoneNumbers.isEmpty()) {
            List<Contact> existingContacts = [SELECT Id, Phone FROM Contact WHERE Phone IN :phoneNumbers];

            Map<String, Contact> phoneToContactMap = new Map<String, Contact>();
            for (Contact existingContact : existingContacts) {
                phoneToContactMap.put(existingContact.Phone, existingContact);
            }

            for (Order__c newOrder : newOrders) {
                if (String.isBlank(newOrder.Phone__c)) {
                    continue;
                }

                Contact existingContact = phoneToContactMap.get(newOrder.Phone__c);

                if (existingContact == null) {
                    if (!String.isBlank(newOrder.Phone__c)) {
                        Contact newContact = new Contact(Phone = newOrder.Phone__c, LastName = newOrder.Phone__c);
                        contactsToInsert.add(newContact);
                    } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Phone cannot be blank.'));
                    }
                } else {
                    newOrder.Client__c = existingContact.Id;
                    newOrder.CommentToOrder__c = 'The client has already placed an order: ' + existingContact.Id;
                }
            }

            if (!contactsToInsert.isEmpty()) {
                insert contactsToInsert;

                for (Order__c newOrder : newOrders) {
                    if (String.isBlank(newOrder.Phone__c)) {
                        continue;
                    }

                    if (newOrder.Client__c == null) {
                        for (Contact newContact : contactsToInsert) {
                            if (newContact.Phone == newOrder.Phone__c) {
                                newOrder.Client__c = newContact.Id;
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
}