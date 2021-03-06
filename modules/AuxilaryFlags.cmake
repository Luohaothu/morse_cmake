###
#
# @copyright (c) 2009-2014 The University of Tennessee and The University
#                          of Tennessee Research Foundation.
#                          All rights reserved.
# @copyright (c) 2012-2019 Inria. All rights reserved.
# @copyright (c) 2012-2014 Bordeaux INP, CNRS (LaBRI UMR 5800), Inria, Univ. Bordeaux. All rights reserved.
#
###
#
#  @file AuxilaryFlags.cmake
#
#  @project MORSE
#  MORSE is a software package provided by:
#     Inria Bordeaux - Sud-Ouest,
#     Univ. of Tennessee,
#     King Abdullah Univesity of Science and Technology
#     Univ. of California Berkeley,
#     Univ. of Colorado Denver.
#
#  @version 0.9.0
#  @author Xavier Lacoste
#  @author Florent Pruvost
#  @date 30-01-2015
#
# Update CMAKE auxilary variables:
#  - CMAKE_C_FLAGS: C compiler flags
#  - CMAKE_CXX_FLAGS: CXX compiler flags
#  - CMAKE_Fortran_FLAGS: Fortran compiler flags
#  - CMAKE_Fortran_PREPROCESS_FLAGS : force C preprocessor.
#  - CMAKE_Fortran_FREEFORM_FLAG : Force free format.
###

if (MORSE_ENABLE_WARNING)

  if(CMAKE_C_COMPILER_ID MATCHES GNU)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -fdiagnostics-show-option")
  elseif(CMAKE_C_COMPILER_ID MATCHES Intel)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -w3 -diag-disable:remark")
  endif()

  if(CMAKE_CXX_COMPILER_ID MATCHES GNU)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -fdiagnostics-show-option")
  elseif(CMAKE_CXX_COMPILER_ID MATCHES Intel)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -w3 -diag-disable:remark")
  endif()

  if(CMAKE_Fortran_COMPILER_ID MATCHES GNU)
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Wall -fdiagnostics-show-option")
  elseif(CMAKE_Fortran_COMPILER_ID MATCHES Intel)
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -warn all -diag-disable:remark")
  endif()

endif(MORSE_ENABLE_WARNING)

if (MORSE_ENABLE_STATIC_ANALYSIS)

  find_program(CLANGTIDY "clang-tidy")
  if (CLANGTIDY)
    set(CMAKE_C_CLANG_TIDY "${CLANGTIDY}")
  endif()
  find_program(CPPCHECK "cppcheck")
  if (CPPCHECK)
    set(CMAKE_C_CPPCHECK "${CPPCHECK}"
      "--language=c"
      "--enable=all"
      "--force"
      )
  endif()
  find_program(INCLUDE_WHAT_YOU_USE "iwyu")
  if (INCLUDE_WHAT_YOU_USE)
    set(CMAKE_C_INCLUDE_WHAT_YOU_USE "${INCLUDE_WHAT_YOU_USE}")
  endif()
  set(CMAKE_LINK_WHAT_YOU_USE TRUE)

endif()

if (MORSE_ENABLE_COVERAGE)
  get_property( languages GLOBAL PROPERTY ENABLED_LANGUAGES )
  set( _enable_coverage FALSE )

  if ( "C" IN_LIST languages )
    if(CMAKE_C_COMPILER_ID MATCHES GNU)
      set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC -fno-inline --coverage")
      set( _enable_coverage TRUE )
    else()
      message(FATAL_ERROR "Code coverage is only available with the GNU C (gcc)"
        "\n   compiler, please turn MORSE_ENABLE_COVERAGE OFF\n.")
    endif()
  endif()

  if ( "CXX" IN_LIST languages )
    if(CMAKE_CXX_COMPILER_ID MATCHES GNU)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -fno-inline --coverage")
      set( _enable_coverage TRUE )
    else()
      message(FATAL_ERROR "Code coverage is only available with the GNU CXX"
        "\n   (g++) compiler, please turn MORSE_ENABLE_COVERAGE OFF\n.")
    endif()
  endif()

  if ( "Fortran" IN_LIST languages )
    if(CMAKE_Fortran_COMPILER_ID MATCHES GNU)
      set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fPIC -fno-inline --coverage")
      set( _enable_coverage TRUE )
    else()
      message(FATAL_ERROR "Code coverage is only available with the GNU"
        "\n   Fortran (gfortran) compiler, please turn MORSE_ENABLE_COVERAGE"
        "\n   OFF\n.")
    endif()
  endif()

  if ( _enable_coverage )
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --coverage")
  endif()

endif(MORSE_ENABLE_COVERAGE)


if(CMAKE_Fortran_COMPILER_ID MATCHES GNU)
  list(APPEND CMAKE_Fortran_PREPROCESS_FLAGS "-cpp")
  list(APPEND CMAKE_Fortran_FREEFORM_FLAG "-ffree-form")
elseif(CMAKE_Fortran_COMPILER_ID MATCHES Intel)
  list(APPEND CMAKE_Fortran_PREPROCESS_FLAG "-fpp")
  list(APPEND CMAKE_Fortran_FREEFORM_FLAG "")
endif()
