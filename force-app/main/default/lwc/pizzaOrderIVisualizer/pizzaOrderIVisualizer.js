import { LightningElement, api } from 'lwc';
import getOrderItems from '@salesforce/apex/pizzaOrderI.getOrderItems';

export default class PizzaOrderIVisualizer extends LightningElement {
    @api recordId;
    largePizzaCount = 0;
    smallPizzaCount = 0;

    connectedCallback() {
        console.log('Connected Callback Called');
        this.getOrderItemData();
    }

    getOrderItemData() {
        if (this.recordId) {
            getOrderItems({ recordId: this.recordId  })
                .then(result => {
                    console.log('Order Item Data:', result);
                    this.updatePizzaCounts(result);
                })
                .catch(error => {
                    console.error('Error fetching order item data:', error);
                });
        }        
    }

    updatePizzaCounts(result) {
        if (result && result.length > 0) {
            for (let i = 0; i < result.length; i++) {
                const pizzaSize = result[i].Recipe__r.PizzaSize__c;
                console.log('Pizza Size: ' + pizzaSize);

                if (pizzaSize === '42 cm') {
                    this.largePizzaCount += result[i].Quantity__c;
                } else if (pizzaSize === '30 cm') {
                    this.smallPizzaCount += result[i].Quantity__c;
                } else {
                    console.log('Invalid pizzaSize.');
                }
            }
        } else {
            console.log('Error, orderItem data invalid');
        }
    }
}