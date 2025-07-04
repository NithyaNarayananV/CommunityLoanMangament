import { LightningElement } from 'lwc';
import getTotalLoanBalance from '@salesforce/apex/CNS_LWC_HelperClass.getTotalActiveBalanceLoan';
import getTotalShareCount from '@salesforce/apex/CNS_LWC_HelperClass.getTotalSharesCount';
import getSangamMemberCount from '@salesforce/apex/CNS_LWC_HelperClass.getSangamMembersCount';
import getSangamTotalExpenses from '@salesforce/apex/CNS_LWC_HelperClass.getSangamTotalExpenses';

export default class CNS_LWC_MasterDataDisplay extends LightningElement {
    activeLoanBalance = 0;
    totalShares = 0;
    totalSharesValue = 0;
    sangamMember = 0;
    totalExpenses =0;

    connectedCallback() {
        this.fetchAllMetrics();
    }

    handleRefresh() {
        this.fetchAllMetrics(); // Trigger refresh from the top icon
    }

    fetchAllMetrics() {
        getTotalLoanBalance()
            .then(result => {
                this.activeLoanBalance = result;
            })
            .catch(error => console.error('Loan balance error:', error));

        getTotalShareCount()
            .then(result => {
                this.totalShares = result;
                this.totalSharesValue = this.totalShares * 5;
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
            })
            .catch(error => console.error('Total Expense error:', error));
    }
}
