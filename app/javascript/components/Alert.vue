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
        isAlertVisible: false, // Controle de visibilidade do alerta
        alertMessage: '',      // Texto da mensagem a ser exibida
      };
    },
    created() {
      EventBus.on('displayAlert', this.showAlert); // Escuta o evento
    },
    methods: {
      showAlert(message) {
        this.alertMessage = message;  // Define o texto do alerta
        this.isAlertVisible = true;   // Exibe o alerta
        setTimeout(() => {
          this.isAlertVisible = false; // Esconde o alerta após 2 segundos
        }, 2000);
      },
    },
    beforeUnmount() {
      EventBus.off('displayAlert', this.showAlert); // Remove o ouvinte
    },
  };
  </script>
  