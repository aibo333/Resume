// 這是Webpack掛載起始點
import Layout from './layout.vue'
import Index from '../.components/index.vue'
import New from '../.components/new.vue'

const router = [
    {
        path: '',
        component: Index,
        name: 'cats',
    },
    {
        path: 'new',
        component: New,
        name: 'new_cat',
    },
]

export default router;
