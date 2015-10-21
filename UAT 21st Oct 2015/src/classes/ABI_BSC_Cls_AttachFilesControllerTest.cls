/**************************
Name-ABI_BSC_Cls_AttachFilesControllerTest
Author- Julalin
Created Date-7/10/2015
Req No-
Description-
*********************************/
@isTest
public class ABI_BSC_Cls_AttachFilesControllerTest {
    /*
     *Name:AttachFilesController
     *Description :
     *Return Type : void
     * Parameter  :  null 

*/
    public static testmethod void AttachFilesController() {
      
        Profile dummyProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 100];
        User dummyUser = new User(Alias = 'restandt', Email = 'standarduser@testorg.com', EmailEncodingKey = 'UTF-8', 
        LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = dummyProfile.Id, 
        TimeZoneSidKey = 'America/Los_Angeles', UserName = 'stan1dard11user101@testorg.com');
        Database.insert(dummyUser);
              
        
        
        Case aCase = new Case();
        acase.Status = 'Delayed';
        acase.description = 'desc';
        Database.insert(aCase);

        ABI_BSC_Cls_AttachFilesController controller = new ABI_BSC_Cls_AttachFilesController(new ApexPages.StandardController(aCase));
        controller.fileName = 'Unit Test Attachment';
        
        try{
        //controller1.relatedid= Apexpages.currentPage().getParameters().get('id',aCase.id);
        
		System.runAs(dummyUser) 
        {
        controller.fileBody = Blob.valueOf('Unit Test Attachment Body');
        string relatedId = apexpages.currentpage().getparameters().put('id', aCase.id);
        controller.attachFile();

        List < Attachment > attachments = [select id, name from Attachment where 
        parent.id = : aCase.id LIMIT 1000];
        System.assertEquals(1, attachments.size());
        }
            
        }
        
        Catch(Exception e){
            e.getMessage();
            
        }
    }

    /*
     *Name:AttachFilesController1
     *Description :
     *Return Type : void
     * Parameter  : null  

*/
    public static testMethod void AttachFilesController1() {
        Case aCase = new Case();
        acase.Status = 'Delayed';
        acase.description = 'desc';
        
        Profile dummyProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 100];
        User dummyUser = new User(Alias = 'restandt', Email = 'standarduser@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = dummyProfile.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'stan1dard11user101@testorg.com');
        Database.insert(dummyUser);
        
        String idToBeRemoved;
         List < Attachment > attachments = new  List < Attachment >();
       Database.insert(aCase);

        ABI_BSC_Cls_AttachFilesController controller = new ABI_BSC_Cls_AttachFilesController(new ApexPages.StandardController(aCase));
        controller.fileName = 'Unit Test Attachment';
        //controller1.relatedid= Apexpages.currentPage().getParameters().get('id',aCase.id);
        
        
        controller.fileBody = Blob.valueOf('Unit Test Attachment Body');
        string relatedId = apexpages.currentpage().getparameters().put('id', aCase.id);
        controller.attachFile();
        
        try{

            System.runAs(dummyUser){
                
        attachments = [select id, name from Attachment where parent.id = : aCase.id LIMIT 1000];
        System.assertEquals(1, attachments.size());
        List < Attachment > lstAttachments = new List < Attachment > ();
        
        for (integer i = 0; i < attachments.size(); i++) {
            lstAttachments.add(attachments[i]);
        }
        idToBeRemoved = Apexpages.currentPage().getParameters().put('removeId', attachments[0].id);

        Set < Attachment > attach = new Set < Attachment > ();
        attach.addall(attachments);
        Test.startTest();
        controller.removeFile();
        Test.stopTest();
        }
        }
            
        Catch(Exception e){
            e.getMessage();
            
        }
        
    }

}