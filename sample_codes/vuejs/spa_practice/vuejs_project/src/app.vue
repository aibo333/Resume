<template>
    <div id="app">
        <router-link class="item"
            :to="{name: 'main'}">
            Home
        </router-link>
        |
        <router-link class="item"
            :to="{name: 'cats'}">
            Cats
        </router-link>
        <router-view class="app-container"></router-view>
    </div>
</template>

<script>
export default {
    data: function () {
        return {
        }
    },
    computed: {

    },
    mounted: function() {
    },
    watch: {

    },
    methods: {

    },
    components: {
    },
}
</script>

<style lang="scss">
</style>
