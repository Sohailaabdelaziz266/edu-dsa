include(FetchContent)

set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)
set(BUILD_GMOCK OFF CACHE BOOL "" FORCE)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/refs/tags/v1.15.2.zip
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
FetchContent_MakeAvailable(googletest)

file(GLOB ASSIGNMENT_TESTS "${CMAKE_CURRENT_SOURCE_DIR}/${EDU_ASSIGNMENT}/test_*.cpp")
if(NOT ASSIGNMENT_TESTS)
    message(FATAL_ERROR "No Google Test files found for assignment ${EDU_ASSIGNMENT}")
endif()

foreach(test_source ${ASSIGNMENT_TESTS})
    get_filename_component(test_name ${test_source} NAME_WE)

    add_executable(${test_name} ${test_source})
    target_link_libraries(${test_name} PRIVATE student_submission GTest::gtest_main)

    add_test(NAME ${test_name} COMMAND ${test_name})
endforeach()
