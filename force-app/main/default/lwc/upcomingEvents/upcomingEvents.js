import { LightningElement, wire } from 'lwc';
import getUpcomingEvents from '@salesforce/apex/EventController.getUpcomingEvents';
import { NavigationMixin } from 'lightning/navigation';

export default class UpcomingEvents extends NavigationMixin(LightningElement) {

    events = [];
    attendeesMap = {};
    error;
    isLoading = true;
    isOpen = false;

    @wire(getUpcomingEvents)
    wiredEvents({ error, data }) {
        this.isLoading = false;

        if (data) {
            this.attendeesMap = data.attendees;
            this.events = data.events.map(ev => {
                return {
                    ...ev,
                    isOpen: false,
                    icon: 'utility:chevronright',
                    attendees: this.attendeesMap[ev.Id] || []
                };
            });
            //this.events = data.events;
            console.log('Events:', JSON.stringify(this.events));
            console.log('Attendees Map:', JSON.stringify(this.attendeesMap));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.events = undefined;
        }
    }

    handleNavigate(event) {
        const recordId = event.currentTarget.dataset.id;

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Event__c',
                actionName: 'view'
            }
        });
    }

    toggleEvent(event) {
        const eventId = event.currentTarget.dataset.id;

        this.events = this.events.map(ev => {

            if (ev.Id === eventId) {
                const isOpen = !ev.isOpen;
                this.isOpen = !ev.isOpen

                return {
                    ...ev,
                    isOpen: isOpen,
                    icon: isOpen ? 'utility:chevrondown' : 'utility:chevronright'
                };
            }

            return ev;
        });
    }
}