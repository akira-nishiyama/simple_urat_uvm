// simple_uart_slave_monitor.svh
//      This file implements the monitor for simple_uart_slave.
//      Reset behavior is not supported.
//
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class simple_uart_slave_monitor extends uvm_monitor;
    `uvm_component_utils(simple_uart_slave_monitor)
    virtual simple_uart_if vif;
    uvm_analysis_port #(simple_uart_seq_item) item_port;
    function new(string name="simple_uart_slave_monitor", uvm_component parent);
        super.new(name, parent);
        item_port = new("item_port",this);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual simple_uart_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for:", get_full_name(), ".vif"});
    endfunction: build_phase
    task run_phase(uvm_phase phase);
        //T.B.D
    endtask

endclass

