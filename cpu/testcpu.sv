/////////////////////////////////////////////////////////////////////
// Design unit: TestCPU
//            :
// File name  : testcpu.sv
//            :
// Description: Simple testbench for basic processor
/////////////////////////////////////////////////////////////////////

module TestCPU;

parameter int WORD_W = 10, OP_W = 3;

logic clock, n_reset;
logic [7:0] switches;
logic [6:0] disp0, disp1, disp2, disp3;

CPU2 #(.WORD_W(WORD_W), .OP_W(OP_W)) c1 (.*);

always
  begin
#10ns clock = 1'b1;
#10ns clock = 1'b0;
end

initial
begin
switches = 'd5;
n_reset = 1'b1;
#1ns n_reset = 1'b0;
#2ns n_reset = 1'b1;
//#260ns switches = 'd5;
end

endmodule