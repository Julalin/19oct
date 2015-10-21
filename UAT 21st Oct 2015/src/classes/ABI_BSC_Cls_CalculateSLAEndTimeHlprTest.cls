/********************************
Name- ABI_BSC_Cls_CalculateSLAEndTimeHlprTest 
Author- Sahil
Created Date- 10/07/2015 
Description-Test Class for ABI_BSC_Cls_CalculateSLAEndTimeHelper
********************************************/
@isTest
public class ABI_BSC_Cls_CalculateSLAEndTimeHlprTest {

    private static final string STRING_BUSINESSHOURS = 'ABI_SFA_Support_Business_Hours';
    private static Id relatedBHId;
    private static Id entitlementId;

    static {
        List < BusinessHours > lstBH = [select id from businesshours where name = : STRING_BUSINESSHOURS and 
        isActive = true LIMIT 1000];
        if (lstBH != null && !lstBH.isEmpty()) {
            relatedBHId = lstBH[0].id;
        }
        
        //Inserting Account for Entitlement
        Account acc = new Account();
        acc.name = 'Test Account';
        Database.insert(acc);
        //Inserting Entitlement
        Entitlement objEnt = new Entitlement();
        objEnt.name = 'Test ent';
        objEnt.Type = 'Speak Up';
        objEnt.accountid = acc.id;
        Database.insert(objEnt);
        if (objEnt != null && objEnt.id != null) {
            entitlementId = objEnt.id;
        }
    }

    /*
     *Name:testMethodInsertCaseScenario
     *Req No-
     *Description :
     *Return Type : void
     * Parameter  :  

*/
    static testMethod void testMethodInsertCaseScenario() {
        Case testCase1 = utilCreateCase('ABI_BSC_RT_General');
        testCase1.ABI_BSC_SLA_Time__c = 5;
        testCase1.Status = 'Open';
        testCase1.EntitlementId = entitlementId;
        Test.startTest();
        Database.insert(testCase1);
        Test.stopTest();
        Case testCaseAfterInsert = [select id, ABI_BSC_Target_Date_to_Resolve__c from Case where id = : testCase1.Id LIMIT 1000];
    }

    /*
     *Name:testMethodUpdateCaseScenario
     *Req No-
     *Description :
     *Return Type : void
     * Parameter  :  

*/
    static testMethod void testMethodUpdateCaseScenario() {
        Case testCase1 = utilCreateCase('ABI_BSC_RT_General');
        testCase1.ABI_BSC_SLA_Time__c = 5;
        testCase1.Status = 'Open';
        testCase1.EntitlementId = entitlementId;
        Database.insert(testCase1);
        testCase1.status = 'More Information Needed';
        testCase1.ABI_BSC_Additional_Required_Information__c = 'Test Info';
        Database.update(testCase1);
        for (Integer i = 0; i < 20; i++) {
            System.debug(i);
        }
        testCase1.status = 'In Progress';
        Test.startTest();
        Database.update(testCase1);
        Test.stopTest();
        Case testCaseAfterUpdate = [select id, ABI_BSC_Target_Date_to_Resolve__c from Case where id = : testCase1.Id LIMIT 1000];
        //  System.assertequals(testCaseAfterUpdate.ABI_BSC_Target_Date_to_Resolve__c.isSameDay(BusinessHours.add(relatedBHId, System.now(), 5*3600000)), true);
    }


    /*
     *Name:utilCreateCase
     *Req No-
     *Description :
     *Return Type : case
     * Parameter  : String recordTypeName 

*/
    private static Case utilCreateCase(String recordTypeName) {
        RecordType rt;
        Case newCaseObj = new Case();
        if (recordTypeName != null) {
            rt = [SELECT Id, Name, DeveloperName from RecordType where DeveloperName = : recordTypeName LIMIT 100];
        }
        if (rt != null) {
            newCaseObj.RecordtypeId = rt.Id;
            newCaseObj.Description = 'Test Case';
            newCaseObj.ABI_BSC_Language__c = 'English';
            newCaseObj.ABI_BSC_Country__c = 'UK';
        }
        return newCaseObj;
    }

}