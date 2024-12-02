<template>
    <div>
      <div 
        v-if="isAlertVisible" 
        class="alert alert-info alert-dismissible fade show" 
        role="alert"
        :style="{ position: 'fixed', top: '20px', right: '20px', zIndex: 1050 }">
        {{ alertMessage }}
      </div>
    </div>
  </template>
  
  <script>
  import EventBus from '@/helper/eventBus';
  
  export default {
    data() {
      return {
        isAlertVisible: false, // Control the visibility of the alert
        alertMessage: '',      // The message text to display
      };
    },
    created() {
      EventBus.on('displayAlert', this.showAlert); // Listen for the event
    },
    methods: {
      showAlert(message) {
        this.alertMessage = message;  // Set the alert text
        this.isAlertVisible = true;   // Show the alert
        setTimeout(() => {
          this.isAlertVisible = false; // Hide the alert after 2 seconds
        }, 2000);
      },
    },
    beforeUnmount() {
      EventBus.off('displayAlert', this.showAlert); // Remove the listener
    },
  };
  </script>
  