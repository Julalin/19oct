/********************************
Name-ABI_BSC_Cls_AttachmentTriggerHelper 
Author-Sahil
Created Date-26/06/2015 
Req No-
Description-Helper Class for Trigger on Attachment
Inital Request - If agent profile, then he or she should not be able to Attach Attachment to the Case for which he is not the owner
*********************************/
public with sharing class ABI_BSC_Cls_AttachmentTriggerHelper {

    private static final string STRING_CASERESOLVED = Label.ABI_BSC_Resolved_Status;
    private static final string STRING_CASECLOSED = Label.ABI_BSC_Closed_Status;
    private static final string SUPPORT_USER = Label.ABI_BSC_Profile_BSC_Support_User;
    public static  final String CaseVar = 'Case';
    public static Id agentProfileId = [select id from Profile where name =:SUPPORT_USER  limit 1].id;

    /*
     *Name:  validateAttachments_NonOwnerCases_NoEdits
     *Req No-
     *Description : If agent profile, then he or she should not be able to Attach Attachment to the Case for which he is not the owner
     *Return Type : void
     * Parameter  : List<Attachment> lstAffectedAttachments, Set<Id> setAffectedCaseIds   

*/
    public void validateAttachments_NonOwnerCases_NoEdits(List < Attachment > lstAffectedAttachments, 
    Set < Id > setAffectedCaseIds) {
       
        
        //We receive all the attachments upserted for Cases by Agents
        Id loggedInUserId = UserInfo.getUserId();
		 Case objCase;
         Map < Id, Case > mapCaseIdToDetail = new  Map < Id, Case >();
        //Get the Case Details
       
        try{
        if (!setAffectedCaseIds.isEmpty()) {
           mapCaseIdToDetail = new Map < Id, Case > ([select id, ownerid, status, createdbyId from Case 
         where id in : setAffectedCaseIds limit: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
            
            if (mapCaseIdToDetail != null && !mapCaseIdToDetail.isEmpty()) {
                //Received some Case Details
                //Check for all the Attachments again
                                               
                for (Attachment objAttach: lstAffectedAttachments) {
                    if (mapCaseIdToDetail.containsKey(objAttach.parentId)) {
                        objCase = mapCaseIdToDetail.get(objAttach.parentId);
                        if (objCase != null) {
                            //check if the status is Resolved or Closed
                            if (objCase.status != null && (objCase.status.equals(STRING_CASERESOLVED) 
                                                           || objCase.status.equals(STRING_CASECLOSED))) {
                                objAttach.addError(Label.ABI_BSC_Attachment_CaseResolvedError);
                            }
                            //check 2 if the owner is not logged in user
                            if (objCase.ownerid != loggedInUserId && objCase.createdbyId != loggedInUserId) {
                                objAttach.addError(Label.ABI_BSC_Attachment_NonOwner_Error);
                            }
                        }
                    }
                }
            }
           }
       } 
            
        Catch(Exception e){
                e.getMessage();
                
            }
        }
    }