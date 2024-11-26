`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2024 19:06:00
// Design Name: 
// Module Name: RISC_CPU
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


module RISC_CPU(
      input rst,
      input clk,
      input en,
      input [15 : 0] memorydata,
      output [15 : 0] memaddress,
      output [15 : 0] memwritedata,
      output  memoryenable, writeenable,
      input [2 : 0]external_reg_sel,
      output [15 : 0] external_reg_data
    );
    
    
    wire [15 : 0]memdata;
    
    wire [15 : 0]register_data, aludata, pcdata, d0data, d1data ;
    wire Nflag, Zflag;
    wire PCreset;
    wire [2 : 0] d0, d1, reg_select, aluopcode;
    wire [15 : 0] regin, memoin, pcin, memaddr;
    wire pcinc, pcen, pcwrite, pcrst;
    wire regen, regwrite, memen, memwrite, aluflag, aluen;
    assign memoryenable = memen;
    assign writeenable = memwrite;
    assign memaddress = memaddr;
    assign memwritedata = memoin;
    assign memdata = memorydata;
    
    CONTROLLER CONTROL_UNIT(.clk(clk), .en(en),
    .memin(memdata),
    .regin(register_data),
    .n(Nflag),
    .z(Zflag),
    .aludata(aludata),
    .pc(pcdata),
    .rst(rst),
    .aluop(aluopcode),
    .d1sel(d1),
    .d0sel(d0),
    .regsel(reg_select),
    .regout(regin),
    .memout(memoin),
    .pcout(pcin),
    .memsel(memaddr),
    .pcinc(pcinc),
    .pcen(pcen),
    .pcwrite(pcwrite),
    .pcrst(pcrst),
    .regen(regen),
    .regwrite(regwrite),
    .memen(memen),
    .memwrite(memwrite),
    .aluflag(aluflag),
    .aluen(aluen)

    );
    REG_BANK REGISTER_BANK(.clk(clk),
    .data(regin),
    .setd1(d1),
    .setd0(d0),
    .en(regen),
    .rst(rst),
    .d0(d0data),
    .d1(d1data),
    .out(register_data),
    .sel(reg_select),
    .rw(regwrite),
    .customreg(external_reg_data),
    .customsel(external_reg_sel)
    );
    PC PROGRAM_COUNTER(.clk(clk) ,
    .addr(pcin),
    .inc(pcinc),
    .write(pcwrite),
    .rst(rst | pcrst),
    .en(pcen),
    .pcout(pcdata)
    );
    ALU ALU_UNIT(
    .a(d0data), .b(d1data),
    .setflag(aluflag),
    .en(aluen),
    .op(aluopcode),
    .r(aludata),
    .z(Zflag),
    .n(Nflag)
    );
    
    
endmodule
