`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2024 16:25:35
// Design Name: 
// Module Name: basics
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

module decoder4x16(
input [3:0] in,
output reg [15:0] out
);
always @(*) begin
case (in)
4'b0000 : out = 16'b0000000000000001;
4'b0001 : out = 16'b0000000000000010;
4'b0010 : out = 16'b0000000000000100;
4'b0011 : out = 16'b0000000000001000;
4'b0100 : out = 16'b0000000000010000;
4'b0101 : out = 16'b0000000000100000;
4'b0110 : out = 16'b0000000001000000;
4'b0111 : out = 16'b0000000010000000;
4'b1000 : out = 16'b0000000100000000;
4'b1001 : out = 16'b0000001000000000;
4'b1010 : out = 16'b0000010000000000;
4'b1011 : out = 16'b0000100000000000;
4'b1100 : out = 16'b0001000000000000;
4'b1101 : out = 16'b0010000000000000;
4'b1110 : out = 16'b0100000000000000;
4'b1111 : out = 16'b1000000000000000;

endcase
end
endmodule

module decoder3x8(
input [2:0] in,
output reg [7:0] out
);
always @(*) begin
case (in)
3'b000 : out = 8'b00000001;
3'b001 : out = 8'b00000010;
3'b010 : out = 8'b00000100;
3'b011 : out = 8'b00001000;
3'b100 : out = 8'b00010000;
3'b101 : out = 8'b00100000;
3'b110 : out = 8'b01000000;
3'b111 : out = 8'b10000000;
endcase
end
endmodule


module mux4x1 #(parameter DATAWIDTH = 16, INPUTS = 4, SELECT = 2)(
input [0:INPUTS-1][DATAWIDTH - 1 : 0]  in ,
output reg [DATAWIDTH - 1 : 0]  out,
input [SELECT - 1 : 0] sel
);
always @(*) begin
out = in[sel];
end
endmodule

module demux1x4 #(parameter DATAWIDTH = 16, OUTPUTS = 4, SELECT = 2)(
input [DATAWIDTH - 1 : 0] in,
output reg [0:OUTPUTS - 1][DATAWIDTH - 1 : 0]  out,
input [SELECT - 1 : 0] sel
);
integer i;
always @(*) begin
for(i = 0; i < OUTPUTS; i = i + 1) begin
if(i == sel) out[i] <= in;
else out[i] <= 0;
end

end
endmodule


module decoder #(parameter IN = 2)(
input [IN-1 : 0] in,
output reg [(1<<IN) - 1: 0]  out
);
always @(*) begin
out = 0;
out[in] = 1'b1;
end
endmodule


module encoder #(parameter IN = 2)(input [(1 << IN) - 1 : 0] in,
output reg[IN - 1 : 0] out);

integer i;
always @(*) begin
for(i = 0; i < (1 << IN) ;  i =i + 1)
begin
if(in[i]) out = i;
end
end
endmodule


module demux1x8(
input [15 : 0] data,
output [15 : 0] o0, o1, o2, o3, o4, o5, o6, o7
);
endmodule



module mux4x1_tb;

    // Parameters
    parameter DATAWIDTH = 1;
    parameter INPUTS = 4;
    parameter SELECT = 2;

    // Testbench signals
    reg [3 : 0] in; // 4 1-bit inputs
    reg [SELECT-1:0] sel;              // 2-bit select signal
    wire [DATAWIDTH-1:0] out;          // Output of the mux

    // Instantiate the mux4x1 module
    mux4x1 #(DATAWIDTH, INPUTS, SELECT) uut (
        .in({in[0], in[1], in[2], in[3]}),
        .out(out),
        .sel(sel));
endmodule
