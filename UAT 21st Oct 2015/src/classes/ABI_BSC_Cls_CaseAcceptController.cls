/********************************
Name-ABI_BSC_Cls_CaseAcceptController 
Author-Julalin
Created Date-27/05/2015 
Req No-
Description-Controller for ABI_BSC_AcceptCase
*********************************/
public without sharing class ABI_BSC_Cls_CaseAcceptController {

    private final Case cas;
    private Id caseId;

    /*
     *Name:ABI_BSC_Cls_CaseAcceptController
     *Req No-
     *Description : 
     *Return Type : NA
     * Parameter  : ApexPages.StandardController stdController   

*/
    public ABI_BSC_Cls_CaseAcceptController(ApexPages.StandardController stdController) {
        this.cas = (Case) stdController.getRecord();

        caseId = ApexPages.currentPage().getParameters().get('id');
    }

    /*
     *Name:PageReference updateOwner
     *Req No-
     *Description : This method provides updates case Owner and Status.
     *Return Type : void
     * Parameter  : List of Case Ids   
     */
    public PageReference updateOwner() {

        try{
        Case casUpd = [Select Id, OwnerId from Case where Id = : caseId LIMIT 1000];

        casUpd.OwnerId = UserInfo.getUserId();
        casUpd.Status = Label.ABI_BSC_In_Progress_Status;
        DataBase.Update(casUpd);
    }
    
    Catch(Exception ex)
    {
        ex.getMessage();
    }
        
        PageReference pgref = new PageReference('/' + caseId);
        return pgref;
    }
}