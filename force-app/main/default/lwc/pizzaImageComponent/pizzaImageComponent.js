import { LightningElement, api } from 'lwc';
import getOrderItems from '@salesforce/apex/pizzaImage.getOrderItems';

export default class PizzaImageComponent extends LightningElement {
    @api recordId;
    pizzaImages =[];
    connectedCallback(){
        console.log('Connected Callback Called');
        this.getOrderItemData();
    }

    getOrderItemData(){
        if(this.recordId){
            getOrderItems({recordId: this.recordId})
            .then(dataResult => {
            console.log('OrderItemData:', dataResult);
                if (dataResult && dataResult.length > 0) {
                    dataResult.forEach(record => {
                        const imageSrc = this.getSrcFromImg(record.Pizza_img__c);
                            if (imageSrc) {
                                this.pizzaImages = [...this.pizzaImages, imageSrc];
                                console.log('Pizza Images:', this.pizzaImages);
                            } else {
                                console.error('No image source found in HTML string');
                            }
                    });
                } else {
                    console.error('Dont found anything');
                }
            })
            .catch(error => {
                console.error('Error fetching order item data:', error);
            });
        }
    }

    getSrcFromImg(htmlString) {
        const regex = /<img[^>]+src=['"]([^'"]+)['"][^>]*>/;
        const match = htmlString.match(regex);
        return match ? match[1] : null;
    }
}