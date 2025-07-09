import { LightningElement } from 'lwc';
import getTotalLoanBalance from '@salesforce/apex/CNS_LWC_HelperClass.getTotalActiveBalanceLoan';
import getTotalShareCount from '@salesforce/apex/CNS_LWC_HelperClass.getTotalSharesCount';
import getSangamMemberCount from '@salesforce/apex/CNS_LWC_HelperClass.getSangamMembersCount';
import getSangamTotalExpenses from '@salesforce/apex/CNS_LWC_HelperClass.getSangamTotalExpenses';
import getTotalInterestReceived from '@salesforce/apex/CNS_LWC_HelperClass.getTotalInterestReceived';
export default class CNS_LWC_MasterDataDisplay extends LightningElement {
    activeLoanBalance = 0;
    totalShares = 0;
    totalSharesValue = 0;
    sangamMember = 0;
    totalExpenses =0;
    time;
    totalIntRec =0;
    availableBalance=0;


    connectedCallback() {
        this.fetchAllMetrics();
    }

    handleRefresh() {
        this.fetchAllMetrics(); // Trigger refresh from the top icon
        //DefaultRecord.accountRefresh();
    }

    fetchAllMetrics() {
        this.availableBalance=0;
        const now = new Date();
        this.time = now.toLocaleTimeString(); // Change format if needed
        getTotalLoanBalance()
            .then(result => {
                this.activeLoanBalance = result;
                this.availableBalance -= this.activeLoanBalance;
            })
            .catch(error => console.error('Loan balance error:', error));

        getTotalShareCount()
            .then(result => {
                this.totalShares = result;
                this.totalSharesValue = this.totalShares * 50;
                this.availableBalance += this.totalSharesValue;
            })
            .catch(error => console.error('Shares count error:', error));

        getSangamMemberCount()
            .then(result => {
                this.sangamMember = result;
            })
            .catch(error => console.error('Member count error:', error));
        getSangamTotalExpenses()
            .then(result => {
                this.totalExpenses = result;
                this.availableBalance -= this.totalExpenses;
            })
            .catch(error => console.error('Total Expense error:', error));
        getTotalInterestReceived()
            .then(result => {
                this.totalIntRec = result;
                this.availableBalance +=this.totalIntRec;
            })
            .catch(error => console.error('Total Int Rec error:', error));
            //this.availableBalance = this.activeLoanBalance + this.totalSharesValue - this.totalExpenses + this.totalIntRec;
    }
}
