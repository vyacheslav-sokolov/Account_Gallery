import {LightningElement, wire} from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import ACCOUNT_TYPE from '@salesforce/schema/Account.Type';
import getAccounts from '@salesforce/apex/FindAccounts.getAccounts';

export default class FindAnAccount extends LightningElement {
    accountType;
    accountsToDisplay;
    budgetJS = 0;
    budgetSOQL = 0;
    budgetAPEX = 0;

    @wire(getPicklistValues, {recordTypeId : '012000000000000AAA', fieldApiName : ACCOUNT_TYPE})
    accountTypes;

    connectedCallback(){
        getAccounts().then(result => {
            this.accountsToDisplay = result.accounts;
            this.budgetSOQL = result.totalBudgetSOQL;
            this.budgetAPEX = result.totalBudgetAPEX;
            result.accounts.map(account => {
                if (account.Budget__c) {
                    this.budgetJS += account.Budget__c;
                }
            })
        }).catch(error => {
            console.log('error: ' + error.message);
        });
    }

    handleAccountTypesChange(event) {
        this.accountsToDisplay = null;
        this.accountType = event.detail.value;
        getAccounts({
            type: event.detail.value,
        }).then(result => {
            this.budgetJS = 0;
            this.accountsToDisplay = result.accounts;
            this.budgetSOQL = result.totalBudgetSOQL;
            this.budgetAPEX = result.totalBudgetAPEX;
            result.accounts.map(account => {
                if (account.Budget__c) {
                    this.budgetJS += account.Budget__c;
                }
            })
        }).catch(error => {
            console.log('error: ' + error.message);
        });
    }

    selectAccount(event) {
        const accountId = event.currentTarget.dataset.id;
        const selectedEvent = new CustomEvent('selectaccount', { detail: accountId });
        this.dispatchEvent(selectedEvent);
    }
}