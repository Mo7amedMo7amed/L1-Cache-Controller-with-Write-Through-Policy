

module top ();
	
	parameter WIDTH = 32;
	parameter DIPTH = 4 ;
	parameter ADDR_SIZE = 10;
	
    // inputs and outputs signals
	logic clk, rst, read, write;
	logic  [WIDTH-1:0] DataIn;
	logic   [ADDR_SIZE-1 : 0] addr; 
	logic processor_stall ;
	logic [WIDTH-1:0] DataOut;

	main_cache cache (.addr(addr), .clk(clk), .rst(rst), .DataIn(DataIn), .read(read), .write(write),  .processor_stall(processor_stall), .DataOut(DataOut));

	//=================================================================================================
	//	for testbench run the tcl file "direct_tcl_tb.do"
	//=================================================================================================



endmodule