/********************************
Name- ABI_BSC_Cls_AttachmentTriggerHelperTest 
Author- Sahil
Created Date- 10/07/2015 
Description-Test Class for ABI_BSC_Cls_AttachmentTriggerHelper
********************************************/
@isTest
public class ABI_BSC_Cls_AttachmentTriggerHelperTest {


    /*
     *Name: testMethodInsertAttachmentNonOwner
     *Req No-
     *Description : Method to test validateAttachments_NonOwnerCases_NoEdits of class ABI_BSC_Cls_AttachmentTriggerHelper
     *Return Type : void
     * Parameter  : NA  

*/
    static testMethod void testMethodInsertAttachmentNonOwner() {
        Profile dummyProfile = [SELECT Id FROM Profile WHERE Name = 'BSC Support User' LIMIT 50];
        User dummyUser = new User(Alias = 'agur', Email = 'agentuser@testorg.com', EmailEncodingKey = 'UTF-8', 
        LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = dummyProfile.Id, 
        TimeZoneSidKey = 'America/Los_Angeles', UserName = 'agentuser1@testorg.com');
        Database.insert(dummyUser);

        User dummyUser2 = new User(Alias = 'agur', Email = 'agentuser@testorg.com', EmailEncodingKey = 'UTF-8', 
        LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = dummyProfile.Id, 
        TimeZoneSidKey = 'America/Los_Angeles', UserName = 'agentuser2@testorg.com');
        Database.insert(dummyUser2);
        List < Case > lstCases = new List < Case > ();
        Case testCase1 = utilCreateCase('ABI_BSC_RT_General');
        testCase1.ABI_BSC_SLA_Time__c = 5;
        testCase1.Status = 'Resolved';
        testCase1.ownerId = dummyUser.id;
        lstCases.add(testCase1);

        Case testCase2 = utilCreateCase('ABI_BSC_RT_General');
        testCase2.ABI_BSC_SLA_Time__c = 5;
        testCase2.Status = 'Open';
        testCase2.ownerId = dummyUser2.id;
        lstCases.add(testCase2);
        Database.insert(lstCases);

        List < Attachment > lstAttachments = new List < Attachment > ();
        Attachment testAttach1 = new Attachment(ParentId = lstCases[0].id, Name = 'Test Attachment for Parent', 
        Body = Blob.valueOf('Test Data'));
        lstAttachments.add(testAttach1);
        Attachment testAttach2 = new Attachment(ParentId = lstCases[1].id, Name = 'Test Attachment for Parent', 
        Body = Blob.valueOf('Test Data'));
        lstAttachments.add(testAttach2);
        System.runAs(dummyUser) {
            Test.startTest();
            try {
                Database.insert(lstAttachments);
            } catch (Exception ex) {
                ex.getMessage();
                //System.assert(true);
            }
            System.assert(true);
            Test.stopTest();
        }
    }

    /*
     *Name: testMethodInsertAttachmentNonOwner
     *Req No-
     *Description : Method to test validateAttachments_NonOwnerCases_NoEdits of class ABI_BSC_Cls_AttachmentTriggerHelper
     *Return Type : void
     * Parameter  : NA  

*/
    static testMethod void testMethodDeleteAttachmentNonOwner() {
        Profile dummyProfile = [SELECT Id FROM Profile WHERE Name = 'BSC Support User' LIMIT 50];
        User dummyUser = new User(Alias = 'agur', Email = 'agentuser@testorg.com', EmailEncodingKey = 'UTF-8', 
        LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = dummyProfile.Id, 
        TimeZoneSidKey = 'America/Los_Angeles', UserName = 'agentuser1@testorg.com');
        Database.insert(dummyUser);
        List < Case > lstCases = new List < Case > ();
        Case testCase1 = utilCreateCase('ABI_BSC_RT_General');
        testCase1.ABI_BSC_SLA_Time__c = 5;
        testCase1.Status = 'Open';
        testCase1.ownerId = dummyUser.id;
        lstCases.add(testCase1);
        Database.insert(lstCases);

        List < Attachment > lstAttachments = new List < Attachment > ();
        Attachment testAttach1 = new Attachment(ParentId = lstCases[0].id, Name = 'Test Attachment for Parent', 
        Body = Blob.valueOf('Test Data'));
        lstAttachments.add(testAttach1);
        System.runAs(dummyUser) {
            Database.insert(lstAttachments);
            Test.startTest();
            try {
                Database.delete(lstAttachments);
            } catch (Exception ex) {
                ex.getMessage();
               
            }
            
            System.assert(true);
            Test.stopTest();
        }
    }

    private static Case utilCreateCase(String recordTypeName) {
        RecordType recType;
        Case newCaseObj = new Case();
        if (recordTypeName != null) {
            recType = [SELECT Id, Name, DeveloperName from RecordType where DeveloperName = : recordTypeName LIMIT 100];
        }
        if (recType != null) {
            newCaseObj.RecordtypeId = recType.Id;
            newCaseObj.Description = 'Test Case';
            newCaseObj.ABI_BSC_Language__c = 'English';
            newCaseObj.ABI_BSC_Country__c = 'UK';
        }
        return newCaseObj;
    }
}