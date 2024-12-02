<template>
  <form @submit.prevent="handleSubmit">
    <!-- Nome -->
    <div class="form-group">
      <label for="name">Nome*</label>
      <input
        type="text"
        class="form-control"
        id="name"
        v-model.trim="name"
        required
      />
    </div>

    <!-- Data de Nascimento -->
    <div class="form-group">
      <label for="birth_date">Data de Nascimento*</label>
      <input
        type="date"
        format="DD/MM/YYYY"
        class="form-control"
        id="birth_date"
        v-model.trim="birth_date"
        required
      />
    </div>

    <!-- Salário -->
    <div class="form-group">
      <label for="salary">Salário*</label>
      <input
        type="number"
        step="0.01"
        class="form-control"
        id="salary"
        v-model.number="salary"
        required
      />
      <button @click.prevent="calculateCurrentDiscount">
        Previsão Desconto INSS
      </button>
      <span>{{ inssDiscount }}</span>
    </div>

    <!-- CPF -->
    <div class="form-group">
      <label for="cpf">CPF*</label>
      <input
        type="text"
        class="form-control"
        id="cpf"
        v-model.trim="cpf"
        placeholder="XXX-XXX-XXX-XX"
        required
      />
    </div>

    <!-- Endereço -->
    <div class="form-group">
      <label for="address_street">Rua</label>
      <input
        type="text"
        class="form-control"
        id="address_street"
        v-model.trim="address_street"
      />
    </div>
    <div class="form-group">
      <label for="address_number">Número</label>
      <input
        type="number"
        class="form-control"
        id="address_number"
        v-model.number="address_number"
      />
    </div>
    <div class="form-group">
      <label for="address_neighborhood">Bairro</label>
      <input
        type="text"
        class="form-control"
        id="address_neighborhood"
        v-model.trim="address_neighborhood"
      />
    </div>
    <div class="form-group">
      <label for="address_city">Cidade</label>
      <input
        type="text"
        class="form-control"
        id="address_city"
        v-model.trim="address_city"
      />
    </div>
    <div class="form-group">
      <label for="address_state">Estado</label>
      <input
        type="text"
        class="form-control"
        id="address_state"
        v-model.trim="address_state"
      />
    </div>
    <div class="form-group">
      <label for="address_zipcode">CEP</label>
      <input
        type="text"
        class="form-control"
        id="address_zipcode"
        v-model.trim="address_zipcode"
      />
    </div>

    <!-- Telefones de Referência -->
    <div class="form-group">
      <label>Telefones de Referência</label>
      <div
        v-for="(ref, index) in phones.refence"
        :key="'ref-' + index"
        class="form-row align-items-center"
      >
        <div class="col">
          <input
            type="text"
            class="form-control"
            placeholder="Descrição"
            v-model.trim="ref.description"
            required
          />
        </div>
        <div class="col">
          <input
            type="tel"
            class="form-control"
            placeholder="Telefone"
            v-model.trim="ref.phone"
            required
          />
        </div>
        <div class="col-auto">
          <button
            type="button"
            class="btn btn-danger"
            @click="removeReferencePhone(index)"
          >
            Remover
          </button>
        </div>
      </div>
      <button
        type="button"
        class="btn btn-secondary mt-2"
        @click="addReferencePhone"
      >
        Adicionar Telefone de Referência
      </button>
    </div>

    <!-- Telefones Pessoais -->
    <div class="form-group">
      <label>Telefones Pessoais</label>
      <div
        v-for="(personal, index) in phones.personal"
        :key="'personal-' + index"
        class="form-row align-items-center"
      >
        <div class="col">
          <input
            type="text"
            class="form-control"
            placeholder="Descrição"
            v-model.trim="personal.description"
            required
          />
        </div>
        <div class="col">
          <input
            type="tel"
            class="form-control"
            placeholder="Telefone"
            v-model.trim="personal.phone"
            required
          />
        </div>
        <div class="col-auto">
          <button
            type="button"
            class="btn btn-danger"
            @click="removePersonalPhone(index)"
          >
            Remover
          </button>
        </div>
      </div>
      <button
        type="button"
        class="btn btn-secondary mt-2"
        @click="addPersonalPhone"
      >
        Adicionar Telefone Pessoal
      </button>
    </div>

    <!-- Botão de Envio -->
    <button type="submit" class="btn btn-primary" :disabled="isLoading">
      Enviar
    </button>
  </form>
</template>

<script>
import { createProponent } from "@/api/proponents";
import { calculateDiscount } from "@/api/inss_calculations";

export default {
  name: "ProponentForm",
  data() {
    return {
      isLoading: false,
      name: "",
      birth_date: "",
      salary: null,
      inssDiscount: null,
      cpf: "",
      address_city: "",
      address_neighborhood: "",
      address_number: null,
      address_state: "",
      address_street: "",
      address_zipcode: "",
      phones: {
        refence: [],
        personal: [],
      },
    };
  },
  methods: {
    async handleSubmit() {
      const body = {
        name: this.name,
        birth_date: new Date(this.birth_date).toISOString(),
        salary: this.salary,
        cpf: this.cpf,
        address_city: this.address_city,
        address_neighborhood: this.address_neighborhood,
        address_number: this.address_number,
        address_state: this.address_state,
        address_street: this.address_street,
        address_zipcode: this.address_zipcode,
        phones: this.phones,
      };

      try {
        this.isLoading = true;
        await createProponent(body);
        this.resetForm();
        this.isLoading = false;
      } catch (error) {
        this.isLoading = false;
        console.error("Erro ao criar proponentes:", error);
      }
    },
    addReferencePhone() {
      this.phones.refence.push({ description: "", phone: "" });
    },
    removeReferencePhone(index) {
      this.phones.refence.splice(index, 1);
    },
    addPersonalPhone() {
      this.phones.personal.push({ description: "", phone: "" });
    },
    removePersonalPhone(index) {
      this.phones.personal.splice(index, 1);
    },
    async calculateCurrentDiscount() {
      try {
        if (!this.salary) return;
        const { inss_discount } = await calculateDiscount(this.salary);
        this.inssDiscount = inss_discount;
      } catch (error) {
        console.log(error);
      }
    },
    resetForm() {
      this.name = "";
      this.birth_date = "";
      this.salary = null;
      this.inssDiscount = null;
      this.cpf = "";
      this.address_city = "";
      this.address_neighborhood = "";
      this.address_number = null;
      this.address_state = "";
      this.address_street = "";
      this.address_zipcode = "";
      this.phones = {
        refence: [],
        personal: [],
      };
    },
  },
};
</script>

<style scoped>
/* Estilos customizados (opcional) */
</style>
