global class CandidateUpdateScoreBatch implements Database.Batchable<SObject>,Database.Stateful{
    
    String query = 'SELECT id, (select Average_Review_Score__c from job_applications__r) FROM candidate__c';
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        //Execute your query        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        //Process each batch of records
        for(Sobject s : scope){
            Double score = 0;
            Integer count = 0;
            Candidate__c cand = (Candidate__c) s;
            List<sObject> jobApps =  cand.Job_Applications__r;
            
            for (Sobject ja: jobApps) {
                score+= Double.valueOf(ja.get('Average_Review_Score__c'));
                count+=1;
            }
            Double average = count == 0? -1: score/count;
            s.put('Overall_Score__c',average); 
        }   
        update scope;
    }
 
    global void finish(Database.BatchableContext BC){
        
        //Do any cleanup process for FirstBatch
        
        //Send any notifications

        //Schedule the next batch to execute 1 minute after the current one ends.
        
        
        //TODO: Schedule next job to run
     }   
}