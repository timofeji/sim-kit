cmake_minimum_required(VERSION 3.2)

set(PROJECT_NAME sim-kit)
set(CMAKE_CXX_STANDARD 17)


project(${PROJECT_NAME})
set(EXTERNAL_DIR ./lib)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "lib")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "bin")





file(GLOB_RECURSE SOURCES ./src/*cc)

add_executable(${PROJECT_NAME}
    ${SOURCES}
    )


set_target_properties(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE CXX)



# if (NOT ${__EMSCRIPTEN__})
    set( SDL_STATIC ON CACHE BOOL "" FORCE )
    set( SDL_SHARED OFF CACHE BOOL "" FORCE )
    add_subdirectory(${EXTERNAL_DIR}/sdl ./bin/sdl)
#     include_directories(${EXTERNAL_DIR}/glfw)
# endif ()


target_link_libraries(${PROJECT_NAME} SDL2main SDL2-static)
