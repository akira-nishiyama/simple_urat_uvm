// simple_uart_monitor.svh
//      This file implements the monitor for simple_uart_slave.
//      Reset behavior is not supported.
//
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
// Configs:
//      vif(simple_uart_if) : simple_uart_if for driver.
//      simple_uart_baud_rate(int)          : baud rate. Currently, only 115200 bps is valid.(default:115200 bps)
//      simple_uart_parity_enable(bit)      : set 1 if uart protocol has parity bit.(default:enable)
//      simple_uart_parity_odd(bit)         : this config is valid when simple_uart_parity_enable set to 1.
//                                            1 for add odd_parity, 0 for add even_parity(default).
//      simple_uart_stop_bit_num(int)       : number of stop bit. 1 and 2 is valid.
//      simple_uart_sampling_interval(int)  : rx data sampling interval.
class simple_uart_monitor extends uvm_monitor;
    `uvm_component_utils(simple_uart_monitor)
    virtual simple_uart_if vif;
    uvm_analysis_port #(simple_uart_seq_item) item_port;
    int baud_rate;//config. Currently, only 115200bps is allowed.
    int bit_period;
    bit parity_enable;//config
    bit parity_odd;//config, used if parity_enable=1.0:even_parity, 1:odd_parity
    int stop_bit_num;//number of stop bit. 1,2 is valid.
    int sampling_interval;//sampling interval.
    real bit_judge_ratio = 0.8;//ratio
    function new(string name="simple_uart_monitor", uvm_component parent);
        super.new(name, parent);
        item_port = new("item_port",this);
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
        //sampling interval
        if(!uvm_config_db#(int)::get(this, "", "simple_uart_sampling_interval", sampling_interval)) begin
            uvm_report_info("CONFIG","sampling interval set to default value(10 ns)");
            sampling_interval = 10;//default value
        end

    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual simple_uart_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for:", get_full_name(), ".vif"});
    endfunction: build_phase
    task run_phase(uvm_phase phase);
        check_data();
    endtask


    task check_data();
        bit ret;
        logic parity;
        logic val;
        logic[7:0] ch;
        simple_uart_seq_item mon_item;
        mon_item = new();
        forever begin
            //search start bit loop.
            forever begin
                search_start_bit(ret,val);
                if(ret === 0) break;
            end
            //data receive loop
            parity = 0;//init
            for(int i = 0; i < 8; ++i) begin
                bit_judge(val);
                ch[7-i] = val;
                parity = parity ^ val;
            end
            mon_item.char = ch;
            uvm_report_info("UART-S-MON-DCHK",$sformatf("received data:%02x",ch));
            item_port.write(mon_item);
            //parity check
            if(parity_enable === 1) begin
                if(parity_odd === 1) begin
                    parity = ~parity;
                end else begin
                    parity = parity;
                end
                check_parity(parity);
            end
            //check stop bit.
            fork
                check_stop_bit();
            join_none
        end
    endtask

    task search_start_bit(output bit ret, output logic val);
        logic b;
        wait(vif.posi === 1);//search starts with high
        wait(vif.posi === 0);//detect edge.
        bit_judge(b);
        if(b === 1'b1 || b === 1'bX) begin
            ret = 1;//start bit search fail
        end else begin
            ret = 0;//start bit search succeed.
        end
        val = b;
    endtask

    task check_parity(input logic pality);
        logic b;
        bit_judge(b);
        if(b != pality) `uvm_error("UART-S-MON-PCHK","wrong pality detected.")
    endtask

    task automatic check_stop_bit();
        logic b;
        for(int i = 0; i < stop_bit_num; ++i) begin
            bit_judge(b);
            if(b === 1'b0 || b === 1'bX) begin
                `uvm_error("UART-S-MON-STPB","stop bit error detected.")
            end
        end
    endtask

    task bit_judge(output logic val);
        int cnt_H = 0;
        int cnt_L = 0;
        int cnt_X = 0;
        int cnt   = 0;
        val = 1'bX;
        forever begin
            //finish condition
            if(cnt > bit_period) begin
                if(cnt_H > bit_period * bit_judge_ratio) begin
                    val = 1'b1;
                end else if(cnt_L > bit_period * bit_judge_ratio) begin
                    val = 1'b0;
                end else begin
                    val = 1'bX;
                end
                break;
            end
            //count
            if(vif.posi === 0) begin
                cnt_L += sampling_interval;
            end else if(vif.posi === 1) begin
                cnt_H += sampling_interval;
            end else begin
                cnt_X += sampling_interval;
            end
            cnt += sampling_interval;
            #sampling_interval;
        end
    endtask

endclass
