add_executable(mbgl-test
    test/include/mbgl/test.hpp
)

target_sources(mbgl-test
    PRIVATE test/util/assert.cpp
    PRIVATE test/util/async_task.cpp
    PRIVATE test/util/geo.cpp
    PRIVATE test/util/image.cpp
    PRIVATE test/util/mapbox.cpp
    PRIVATE test/util/merge_lines.cpp
    PRIVATE test/util/run_loop.cpp
    PRIVATE test/util/number_conversions.cpp
    PRIVATE test/util/text_conversions.cpp
    PRIVATE test/util/thread.cpp
    PRIVATE test/util/thread_local.cpp
    PRIVATE test/util/tile_cover.cpp
    PRIVATE test/util/timer.cpp
    PRIVATE test/util/token.cpp
    PRIVATE test/util/work_queue.cpp

    PRIVATE test/algorithm/covered_by_children.cpp
    PRIVATE test/algorithm/generate_clip_ids.cpp
    PRIVATE test/algorithm/mock.hpp
    PRIVATE test/algorithm/update_renderables.cpp

    PRIVATE test/api/annotations.cpp
    PRIVATE test/api/api_misuse.cpp
    PRIVATE test/api/repeated_render.cpp
    PRIVATE test/api/render_missing.cpp
    PRIVATE test/api/set_style.cpp
    PRIVATE test/api/custom_layer.cpp

    PRIVATE test/geometry/binpack.cpp

    PRIVATE test/gl/object.cpp

    PRIVATE test/map/map.cpp
    PRIVATE test/map/transform.cpp

    PRIVATE test/math/minmax.cpp
    PRIVATE test/math/clamp.cpp

    PRIVATE test/tile/geometry_tile.cpp
    PRIVATE test/tile/tile_id.cpp

    PRIVATE test/storage/offline.cpp
    PRIVATE test/storage/offline_database.cpp
    PRIVATE test/storage/offline_download.cpp
    PRIVATE test/storage/asset_file_source.cpp
    PRIVATE test/storage/default_file_source.cpp
    PRIVATE test/storage/http_file_source.cpp
    PRIVATE test/storage/online_file_source.cpp
    PRIVATE test/storage/headers.cpp
    PRIVATE test/storage/resource.cpp

    PRIVATE test/style/glyph_store.cpp
    PRIVATE test/style/source.cpp
    PRIVATE test/style/style.cpp
    PRIVATE test/style/style_layer.cpp
    PRIVATE test/style/filter.cpp
    PRIVATE test/style/functions.cpp
    PRIVATE test/style/style_parser.cpp

    PRIVATE test/sprite/sprite_atlas.cpp
    PRIVATE test/sprite/sprite_image.cpp
    PRIVATE test/sprite/sprite_parser.cpp
    PRIVATE test/sprite/sprite_store.cpp

    PRIVATE test/src/mbgl/test/stub_file_source.hpp
    PRIVATE test/src/mbgl/test/stub_file_source.cpp
    PRIVATE test/src/mbgl/test/util.hpp
    PRIVATE test/src/mbgl/test/util.cpp
    PRIVATE test/src/mbgl/test/fixture_log_observer.hpp
    PRIVATE test/src/mbgl/test/fixture_log_observer.cpp
    PRIVATE test/src/mbgl/test/test.cpp
)

cache_executable_path(node _node)

target_compile_options(mbgl-test
    PRIVATE -Wno-variadic-macros
    PRIVATE -Wno-unknown-pragmas
    PRIVATE -fvisibility-inlines-hidden
)

set_source_files_properties(test/src/mbgl/test/util.cpp PROPERTIES COMPILE_FLAGS -DNODE_EXECUTABLE="${_node}")

target_include_directories(mbgl-test
    PRIVATE include
    PRIVATE src # TODO: eliminate
    PRIVATE test/include
    PRIVATE test/src
    PRIVATE platform/default
)

target_link_libraries(mbgl-test
    PRIVATE mbgl-core
)

target_add_mason_package(mbgl-test PRIVATE geometry)
target_add_mason_package(mbgl-test PRIVATE variant)
target_add_mason_package(mbgl-test PRIVATE unique_resource)
target_add_mason_package(mbgl-test PRIVATE rapidjson)
target_add_mason_package(mbgl-test PRIVATE gtest)
target_add_mason_package(mbgl-test PRIVATE pixelmatch)
target_add_mason_package(mbgl-test PRIVATE boost)
target_add_mason_package(mbgl-test PRIVATE geojsonvt)

if(EXISTS ${CMAKE_SOURCE_DIR}/platform/${MBGL_PLATFORM}/test.cmake)
    include(platform/${MBGL_PLATFORM}/test.cmake)
endif()
