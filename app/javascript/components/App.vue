<template>
  <div id="app">
    <nav class="w-100 d-flex justify-content-between p-2" @click="loggsss">
      <div class="d-flex gap-2">
        <router-link to="/" class="btn btn-primary">Relatórios</router-link>
        <router-link to="/proponents" class="btn btn-primary">
          Cadastrar Proponentes
        </router-link>
      </div>
      <div>
        <router-link v-if="!isLoggedIn" to="/login" class="btn btn-secondary">
          Login
        </router-link>
        <button v-if="isLoggedIn" @click="logout" class="btn btn-danger">
          Logout
        </button>
      </div>
    </nav>
    <router-view />
  </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import AlertBox from "./Alert.vue";

export default {
  name: "App",
  components: {
    AlertBox,
  },
  computed: {
    ...mapGetters("sessionManager", ["isLoggedIn"]),
  },
  methods: {
    ...mapActions("sessionManager", ["logoutUser"]),
    logout() {
      this.logoutUser();
      this.$router.push({ name: "Login" });
    },
    loggsss() {
      console.log("asjkdjklasdjlhk");
      console.log(this.isLoggedIn);
      console.log(localStorage.auth_token);
      console.log(localStorage.getItem("auth_token"));
    },
  },
};
</script>
<style lang=""></style>
