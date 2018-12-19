<template>
 <div id="products">
  <div v-for="(product, index) in products" :key="product.id">
   <p>{{index}} - {{product.name}} at {{product.price}}</p>
  </div>
  {{logged}}
 </div>
</template>

<script>
export default {
  data() {
    return {
      products: [],
      name: [],
      errors: [],
      logged: false,
    };
  },
  created() {
    if (window.sessionStorage.getItem('jwt')) this.logged = true;
    this.$http.secured.get('/products').then((response) => {
      this.products = response.data;
    }).catch(e => this.error.push(e));
  },
};
</script>
