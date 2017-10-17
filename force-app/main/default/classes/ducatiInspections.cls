public with sharing class ducatiInspections {


    @AuraEnabled
    public static list<account> getDealers(){
        return [select id,name from account where Type = 'Dealer'];
    }
}
