import {LightningElement} from 'lwc';

export default class AccountGallery extends LightningElement {
    selectedAccountId;

    handleSelectAccount(event) {
        this.selectedAccountId =  event.detail;
    }
}