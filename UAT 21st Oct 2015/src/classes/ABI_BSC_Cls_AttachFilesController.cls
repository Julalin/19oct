/**************************
Name- ABI_BSC_Cls_AttachFilesController 
Author- Julalin
Created Date-7/10/2015
Req No-
Description- Controller class for VF page 'ABI_BSC_AttachFilesPage'

*********************************/
public without sharing class ABI_BSC_Cls_AttachFilesController {

    public ABI_BSC_Cls_AttachFilesController(ApexPages.StandardController controller) {
        
        
        lstAttachments = new List < Attachment > ();
    }


    //Declaring Constants
    private static final string STRING_ERROR = Label.ABI_BSC_AttachFilesPage_ErrorUploading;
    private static final string STRING_ERROR_2 = Label.ABI_BSC_AttachFilesPage_ErrorRemoving;
    private static final string STRING_SUCCESS = Label.ABI_BSC_AttachFilesPage_SuccessUploading;
    private static final string STRING_SUCCESS_2 = Label.ABI_BSC_AttachFilesPage_SuccessRemoving;
    private static final string STRING_IDPARAM = 'id';

    //Declaring Page Variables
    public List < Attachment > lstAttachments {
        get;
        set;
    }
    public Blob fileBody {
        get;
        set;
    }
    public String fileName {
        get;
        set;
    }

    //Declaring Class Level Variables
    private Boolean uploadSuccess = true;

    //Class Controller
    public ABI_BSC_Cls_AttachFilesController() {

    }

    //Method that will attach the file to the real case or a temporary Record Id
    /*
     *Name: attachFile
     *Req No-
     *Description : Method that will attach the file to the real case or a temporary Record Id
     *Return Type : PageReference
     * Parameter  : NA

*/
    public PageReference attachFile() {
        //Check if the User Selected a File
        String relatedId = Apexpages.currentPage().getParameters().get(STRING_IDPARAM);
        
        if (fileName != null && fileBody != null) {
            //If Yes, then we upload the file to dummy Record and Display in the List
            try {
                Attachment objAttachment = new Attachment();
                objAttachment.name = fileName;
                objAttachment.body = fileBody;
                if (relatedId != null && relatedId != '') {
                    objAttachment.parentId = relatedId;
                }
                // insert the attahcment
                Database.SaveResult objSR2 = Database.insert(objAttachment);
                // reset the file for the view state
                fileBody = Blob.valueOf(' ');
                fileName = '';
                objAttachment.body = Blob.valueOf(' ');
                //If it was uploaded successfully
                
                if (objSR2.isSuccess() && objAttachment.Id != null) {
                    lstAttachments.add(objAttachment);
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, STRING_SUCCESS));
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, STRING_ERROR));
                }
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, ex.getMessage()));
            }
        }

        
        return null;
    }




    //Method that will be called to remove the file selected from the list
    /*
     *Name: removeFile
     *Req No-
     *Description : Method that will be called to remove the file selected from the list
     *Return Type : PageReference
     * Parameter  : NA

*/
    public PageReference removeFile() {
        String idToBeRemoved = Apexpages.currentPage().getParameters().get('removeId');
        
        

        if (lstAttachments != null && !lstAttachments.isEmpty() && idToBeRemoved != null) {
            //Adding List to a Set
            Set < Attachment > setAttachments = new Set < Attachment > ();
            setAttachments.addall(lstAttachments);
            for (Attachment objAttach: setAttachments) {
                if (objAttach.Id == idToBeRemoved) {
                    //Deleting from Database
                    try {
                        setAttachments.remove(objAttach);
                        Database.delete(objAttach);
                        
                        //If no Exception Occured
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, STRING_SUCCESS_2));
                    } catch (Exception ex) {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, STRING_ERROR_2));
                    }

                }
            }
            lstAttachments.clear();
            lstAttachments.addall(setAttachments);
        }
        return null;
    }

}