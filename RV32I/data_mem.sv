module data_mem
(

	input logic 		clk, //self explanatory 

	input logic 		reading, //low for no reading intended, high for reading intended
	input logic 		write_enable, //self explanatory 
	input logic [31:0] 	address, //for read or write, since it doesn't happen in the same instruction
	input logic [31:0] 	write_value, //self explanatory 
	input logic [2:0] 	load_store_type, //choosing between the operations (write hf, read byte unsigned, etc) 
	
	output logic [31:0] 	read_value, //self explanatory 
	output logic 		valid_read //Is the valid read junk or useful (whether it was an invalid read attempt or write instruction that also reads or nothing, etc)

);

logic [31:0] memory [1023:0];
logic [31:0] memory_value;
assign memory_value = memory[address[11:2]];  // adress[11:2] just for testing purposes since 2^32 is a lot for waveform testing


always_comb
begin

valid_read = reading;


if (load_store_type == 3'b000)

	read_value = {{24{memory_value[7 + 8*address[1:0]]}}, memory_value[8*address[1:0] +: 8]};

else if ((load_store_type == 3'b001) && (address[0] == 1'b0))

	read_value = {{16{memory_value[15 + 16*address[1]]}}, memory_value[16*address[1] +: 16]};

else if ((load_store_type == 3'b010) && (address[1:0] == 2'b00))

	read_value = memory_value;

else if (load_store_type == 3'b011)

	read_value = {{24{1'b0}}, memory_value[8*address[1:0] +: 8]};

else if ((load_store_type == 3'b100) && (address[0] == 1'b0))

	read_value = {{16{1'b0}}, memory_value[16*address[1] +: 16]};

else

begin

	valid_read = 1'b0;
	read_value = 32'h00000000;

end

end




always_ff @(posedge clk)
begin

	if (write_enable)
	begin
		
		if ((load_store_type == 3'b001) && (address[0] == 1'b0)) 
			
			memory[address[11:2]][16*address[1] +: 16] <= write_value[15:0];

		else if ((load_store_type == 3'b010) && (address[1:0] == 2'b00))

			memory[address[11:2]] <= write_value;

		else if (load_store_type == 3'b000)

			memory[address[11:2]][8*address[1:0] +: 8] <= write_value[7:0];

	
	end

end

endmodule
