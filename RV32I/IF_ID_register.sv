module IF_ID_register
(

	input logic clk,
	input logic reset,
	input logic [31:0] instruction_IF,	

	output logic [31:0] instruction_ID


);

always_ff @(posedge clk)
begin

	if (reset)
		instruction_ID <= 32'h00000000;
	else
		instruction_ID <= instruction_IF;

end

endmodule