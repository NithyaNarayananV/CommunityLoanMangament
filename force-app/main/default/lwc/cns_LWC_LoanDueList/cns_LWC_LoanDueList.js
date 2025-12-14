import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getActiveLoans from '@salesforce/apex/CNS_LWC_HelperClass.getActiveLoans';
export default class Cns_LWC_LoanDueList extends NavigationMixin(LightningElement) {
    //Flow start
    //showFlow = false;
    showCreatedExpenseRecord = false;    
    activeButton = '';
    showFlowE=false;
    showFlowI=false;
    handleClickAddExpense() {
        this.activeButton = 'Ex';
        if(this.showFlowE) {
            
            this.showFlowE = false;
        }            
        else{
            this.showFlowI = false;
            setTimeout(() => {
                this.showFlowE = true;
            }, 10);
        }
    }
    handleClickAddDonation() {
        this.activeButton = 'In';
        if(this.showFlowI) 
            this.showFlowI = false;
        else{
            this.showFlowE = false;
            setTimeout(() => {
                this.showFlowI = true;
            }, 10);
            
        } 
    }
    get inputVariables(){
        if (this.showFlowE)
            return  [{
            name: 'IncomeOrExpense',
            type: 'String',
            value: 'Expense'
        }];
        if (this.showFlowI)
            return  [{
            name: 'IncomeOrExpense',
            type: 'String',
            value: 'Income'
        }];
    }
    get showFlow() {
        return this.showFlowI || this.showFlowE;
    }
    get IncomeButtonClass() {
        return this.activeButton === 'Ex' ? 'slds-m-left_x-small' : 'slds-m-left_x-small';
    }

    get ExpenseButtonClass() {
        return this.activeButton === 'In' ? 'slds-m-left_xx-small' : 'slds-m-left_x-small'; //variant="brand"
    }
    //    return this.activeButton === 'B' ? 'slds-button_brand' : 'slds-button_neutral slds-button_stretch slds-opacity_50';
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
