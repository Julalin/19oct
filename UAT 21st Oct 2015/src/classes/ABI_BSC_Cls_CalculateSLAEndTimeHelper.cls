/**************************
Name-ABI_BSC_Cls_CalculateSLAEndTimeHelper 
Author- Kavya
Created Date-7/10/2015
Req No-
Description-
*********************************/
public with sharing class ABI_BSC_Cls_CalculateSLAEndTimeHelper {

    private static final string STRING_BUSINESSHOURS = 'ABI_SFA_Support_Business_Hours';
    private static final string STRING_CASESTATUSSLARESUME = 'In Progress';
    private static final string STRING_CASESTATUSSLASTOP = 'More Information Needed';
    private static Id relatedBHId;

    /*
     *Name:updateSLATargetTimeToResolve
     *Req No-
     *Description :Auto submission of Approval Process
     *Return Type : void
     * Parameter  : List<Case> lstCasesNew, List<Case> lstCasesOld   

*/
    public static void updateSLATargetTimeToResolve(List < Case > lstCasesNew, List < Case > lstCasesOld) {
       
        try {
            List < BusinessHours > lstBH = [select id from businesshours where name = : STRING_BUSINESSHOURS and 
                                            isActive = true LIMIT 1000];
            if (lstBH != null && !lstBH.isEmpty()) {
                relatedBHId = lstBH[0].id;
            }
            
            //Check Valid BH ID
            if (relatedBHId != null) {
                //Check if Insert
                if (lstCasesNew != null && lstCasesOld == null) {
                    for (Case objCase: lstCasesNew) {
                        
                        //Check if the sla time is valid and status is not equal to More Information Needed
                        if (objCase.ABI_BSC_SLA_Time__c != null && objCase.entitlementId != null && 
                            objCase.status != null && !objCase.status.equals(STRING_CASESTATUSSLASTOP)) {
                            objCase.ABI_BSC_Target_Date_to_Resolve__c = BusinessHours.add(relatedBHId, System.now(), 
                            (Long) objCase.ABI_BSC_SLA_Time__c * 3600000);
                        }
                    }
                }
                //Check if Update
                else if (lstCasesNew != null && lstCasesOld != null) {
                    Long timeSLAWasStopped = 0;
                    for (Integer i = 0; i < lstCasesNew.size(); i++) {
                        if (lstCasesNew[i].status != lstCasesOld[i].status && 
                            lstCasesNew[i].status != null && 
                            lstCasesNew[i].status.equals(STRING_CASESTATUSSLARESUME)) {
                            //check the date time of last stop is not null
                            if (lstCasesNew[i].ABI_BSC_SLA_Time__c != null && 
                                lstCasesNew[i].entitlementId != null && 
                                lstCasesNew[i].ABI_BSC_SLA_Stopped_Time_Last__c != null) {
                                //find the time difference since last stop
                                timeSLAWasStopped = BusinessHours.diff(relatedBHId, lstCasesNew[i].ABI_BSC_SLA_Stopped_Time_Last__c, System.now());
                                
                                if (lstCasesNew[i].ABI_BSC_Target_Date_to_Resolve__c != null && timeSLAWasStopped > 0) {
                                    lstCasesNew[i].ABI_BSC_Target_Date_to_Resolve__c = BusinessHours.add(relatedBHId,
                                    lstCasesNew[i].ABI_BSC_Target_Date_to_Resolve__c, timeSLAWasStopped);
                                    //Even empty the field for this case, so even if the trigger runs recursively, it is not calculated again
                                    lstCasesNew[i].ABI_BSC_SLA_Stopped_Time_Last__c = null;
                                }
                                else{}
                            }
                            else{}
                        }
                        else{}
                    }
                }
            }
        } catch (Exception ex) {
            ex.getMessage();
        }
    }
}