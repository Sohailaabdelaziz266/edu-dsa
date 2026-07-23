cmake_minimum_required(VERSION 3.16)
project(edu-dsa C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(cmake/edu_submissions.cmake)

# Assignment selects shared tests in tests/<assignment>/.
# Each student directory under <assignment>/<student>/{inc,src} becomes its own library.
# The same test sources are linked once per student binary.
#
# Build every student for SWB-04:
#   cmake -S . -B build/SWB-04 -DEDU_ASSIGNMENT=SWB-04
#
# Build a subset only:
#   cmake ... -DEDU_STUDENTS="example-student;dev-reference"
set(EDU_ASSIGNMENT "SWB-04" CACHE STRING "Assignment id used to select tests (e.g. SWB-04)")
set(EDU_EXTRA_SUBMISSIONS "dev/reference"
    CACHE STRING "Extra submission paths (semicolon-separated, e.g. dev/reference)")
set(EDU_STUDENTS "" CACHE STRING "Optional submission ids to build (semicolon-separated)")

add_compile_options(-Wall -Wextra -Wpedantic -Werror)

edu_discover_submissions("${EDU_ASSIGNMENT}" EDU_ASSIGNMENT_SUBMISSIONS)

set(EDU_ALL_SUBMISSIONS ${EDU_ASSIGNMENT_SUBMISSIONS})
if(EDU_EXTRA_SUBMISSIONS)
    list(APPEND EDU_ALL_SUBMISSIONS ${EDU_EXTRA_SUBMISSIONS})
endif()
list(REMOVE_DUPLICATES EDU_ALL_SUBMISSIONS)

if(NOT EDU_ALL_SUBMISSIONS)
    message(FATAL_ERROR "No submissions found for assignment ${EDU_ASSIGNMENT}")
endif()

foreach(submission_path IN LISTS EDU_ALL_SUBMISSIONS)
    edu_add_submission("${submission_path}" "${EDU_ASSIGNMENT}")
endforeach()

get_property(EDU_SUBMISSION_IDS GLOBAL PROPERTY EDU_SUBMISSION_IDS)
if(NOT EDU_SUBMISSION_IDS)
    message(FATAL_ERROR "No submission libraries were registered")
endif()

enable_testing()
add_subdirectory(tests)
