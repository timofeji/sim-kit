cmake_minimum_required(VERSION 3.2)

set(PROJECT_NAME sim-kit)
set(CMAKE_CXX_STANDARD 11)


project(${PROJECT_NAME})
set(EXTERNAL_DIR ./lib)
set(ASSETS_DIR ../resources)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "lib")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "bin")

# https://stackoverflow.com/questions/12264299/cmake-on-linux-target-platform-does-not-support-dynamic-linking
set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS TRUE)

set(OpenGL_GL_PREFERENCE "GLVND") # We dont want the legacy openGl
find_package(OpenGL REQUIRED)




# --------------------------------------------------------SRC-----------------------------------------------------------
file(GLOB_RECURSE SOURCES ./src/*cc)

add_executable(${PROJECT_NAME}
    ${SOURCES}
    )

set_target_properties(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE CXX)
set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 11)
set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD_REQUIRED ON)

# --------------------------------------------------------GLAD----------------------------------------------------------

add_library(glad ${EXTERNAL_DIR}/glad/include/glad/glad.h ${EXTERNAL_DIR}/glad/src/glad.c)
target_include_directories(glad PUBLIC ${EXTERNAL_DIR}/glad/include/)


# --------------------------------------------------------SDL-----------------------------------------------------------
if( ${CMAKE_SYSTEM_NAME} MATCHES "Emscripten")
    message(STATUS "Using emscripten")
    # set(USE_FLAGS "-s USE_SDL=2 -s USE_WEBGL2=1")
    # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${USE_FLAGS}")
    # set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${USE_FLAGS}")
    # set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${USE_FLAGS}")
    # set(CMAKE_EXECUTABLE_SUFFIX .html)
    set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".html")
    set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "-s USE_SDL=2 -s USE_WEBGL2=1 -s BINARYEN_METHOD='native-wasm' --preload-file ${ASSETS_DIR} --shell-file ../resources/index.html")
    target_compile_definitions(${PROJECT_NAME} PRIVATE __EMSCRIPTEN=1)
    target_link_libraries(${PROJECT_NAME} glad)
else()
    message(STATUS "Using desktop")
    set( SDL_STATIC ON CACHE BOOL "" FORCE )
    set( SDL_SHARED OFF CACHE BOOL "" FORCE )
    add_subdirectory(${EXTERNAL_DIR}/sdl ./bin/sdl)
    target_link_libraries(${PROJECT_NAME} glad SDL2main SDL2-static)
endif ()

# set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".html")
# set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "-Werror -s WASM=1 -s USE_SDL=2 -s USE_WEBGL2=1 -s BINARYEN_METHOD='native-wasm' --preload-file ${ASSETS_DIR} --shell-file ../helpers/index.html")
