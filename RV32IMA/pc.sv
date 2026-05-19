module pc
(

	input logic reset,
	input logic clk,
	input logic [31:0] next_pc,

	output logic [31:0] pc


);

always_ff @(posedge clk)
begin

	if (reset)
	begin
		pc <= 32'h00000000; 
	end
	else
	begin
		pc <= next_pc;
	end

end


endmodule
