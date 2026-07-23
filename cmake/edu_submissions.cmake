function(edu_submission_id submission_path assignment out_var)
    string(LENGTH "${assignment}/" prefix_len)
    string(SUBSTRING "${submission_path}" 0 ${prefix_len} path_prefix)

    if(path_prefix STREQUAL "${assignment}/")
        string(SUBSTRING "${submission_path}" ${prefix_len} -1 id)
    else()
        string(REPLACE "/" "-" id "${submission_path}")
    endif()

    set(${out_var} "${id}" PARENT_SCOPE)
endfunction()

function(edu_discover_submissions assignment out_var)
    set(found "")
    set(assignment_dir "${CMAKE_SOURCE_DIR}/${assignment}")

    if(NOT IS_DIRECTORY "${assignment_dir}")
        message(FATAL_ERROR "Assignment directory not found: ${assignment}")
    endif()

    file(GLOB entries RELATIVE "${assignment_dir}" "${assignment_dir}/*")
    foreach(entry IN LISTS entries)
        set(path "${assignment}/${entry}")
        if(IS_DIRECTORY "${CMAKE_SOURCE_DIR}/${path}/inc"
           AND IS_DIRECTORY "${CMAKE_SOURCE_DIR}/${path}/src")
            list(APPEND found "${path}")
        endif()
    endforeach()

    list(SORT found)
    set(${out_var} ${found} PARENT_SCOPE)
endfunction()

function(edu_add_submission submission_path assignment)
    set(submission_dir "${CMAKE_SOURCE_DIR}/${submission_path}")

    if(NOT IS_DIRECTORY "${submission_dir}/inc" OR NOT IS_DIRECTORY "${submission_dir}/src")
        message(FATAL_ERROR
            "Submission must contain inc/ and src/ directories: ${submission_path}")
    endif()

    edu_submission_id("${submission_path}" "${assignment}" submission_id)

    if(EDU_STUDENTS)
        list(FIND EDU_STUDENTS "${submission_id}" student_index)
        if(student_index EQUAL -1)
            return()
        endif()
    endif()

    file(GLOB submission_sources "${submission_dir}/src/*.c")
    if(NOT submission_sources)
        message(FATAL_ERROR "No .c files found in ${submission_path}/src")
    endif()

    set(target_name "submission_${submission_id}")
    add_library(${target_name} STATIC ${submission_sources})
    target_include_directories(${target_name} PUBLIC "${submission_dir}/inc")

    set_property(GLOBAL APPEND PROPERTY EDU_SUBMISSION_IDS "${submission_id}")
    message(STATUS "Registered submission: ${submission_path} -> ${target_name}")
endfunction()
