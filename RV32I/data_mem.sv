module data_mem
(

	input logic clk,

	input logic write_enable,
	input logic [31:0] address, //for read or write, since it doesn't happen in the same instruction
	input logic [31:0] write_value,
	
	output logic [31:0] read_value

);

logic [31:0] memory [1023:0];

always_comb
begin

	read_value = memory[address[11:2]]; //just for testing purposes since 2^32 is a lot for waveform testing

end

always_ff @(posedge clk)
begin

	if (write_enable)
	begin
		memory[address[11:2]] <= write_value;
	end

end

endmodule