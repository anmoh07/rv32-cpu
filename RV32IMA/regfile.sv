module regfile
(

	input logic clk,
	input logic reset,
	
	input logic [4:0] rs1,
	input logic [4:0] rs2,

	input logic write_enable,
	input logic [31:0] write_value,
	input logic [4:0] rd,
	
	output logic [31:0] read_value_1,
	output logic [31:0] read_value_2

);

logic [31:0] registers [31:0];

always_comb
begin

	read_value_1 = (rs1 != 5'b00000) ? registers[rs1] : 32'h00000000; //x0 hardwired to 0
	read_value_2 = (rs2 != 5'b00000) ? registers[rs2] : 32'h00000000;

end

always_ff @(posedge clk)
begin
	
	if (reset)
	begin
		
		for (int i = 0; i < 32; i++)
		begin
			registers[i] <= 32'h00000000; 
		end

	end
	else if (write_enable && (rd != 5'b00000)) //can't write to x0
	begin
		registers[rd] <= write_value;
	end

end

endmodule