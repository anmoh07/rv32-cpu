module decoder
(

	input logic [31:0] instruction,

	output logic [6:0] opcode,
	output logic [4:0] rs1,
	output logic [4:0] rs2,
	output logic [4:0] rd,
	output logic [2:0] funct3,
	output logic [6:0] funct7,
	output logic [31:0] immediate

);

assign opcode = instruction[6:0];
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign rd = instruction[11:7];
assign funct3 = instruction[14:12];
assign funct7 = instruction[31:25];


always_comb
begin

immediate = 32'h00000000;

	case (instruction[6:0])
	
		7'b0110011: immediate = 32'h00000000;//R

		7'b0010011, //I alu
		7'b0000011, //I loads
		7'b1100111: immediate = {{20{instruction[31]}}, instruction[31:20]}; //I
		//7'b1110011: //I CSR, ignored temporarily

		7'b0100011: immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; //S 

		7'b1100011: immediate = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; //B

		7'b1101111: immediate = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0}; //J

		7'b0110111, //U
		7'b0010111: immediate = {instruction[31:12], {12{1'b0}}}; //U
		
		default: immediate = 32'h00000000;

	endcase

end

endmodule
