trigger OfferTrigger on Offer__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	
	List<Job_Application__c> jobAppsForUpdate;
	List<Offer__c> offersToRollup; 
	
	if (Trigger.isAfter){
		if (Trigger.isUpdate){
			offersToRollup = new List<Offer__c>();
			jobAppsForUpdate = new List<Job_Application__c>();
			
			for (Offer__c o: Trigger.new) {
				if (o.Status__c == 'Sent' && o.Job_Application__c != null && !OfferTriggerHelper.appIds.contains(o.Job_Application__c)) { //here we check to make sure that the parent record hasn't already been added to the list to work with, or worked with in a previous batch of 200
					offersToRollup.add(o);
					OfferTriggerHelper.appIds.add(o.Job_Application__c); //this is the caching so that we won't update the same parent record twice
				}
			}
			
			jobAppsForUpdate = OfferTriggerHelper.createJobAppsForUpdate(offersToRollup);
						
			update jobAppsForUpdate;
			
		} else if (Trigger.isInsert){
			offersToRollup = new List<Offer__c>();
			jobAppsForUpdate = new List<Job_Application__c>();
			
			for (Offer__c o: Trigger.new) {
				if (o.Status__c == 'Sent' && o.Job_Application__c != null && !OfferTriggerHelper.appIds.contains(o.Job_Application__c)) {
					offersToRollup.add(o);
					OfferTriggerHelper.appIds.add(o.Job_Application__c);
				}
			}
			
			jobAppsForUpdate = OfferTriggerHelper.createJobAppsForUpdate(offersToRollup);
						
			update jobAppsForUpdate;
			
		} else if (Trigger.isDelete){
			
		} else { //for after undelete code
			
		}		
	}
	else { //all before code
		if (Trigger.isUpdate){
			
		} else if (Trigger.isInsert){
			
		} else { //for before delete code
			
		}			
	}
}