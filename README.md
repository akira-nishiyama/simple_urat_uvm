# simple_urat_uvm
 Simple uart verification ip. Main target is vivado simulator.

# Dependency
Vivado 2019.2  
CMake 3.1 or later  
Ninja(Make also works)  
vivado_cmake_helper  

# Setup
- get source
```bash
git clone https://github.com/akira-nishiyama/simple_uart_uvm
```

# Usage
Create instance of the simple_uart_agent in you test and environment.
simple_uart_uvm_env and simple_uart_uvm_test are not provided.

Connect simple_uart_if in uvm_config_db.
The below options are also available.

+ Configs
  + vif(simple_uart_if)  
    simple_uart_if for driver.  
  + simple_uart_baud_rate(int)  
    baud rate. Currently, only 115200 bps is valid.(default:115200 bps)  
  + simple_uart_parity_enable(bit)  
    set 1 if uart protocol has parity bit.(default:enable)  
  + simple_uart_parity_odd(bit)  
    this config is valid when simple_uart_parity_enable set to 1.  
    1 for add odd_parity, 0 for add even_parity(default).  
  + simple_uart_stop_bit_num(int)  
    number of stop bit. 1 and 2 is valid.  
  + simple_uart_sampling_interval(int)  
    rx data sampling interval.  

For example, to change simple_uart sampling_interval, write below in initial statement.

```
uvm_config_db#(int)::set(uvm_root::get(), "\*", "simple_uart_sampling_interval", 10);
```

To issue transaction sequence, use below sequence item.

+ simple_uart_seq_item
  + char(logic[7:0])  
    transfer character


To use this ip in your FPGA project with Cmake,
You should call find_package(simple_uard_uvm) and below variable is defined.
Below option is valid, change to define in uvm_config_db.

+ simple_uart_uvm_INCLUDE_DIRS      - include directories for simple_uart_uvm package  
+ simple_uart_uvm_SRC_FILES         - source files for implementation.(source file list is empty because simple_uart_uvm is used only simulation)  
+ simple_uart_uvm_TESTBENCH_FILES   - testbench files for simulation.(simple_uart_uvm_pkg.sv and simple_uart_if.sv are compile required.)  
+ simple_uart_uvm_DEFINITIONS_VLOG  - additional compile option for xvlog. include options are defined.  

# Example Setup
- Install Vivado.

- Install CMake and NInja
```bash
apt install cmake ninja-build
```

- Clone vivado_cmake_helper. The path can be anywhere.
```bash
git clone https://github.com/akira-nishiyama/vivado_cmake_helper ~
```

# Example build
```bash
source <vivado_installation_path>/settings64.sh
source ~/vivado_cmake_helper/setup.sh
mkdir build
cd build
cmake .. -GNinja
ninja open_wdb_tb_simple_uart_uvm
```

# License
This software is released under the MIT License, see LICENSE.
