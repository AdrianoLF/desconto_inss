<template lang="">
  <div class="p-2">
    <h1>Cadastrar Proponente</h1>
    <proponent-form />
    <div style="height: 50px" />
  </div>
</template>
<script>
import { getProponents, deleteProponent } from "@/api/proponents";
import ActionCableApp from "@/helper/actionCable.js";
import { mapGetters } from "vuex";
import ProponentForm from "./proponents/Form.vue";

export default {
  name: "Home",
  components: {ProponentForm},
  data() {
    return {
      proponents: [],
    };
  },
  computed: {
    ...mapGetters("sessionManager", ["getAuthToken"]),
  },
  mounted() {
    this.fetchProponents();
    this.subscribeToNotifications();
  },
  methods: {
    subscribeToNotifications() {
      ActionCableApp.cable.subscriptions.create(
        { channel: "NotificationsChannel", token: this.getAuthToken },
        {
          received: (data) => {
            if (data?.message === "refresh_proponents") this.fetchProponents();
          },
        }
      );
    },
    async fetchProponents() {
      try {
        const { proponents } = await getProponents();
        this.proponents = proponents;
      } catch (error) {
        console.error("Erro ao buscar proponentes:", error);
      }
    },
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
