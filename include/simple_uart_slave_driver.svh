// simple_uart_slave_driver.svh
//      This file implements the simple_uart_slave_driver.
//
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//
class simple_uart_slave_driver extends uvm_driver #(simple_uart_seq_item);
    `uvm_component_utils(simple_uart_slave_driver)
    virtual simple_uart_if vif;
    function new (string name ="simple_uart_slave_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual simple_uart_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        simple_uart_seq_item trans_item;
        forever begin
            seq_item_port.get_next_item(trans_item);
            seq_item_port.item_done();
        end
    endtask

//    function void check_phase(uvm_phase phase);
//        if( awchannel.size() != 0 || wchannel.size() != 0 || bchannel.size() != 0 || archannel.size() != 0 || rchannel.size() != 0 ||
//            awchannel_busy   != 0 || wchannel_busy   != 0 || bchannel_busy   != 0 || archannel_busy   != 0 || rchannel_busy   != 0) begin
//            `uvm_warning("AXI-M-DRV-CHK",$sformatf("aw_size=%4d,w_size=%4d,b_size=%4d,ar_size=%4d,r_size=%4d",
//                                                        awchannel.size(), wchannel.size(), bchannel.size(), archannel.size(), rchannel.size()));
//            `uvm_warning("AXI-M-DRV-CHK",$sformatf("aw_busy=%1d,w_busy=%1d,b_busy=%1d,ar_busy=%1d,r_busy=%1d",
//                                                        awchannel_busy, wchannel_busy, bchannel_busy, archannel_busy, rchannel_busy));
//            `uvm_error("REMAINED DATA",{get_full_name(), "channel data is remained."});
//        end
//    endfunction


endclass

