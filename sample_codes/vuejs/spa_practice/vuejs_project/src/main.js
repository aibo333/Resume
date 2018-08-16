// import all need packages
import 'babel-polyfill'
import { sync } from 'vuex-router-sync'
import Vue from 'vue/dist/vue.esm'
import store from '@/store.js';
import router from '@/routes.js';
import App from '@/app.vue'

// require all need packages

// Vue.js config
Vue.config.productionTip = true
Vue.config.debug = true;
Vue.config.devtools = true;
sync(store, router)

// DOMContentLoaded
document.addEventListener('DOMContentLoaded', function() {

    document.getElementById('app-body').appendChild(document.createElement('app'))

    const app = new Vue({
        el: 'app',
        store: store,
        router: router,
        template: '<App/>',
        components: {
            App
        }
    })
})
