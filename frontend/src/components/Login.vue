<template>
  <Row type="flex" justify="center">
    <i-col span="6">
      <h1>
        Sign In
      </h1>
      <i-form ref="user" :model="user" :label-width="80">
        <div class="alert alert-danger" v-if="error">{{ error }}</div>
        <FormItem prop="email" label="Email">
          <i-input type="text" v-model="user.email" placeholder="email@example.com">
            <Icon type="ios-person-outline" slot="prepend"></Icon>
          </i-input>
        </FormItem>
        <FormItem prop="password" label="Password">
          <i-input type="password" v-model="user.password" placeholder="Password">
            <Icon type="ios-lock-outline" slot="prepend"></Icon>
          </i-input>
        </FormItem>
        <FormItem>
          <i-button type="primary" @click="login">Sign in</i-button>
          <Divider>or</Divider>
          <router-link to="/register">Sign up</router-link>
        </FormItem>
      </i-form>
    </i-col>
  </Row>
</template>

<script>
export default {
  name: 'Login',
  data() {
    return {
      user: {
        email: '',
        password: '',
      },
      error: '',
    };
  },
  created() {
    this.checkSignedIn();
  },
  updated() {
    this.checkSignedIn();
  },
  methods: {
    login() {
      this.$http.plain.post('/login', { user: this.user })
        .then(response => this.signinSuccessful(response))
        .catch(error => this.signinFailed(error));
    },
    signinSuccessful(response) {
      const jwt = response.headers.authorization.split('Bearer ')[1];
      if (!jwt) {
        this.signinFailed(response);
        return;
      }
      window.sessionStorage.setItem('jwt', jwt);
      this.error = '';
      this.$router.replace('/products');
    },
    signinFailed(error) {
      this.error = (error.response && error.response.data && error.response.data.error) || '';
      window.sessionStorage.removeItem('jwt');
    },
    checkSignedIn() {
      if (localStorage.signedIn) {
        this.$router.replace('/products');
      }
    },
  },
};

</script>
