cmake_minimum_required(VERSION 3.16)
project(edu-dsa C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Assignment selects which tests to run (tests/<assignment>/).
# Submission is either EDU_SUBMISSION or <assignment>/<student>.
#
# Student submission:
#   cmake -DEDU_ASSIGNMENT=SWB-04 -DEDU_STUDENT=john-doe ..
#
# Instructor reference:
#   cmake -DEDU_ASSIGNMENT=SWB-04 -DEDU_SUBMISSION=dev/reference ..
set(EDU_ASSIGNMENT "SWB-04" CACHE STRING "Assignment id used to select tests (e.g. SWB-04)")
set(EDU_STUDENT "example-student" CACHE STRING "Student directory under the assignment")
set(EDU_SUBMISSION "" CACHE STRING "Optional submission path relative to repo root (e.g. dev/reference)")

if(EDU_SUBMISSION)
    set(SUBMISSION_DIR "${CMAKE_SOURCE_DIR}/${EDU_SUBMISSION}")
else()
    set(SUBMISSION_DIR "${CMAKE_SOURCE_DIR}/${EDU_ASSIGNMENT}/${EDU_STUDENT}")
endif()

if(NOT IS_DIRECTORY "${SUBMISSION_DIR}")
    message(FATAL_ERROR "Submission directory not found: ${SUBMISSION_DIR}")
endif()

if(NOT IS_DIRECTORY "${SUBMISSION_DIR}/inc" OR NOT IS_DIRECTORY "${SUBMISSION_DIR}/src")
    message(FATAL_ERROR
        "Submission must contain inc/ and src/ directories: ${SUBMISSION_DIR}")
endif()

add_compile_options(-Wall -Wextra -Wpedantic -Werror)

file(GLOB STUDENT_SOURCES "${SUBMISSION_DIR}/src/*.c")
if(NOT STUDENT_SOURCES)
    message(FATAL_ERROR "No .c files found in ${SUBMISSION_DIR}/src")
endif()

add_library(student_submission STATIC ${STUDENT_SOURCES})
target_include_directories(student_submission PUBLIC "${SUBMISSION_DIR}/inc")

enable_testing()
add_subdirectory(tests)
