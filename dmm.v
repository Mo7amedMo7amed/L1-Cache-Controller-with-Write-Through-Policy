//---------------------------------------------------------------------
// Date : 		23/08/2023
// Description : 4Kbyte Data Memory
//---------------------------------------------------------------------

module dmm (addr, clk, rst, WrtEn, RdEn, DataIn, DataOut );
	parameter WIDTH = 32;
	parameter DEPTH = 1024;
	parameter ADDR_SIZE = 10;
	input clk, rst, WrtEn, RdEn;
	input [WIDTH-1:0] DataIn;
	input [ADDR_SIZE-1 : 0] addr;

	//output reg mem_rdy; 
	output reg [WIDTH-1:0] DataOut;
	reg [WIDTH-1:0] temp [0:DEPTH-1]; /// 4Kbyte
	integer i ;
	always @(posedge clk or negedge rst)begin
		if (!rst) begin 
			DataOut <= 0;
			for (i = 0; i < DEPTH; i = i +1)begin
				temp [i] <= 0;
			end
			//  mem_rdy <= 1;
		end
		else begin 
			if (WrtEn == 1) begin 
				temp [addr] <= DataIn;
				// mem_rdy <= 1;
			end   
			else 
				temp [addr] <= temp [addr];
		end

		end
	always @(*)begin  // Asyn read 
		if (RdEn == 1) begin 
			DataOut <= temp [addr];
		end
	end 
endmodule 