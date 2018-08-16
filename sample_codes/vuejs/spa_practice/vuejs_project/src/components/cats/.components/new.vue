<template>
    <div id="new">
        {{ cats_new }}
    </div>
</template>

<script>
export default {
    name: "NewCat",
    prop: {
    },
    data: function () {
        return {
            cats_new: "Cats New"
        }
    },
    created: function() {
        console.log("Cats New created");
    },
    mounted: function() {
        console.log("Cats New mounted");
    },
    watch: {
    },
    computed: {
    },
    methods: {
    },
    components: {
    }
}
</script>

<style scoped>
</style>
