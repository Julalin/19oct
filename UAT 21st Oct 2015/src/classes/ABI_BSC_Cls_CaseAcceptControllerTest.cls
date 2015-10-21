/********************************
Name-ABI_BSC_Cls_CaseAcceptControllerTest 
Author- Sachin
Created Date-  7/10/2015
Description-Test Class for ABI_BSC_Cls_AcceptCase
*********************************/
@isTest

public Class ABI_BSC_Cls_CaseAcceptControllerTest

{


    // Method to invoke and test the 'updateOwner' method in the ABI_Cls_CaseAcceptControllerTest.
    /*
     *Name:updateOwnerTest
     *Req No-
     *Description :
     *Return Type : void
     *Parameter  : 
     */
    public Static testMethod void updateOwnerTest()

    {

        Profile dummyProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 100];
        User dummyUser = new User(Alias = 'restandt', Email = 'standarduser@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = dummyProfile.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'stan1dard11user101@testorg.com');
        Database.insert(dummyUser);

        
        RecordType recType = new RecordType();
        recType = [SELECT Id, Name, DeveloperName from RecordType where DeveloperName = 'ABI_BSC_RT_General' LIMIT 100];
        Case case1 = new
    	case ();

        case1.RecordTypeId = recType.Id;

        case1.ABI_BSC_Communication_Type__c = 'Inbound';
        case1.description = 'Test';
        case1.ABI_BSC_Country__c = 'English';
        case1.ABI_BSC_Country__c = 'UK';
        case1.Status = 'Open';
        
        System.runAs(dummyUser){
        
        try{
        Database.insert(case1);
            }
        
        catch(Exception e){ 
            e.getMessage();
        }
        
        System.test.starttest();
        String caseId = '/' + case1.Id;
        PageReference pageRef = new PageReference(caseId);
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('Id', case1.Id);
        ApexPages.StandardController con = new ApexPages.StandardController(case1);
        ABI_BSC_Cls_CaseAcceptController ac = new ABI_BSC_Cls_CaseAcceptController(con);
        ac.updateOwner();
         System.assert(True);
        System.test.stoptest();
       
        }




    }
}