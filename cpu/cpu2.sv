
module CPU2 #(parameter WORD_W = 8, OP_W = 3)
                  (input logic clock, n_reset, 
                   input logic [7:0] switches,
                   output logic [6:0] disp0, disp1, disp2, disp3);

logic ACC_bus, load_ACC, PC_bus, load_PC, load_IR, load_PTR_IR, load_MAR,
      MDR_bus, load_MDR, ALU_ACC, ALU_add, ALU_sub, ALU_xor, 
      INC_PC, Addr_bus, CS, R_NW, z_flag;

logic [WORD_W-1:0] disp;

logic [OP_W-1:0] op;
wire [WORD_W-1:0] sysbus;


sequencer #(.WORD_W(WORD_W), .OP_W(OP_W)) s1  (.*);

IR #(.WORD_W(WORD_W), .OP_W(OP_W)) i1  (.*);

PC #(.WORD_W(WORD_W), .OP_W(OP_W)) p1 (.*);

ALU #(.WORD_W(WORD_W), .OP_W(OP_W)) a1 (.*);

RAM2 #(.WORD_W(WORD_W), .OP_W(OP_W)) r1 (.*);

ROM #(.WORD_W(WORD_W), .OP_W(OP_W)) r2 (.*);

//Display sysbus. Modify if WORD_W changes.

sevenseg d0 (.address(sysbus[3:0]), .data(disp0));
sevenseg d1 (.address(sysbus[7:4]), .data(disp1));

// mapped to addr 30 in RAM
sevenseg d2 (.address(disp[3:0]), .data(disp2));
sevenseg d3 (.address(disp[7:4]), .data(disp3));


endmodule