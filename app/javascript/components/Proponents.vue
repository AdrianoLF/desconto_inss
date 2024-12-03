<template lang="">
  <div class="container">
    <h2 class="mb-4">Cadastrar proponentes</h2>
    <proponent-form />
    <div style="height: 50px" />
  </div>
</template>
<script>
import { deleteProponent } from "@/api/proponents";
import ProponentForm from "./proponents/CreateForm.vue";

export default {
  name: "Home",
  components: { ProponentForm },
  data() {
    return {
      proponents: [],
    };
  },
  mounted() {
    this.subscribeToNotifications();
  },
  methods: {
    async deleteRecord(id) {
      try {
        await deleteProponent(id);
      } catch (error) {
        console.error("Erro ao deletar proponentes:", error);
      }
    },
  },
};
</script>
<style lang=""></style>
