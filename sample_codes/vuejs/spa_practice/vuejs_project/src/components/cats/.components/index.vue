<template>
    <div id="index">
        {{ cats_index }}
        <router-link class="item"
            :to="{name: 'new_cat'}">
            NewCat
        </router-link>
    </div>
</template>

<script>
export default {
    name: "CatsIndex",
    data: function () {
        return {
            cats_index: "Cats Index",
        }
    },
    created: function() {
        console.log("Cats Index created");
    },
    mounted: function() {
        console.log("Cats Index mounted");
    },
    computed: {
    },
    watch: {
    },
    methods: {
    },
    components: {
    }
}
</script>

<style scoped>
</style>
