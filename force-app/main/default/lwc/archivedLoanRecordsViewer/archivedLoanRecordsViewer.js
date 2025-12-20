import { LightningElement, wire } from 'lwc';
import getLoanData from '@salesforce/apex/Flow2Apex.getLoanData';

export default class ArchivedLoanRecordsViewer extends LightningElement {
    loans;
    loanDetails=[];
    masterLoan=[];
    loanColumns = [
    { label: 'Type', fieldName: 'Type', type: 'text' },
    { label: 'Description', fieldName: 'Description', type: 'text' },
    { label: 'Repaid', fieldName: 'Repaid__c', type: 'boolean' },
    { label: 'SLA', fieldName: 'SLA__c', type: 'text' },
    { label: 'Active', fieldName: 'Active__c', type: 'boolean' },
    { label: 'Balance', fieldName: 'Balance__c', type: 'currency' },
    { label: 'Interest Paid A', fieldName: 'Interest_Paid_A__c', type: 'currency' },
    { label: 'Loan Date', fieldName: 'Loan_Date__c', type: 'date' },
    { label: 'Contact', fieldName: 'Contact__c', type: 'text' },
    { label: 'Security Contact', fieldName: 'Security_Contact__c', type: 'text' },
    { label: 'Account Id', fieldName: 'Account_Id__c', type: 'text' },
    { label: 'Loan Amount', fieldName: 'Loan_Amount__c', type: 'currency' },
    { label: 'Advance Deduction', fieldName: 'Advance_Deduction__c', type: 'currency' },
    { label: 'State', fieldName: 'State__c', type: 'text' },
    { label: 'Type', fieldName: 'Type__c', type: 'text' },

        {
            type: 'action',
            typeAttributes: { rowActions: [
                { label: 'View details', name: 'view_details' }
            ] }
        }
    ];
    repayColumns = [
    { label: 'Id', fieldName: 'Id', type: 'text' },
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Payment Date', fieldName: 'PyamentDate__c', type: 'date' },
    { label: 'Action', fieldName: 'Action__c', type: 'text' },
    { label: 'Repay Amount', fieldName: 'Repay_Amount__c', type: 'currency' },
    { label: 'Paid To', fieldName: 'Paid_To__c', type: 'text' },
    { label: 'Repay Date', fieldName: 'Repay_Date__c', type: 'date' },
    { label: 'Loaner ID', fieldName: 'LoanerID__c', type: 'text' },
    { label: 'State', fieldName: 'State__c', type: 'text' },
    { label: 'Description', fieldName: 'Description__c', type: 'text' },
    { label: 'Category', fieldName: 'Category__c', type: 'text' },
    { label: 'Loan Account', fieldName: 'Loan_Account__c', type: 'text' }
];
loanColumns = [
        { label: 'Name', fieldName: 'Name__c', type: 'text' },
        { label: 'Loan Amount', fieldName: 'Loan_Amount__c', type: 'currency' },
        { label: 'State', fieldName: 'State__c', type: 'text' },
        {
            type: 'action',
            typeAttributes: { rowActions: [{ label: 'View Details', name: 'view_details' }] }
        }
    ];

    detailColumns = [
        { label: 'Id', fieldName: 'Id', type: 'text' },
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'Payment Date', fieldName: 'PyamentDate__c', type: 'date' },
        { label: 'Action', fieldName: 'Action__c', type: 'text' },
        { label: 'Repay Amount', fieldName: 'Repay_Amount__c', type: 'currency' },
        { label: 'Paid To', fieldName: 'Paid_To__c', type: 'text' },
        { label: 'Repay Date', fieldName: 'Repay_Date__c', type: 'date' },
        { label: 'Loaner ID', fieldName: 'LoanerID__c', type: 'text' },
        { label: 'State', fieldName: 'State__c', type: 'text' },
        { label: 'Description', fieldName: 'Description__c', type: 'text' },
        { label: 'Category', fieldName: 'Category__c', type: 'text' },
        { label: 'Loan Account', fieldName: 'Loan_Account__c', type: 'text' }
    ];

    connectedCallback() {
        // Flatten masterLoan into loanData for datatable
        // Example: masterLoan = [{ loan, details }]
        // Replace with your actual data assignment
        this.loanData = this.masterLoan.map(entry => entry.loan);
    }

    handleRowAction(event) {
        const { action, row } = event.detail;
        if (action.name === 'view_details') {
            // Find the entry in masterLoan and set selectedDetails
            const entry = this.masterLoan.find(e => e.loan.Id === row.Id);
            this.selectedDetails = entry ? entry.details : [];
        }
    }
    //    Type, Description, Repaid__c, SLA__c, Active__c, Balance__c, Interest_Paid_A__c, Loan_Date__c, Contact__c, Security_Contact__c, Account_Id__c, Loan_Amount__c, Advance_Deduction__c, State__c, Type__c 





    @wire(getLoanData)
    wiredLoans({ error, data }) {
        if (data) {
            this.loans = data;
            console.log('Loan data:', this.loans);

            this.loanExtractor(data);
        } else if (error) {
            console.error('Error fetching loan data:', error);
        }
    }

    loanExtractor(data) {
        this.loans = data;

        for (let i = 0; i < this.loans.length; i++) {
            let loan = this.loans[i];
            console.log('Loan I = ', loan);
            console.log('Details = ',loan.Details__c);

            if (loan.Details__c) {
                try {
                    let detailsList = JSON.parse(loan.Details__c);
                    console.log('[loan.details__c]:', detailsList);

                    let detailslistMaster = [];

                    for (let det of detailsList) {
                        // If det is already an object, skip parsing again
                        let detList = (typeof det === 'string') ? JSON.parse(det) : det;
                        console.log('detList:', detList);
                        detailslistMaster.push(detList);
                    }
                    
                    console.log(' --detailslistMaster-- :', detailslistMaster);
                    this.loanDetails.push(...detailslistMaster)
                    this.masterLoan.push({ loan, details: detailslistMaster });
                                           //loan.Details__x = detailslistMaster    ;
                    console.log('loan.Details__x:', this.loanDetails);
                } catch (e) {
                    console.error('Error parsing loan.Details__c for loan:', loan.Id, e);
                }
            } else {
                console.warn('Loan has no Details__c:', loan.Id);
            }
        }
    }
}