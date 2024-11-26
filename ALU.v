`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.11.2024 14:39:55
// Design Name: 
// Module Name: ALU
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


module ALU(
input [15:0] a, b,
input setflag,
input en,
input [2:0]op,
output reg [15:0]  r,
output reg z, n
);
always @(*) begin
//ADD = 000, SUB = 01, AND = 100, OR = 010, NOT = 001
if(en) begin

case (op)
3'b000 : r <= a + b;
3'b111 : r <= a - b;
3'b100 : r <= a & b;
3'b010 : r <= a | b;
3'b001 : r <= ~a;
default : r <= 0;
endcase
end
if(setflag )begin  //set the flag

if(a == b)begin
z <= 1;
n <= 0;
end

if(a < b)begin
z <= 0;
n <= 1;
end

if(a > b) begin
z <= 0;
n <= 0;
end

end
end
endmodule




