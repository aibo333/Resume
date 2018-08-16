import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'

import main from '@layouts/main/store.js'
Vue.use(Vuex)

const store = new Vuex.Store({
    state: {
    },
    getters: {
    },
    actions: {
    },
    mutations: {
    },
    modules: {
        main,
    }
})

export default store
