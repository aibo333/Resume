import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router';
Vue.use(VueRouter)

import page_404 from '@partials/page_404.vue'
import main from '@layouts/main/layout.vue'
import main_router from '@layouts/main/routes.js'

const router = new VueRouter({
    mode: 'history',
    routes: [
        {
            path: '/main', component: main,
            children: main_router
        },
        {
            path: '*', component: page_404, name: 'page_404',
        }
    ]
})

export default router;
