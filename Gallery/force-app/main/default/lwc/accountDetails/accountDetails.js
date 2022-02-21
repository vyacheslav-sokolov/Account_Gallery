import {LightningElement, api} from 'lwc';
import getAccountDetails from '@salesforce/apex/FindAccounts.getAccountDetails';
import {NavigationMixin} from "lightning/navigation";

export default class AccountDetails extends NavigationMixin(LightningElement) {
    accountIdDetails;
    accountDetails;

    @api
    get accountId() {
        return this.accountIdDetails;
    }

    set accountId(value) {
        this.accountIdDetails = value;
        getAccountDetails({
            accountId : this.accountId
        }).then(result => {
            this.accountDetails = result;
        }).catch(error => {
            console.log('error: ' + error.message);
        });
    }

    navigateToAccount() {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.accountId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        }).then(url => { window.open(url) });
    }
}