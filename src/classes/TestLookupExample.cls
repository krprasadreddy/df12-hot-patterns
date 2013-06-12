@isTest
private class TestLookupExample {
    public static void setup(Integer numLeads) {
        // create numLeads Account records
        List<Lead> leads = new List<Lead>();
        for (Integer i=0; i<numLeads; i++) {
            Lead lead = new Lead(LastName = 'TEST ' + i, Company = 'TestCo', PostalCode = '94305');
            leads.add(lead);
        }
        if (!leads.isEmpty()) insert leads;
    }

    static testmethod void testLookupTrigger() {
        // setup
        setup(200);
        System.Assert([select Name, City, State from Lead where Company = 'TestCo'][0].City == 'Stanford', 'City should match zip code.');
    }
}