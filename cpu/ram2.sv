/////////////////////////////////////////////////////////////////////
// Design unit: RAM
//            :
// File name  : ram.sv
//            :
// Description: Synchronous RAM for basic processor
/////////////////////////////////////////////////////////////////////

module RAM2 #(parameter WORD_W = 8, OP_W = 3)
               (input logic clock, n_reset, MDR_bus, load_MDR, load_MAR, CS, R_NW,
                input logic [7:0] switches,
                inout wire [WORD_W-1:0] sysbus,
                output logic [WORD_W-1:0] disp);

//`include "opcodes.h"
		
logic [WORD_W-1:0] mdr;
logic [WORD_W-OP_W-1:0] mar;
logic [WORD_W-1:0] mem [0:(1<<(WORD_W-OP_W-1))-1]; //top half of address range

assign sysbus = (MDR_bus & mar[WORD_W-OP_W-1]) ? mdr : {WORD_W{1'bZ}};
assign disp = mem[63]; // at addr 126

always_ff @(posedge clock, negedge n_reset)
  begin
  if (~n_reset)
    begin 
    mdr <= 0;
    mar <= 0;
    end
  else
    if (load_MAR)
      mar <= sysbus[WORD_W-OP_W-1:0]; 
    else if (load_MDR)
      mdr <= sysbus;
    else if (CS & mar[WORD_W-OP_W-1])
      if (R_NW)
        if (mar == 7'd126) // switches at addr 31
          mdr = switches;
        else
          mdr <= mem[mar[WORD_W-OP_W-2:0]];
      else
        mem[mar[WORD_W-OP_W-2:0]] <= mdr;
  end


endmodule