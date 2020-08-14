// simple_uart_uvm_pkg.sv
//      This file implements the simple_uart_uvm_pkg for simulation with uvm.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

package simple_uart_uvm_pkg;

    `include "uvm_macros.svh"
    import uvm_pkg::*;
    `include "simple_uart_seq_item.svh"
    `include "simple_uart_slave_sequencer.svh"
    `include "simple_uart_slave_driver.svh"
    `include "simple_uart_slave_monitor.svh"
    `include "simple_uart_slave_agent.svh"
    `include "simple_uart_slave_base_sequence.svh"
endpackage

