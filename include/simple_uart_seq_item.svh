// simple_uart_seq_item.svh
//      This file implements the sequence_item for simple_uart.
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class simple_uart_seq_item extends uvm_sequence_item;
//    rand logic[31:0]        addr;
//    rand logic[31:0]        data[$];
//    rand logic[7:0]         length;
//    simple_axi_access_type  access_type;
//    simple_axi_resp_code    resp_code;

    `uvm_object_utils_begin(simple_uart_seq_item)
//        `uvm_field_int (addr, UVM_DEFAULT | UVM_HEX)
//        `uvm_field_queue_int (data, UVM_DEFAULT | UVM_HEX)
//        `uvm_field_int (length, UVM_DEFAULT | UVM_DEC)
//        `uvm_field_enum (simple_axi_access_type, access_type, UVM_DEFAULT)
//        `uvm_field_enum (simple_axi_resp_code, resp_code, UVM_DEFAULT)
    `uvm_object_utils_end
    function new (string name = "simple_uart_seq_item_inst");
        super.new(name);
    endfunction : new
endclass

