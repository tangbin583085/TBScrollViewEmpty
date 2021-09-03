foreach(example IN ITEMS list table custom)
    add_executable(tbempty_${example} ${example}_main.cpp)
    target_link_libraries(tbempty_${example} PRIVATE TBScrollViewEmpty::Widgets)
endforeach()
