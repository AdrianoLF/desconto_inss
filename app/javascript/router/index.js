import { createRouter, createWebHistory } from "vue-router";
import Home from "../components/Home.vue";
import Login from "../components/session/Login.vue";
import store from "@/store"; 

const routes = [
  { path: "/", name: "Home", component: Home },
  { path: "/login", name: "Login", component: Login },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  if (!store.getters["sessionManager/isLoggedIn"] && to.name !== "Login") {
    next({ name: "Login" });
  } else {
    next(); 
  }
});

export default router;
