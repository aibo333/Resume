# Vuejs
index.html => Vue instance => Global vuex(store) + vue-router(routes) => Scoped vuex(store) + vue-router(routes) => SPA

在dom佈置上可以透過<router-view></router-view>動態引入內容(by route)

# 部署
由單個index.html引入整個app需要的資源，再藉由nginx try_files指向該檔案，實現前後端分離的SPA應用

refs: https://segmentfault.com/a/1190000013218418
