cmake_minimum_required(VERSION 3.12)
project(HBM_TERM)

set(CMAKE_CXX_STANDARD 11)

# Add the main executable
add_executable(HBM_TERM main.cpp serial_port.hpp serial_port.cpp)