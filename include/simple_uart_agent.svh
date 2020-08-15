// simple_uart_agent.svh
//      This file implements the simple_uart_agent.
//      simple_uart_slave is consists of driver, sequencer and monitor.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//
class simple_uart_agent extends uvm_agent;
    `uvm_component_utils(simple_uart_agent)
    `uvm_new_func
    simple_uart_driver       driver;
    simple_uart_sequencer    sequencer;
    simple_uart_monitor      monitor;
    function void build_phase(uvm_phase phase);
        driver = simple_uart_driver::type_id::create("driver",this);
        sequencer = simple_uart_sequencer::type_id::create("sequencer",this);
        monitor = simple_uart_monitor::type_id::create("monitor",this);
    endfunction
    function void connect_phase(uvm_phase phase);
        if(get_is_active() == UVM_ACTIVE) begin
            uvm_report_info("AGENT", "connect driver to sequencer");
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction
    task run_phase(uvm_phase phase);
    endtask
endclass

