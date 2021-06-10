import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import getMeetupsRecord from '@salesforce/apex/meetupsController.getMeetupsRecord';
import registerMeetups from '@salesforce/apex/meetupsController.registerMeetups';

export default class MeetupsTechStarsChallenge extends LightningElement {
    @track showForm = false;
    @track regCode;
    @track meetupId;
    @track error;
    @track firstName;
    @track lastName;
    @track email;

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    handleCodeValidation(){
        const allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                        inputCmp.reportValidity();
                        return validSoFar && inputCmp.checkValidity();
            }, true);
        if(allValid){
            getMeetupsRecord({regCode: this.regCode})
            .then((result)=>{
                this.meetupId = result;
                this.showForm = true;
            })
            .catch ((error)=>{
                this.meetupId = undefined;
                this.error = error;
                this.showForm = false;
            })
        }
        else {
            this.showToast ('Something went wrong', 'All fields need to be filled before submission!', 'error')
        }
    }

    handleRegister(){
        const allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                        inputCmp.reportValidity();
                        return validSoFar && inputCmp.checkValidity();
            }, true);
        if(allValid){
            registerMeetups({firstName: this.firstName, lastName: this.lastName, emailAddress: this.email, meetupId: this.meetupId})
            .then((result)=>{
                if (result ==''){
                    this.showToast('Success!', 'Meetup Registered!', 'success');
                }
                else if (result == 'Meetup status must be open'){
                    this.showToast('Something went wrong!', 'Meetup status must be open!', 'error');
                }
                else if (result == 'Total # of registrations exceed the registration limit for this Meetup'){
                    this.showToast('Something went wrong!', 'Total # of registrations exceed the registration limit for this Meetup!', 'error');
                }
                else {
                    this.showToast('Something went wrong!', 'This email has been registered!', 'error');
                }
                this.showForm = false;
            })
            .catch ((error)=>{
                this.showToast('Something went wrong', error.body.message, 'error');
                this.showForm = false;
            })
        }
        else {
            this.showToast('Something went wrong', 'All fields need to be filled before submission', 'error');
        }
    }


    handleRegistrationCodeChanges(event){
        this.regCode = event.target.value;
    }

    handlePrevious(){
        this.error = undefined;
    }

    handleFirstNameChanges(event){
        this.firstName = event.target.value;
    }

    handleLastNameChanges(event){
        this.lastName = event.target.value;
    }

    handleEmailChanges(event){
        this.email = event.target.value;
    }
}