<template>
  <Row type="flex" justify="center">
    <i-col span="6">
      <h1>
        Create an account
      </h1>
      <i-form ref="user" :model="user" :label-width="80" :rules="ruleRegister">
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
        <FormItem prop="passwordConfirmation" label="Password Confirmation">
          <i-input type="password" v-model="user.passwordConfirmation" placeholder="Password">
            <Icon type="ios-lock-outline" slot="prepend"></Icon>
          </i-input>
        </FormItem>
        <FormItem>
          <i-button type="primary" @click="register">Sign up</i-button>
          <Divider>or</Divider>
          <router-link to="/login">Sign in</router-link>
        </FormItem>
      </i-form>
    </i-col>
  </Row>
</template>

<script>
export default {
  name: 'Register',
  data() {
    const validatePass = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please enter your password'));
      } else if (this.user.password.length < 6) {
        callback(new Error('Password too short'));
      } else {
        this.$refs.user.validateField('passwordConfirmation');
        callback();
      }
    };
    const validatePassCheck = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please enter your password again'));
      } else if (value !== this.user.password) {
        callback(new Error('The two input passwords do not match!'));
      } else {
        callback();
      }
    };
    const validateEmail = (rule, value, callback) => {
      if (!value) {
        callback(new Error('Email cannot be empty'));
      } else {
        callback();
      }
    };
    return {
      user: {
        email: '',
        password: '',
        passwordConfirmation: '',
      },
      ruleRegister: {
        email: [
          { validator: validateEmail, trigger: 'blur' },
        ],
        password: [
          { validator: validatePass, trigger: 'blur' },
        ],
        passwordConfirmation: [
          { validator: validatePassCheck, trigger: 'blur' },
        ],
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
    register() {
      this.$http.plain.post('/register', {
        user: this.user,
      }).then(response => this.registerSuccessful(response))
        .catch(error => this.registerFailed(error));
    },
    registerSuccessful(response) {
      const jwt = response.headers.authorization.split('Bearer ')[1];
      if (!jwt) {
        this.signinFailed(response);
        return;
      }
      window.sessionStorage.setItem('jwt', jwt);
      this.error = '';
      this.$router.replace('/products');
    },
    registerFailed(error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong';
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
