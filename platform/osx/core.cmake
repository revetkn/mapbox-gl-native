target_sources(mbgl-core
    PRIVATE platform/default/asset_file_source.cpp
    PRIVATE platform/default/default_file_source.cpp
    PRIVATE platform/default/online_file_source.cpp
    PRIVATE platform/default/mbgl/storage/offline.cpp
    PRIVATE platform/default/mbgl/storage/offline_database.hpp
    PRIVATE platform/default/mbgl/storage/offline_database.cpp
    PRIVATE platform/default/mbgl/storage/offline_download.hpp
    PRIVATE platform/default/mbgl/storage/offline_download.cpp
    PRIVATE platform/default/sqlite3.hpp
    PRIVATE platform/default/sqlite3.cpp
    PRIVATE platform/darwin/src/async_task.cpp
    PRIVATE platform/darwin/src/run_loop.cpp
    PRIVATE platform/darwin/src/timer.cpp
    PRIVATE platform/darwin/src/http_file_source.mm
    PRIVATE platform/darwin/src/log_nslog.mm
    PRIVATE platform/darwin/src/string_nsstring.mm
    PRIVATE platform/darwin/src/image.mm
    PRIVATE platform/darwin/src/nsthread.mm
    PRIVATE platform/darwin/src/reachability.m
    PRIVATE platform/default/headless_display.cpp
    PRIVATE platform/default/headless_view.cpp
    PRIVATE platform/darwin/src/headless_view_cgl.cpp
)

target_compile_options(mbgl-core
    PRIVATE -fobjc-arc
)

target_include_directories(mbgl-core
    PRIVATE platform/default
)
