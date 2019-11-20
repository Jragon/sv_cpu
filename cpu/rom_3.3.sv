/////////////////////////////////////////////////////////////////////
// Design unit: ROM
//            :
// File name  : rom.sv
//            :
// Description: ROM for basic processor
//            : including simple program 
/////////////////////////////////////////////////////////////////////

module ROM #(parameter WORD_W = 8, OP_W = 3)
               (input logic clock, n_reset, MDR_bus, load_MDR, load_MAR, CS, R_NW,
                inout wire [WORD_W-1:0] sysbus);

`include "opcodes.h"
		

logic [WORD_W-OP_W-1:0] mar;
logic [WORD_W-1:0] mdr;


assign sysbus = (MDR_bus & ~mar[WORD_W-OP_W-1]) ? mdr : {WORD_W{1'bZ}};

always_ff @(posedge clock, negedge n_reset)
  begin
  if (~n_reset)
    mar <= 0;
  else if (load_MAR)
    mar <= sysbus[WORD_W-OP_W-1:0];
  end

always_comb
  begin
  mdr = 0;
  case (mar)
    0: mdr = {`STORE, 5'd30};
	1: mdr = {`LOAD, 5'd31};
    2: mdr = {`ADD, 5'd31}; // add switches to switches
    3: mdr = {`STORE, 5'd30};
    4: mdr = {`BNE, 5'd6};
    5: mdr = 5;
    6: mdr = 1;
    default: mdr = 0;
  endcase
  end
  
//always_comb
//  begin
//  mdr = 0;
//  case (mar)
//    0: mdr = {`STORE, 5'd30};
//	1: mdr = {`LOAD, 5'd30};
//	2: mdr = {`XOR, 5'd7};
//    3: mdr = {`ADD, 5'd31}; // add switches to switches
//	4: mdr = {`XOR, 5'd7};
//    5: mdr = {`STORE, 5'd30};
//    6: mdr = {`BNE, 5'd8};
//    7: mdr = 5;
//    8: mdr = 1;
//    default: mdr = 0;
//  endcase
//  end
  
endmodule