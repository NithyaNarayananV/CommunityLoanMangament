import { LightningElement , wire} from 'lwc';
import getTotalLoanBalance from '@salesforce/apex/CNS_LWC_HelperClass.getTotalActiveBalanceLoan';
import getTotalShareCount from '@salesforce/apex/CNS_LWC_HelperClass.getTotalSharesCount';

export default class CNS_LWC_MasterDataDisplay extends LightningElement {
    activeLoanBalance = 0;
    @wire(getTotalLoanBalance)
    wiredBalance({ error, data }) {
        if (data) {
            this.activeLoanBalance = data;
        } else if (error) {
            console.error('Error fetching balance:', error);
        }
    }
    totalShares = 0;
    totalSharesValue = 0;
    @wire(getTotalShareCount)
    wiredBalance({ error, data }) {
        if (data) {
            this.totalShares = data;
            this.totalSharesValue= this.totalShares * 5; // each share is worth 5
        } else if (error) {
            console.error('Error fetching balance:', error);
        }
    }



    //
}
