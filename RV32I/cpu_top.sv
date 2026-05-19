module cpu_top
(
	input logic reset,
	input logic clk
);

//Signals 

//IF
logic [31:0] pc_index;
logic [31:0] instruction;

//decode
logic [6:0] opcode;
logic [4:0] rs1;
logic [4:0] rs2;
logic [4:0] rd;
logic [2:0] funct3;
logic [6:0] funct7;
logic [31:0] immediate;

//control 
logic [31:0] read_1;
logic [31:0] read_2;

logic [31:0] value_1;
logic [31:0] value_2;
logic [31:0] value_3;

logic [3:0] alu_op;
logic immediate_used;
logic [2:0] branch_op;


logic [31:0] alu_second_value;
logic [31:0] alu_result;

	pc pc_inst
	(
		.reset(reset),
		.clk(clk),

		.index(pc_index)
	);

	rom rom_inst
	(
		
		.address(pc_index),

		.instruction(instruction)

	);



	decoder decoder_inst
	(

		.instruction(instruction),

		.opcode(opcode),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd),
		.funct3(funct3),
		.funct7(funct7),
		.immediate(immediate)
	
	);

	regfile regfile_inst
	(

		.clk(clk),
		.reset(reset),
	
		//Reads
		.rs1(rs1),
		.rs2(rs2),
	
		.read_value_1(read_1),
		.read_value_2(read_2),

		//WB
		.write_enable(),
		.write_value(),
		.rd()

	);
	
	
	control_unit control_unit_inst
	(

		.opcode(opcode),
		.funct3(funct3),
		.funct7(funct7),

		.alu_op(),
		.immediate_used(),
		.branch_op(),

	);


//MUXes
always_comb
begin

value_1 = read_1;
value_2 = read_2;
value_3 = immediate;

	if (immediate_used)
		alu_second_value = value_3;
	else
		alu_second_value = value_2;

end




	alu alu_inst
	(
		
		.alu_op(alu_op),
		.value_1(value_1),
		.value_2(alu_second_value),
	
		.result(alu_result)

	);

	branch_unit branch_unit_inst
	(

		.pc(),
		.rs1(),
		.rs2,
		.immediate(),
		.branch_op(),

		.new_pc()

	);

	data_mem data_mem_inst
	(

		.clk(),
		.write_enable(),
		.address(),
		.write_value(),
	
		.read_value()

	);
	
	
endmodule