import { LightningElement, wire, track } from 'lwc';
import getLoanData from '@salesforce/apex/Flow2Apex.getLoanData';

export default class ArchivedLoanRecordsViewer extends LightningElement {
    @track loans = [];
    @track loanDetails = [];
    @track masterLoan = {};          // map: accountNumber -> array of detail objects
    @track expandedRowId = null;     // currently expanded parent key
    @track expandedRowData = [];     // array of child records for the expanded row


    loanColumns = [
        { label: 'Created Date', fieldName: 'CreatedDate', type: 'date',
          typeAttributes: { day: 'numeric', month: 'short', year: 'numeric' } },
        { label: 'Name', fieldName: 'Name__c', type: 'text' },
        //{ label: 'Contact', fieldName: 'Contact__c', type: 'text' },
        { label: 'Contact Name', fieldName: 'Contact_Name__c', type: 'text' },
        { label: 'Security Name', fieldName: 'Security_Contact_Name__c', type: 'text' },
        { label: 'Loan Type', fieldName: 'Loan_Type__c', type: 'text' },
        { label: 'Loan Amount', fieldName: 'Loan_Amount__c', type: 'currency',
          typeAttributes: { currencyCode: 'INR' } },
        { label: 'Account Number', fieldName: 'Account_Number__c', type: 'text' },
        { label: 'Details', fieldName: 'Details__c', type: 'text' },
        { type: 'action', typeAttributes: 
            { rowActions: 
                [   { label: 'View Details', name: 'view_details' },
                    { label: 'Delete', name: 'delete' }
                ] 
            }
        },
        { type: 'action' }
    ];

    detailColumns = [
        //{ label: 'Id', fieldName: 'Id', type: 'text' },
        //{ label: 'Name', fieldName: 'Name', type: 'text', initialWidth: 250},
        { label: 'Type', fieldName: 'Action__c', type: 'text' , initialWidth: 100 },
        { label: 'Paid', fieldName: 'Repay_Amount__c', type: 'currency',
          typeAttributes: { currencyCode: 'INR' } ,initialWidth: 100},
        { label: 'Paid To', fieldName: 'Paid_To__c', type: 'text', initialWidth: 100 },
        { label: 'Due Date', fieldName: 'Repay_Date__c', type: 'date',
          typeAttributes: { day: 'numeric', month: 'short', year: 'numeric' }, initialWidth: 100 },
        //{ label: 'Loaner ID', fieldName: 'LoanerID__c', type: 'text' },
        { label: 'Paid Date', fieldName: 'PyamentDate__c', type: 'date',
          typeAttributes: { day: 'numeric', month: 'short', year: 'numeric' }, initialWidth: 100 },
        { label: 'State', fieldName: 'State__c', type: 'text', initialWidth: 120}//,
        //{ label: 'Description', fieldName: 'Description__c', type: 'text' },
        //{ label: 'Category', fieldName: 'Category__c', type: 'text' },
        //{ label: 'Loan Account', fieldName: 'Loan_Account__c', type: 'text' }
    ];

    @wire(getLoanData)
    wiredLoans({ error, data }) {
        if (data) {
            // store raw loans
            //this.loans = data;
            //console.log('Loan data sample', JSON.stringify(this.loans[0]));
            //this.loanExtractor(data);
            if (data) { // clone each loan record before adding custom props 
                this.loans = data.map(loan => { let loanCopy = { ...loan }; 
                    try {
                        if (loan.Details__c) {
                            let parsed = JSON.parse(loan.Details__c);
                            loanCopy.detailsParsed = Array.isArray(parsed) ? parsed : [parsed];
                        } else {
                            loanCopy.detailsParsed = [];
                        }
                    } catch (error) {
                        console.error('Error parsing Details__c for loan', loan.Id, error);
                        loanCopy.detailsParsed = [];
                    }    
                    return loanCopy; 
                });
            } 
            else if (error) { console.error(error); }
        } else if (error) {
            console.error('Error fetching loan data:', error);
        }
    }

    handleRowAction(event) {
        let actionName =  event.detail.action.name;
        let row = event.detail.row;
        console.log('row : ',row);
        let parentKey = row.Account_Number__c;
        console.log('row.Account_Number__c',row.Account_Number__c);
        if(this.masterLoan[parentKey]==null)
            this.expandedRowId = false;
        else if (actionName === 'view_details' ) {
            this.expandedRowId = parentKey;
            this.expandedRowData=[];
            this.expandedRowData = this.masterLoan[parentKey];
        }
    }
}