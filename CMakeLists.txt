cmake_minimum_required(VERSION 3.16)
project(TBScrollViewEmpty VERSION 1.0.0 LANGUAGES CXX)

option(TBEMPTY_BUILD_TESTS "Build Qt Test cases" OFF)
option(TBEMPTY_BUILD_EXAMPLES "Build Widgets examples" OFF)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Widgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Widgets)
if(QT_VERSION_MAJOR EQUAL 5 AND Qt5Core_VERSION VERSION_LESS 5.15)
    message(FATAL_ERROR "TBScrollViewEmpty requires Qt 5.15 or Qt 6")
endif()

add_library(TBScrollViewEmptyCore STATIC
    include/TBScrollViewEmpty/EmptyStateController.hpp
    src/EmptyStateController.cpp)
add_library(TBScrollViewEmpty::Core ALIAS TBScrollViewEmptyCore)
set_target_properties(TBScrollViewEmptyCore PROPERTIES EXPORT_NAME Core)

add_library(TBScrollViewEmptyWidgets STATIC
    include/TBScrollViewEmpty/EmptyStateHost.hpp
    include/TBScrollViewEmpty/EmptyStateView.hpp
    src/EmptyStateHost.cpp
    src/EmptyStateView.cpp)
add_library(TBScrollViewEmpty::Widgets ALIAS TBScrollViewEmptyWidgets)
set_target_properties(TBScrollViewEmptyWidgets PROPERTIES EXPORT_NAME Widgets)

include(GNUInstallDirs)
foreach(target IN ITEMS TBScrollViewEmptyCore TBScrollViewEmptyWidgets)
    target_compile_features(${target} PUBLIC cxx_std_17)
    target_include_directories(${target} PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>")
    set_target_properties(${target} PROPERTIES AUTOMOC ON CXX_EXTENSIONS OFF
        POSITION_INDEPENDENT_CODE ON)
endforeach()
target_link_libraries(TBScrollViewEmptyCore PUBLIC Qt${QT_VERSION_MAJOR}::Core)
target_link_libraries(TBScrollViewEmptyWidgets PUBLIC TBScrollViewEmpty::Core Qt${QT_VERSION_MAJOR}::Widgets)

if(TBEMPTY_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()
