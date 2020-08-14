// simple_uart_slave_sequencer.svh
//      This file implements the sequencer for simple_uart_slave.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class simple_uart_slave_sequencer extends uvm_sequencer #(simple_uart_seq_item);
    `uvm_component_utils(simple_uart_slave_sequencer)
    `uvm_new_func
    task run_phase(uvm_phase phase);
    endtask
endclass

