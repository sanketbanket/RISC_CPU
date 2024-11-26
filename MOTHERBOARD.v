`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2024 20:19:54
// Design Name: 
// Module Name: MOTHERBOARD
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MOTHERBOARD(
    input clk,
    input rst,
    input en,
    output [15 : 0]reg_external,
    input [2 : 0] reg_sel
    );
    
    wire  write, memory_enable;
    wire [15 : 0] into_memory, from_memory, memory_address;
    
    RISC_CPU da_processor(.en(en), .rst(rst), .clk(clk),
    .memorydata(from_memory),
    .memaddress(memory_address),
    .memwritedata(into_memory),
    .memoryenable(memory_enable),
    .writeenable(write),
    .external_reg_sel(reg_sel),
    .external_reg_data(reg_external)
    );

    MAIN_MEM memory_8K(.en(memory_enable),
    .rw(write),
    .clk(clk),
    .addr(memory_address),
    .din(into_memory),
    .memout(from_memory),
    .rst(rst)
    );
    
endmodule
