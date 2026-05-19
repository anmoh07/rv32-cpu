module control_unit
(

	input logic [6:0] opcode,
	input logic [2:0] funct3,
	input logic [6:0] funct7,

	output logic [3:0] alu_op,
	output logic immediate_used,

	output logic [2:0] branch_op,


);

always_comb
begin

alu_op = 4'b0000;
immediate_used = 1'b0;
branch_op = 3'b000;

	case (opcode)
	
		7'b0110011,
		7'b0010011:
		begin
			if (opcode == 7'b0010011)
			begin
				immediate_used = 1'b1; //immediates, funct7 is equvilant to imm[11:5]
			end
			case (funct3)
				
				3'b000: 
				if ((opcode == 7'b0110011) && (funct7 == 7'h20)) //no subi
       					alu_op = 4'b0001; 
   				else
        				alu_op = 4'b0000;
				3'b100:
					alu_op = 4'b0010;
				3'b110:
					alu_op = 4'b0011;
				3'b111:
					alu_op = 4'b0100;
				3'b001:
					alu_op = 4'b0101;
				3'b101:
				if (funct7 == 7'h00)
					alu_op = 4'b0110;
				else
					alu_op = 4'b0111;
				3'b010:
					alu_op = 4'b1000;
				3'b011:
					alu_op = 4'b1001;
				default: 
					alu_op = 4'b0000;
			endcase

		end
		7'b0000011:
		begin
		
			alu_op = 4'b0000;
			immediate_used = 1'b1;

		end
		7'b0100011:	
		begin
		
			alu_op = 4'b0000;
			immediate_used = 1'b0;

		end
		7'b1100011:
		begin

			case (funct3)
				
				3'b000: 
       					branch_op = 3'b000; 
				3'b001:
					branch_op = 3'b001;
				3'b100:
					branch_op = 3'b010;
				3'b101:
					branch_op = 3'b011;
				3'b110:
					branch_op = 3'b100;
				3'b111:
					branch_op = 3'b101;
				default: 
					branch_op = 3'b000;
			endcase


		end
		7'b1101111:
		begin
			branch_op = 3'b110;
		end
		7'b1100111:
		begin
			branch_op = 3'b111;
		end
		7'0110111:
		begin

		end
		7'0010111:
		begin

		end
		default:
		begin

			alu_op = 4'b0000;
			immediate_used = 1'b0;
			branch_op = 3'b000;

		end
	endcase

end

endmodule