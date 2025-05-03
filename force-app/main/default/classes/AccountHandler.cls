public class AccountHandler {

    public static Account insertNewAccount(String str1)
    {
        Account acct = new Account(Name=str1);
        try {
            insert acct;
        } catch (Exception e) { return null;}
        return acct;

    }

}
