// simple_uart_seq_item.svh
//      This file implements the sequence_item for simple_uart.
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class simple_uart_seq_item extends uvm_sequence_item;
    rand logic[7:0] char;

    `uvm_object_utils_begin(simple_uart_seq_item)
        `uvm_field_int (char, UVM_DEFAULT | UVM_HEX)
    `uvm_object_utils_end
    function new (string name = "simple_uart_seq_item_inst");
        super.new(name);
    endfunction : new
endclass

