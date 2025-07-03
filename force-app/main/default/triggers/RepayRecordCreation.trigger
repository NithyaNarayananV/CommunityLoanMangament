trigger RepayRecordCreation on Loan__c (after insert) {
    
    System.debug('Start Loan');
    list<Loan__c> LoanCList  = [Select CreatedDate, Loan_Account__c,Loan_given_to__c, Action__c, Repay_Amount__c,state__C from Loan__c WHERE Id in :Trigger.new];
    
    for ( Loan__c LoanC : LoanCList) 
    {
        if (LoanC.state__C != 'Upcoming' && LoanC.state__C != 'Due'  && LoanC.state__C != 'OverDue' )
        {
            String AccountId = ''+LoanC.get('Loan_Account__c');
            Account Ac = Database.query('select Active__c,Loan_Date__c,Balance__c,Interest_Paid_A__c,state__C,Type ,Contact__c,Advance_Deduction__c,Loan_Amount__c from Account WHERE Id  = \'' +AccountId +'\'');
            String ContactId = ''+Ac.get('Contact__c');
            Contact C = Database.query('select id, Loan__c,Lastname from Contact WHERE Id  = \'' +ContactId+'\'');
            
            //LoanC.Name= 'R '+C.get('Lastname') ;//Ac.Account_Id__c;
    
            //LoanC.Name='Repay';

            if (LoanC.Action__c == 'Interest')
            {
                LoanC.Name= 'Interest Pay - '+C.get('Lastname') ;//Ac.Account_Id__c;
                if(Ac.Type =='Regular_Loan')
                LoanC.Repay_Date__c = Ac.Loan_Date__c;
                System.debug('Else |  Ac.Advance_Deduction__c +=LoanC.Repay_Amount__c;');
                //if(Ac.Type  =='Annual_Loan')
                //LoanC.Repay_Amount__c.addError('Amount Invalid');
                //Ac.Interest_Paid_A__c +=LoanC.Repay_Amount__c;
                Ac.Advance_Deduction__c +=LoanC.Repay_Amount__c;
                system.debug(Ac.Advance_Deduction__c);

                System.debug('Before | Ac.Type == Regular_Loan | '+Ac.Type);
                if (Ac.Type == 'Regular_Loan')  // For Regular Loan, Interest is paid only one time : at the begginning.
                {
                    System.debug('Ac.Type == Regular_Loan');
                    // 10 New Records Creation for Installment of the Loan
                    list<Loan__c> InstallmentList = new list<Loan__c>();
                    Date today = Ac.Loan_Date__c;
                    for (Integer i = 0;i<10;i++)
                    {
                        System.debug('For Loop - '+i);
                        Loan__c Installment = new Loan__c();
                        
                        Installment.Loan_Account__c = AccountId;
                        
                        Installment.Action__c = 'Installment';
                        
                        Installment.Repay_Amount__c = Ac.Loan_Amount__c/10;
                        Date nextMonthDate = today.addMonths(i+1);                    
                        // Check for day overflow and adjust the date (e.g., February 30)
                        if (nextMonthDate.day() != today.day()) {
                            Integer daysInNextMonth = Date.daysInMonth(nextMonthDate.year(), nextMonthDate.month());
                            nextMonthDate = Date.newInstance(nextMonthDate.year(), nextMonthDate.month(), Math.min(daysInNextMonth, today.day()));
                        }
                        Installment.Name= 'Installment - '+(i+1)+' - '+C.get('Lastname');
                        Installment.Repay_Date__c=nextMonthDate;
                        if (nextMonthDate < Date.today())
                            Installment.state__C = 'OverDue';
                        else if(nextMonthDate < Date.today().addDays(28))
                            Installment.state__C = 'Due';
                        else
                            Installment.state__C = 'Upcoming';                    
                        System.debug(Installment.Name+'  | '+Installment.Repay_Date__c);
                        InstallmentList.add(Installment);
                        if(Ac.State__C == 'OverDue' || Installment.state__C == 'OverDue')
                            Ac.state__C = 'OverDue';
                        else if(Ac.State__C == 'Due' || Installment.state__C == 'Due')
                                Ac.state__C = 'Due';
                        else
                            Ac.state__C = 'Upcoming';                        
                        System.debug(Ac.state__C);
                    }
                    try {
                        insert InstallmentList;
                        System.debug('Account created successfully with Id: ' + ac.Id);
                    } catch (Exception e) {
                        System.debug('Error creating 10 Installment Records: ' + e.getMessage());
                    }
                    system.debug('InstallmentList.size() : '+InstallmentList.size());
                }
                system.debug('out of : if (LoanC.Action__c == Interest)');
                
            }
            if (LoanC.Action__c == 'Repay' || (LoanC.Action__c == 'Installment' && LoanC.state__C != 'Upcoming'))
            {
                System.debug('LoanC.Action__c == Repay || LoanC.Action__c == Installment');
                if (Ac.Type =='Regular_Loan')
                {
                    LoanC.Name= 'Installment '+C.get('Lastname') ;//Ac.Account_Id__c;
                    //Ac.Advance_Deduction__c +=LoanC.Repay_Amount__c;//=========
                    C.Loan__c  -=LoanC.Repay_Amount__c;
                }
                else if(Ac.Type  =='Annual_Loan')
                {
                    LoanC.Name= 'RePay '+C.get('Lastname') ;
                    LoanC.state__C ='Paid On Time';
                    //Ac.Advance_Deduction__c +=LoanC.Repay_Amount__c;//=========

                    C.Loan__c -=LoanC.Repay_Amount__c;
                }
            }
            
            if(Ac.Balance__c <= 0)
            {
                Ac.State__C='Closed';
                Ac.Active__c = 'No';
            }
            /*Advance_Deduction__c
            //++++++++++++++++++ Adding Amount to Contacts +++++++++++++++++++++++++
            String AcNo = ''+LoanC.get('Loan_Account__c');
            Integer NetAmount = 0;
            Account AcDetail  = Database.query('select CreatedDate,ContactName__c,Loan_Start_date__c, Action__c, Loan_Amount__c, Repay_Amount__c from Loan__c WHERE Id IN :'+AcNo);
            if(LoanC.get('Action__c') == 'Installment')
            LoanC.Repay_Amount__c= AcDetail.Loan_Amount__c/10; // NetAmount += Integer.valueOf(LoanC[0].get('Loan_Amount__c'));
            
            //else if(LoanC.get('Action__c') == 'Installment')
            //    NetAmount -= Integer.valueOf(LoanC.get('Repay_Amount__c'));
            //LoanUser.Loan__c +=NetAmount;
            

            //LoanC[0].Loan_Start_date__c = date.valueOf(LoanC[0].get('CreatedDate'));
            //Loan_Start_date__c
            */
            try {
                //update LoanUser;\system.debug(Ac.Advance_Deduction__c);
                System.debug(Ac.Advance_Deduction__c);
                //Ac.Loan_Amount__c +=Ac.Loan_Amount__c; 
                Update Ac;
                Update C;
                Update LoanC;
            } catch (DmlException e) {
                system.debug(e);// Process exception here
            }//Loan_Start_date__c
        }
    }
}