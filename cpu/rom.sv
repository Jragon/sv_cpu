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
    0: mdr = {`STORE, 7'd127}; // disp
    1: mdr = {`LOAD, 7'd12}; // bottom - label: :start:
    2: mdr = {`STORE, 7'd64}; // i
    3: mdr = {`LOAD, 7'd64}; // i - label: :loop:
    4: mdr = {`STORE, 7'd127}; // disp
    5: mdr = {`ADD, 7'd12}; // bottom - add bottom (instead of inc) to keep within the  ROM
    6: mdr = {`STORE, 7'd64}; // i
    7: mdr = {`LOAD, 7'd13}; // top
    8: mdr = {`SUB, 7'd64}; // i
    9: mdr = {`BNE, 7'd15}; // :loop:
    10: mdr = {`LOAD, 7'd12}; // bottom - needed hack since there's no jump if zero
    11: mdr = {`BNE, 7'd14}; // :start:
    12: mdr = 1; // bottom
    13: mdr = 10; // top
    14: mdr = 1; // :start: labelhttps://coursecast.soton.ac.uk/Panopto/Pages/Viewer/Image.aspx?id=211904&number=63&x=undefined
    15: mdr = 3; // :loop: label
    default: mdr = 0;
  endcase
  end
  
endmodule