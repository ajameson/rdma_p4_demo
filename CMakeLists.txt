cmake_minimum_required(VERSION 3.5)

project(Rdma-P4-Demo LANGUAGES C)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/")
find_package(ibverbs REQUIRED)

add_executable(rdma_p4_demo rdma_p4_demo.c pingpong.c)

if(IBVERBS_FOUND)
  target_link_libraries(rdma_p4_demo PUBLIC ibverbs)
endif()

