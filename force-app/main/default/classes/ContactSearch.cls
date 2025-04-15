public class ContactSearch {
	public static list<Contact> searchForContacts(String s1, String s2)
    {
        return [SELECT Name FROM Contact WHERE LastName =:s1 and MailingPostalCode=:s2];
		

    }
}