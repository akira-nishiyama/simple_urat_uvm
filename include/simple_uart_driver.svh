// simple_uart_driver.svh
//      This file implements the simple_uart_driver.
//
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
// Configs:
//      vif(simple_uart_if) : simple_uart_if for driver.
//      simple_uart_baud_rate(int)     : baud rate. Currently, only 115200 bps is valid.(default:115200 bps)
//      simple_uart_parity_enable(bit) : set 1 if uart protocol has parity bit.(default:enable)
//      simple_uart_parity_odd(bit)    : this config is valid when simple_uart_parity_enable set to 1.
//                                       1 for add odd_parity, 0 for add even_parity(default).
//      simple_uart_stop_bit_num(int)  : number of stop bit. 1 and 2 is valid.
class simple_uart_driver extends uvm_driver #(simple_uart_seq_item);
    `uvm_component_utils(simple_uart_driver)
    virtual simple_uart_if vif;
    uvm_analysis_port #(simple_uart_seq_item) item_port;
    int baud_rate;//config. Currently, only 115200bps is allowed.
    int bit_period;
    bit parity_enable;//config
    bit parity_odd;//config, used if parity_enable=1.0:even_parity, 1:odd_parity
    int stop_bit_num;//number of stop bit. 1,2 is valid.
    function new (string name ="simple_uart_driver", uvm_component parent);
        super.new(name, parent);
        item_port = new("item_port",this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual simple_uart_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
        //baud rate config
        if(!uvm_config_db#(int)::get(this, "", "simple_uart_baud_rate", baud_rate)) begin
            uvm_report_info("CONFIG","baud rate set to default value(115200 bps)");
            baud_rate = 115200;//default value
        end
        case(baud_rate)
            115200: bit_period = 8681;//8680.6 ns for 115200 bps.
            default: `uvm_fatal("CONFIG_ERR","Undefined baud rate.")
        endcase
        //parity enable flag
        if(!uvm_config_db#(bit)::get(this, "", "simple_uart_parity_enable", parity_enable)) begin
            uvm_report_info("CONFIG","parity_enable set to default value(enabled)");
            parity_enable = 1;//default value
        end
        //odd parity flag
        if(!uvm_config_db#(bit)::get(this, "", "simple_uart_parity_odd", parity_odd)) begin
            uvm_report_info("CONFIG","parity set to default value(even)");
            parity_odd = 0;//default value
        end
        //number of stop bit
        if(!uvm_config_db#(int)::get(this, "", "simple_uart_stop_bit_num", stop_bit_num)) begin
            uvm_report_info("CONFIG","number of stop bit set to default value(1bit)");
            stop_bit_num = 1;//default value
        end
        if(stop_bit_num == 0 || stop_bit_num > 2) begin
            `uvm_fatal("CONFIG_ERR", "Invalid number of stop bit.")
        end
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        simple_uart_seq_item trans_item;
        bit parity;
        bit uart_sig;
        vif.piso <= 1;
        #(bit_period);
        forever begin
            seq_item_port.get_next_item(trans_item);
            uvm_report_info("DRV",$sformatf("transfer:%02x",trans_item.char));
            item_port.write(trans_item);
            parity = 0;//init
            //start bit
            vif.piso = 0;
            #(bit_period);
            //character
            for(int i = 0; i < 8; ++i) begin
                uart_sig = ((trans_item.char >> (7 - i)) & 1'b1 );
                vif.piso <= uart_sig;
                parity = parity ^ uart_sig;
                #(bit_period);
            end
            //parity bit
            if(parity_enable === 1) begin
                if(parity_odd === 1) begin
                    vif.piso <= ~parity;
                end else begin
                    vif.piso <= parity;
                end
                #(bit_period);
            end
            //stop bit
            vif.piso <= 1;
            repeat(stop_bit_num) #(bit_period);
            seq_item_port.item_done();
        end
    endtask
endclass

