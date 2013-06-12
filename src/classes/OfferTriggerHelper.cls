public without sharing class OfferTriggerHelper {
	
	public static Set<Id> appIds = new Set<Id>(); 
	
	public static List<Job_Application__c> createJobAppsForUpdate(List<Offer__c> childRecords){
		
		List<Job_Application__c> jobAppsForUpdate = new List<Job_Application__c>();
		
		for (Offer__c o: childRecords) {
			if (o.Job_Application__c != null) {
				//this is the "money shot" line right here. 
				//most developers think in order to update a record, they *must* query
				//what they don't realize is that sObjects can have their Ids initialized
				//you can't assign them later, but in the constructor you can. once initialized
				//all you have to do is call update back in the trigger 
				jobAppsForUpdate.add(new Job_Application__c(id=o.Job_Application__c,Status__c='Hold',Stage__c='Offer Extended'));
			} else {
				OfferTriggerHelperException e = new OfferTriggerHelperException('Calling the createJobAppsForUpdate method of OfferTriggerHelper requires the Job_Application__c field of each offer to be populated');
			}
		}	
		
		return jobAppsForUpdate;
	}
	
	public class OfferTriggerHelperException extends Exception {}

}