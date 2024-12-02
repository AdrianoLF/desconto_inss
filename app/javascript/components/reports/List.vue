<template>
  <div class="container mt-5">
    <h1 class="mb-4">Lista de Funcionários</h1>

    <!-- Barra de Pesquisa -->
    <div class="row mb-3">
      <div class="col-md-3">
        <input
          type="text"
          class="form-control"
          placeholder="Pesquisar por Nome"
          v-model="searchName"
          @input="debouncedFetchProponents"
        />
      </div>
      <div class="col-md-3">
        <input
          type="text"
          class="form-control"
          placeholder="Pesquisar por CPF"
          v-model="searchCpf"
          @input="debouncedFetchProponents"
        />
      </div>
      <div class="col-md-3">
        <select
          class="form-control"
          v-model="selectedDiscountGroup"
          @change="fetchProponents"
        >
          <option value="">Todos os Grupos</option>
          <option value="first">Faixa 1</option>
          <option value="second">Faixa 2</option>
          <option value="third">Faixa 3</option>
          <option value="fourth">Faixa 4</option>
        </select>
      </div>
      <div class="col-md-3">
        <button class="btn btn-primary w-100" @click="fetchProponents">
          Buscar
        </button>
      </div>
    </div>

    <!-- Tabela de Funcionários -->
    <table class="table table-striped table-bordered">
      <thead class="thead-dark">
        <tr>
          <th scope="col">#</th>
          <th scope="col">Nome</th>
          <th scope="col">CPF</th>
          <th scope="col">Salário</th>
          <th scope="col">Ações</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="proponent in proponents" :key="proponent.id">
          <th scope="row">{{ proponent.id }}</th>
          <td>{{ proponent.name }}</td>
          <td>{{ proponent.cpf }}</td>
          <td>{{ formatSalary(proponent.salary) }}</td>
          <td>
            <button
              class="btn btn-danger btn-sm"
              @click="deleteRecord(proponent.id)"
            >
              Deletar
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Paginação -->
    <nav aria-label="Page navigation example">
      <ul class="pagination justify-content-center">
        <li class="page-item" :class="{ disabled: currentPage === 1 }">
          <a
            class="page-link"
            href="#"
            @click.prevent="changePage(currentPage - 1)"
          >
            Anterior
          </a>
        </li>

        <li
          class="page-item"
          v-for="page in totalPages"
          :key="page"
          :class="{ active: currentPage === page }"
        >
          <a class="page-link" href="#" @click.prevent="changePage(page)">
            {{ page }}
          </a>
        </li>

        <li class="page-item" :class="{ disabled: currentPage === totalPages }">
          <a
            class="page-link"
            href="#"
            @click.prevent="changePage(currentPage + 1)"
          >
            Próximo
          </a>
        </li>
      </ul>
    </nav>
  </div>
</template>
<script>
import { getProponents, deleteProponent } from "@/api/proponents";
import ActionCableApp from "@/helper/actionCable.js";
import { mapGetters } from "vuex";
import debounce from "lodash.debounce"; // Importa debounce para otimizar as buscas

export default {
  name: "Home",
  data() {
    return {
      proponents: [],
      searchName: "",
      searchCpf: "",
      selectedDiscountGroup: "", // Nova propriedade para o filtro discount_group
      currentPage: 1,
      totalPages: 1,
      perPage: 10, // Número de itens por página
    };
  },
  computed: {
    ...mapGetters("sessionManager", ["getAuthToken"]),
  },
  mounted() {
    this.fetchProponents();
    this.subscribeToNotifications();
    // Cria uma versão debounced do fetchProponents para otimizar as buscas
    this.debouncedFetchProponents = debounce(this.fetchProponents, 300);
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
        const params = {
          page: this.currentPage,
          per_page: this.perPage,
          name: this.searchName,
          cpf: this.searchCpf,
          discount_group: this.selectedDiscountGroup, // Inclui o filtro discount_group
        };
        const response = await getProponents(params);
        // Supondo que a resposta contenha 'proponents' e 'total_pages'
        this.proponents = response.proponents;
        this.totalPages = response.total_pages || 1;
      } catch (error) {
        console.error("Erro ao buscar proponentes:", error);
      }
    },
    async deleteRecord(id) {
      if (confirm("Tem certeza que deseja deletar este funcionário?")) {
        try {
          await deleteProponent(id);
          this.fetchProponents(); // Atualiza a lista após deletar
        } catch (error) {
          console.error("Erro ao deletar proponente:", error);
        }
      }
    },
    changePage(page) {
      if (page < 1 || page > this.totalPages) return;
      this.currentPage = page;
      this.fetchProponents();
    },
    formatSalary(value) {
      return new Intl.NumberFormat("pt-BR", {
        style: "currency",
        currency: "BRL",
      }).format(value);
    },
  },
};
</script>
