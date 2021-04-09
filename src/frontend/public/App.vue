<template>
  <v-app>
    <link
      href="https://cdn.jsdelivr.net/npm/@mdi/font@4.x/css/materialdesignicons.min.css"
      rel="stylesheet"
    />
    <v-container>
    <p>{{ greetings }}</p>
    </v-container>
  </v-app>
</template>

<script>
import auth from "ic:canisters/auth";

export default {
  data: () => {
    return {
      greetings: "",
    }
  },

  created() {
    auth.greet().then((greetings) => {
      this.greetings = greetings
    });
  },
  methods: {},
};
</script>
