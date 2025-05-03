public class StringArrayTest {
    public static List<String> generateStringArray( Integer  countofoutputs){
        //String[] StringList = new String[];   
        List<String> StringList = new List<String>{};
        for( Integer i=0;i<countofoutputs;i++)
        {
            StringList.add('Test '+i);
        }
        System.debug(StringList);

        //return list of strings
        System.debug(countofoutputs);
        return StringList;
    }
}