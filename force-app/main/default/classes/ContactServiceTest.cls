@isTest
private class ContactServiceTest {
    @isTest
    static void testCreateContact() {
        Order__c order1 = new Order__c(Phone__c = '12345');
        Order__c order2 = new Order__c(Phone__c = '54321');
        insert new List<Order__c>{order1, order2};

        Test.startTest();
        System.debug('Before calling ContactService.createContact');
        ContactService.createContact(new List<Order__c>{order1, order2});
        System.debug('After calling ContactService.createContact');
        Test.stopTest();

        List<Contact> insertedContacts = [SELECT Id, Phone FROM Contact WHERE Phone IN ('12345', '54321')];
        System.assertEquals(2, insertedContacts.size(), 'Two contacts should be inserted');
    }
    @isTest
    static void testCreateEmptyContact() {
        Order__c order1 = new Order__c(Phone__c = '');
        insert new List<Order__c>{order1};
            
        Test.startTest();
        ContactService.createContact(new List<Order__c>{order1});
        Test.stopTest();
        
        List<Contact> insertedContacts = [SELECT Id, Phone FROM Contact WHERE Phone IN ('')];
        System.assertEquals(0, insertedContacts.size(), 'No contact should be inserted for an empty phone number');
    }
}