// simple_uart_if.sv
//      This file implements the axi interface for simple_axi.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

interface simple_uart_if;
    logic posi;//primary out secondary in
    logic piso;//primary in  secondary out
endinterface
