<template lang="">
  <div>
    <h1>Desconto INSS</h1>

    <div v-for="proponent in proponents" :id="proponent.id" :key="proponent.id">
      {{ proponent.id }}
      {{ proponent.name }}
      <button @click="deleteRecord(proponent.id)">Deletar</button>
    </div>
  </div>
</template>
<script>
import { getProponents, deleteProponent } from "@/api/proponents";
import ActionCableApp from "@/helper/actionCable.js";
import { mapGetters } from "vuex";

export default {
  name: "Home",
  components: {},
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
