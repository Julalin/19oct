/********************************
Name-ABI_BSC_Cls_AllRequestsExtractScheduler 
Author-Sahil
Created Date-26/08/2015 
Req No-
Description- Scheduler that will extract all requests and email    
*********************************/
global with sharing class ABI_BSC_Cls_AllRequestsExtractScheduler implements Schedulable {
    
    global Boolean executeFromTest = false;
    global static String string_Empty = '';
    global static String string_Space = ' ';
    //global static String STRING_ADMINEMAILTEST = 'sahil.prinja@accenture.com';
    //global static String STRING_TOADDRESSES = 'sahil.prinja@accenture.com;sahil.prinja001@gmail.com';
    
    
    //Execute Method that will be called
      /*
     *Name:execute
     *Req No-
     *Description :
     *Return Type : void
     *Parameter  : SchedulableContext sc

*/
    global void execute(SchedulableContext sc){
        try{
            ABI_BSC_Cls_AllRequestsExtractHelper objHelper = new ABI_BSC_Cls_AllRequestsExtractHelper();
            String toAddresses = Null;
            String lastNDays = Label.ABI_BSC_ExtractJob_LastNDays;
            if(executeFromTest){
                toAddresses = Label.ABI_BSC_ExtractJob_AdminEmail;
            }
            else{
                toAddresses = Label.ABI_BSC_ExtractJob_ToAddresses;
            }
            List<String> lstToAddresses = new List<String>();
            if(toAddresses != null){
                lstToAddresses = toAddresses.split(';');
            }
            if(lstToAddresses != null && !lstToAddresses.isEmpty()){
                Set<String> setToAddresses = new Set<String>();
                setToAddresses.addall(lstToAddresses);
                setToAddresses.remove(null);
                setToAddresses.remove(string_Empty);
                setToAddresses.remove(string_Space);
                lstToAddresses = null;
                lstToAddresses = new List<String>();
                lstToAddresses.addall(setToAddresses);
                if(!setToAddresses.isEmpty()){
                    objHelper.extractAllRequestsAndEmail(lstToAddresses, lastNDays, executeFromTest);
                }
            }
        }
        catch(Exception ex){
            ex.getMessage();
        }
            
    }   

}