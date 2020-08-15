# - Config file for the simple_uart_uvm package
# It defines the following variables
#  simple_uart_uvm_INCLUDE_DIRS      - include directories for simple_uart_uvm package
#  simple_uart_uvm_SRC_FILES         - source files for implementation.
#  simple_uart_uvm_TESTBENCH_FILES   - testbench files for simulation.
#  simple_uart_uvm_DEFINITIONS_VLOG  - additional compile option for vlog.
#  simple_uart_uvm_DEPENDENCIES      - simple_uart_uvm components list. use for target depends.

# Compute paths
set(simple_uart_uvm_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}/include")
set(simple_uart_uvm_SRC_FILES "") #empty. this package is for simulation only.
file(GLOB simple_uart_uvm_TESTBENCH_FILES ${CMAKE_CURRENT_LIST_DIR}/src/*.sv)
set(simple_uart_uvm_DEFINITIONS_VLOG "-i ${simple_uart_uvm_INCLUDE_DIRS}")
file(GLOB simple_uart_uvm_DEPENDENCIES   ${CMAKE_CURRENT_LIST_DIR}/include/*.svh
                                        ${CMAKE_CURRENT_LIST_DIR}/src/*.sv)
