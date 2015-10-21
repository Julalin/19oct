/**************************
Name- ABI_BSC_Cls_AllRequestsExtractsSchedTest 
Author- Kaushal
Created Date-7/10/2015
Req No-
Description- 

*********************************/
@isTest
public class ABI_BSC_Cls_AllRequestsExtractsSchedTest {

    /*
     *Name: extractAndEmailTest
     *Req No-
     *Description : 
     *Return Type : void
     * Parameter  : NA

*/
    static testmethod void extractAndEmailTest() {
        
        Profile dummyProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 100];
        User dummyUser = new User(Alias = 'restandt', Email = 'standarduser@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = dummyProfile.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'stan1dard11user101@testorg.com');
        Database.insert(dummyUser);
        
        ABI_BSC_Cls_AllRequestsExtractScheduler objScheduler = new ABI_BSC_Cls_AllRequestsExtractScheduler();
        objScheduler.executeFromTest = true;
        
        System.RunAs(dummyUser){
        
        String day = string.valueOf(system.now().day());
        String month = string.valueOf(system.now().month());
        String hour = string.valueOf(system.now().hour());
        String minute = string.valueOf(system.now().addminutes(1).minute());
        String second = string.valueOf(system.now().second());
        String year = string.valueOf(system.now().year());

        String strJobName = 'Job -' + second + '_' + minute + '_' + hour + '_' + day + '_' + month + '_' + year;
        String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
        //System.schedule(strJobName, strSchedule, objScheduler);
        }
    }
}