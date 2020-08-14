// tb_simple_uart_uvm
//      This file implements the testbench for simple_uart_uvm_pkg.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

module tb_simple_uart_uvm;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    //import simpla_uart_uvm_pkg::*;
    import tb_simple_uart_uvm_test_pkg::*;
    
    logic clk, rstz;
    simple_uart_if sif();// interface
    initial begin
        fork
            begin
                clk = 1'b1;
                #100;
                forever #10 clk = ~clk;
            end
            begin
                rstz = 1'b0;
                #100;
                rstz = 1'b1;
            end
        join
    end
    initial begin
        set_global_timeout(10000000ns);
        uvm_config_db#(virtual simple_uart_if)::set(uvm_root::get(), "*", "vif", sif);
        run_test("simple_uart_uvm_test_example");
    end

endmodule
