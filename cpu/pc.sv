/////////////////////////////////////////////////////////////////////
// Design unit: PC
//            :
// File name  : pc.sv
//            :
// Description: Program counter for basic processor
/////////////////////////////////////////////////////////////////////

module PC #(parameter WORD_W = 8, OP_W = 3)
               (input logic clock, n_reset, PC_bus, load_PC, INC_PC, 
                inout wire [WORD_W-1:0] sysbus);
		
logic [WORD_W-OP_W-1:0] count;

assign sysbus = PC_bus ? {{OP_W{1'b0}},count} : {WORD_W{1'bZ}};

always_ff @(posedge clock, negedge n_reset)
  if (~n_reset)
    count <= 0;
  else
    if (load_PC)
      if (INC_PC)
        count <= count + 1;
      else
	      count <= sysbus;

endmodule