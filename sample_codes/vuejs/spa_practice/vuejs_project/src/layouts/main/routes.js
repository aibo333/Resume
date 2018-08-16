import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router';
Vue.use(VueRouter)

import index from './index.vue'

import cats_layout from '@cats/main/layout.vue'
import cats_router from '@cats/main/routes.js'
const router = [
    {
        path: '', component: index, name: 'main',
    },
    {
        path: 'cats', component: cats_layout,
        children: cats_router
    },
]

export default router;
