<template>
    <div id="cats_layout">
        {{ cats }}
        <transition name="slide-fade" mode="out-in" appear>
            <router-view>
            </router-view>
        </transition>
    </div>
</template>

<script>
export default {
    name: "CatsLayout",
    data: function() {
        return {
            cats: "Cats Layout"
        }
    },
    computed: {
    },
    created: function() {
        console.log("Cats Layout created");
    },
    mounted: function() {
        console.log("Cats Layout mounted");
        var that = this;
        that.init();
    },
    watch: {
    },
    methods: {
        init: async function() {
            var that = this;

            await new Promise(resolve => {
                console.log("initing...");
                resolve();
            });
            await that.fetch_cats();
            await new Promise(resolve => {
                console.log("init done");
                resolve();
            });
        },
        fetch_cats: function() {
            var that = this;
            console.log("cats fetched");
            return Promise.resolve();
        },
    },
    components: {
    }
}
</script>
