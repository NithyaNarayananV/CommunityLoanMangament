import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getActiveLoans from '@salesforce/apex/CNS_LWC_HelperClass.getActiveLoans';
export default class Cns_LWC_LoanDueList extends NavigationMixin(LightningElement) {
    //Flow start
    showFlow = false;
    showCreatedExpenseRecord = false;
    handleClickAddExpense() {
        this.inputVariables = [{
            name: 'IncomeOrExpense',
            type: 'String',
            value: 'Expense'
        }];
        if(this.showFlow) 
            this.showFlow = false;
        else
            this.showFlow = true;
        
    }
    handleClickAddDonation() {
        this.inputVariables = [{
            name: 'IncomeOrExpense',
            type: 'String',
            value: 'Donation'
        }];
        if(this.showFlow) 
            this.showFlow = false;
        else
            this.showFlow = true;        
    }
    handleStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            //this.showFlow = false;
            this.inputVariables[0].value=='Expense' ? this.showCreatedExpenseRecord = true : this.showCreatedDonationRecord = true;
            setTimeout(() => {
            this.showCreatedExpenseRecord = false;
            this.showCreatedDonationRecord = false;
        }, 3000); // Optional: handle post-flow logic here
        }
    }
    ////Flow launcher component end

    @track columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Loan Amount', fieldName: 'Loan_Amount__c', type: 'currency' },
        { label: 'Balance', fieldName: 'Balance__c', type: 'currency' }
    ];
    @track loanRecords;
    @wire(getActiveLoans)
    wiredLoans({ error, data }) {
        if (data) {
            this.loanRecords = data;
        } else if (error) {
            console.error(error);
        }
    }
}
