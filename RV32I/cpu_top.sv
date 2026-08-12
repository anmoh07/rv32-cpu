module cpu_top
(
	input logic reset,
	input logic clk
);


logic [31:0] pc;
logic [31:0] instruction;

logic [6:0] opcode;
logic [4:0] rs1;
logic [4:0] rs2;
logic [4:0] rd;
logic [2:0] funct3;
logic [6:0] funct7;
logic [31:0] immediate;

logic [31:0] read_value_1;
logic [31:0] read_value_2;

	pc pc_inst
	(
		.reset(reset),
		.clk(clk),
		.next_pc(new_pc),				

		.pc(pc)
	);

	rom rom_inst
	(
		
		.address(pc),

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
	
		.read_value_1(read_value_1),
		.read_value_2(read_value_2),

		//WB
		.write_enable(wb_enable),
		.write_value(wb_value),
		.rd(rd)

	);
	
	
	control_unit control_unit_inst
	(

		.opcode(opcode),
		.funct3(funct3),
		.funct7(funct7),

		.alu_op(alu_op),
		.alu_sel(alu_sel),

		.branch_op(branch_op),
		.branch_enable(branch_enable),

		.dm_write_enable(dm_write_enable),
		.load_store_type(load_store_type),
		.reading_from_dm(reading_from_dm),

		.auipc(auipc),

		.wb_sel(wb_sel) //1 for alu_result

	);

logic [31:0] wb_value;
logic wb_enable; //0 for not enabled, 1 for enabled
logic [1:0] wb_sel; //0 for no wb, 1 for alu result, 2 for loaded value, 3 for pc + 4 (jal, jalr)

logic [3:0] alu_op;
logic alu_sel; //0 for read_value_2, 1 for immediate
logic [31:0] alu_operand_1;
assign alu_operand_1 = (auipc) ? pc : read_value_1;
logic [31:0] alu_operand_2;
assign alu_operand_2 = (alu_sel) ? immediate : read_value_2;
logic [31:0] alu_result;
logic alu_result_valid;

logic [31:0] new_pc;
logic [2:0] branch_op;
logic branch_enable;

logic dm_write_enable;
logic [2:0] load_store_type;
logic [31:0] dm_read_value;
logic dm_valid_read;
logic reading_from_dm;

always_comb
begin

wb_value = 32'h00000000;
wb_enable = 1'b0;

if ((wb_sel == 2'b01) && (alu_result_valid))
begin

	wb_value = alu_result;
	wb_enable = 1'b1;

end
else if ((wb_sel == 2'b10) && (dm_valid_read))
begin

	wb_value = dm_read_value;
	wb_enable = 1'b1;

end
else if (wb_sel == 2'b11)
begin

	wb_value = pc + 32'h00000004;
	wb_enable = 1'b1;

end

end

	alu alu_inst
	(
		
		.alu_op(alu_op),
		.value_1(alu_operand_1),
		.value_2(alu_operand_2),
	
		.result(alu_result),
		.result_valid(alu_result_valid)		

	);

	branch_unit branch_unit_inst
	(

		.pc(pc),
		.rs1(read_value_1),
		.rs2(read_value_2),
		.immediate(immediate),
		.branch_op(branch_op),
		.branch_enable(branch_enable),

		.new_pc(new_pc)

	);


	data_mem data_mem_inst
	(

		.clk(clk),
		.reading(reading_from_dm),
		.write_enable(dm_write_enable),
		.address(alu_result),
		.write_value(read_value_2),
		.load_store_type(load_store_type),
	
		.read_value(dm_read_value),
		.valid_read(dm_valid_read)

	);

endmodule
