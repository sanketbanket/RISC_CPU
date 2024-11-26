`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.11.2024 15:24:16
// Design Name: 
// Module Name: SPECIAL_REGISTERS
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


module PC(
input [15:0] addr,
input inc, 
input write,
input clk,
input rst,
input en,
output reg [15:0] pcout
);
always @(posedge clk or posedge rst) begin

if(rst)pcout <= 0;

else if(en) begin
if(write) pcout <= addr;
else if(inc) pcout <= pcout +2;
end

end
endmodule

module DR(
input clk,
input [15 : 0] data, 
output reg [15:0] out,
input en,
input rst 

);
always @(posedge clk or posedge rst) begin
if(rst) out <= 0;

else if(en)out <= data;
end
endmodule

module AR(
input clk,
input [15:0] addr,
output reg [15:0] out,
input en,
input rst
);
always @(posedge rst) out  <= 0;
always @(posedge clk) begin
if(en) out <= addr;
end
endmodule



module register #(parameter DATA_WIDTH = 16)(input clk,
input rst,
input en,
input write,
input [DATA_WIDTH - 1 : 0] data,
output  reg [DATA_WIDTH - 1: 0]  out);


always @(posedge clk or posedge rst) begin
if(rst) out <= 0;
else if(en & write) out <= data;
end
endmodule

module REG_BANK(input [2 : 0] sel, customsel,
input [15 : 0] data,
input [2 : 0]setd1 ,
input [2 : 0]setd0,
input clk,
input rw,
input en,
input rst,
output [15 : 0] d0, //d's will go the ALU
output [15 : 0] d1,
output  [15 : 0] out,
output [15 : 0 ]customreg
);


wire [7 : 0] select; //enabl
decoder #(3) dec(.in(sel), .out(select));

wire [15:0] words [ 0: 7];
register r0(.clk(clk), .rst(rst), .data(data),.write(rw), .en(select[0] & en), .out(words[0]));
register r1(.clk(clk), .rst(rst), .data(data),.write(rw), .en(select[1] & en), .out(words[1]));
register r2(.clk(clk), .rst(rst), .data(data),.write(rw), .en(select[2] & en), .out(words[2]));
register r3(.clk(clk), .rst(rst), .data(data),.write(rw), .en(select[3] & en), .out(words[3]));
register r4(.clk(clk), .rst(rst), .data(data),.write(rw), .en(select[4] & en), .out(words[4]));
register r5(.clk(clk), .rst(rst), .data(data),.write(rw), .en(select[5] & en), .out(words[5]));
register r6(.clk(clk), .rst(rst), .data(data),.write(rw), .en(select[6] & en), .out(words[6]));
register r7(.clk(clk), .rst(rst), .data(data),.write(rw), .en(select[7] & en), .out(words[7]));

mux4x1 #(.DATAWIDTH(16), .INPUTS(8), .SELECT(3)) muk(
.in({words[0], words[1], words[2], words[3], words[4], words[5], words[6], words[7]}),
.out(out),
.sel(sel& {en,en,en})
);

mux4x1 #(.DATAWIDTH(16), .INPUTS(8), .SELECT(3)) muxd0(
.in({words[0], words[1], words[2], words[3], words[4], words[5], words[6], words[7]}),
.out(d0),
.sel(setd0 & {en,en,en})
);
mux4x1 #(.DATAWIDTH(16), .INPUTS(8), .SELECT(3)) muxd1(
.in({words[0], words[1], words[2], words[3], words[4], words[5], words[6], words[7]}),
.out(d1),
.sel(setd1 & {en,en,en})
);

mux4x1 #(.DATAWIDTH(16), .INPUTS(8), .SELECT(3)) external(
.in({words[0], words[1], words[2], words[3], words[4], words[5], words[6], words[7]}),
.out(customreg),
.sel(customsel)
);
endmodule




