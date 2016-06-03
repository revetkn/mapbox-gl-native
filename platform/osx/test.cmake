target_sources(mbgl-test
    PRIVATE test/src/main.cpp
)

set_source_files_properties(test/src/main.cpp PROPERTIES COMPILE_FLAGS -DWORK_DIRECTORY="${CMAKE_SOURCE_DIR}")

target_link_libraries(mbgl-test
    PRIVATE "-framework Cocoa"
    PRIVATE "-framework OpenGL"
    PRIVATE "-lz"
    PRIVATE "-lsqlite3"
)
