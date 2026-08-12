module control_unit
(
	input logic [6:0] opcode,
	input logic [2:0] funct3,
	input logic [6:0] funct7,

	output logic [3:0] alu_op,
	output logic alu_sel,

	output logic [2:0] branch_op,
	output logic branch_enable,

	output logic dm_write_enable,
	output logic [2:0] load_store_type,
	output logic reading_from_dm,

	output logic auipc,

	output logic [1:0] wb_sel
);

localparam logic [6:0] ALU = 7'b0110011;
localparam logic [6:0] ALU_I = 7'b0010011;
localparam logic [6:0] LOAD = 7'b0000011;
localparam logic [6:0] STORE = 7'b0100011;
localparam logic [6:0] BRANCH = 7'b1100011; 
localparam logic [6:0] JAL = 7'b1101111; 
localparam logic [6:0] JALR = 7'b1100111; 
localparam logic [6:0] LUI = 7'b0110111;
localparam logic [6:0] AUIPC = 7'b0010111;

always_comb
begin

	// Default signal assignments
	alu_op = 4'b0000;
	alu_sel = 1'b0;
	branch_op = 3'b000;
	branch_enable = 1'b0;
	dm_write_enable = 1'b0;
	load_store_type = 3'b000;
	reading_from_dm = 1'b0;
	auipc = 1'b0;
	wb_sel = 2'b00;

	case (opcode)
	
		ALU:
		begin
			alu_sel = 1'b0;
			wb_sel = 2'b01;

			case (funct3)

				3'b000: alu_op = (funct7[5]) ? 4'b0001 : 4'b0000; 
				3'b001: alu_op = 4'b0101; 
				3'b010: alu_op = 4'b1000; 
				3'b011: alu_op = 4'b1001; 
				3'b100: alu_op = 4'b0010; 
				3'b101: alu_op = (funct7[5]) ? 4'b0111 : 4'b0110; 
				3'b110: alu_op = 4'b0011; 
				3'b111: alu_op = 4'b0100; 

			endcase
		end

		ALU_I:
		begin
			alu_sel = 1'b1;
			wb_sel = 2'b01;

			case (funct3)

				3'b000: alu_op = 4'b0000;
				3'b001: alu_op = 4'b0101; 
				3'b010: alu_op = 4'b1000; 
				3'b011: alu_op = 4'b1001; 
				3'b100: alu_op = 4'b0010; 
				3'b101: alu_op = (funct7[5]) ? 4'b0111 : 4'b0110; 
				3'b110: alu_op = 4'b0011; 
				3'b111: alu_op = 4'b0100; 

			endcase
		end

		LOAD:
		begin
			alu_op = 4'b0000; 
			alu_sel = 1'b1;
			reading_from_dm = 1'b1;
			wb_sel = 2'b10;
			load_store_type = funct3; 
		end

		STORE:
		begin
			alu_op = 4'b0000; 
			alu_sel = 1'b1;
			dm_write_enable = 1'b1;
			load_store_type = funct3; 
		end

		BRANCH:
		begin
			branch_enable = 1'b1;
			branch_op = funct3; 
		end

		JAL:
		begin
			branch_op = 3'b110;
			branch_enable = 1'b1;
			wb_sel = 2'b11;
		end		

		JALR:
		begin
			branch_op = 3'b111;
			branch_enable = 1'b1;
			wb_sel = 2'b11;
		end

		LUI:
		begin
			alu_op = 4'b1011;
			alu_sel = 1'b1;
			wb_sel = 2'b01;
		end

		AUIPC: 
		begin
			auipc = 1'b1;
			wb_sel = 2'b01;
			alu_op = 4'b0000; 
			alu_sel = 1'b1;
		end
			
	endcase

end

endmodule
