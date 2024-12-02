<template>
  <div>
    <div>Reports</div>
    <button @click="teste">teste</button>
    <proponents-list></proponents-list>
  </div>
</template>

<script>
import EventBus from "@/helper/eventBus";
import ProponentsList from "./List.vue";

export default {
  components: {
    ProponentsList,
  },
  methods: {
    teste() {
      EventBus.emit("displayAlert", "Minha mensagem de alerta!");
    },
  },
};
</script>
