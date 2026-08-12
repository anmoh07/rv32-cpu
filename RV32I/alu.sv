module alu
(

	input logic [3:0] alu_op,
	input logic [31:0] value_1,
	input logic [31:0] value_2,
	
	output logic [31:0] result,
	output logic result_valid


);

typedef enum logic [3:0]
{

	ADD,
	SUB,
	XOR,
	OR,
	AND,
	SLL,
	SRL,
	SRA,
	SLT,
	SLTU,
	PASS_1,
	PASS_2

} op_t;



always_comb
begin
result = 32'h00000000;
result_valid = 1'b1;

	case (op_t'(alu_op))

		ADD: result = value_1 + value_2;
		SUB: result = value_1 - value_2;
		XOR: result = value_1 ^ value_2;
		OR: result = value_1 | value_2;
		AND: result = value_1 & value_2;
		SLL: result = value_1 << value_2[4:0]; // RV32 shift amount uses lower 5 bits
		SRL: result = value_1 >> value_2[4:0];
		SRA: result = $signed(value_1) >>> (value_2[4:0]);
		SLT: result = ($signed(value_1) < $signed(value_2)) ? 32'h00000001 : 32'h00000000; 
		SLTU: result = (value_1 < value_2) ? 32'h00000001 : 32'h00000000;
		PASS_1: result = value_1;
		PASS_2: result = value_2;
		default: result_valid = 1'b0; 

	endcase

end


endmodule
