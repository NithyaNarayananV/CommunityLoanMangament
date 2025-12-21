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
        { label: 'Loan Type', fieldName: 'Loan_Type__c', type: 'text' },
        { label: 'Loan Amount', fieldName: 'Loan_Amount__c', type: 'currency',
          typeAttributes: { currencyCode: 'INR' } },
        { label: 'Account Number', fieldName: 'Account_Number__c', type: 'text' },
        { label: 'Details', fieldName: 'Details__c', type: 'text' },
        {
            type: 'action',
            typeAttributes: { rowActions: [{ label: 'View Details', name: 'view_details' },
            { label: 'Delete', name: 'delete' }] }
        },
        {
            type: 'action',
        }
    ];

    detailColumns = [
        //{ label: 'Id', fieldName: 'Id', type: 'text' },
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'Action', fieldName: 'Action__c', type: 'text' },
        { label: 'Repay Amount', fieldName: 'Repay_Amount__c', type: 'currency',
          typeAttributes: { currencyCode: 'INR' } },
        { label: 'Paid To', fieldName: 'Paid_To__c', type: 'text' },
        { label: 'Due Date', fieldName: 'Repay_Date__c', type: 'date',
          typeAttributes: { day: 'numeric', month: 'short', year: 'numeric' } },
        //{ label: 'Loaner ID', fieldName: 'LoanerID__c', type: 'text' },
        { label: 'Paid Date', fieldName: 'PyamentDate__c', type: 'date',
          typeAttributes: { day: 'numeric', month: 'short', year: 'numeric' } },
        { label: 'State', fieldName: 'State__c', type: 'text' }//,
        //{ label: 'Description', fieldName: 'Description__c', type: 'text' },
        //{ label: 'Category', fieldName: 'Category__c', type: 'text' },
        //{ label: 'Loan Account', fieldName: 'Loan_Account__c', type: 'text' }
    ];

    @wire(getLoanData)
    wiredLoans({ error, data }) {
        if (data) {
            // store raw loans
            this.loans = data;
            console.log('Loan data sample', JSON.stringify(this.loans[0]));
            this.loanExtractor(this.loans);
        } else if (error) {
            console.error('Error fetching loan data:', error);
        }
    }

    loanExtractor(loans) {
        // reset maps
        this.masterLoan = {};
        this.loanDetails = [];

        for (let loan of loans) {
            // guard: ensure Account_Number__c exists and is a string key
            let accountKey = loan.Account_Number__c ;

            if (loan.Details__c) {
                try {
                    // Details__c may be a JSON string or already an array/object
                    let detailsList = loan.Details__c;
                    if (typeof detailsList === 'string') {
                        detailsList = JSON.parse(detailsList);
                    }

                    // detailsList should be an array; normalize each element to object
                    const detailslistMaster = [];
                    if (Array.isArray(detailsList)) {
                        for (let det of detailsList) {
                            let detObj = det;
                            if (typeof det === 'string') {
                                detObj = JSON.parse(det);
                            }
                            detailslistMaster.push(detObj);
                        }
                    } else {
                        // single object case
                        detailslistMaster.push(detailsList);
                    }
                    this.masterLoan[accountKey] = detailslistMaster;
                    console.log('masterLoan[accountKey] = detailslistMaster ', accountKey, 'list = ',detailslistMaster);

                    // store full list keyed by accountKey
                    // accumulate for debugging or other uses
                    this.loanDetails.push(...detailslistMaster);
                } catch (e) {
                    console.error('Error parsing Details__c for loan', loan.Id, e);
                    //this.masterLoan[accountKey] = []; // safe fallback
                }
            } else {
                //this.masterLoan[accountKey] = [];
            }
        }
        console.log('masterLoan map keys', Object.keys(this.masterLoan));
    }

    handleRowAction(event) {
        let actionName =  event.detail.action.name;
        let row = event.detail.row;
        console.log('row : ',row);

        let parentKey = row.Account_Number__c;
        console.log('row.Account_Number__c',row.Account_Number__c);
        if (actionName === 'view_details') {
                this.expandedRowId = parentKey;
                this.expandedRowData=[];
                this.expandedRowData = this.masterLoan[parentKey];

        }
    }

    
}