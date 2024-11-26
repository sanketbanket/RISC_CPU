`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2024 19:04:31
// Design Name: 
// Module Name: CONTROLLER
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

module CONDITIONS(input n, z, output eq, ne, lt, le, gt, ge);
assign eq = z;
assign ne = ~z;
assign lt = n;
assign le = n | z;
assign gt = ~n;
assign ge = ~n | z;

endmodule



module CONTROLLER(
      //input [15 : 0] op,
      input [15 : 0] memin,
      input [15 : 0] regin,
      input n, z,
      input [15 : 0] aludata,
      input [15 : 0] pc,
      input rst,
      input en,
      input clk,
      output [2: 0]aluop, d1sel, d0sel, regsel,
      output [15 : 0] regout, memout, pcout, memsel,
      output pcinc,pcen, pcwrite,pcrst, //signal PC to increment
      output regen, regwrite, memen, memwrite, aluflag, aluen
    );
    wire negclk;
    
    not(negclk, clk);
    
    wire [7 : 0]CARin;
    wire [7 : 0]CARout;
    wire [15 : 0]ARin;
    wire [15 : 0]ARout;
    wire [15 : 0]DRin;
    wire [15 : 0]DRout;
    wire [15 : 0]IRout;
    wire [15 : 0]CROMout;
    //wire [7 : 0] nextADDR;//stores the next access address for the CROM
    //wire [2 : 0] ra_select, d0_select, d1_select;//from instruction register
    //wire [2 : 0] ALUout;
    
    
    
    
    //all of the signals that will every be done
    wire write;  //write enable for every register in this place
    wire DRen, IRen, ARen, REGen, MEMen, PCen, PCwrite,PCinc, D1sel, D0sel, REGwrite, DRa, DRb, MEMwrite;   //kinda redundant but dc
    //now select signals;
    wire [1:0] DRselect;
    wire PCselect, ARselect, MEMselect;
    wire flagenable;
    wire [31 : 0]signal ;
    //assigning every single signal
    assign MEMwrite = signal[12];
    assign IRen = signal[0];
    assign DRen = signal[7] | signal[9] | signal[13] | signal[20] | signal[23];
    assign ARen = signal[10] | signal[11];
    assign REGen = signal[8] | signal[9] | signal[2] | signal[3] | signal[4] | signal[5] | signal[6] | signal[24] | signal[23];
    assign MEMen = signal[12] | signal [13] | signal[0];
    assign PCen = signal[1] | signal[21] | signal[22] | signal[14];
    assign PCwrite = signal[21] | signal[22];
    assign PCinc = signal[1];
    assign D1sel = signal[2] | signal[3] | signal[4] | signal[5] | signal[6] | signal[24];
    assign D0sel = signal[2] | signal[3] | signal[4] | signal[5] | signal[6] | signal[24];
    assign aluen = signal[2] | signal[3] | signal[4] | signal[5] | signal[6] | signal[24];
    assign write = signal[0] | signal[7] | signal[9] | signal[10] | signal[11] | signal[13] | signal[20] | signal[23];
    assign REGwrite = signal[8];
    assign PCselect = signal[21];
    assign ARselect = signal[10];
    assign DRa = signal[9] | signal[8];
    assign DRb = signal[23];
    assign MEMselect = signal[0];
    assign pcrst = signal[17];
    assign regsel = ({DRa, DRa, DRa} & IRout[8 : 6]) | ({DRb, DRb, DRb} & IRout[5 : 3]);
    assign flagenable = signal[14];
    encoder DRchooser(.in({signal[7], signal[9] | signal[23], signal[13], signal[20]}), .out(DRselect)); //4 to 2 encoder
    
    wire flagcheck;
    assign pcinc = (flagcheck & flagenable) | PCinc;
    wire ne, eq, lt, gt, le,ge;
    CONDITIONS CD(.n(n), .z(z), .ne(ne), .eq(eq), .lt(lt), .gt(gt), .le(le), .ge(ge));
    
    mux4x1 #(.DATAWIDTH(1), .INPUTS(8), .SELECT(3)) FLAGGER(.in({eq, 1'b0, lt, le, gt, ge, 1'b0, ne}),.sel(IRout[5 : 3]), .out(flagcheck));
    
    register INSTRUCTION_REGISTER(.clk(clk), .data(memin), .out(IRout), .write(write), .en(IRen),.rst(rst));  //IR
    mux4x1 #(.DATAWIDTH(8),.INPUTS(2),.SELECT(1)) CROMSEL(.in({CROMout[10 : 3], {IRout[15 : 12], 4'b0000}}),.out(CARin),.sel(CROMout[2]));//input to car
    mux4x1 DRSEL(.out(DRin),.in({pc, memin, regin, aludata}), .sel(DRselect));  //inputs to DR
    
    
    mux4x1 #(.DATAWIDTH(16), .INPUTS(2), .SELECT(1)) ARSEL(.out(ARin),.in({pc - 1, DRout}), .sel(ARselect));   //input to AR
    register #(8) CAR(.clk(negclk), .data(CARin), .out(CARout),.write(1'b1),.rst(rst), .en(en));    //CROM address
    //wire CARout;
    CON_MEM CROM(.en(en), .addr(CARout),.memout(CROMout), .rst(rst));
    
    register DR(.clk(clk), .data(DRin), .out(DRout), .write(write), .en(DRen),.rst(rst));  //DR
    register AR(.clk(clk), .data(ARin), .out(ARout), .write(write),.en(ARen),.rst(rst));  //AR
    
    assign regout = DRout;
    
    mux4x1 #(16, 2, 1) PCOUT(.out(pcout), .in({ARout, DRout}), .sel(PCselect));  //outputs to PC
    mux4x1 #(16, 2, 1) MEMSEL(.in({ARout, pc}), .out(memsel), .sel(MEMselect));    //data fetching using mem address
    
    decoder #(5) DECODE(.in(CROMout[15 : 11]),. out(signal)); //decode the operation
    
    
    
    
    assign memout = DRout;
    assign regen = REGen;
    assign regwrite = REGwrite;
    assign pcwrite = PCwrite;
    assign pcen = PCen;
    assign memwrite = MEMwrite;
    assign memen = MEMen;
    assign d0sel = IRout[5 : 3] & {D0sel, D0sel, D0sel}; //first operand;
    assign d1sel = IRout[2 : 0] & {D1sel, D1sel, D1sel};
    assign aluflag = signal[24];
    assign aluop[0] = signal[3] | signal[6];
    assign aluop[1] = signal[3] | signal[5];
    assign aluop[2] = signal[3] | signal[4];
    
    
    
endmodule



