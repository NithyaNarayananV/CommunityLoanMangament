trigger OppClose on Opportunity (after update) {
    
    Set<Id> accountIds = new Set<Id>();
    for (Opportunity opp : Trigger.new) {
        if (opp.StageName == 'Closed Lost') 
        {
            System.debug('Inside | if (opp.StageName == Closed Lost) ');
            accountIds.add(opp.AccountId);
        }
        System.debug('accountIds'+accountIds);
    }

    if (accountIds.size()>0) {
        system.debug('accountIds Size = '+accountIds.size() +' || Set - '+accountIds);
        List<Account> AccountsL = [SELECT Id,OwnerId FROM Account WHERE Id IN :accountIds];
        List<Opportunity> OpsAccList = [SELECT AccountId from Opportunity  Where AccountId IN :accountIds and IsClosed = False];
        System.debug(OpsAccList);
                
		List<String> OpsAccListString = new List<String>();
        for(Opportunity Ops:OpsAccList)
            OpsAccListString.add(String.valueOf(Ops.AccountId));
        for(Account acc : AccountsL){
            System.debug(acc.id);
            if (OpsAccListString.contains(String.valueOf(acc.id)))
                break;
            //else
			Case CNew =	new Case(
                    AccountId = acc.id,
                    Subject = 'Follow-up on Closed Lost Opportunity',
                    Priority = 'High',
                    Origin='Phone',
                    OwnerId= acc.OwnerId,
                	Status = 'New'
                );
            Insert CNew;
        }
	}
}