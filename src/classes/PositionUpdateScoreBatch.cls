global class PositionUpdateScoreBatch implements Database.Batchable<SObject>,Database.Stateful{
    
    String query = 'SELECT name, (SELECT Candidate__r.Overall_Score__c FROM Job_Applications__r) from position__c';
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        //Execute your query        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        //Process each batch of records
        for(Sobject s : scope){
            Double score = 0;
            Integer count = 0;
            Position__c position = (Position__c) s;
            
            for (Job_Application__c ja: position.Job_Applications__r) {
                if (ja.Candidate__r !=null) {
                    score+= Double.valueOf(ja.Candidate__r.Overall_Score__c);
                    count+=1;
                }
            }
            Double average = count == 0? -1: score/count;

            s.put('Overall_Rating_Candidate_Pool__c',average); 
        }   
        update scope;
    }
 
    global void finish(Database.BatchableContext BC){
        
        //Do any cleanup process for FirstBatch
        
        //Send any notifications

        //Schedule the next batch to execute 1 minute after the current one ends.
        
        
        //1. Schedule next job to run
        //BatchScheduler contactUpdateBatchSch = new BatchScheduler(BatchScheduler.STEP_2);
        //System.schedule(contactUpdateBatchSch.getJobName(),BatchScheduler.getTimeToSchedule(),contactUpdateBatchSch);
    } 
    
}