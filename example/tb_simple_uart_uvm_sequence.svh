// tb_simple_uart_uvm_sequence
//      This file implements the sequence for simple_uart_uvm_pkg.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class issue_one_trans_seq extends simple_uart_base_sequence;
    `uvm_object_utils(issue_one_trans_seq)
    function new(string name="issue_one_trans_seq");
        super.new(name);
    endfunction
  virtual task body();
    simple_uart_seq_item trans_item;
    `uvm_create(trans_item)
    for(int i = 0; i < 64; ++i) begin
        `uvm_do(trans_item)
    end
    //`uvm_send(trans_item)
    #1000;
  endtask
endclass

