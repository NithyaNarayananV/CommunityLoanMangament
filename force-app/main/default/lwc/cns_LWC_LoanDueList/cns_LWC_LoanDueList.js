import { LightningElement, wire, track } from 'lwc';
import getActiveLoans from '@salesforce/apex/CNS_LWC_HelperClass.getActiveLoans';

export default class Cns_LWC_LoanDueList extends LightningElement {
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
