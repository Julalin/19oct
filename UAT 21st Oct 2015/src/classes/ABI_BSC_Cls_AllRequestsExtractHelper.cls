/********************************
Name-ABI_BSC_Cls_AllRequestsExtractHelper 
Author-Sahil
Created Date-26/08/2015 
Req No-
Description-Helper Class that will extract all requests and email    
*********************************/
public with sharing class ABI_BSC_Cls_AllRequestsExtractHelper {
    private static final string STRING_SUBJECTEMAIL = 'All Requests';
    private static final string STRING_FILENAME = 'All Requests.xls';
    
     /*
     *Name:extractAllRequestsAndEmail
     *Req No-
     *Description :
     *Return Type : void
     *Parameter  : List<String> toAddresses, String lastNDays, Boolean executeFromTest

*/
    public void extractAllRequestsAndEmail(List<String> toAddresses, String lastNDays, Boolean executeFromTest){
        if(toAddresses != null && toAddresses.size() > 0){
            try{
                //Retriving the Info from the DB
                String queryCase = 'Select CaseNumber, ABI_BSC_Level1__c, ABI_BSC_Level2__c, ABI_BSC_Level3__c, ';
                queryCase = queryCase + 'Status, Owner.name, CreatedBy.name, CreatedDate, ABI_BSC_Target_Date_to_Resolve__c, ';
                queryCase = queryCase + 'ClosedDate, ABI_BSC_Language__c, ABI_BSC_Country__c';
                queryCase = queryCase + 'ABI_BSC_Date_Time_Closed__c, ABI_BSC_Date_Time_Resolved__c from Case ';
                
                if(lastNDays != null && lastNDays.isNumeric()){
                    //As per the input from the Calling Class
                    queryCase = queryCase + ' where createddate = Last_N_Days:' + lastNDays ;
                }
                else{
                    //Default for the current day
                    queryCase = queryCase + ' where createddate = today';
                }
                
                if(executeFromTest){
                    queryCase = queryCase + ' limit 1';
                }
                else{
                    queryCase = queryCase + ' limit 50000';
                }
                
                
                List<Case> lstCase = database.query(queryCase);
                
                //Initializing the Header
                String header = '<table><b><tr>';
                header = header + '<th>Request Number</th>';
                header = header + '<th>Level 1</th>';
                header = header + '<th>Level 2</th>';
                header = header + '<th>Level 3</th>';
                header = header + '<th>Status</th>';
                header = header + '<th>Request Owner</th>';
                header = header + '<th>Created By</th>';
                header = header + '<th>Date Time Opened</th>';
                header = header + '<th>Target Date to Resolve</th>';
                header = header + '<th>Date Time Resolved</th>';
                header = header + '<th>Date Time Closed</th>';
                header = header + '<th>Language</th>';
                header = header + '<th>Country</th>';
                header = header + '</tr></b>\n';
                
                //Initializing final string
                String finalstr = header;
                
                for(Case objCase: lstCase)
                {           
                    String recordString = '<tr><td>'+objCase.CaseNumber+'</td>';
                    recordString = recordString + '<td>'+objCase.ABI_BSC_Level1__c+'</td>';
                    recordString = recordString + '<td>'+objCase.ABI_BSC_Level2__c+'</td>';
                    recordString = recordString + '<td>'+objCase.ABI_BSC_Level3__c+'</td>';
                    recordString = recordString + '<td>'+objCase.Status+'</td>';
                    recordString = recordString + '<td>'+objCase.Owner.name+'</td>';
                    recordString = recordString + '<td>'+objCase.CreatedBy.name+'</td>';
                    recordString = recordString + '<td>'+objCase.CreatedDate+'</td>';
                    recordString = recordString + '<td>'+objCase.ABI_BSC_Target_Date_to_Resolve__c+'</td>';
                    recordString = recordString + '<td>'+objCase.ABI_BSC_Date_Time_Resolved__c+'</td>';
                    recordString = recordString + '<td>'+objCase.ABI_BSC_Date_Time_Closed__c+'</td>';
                    recordString = recordString + '<td>'+objCase.ABI_BSC_Language__c+'</td>';
                    recordString = recordString + '<td>'+objCase.ABI_BSC_Country__c+'</td></tr>\n';
                    finalstr = finalstr +recordString;
                }
                finalstr = finalstr + '</table>';
                
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                blob csvBlob = Blob.valueOf(finalstr);
                string csvname= STRING_FILENAME;
                csvAttc.setFileName(csvname);
                csvAttc.setBody(csvBlob);
                Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
                String subject =STRING_SUBJECTEMAIL;
                email.setSubject(subject);
                email.setToAddresses( toAddresses );
                email.setPlainTextBody('Hi, \n\t Attached is the extract of all requests as of '+ system.now()+ ' GMT');
                email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
                email.setCharset('UTF-8');
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
            catch(Exception ex){
                ex.getMessage();
            }
                
        }
    }
}