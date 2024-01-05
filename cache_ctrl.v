// Date:        		03/09/2023
// Description:  
//
//

module main_cache(addr, clk, rst, DataIn, read, write,  processor_stall, DataOut);
parameter WIDTH = 32;
parameter DIPTH = 4 ;
parameter ADDR_SIZE = 10;
     // inputs and outputs signals
input clk, rst, read, write;
input   [WIDTH-1:0] DataIn;
input   [ADDR_SIZE-1 : 0] addr; 
output reg  processor_stall ;
output  [WIDTH-1:0] DataOut;
			//  Internal structure of cache memory
reg [WIDTH-1:0] temp [0:WIDTH-1][0:DIPTH-1]; 		 // 2d array -- 32 row * 4 columns = 128 register 
reg [2:0] tag_array  [0:WIDTH-1];              		//Each one is 32 bit with total capacity 32*128= 4096 = 512bytes  
reg valid_array      [0:WIDTH-1];
reg [ADDR_SIZE-1 : 0] addr_temp;
wire [ADDR_SIZE-1 : 0] addr1;
wire [1:0] offset;
wire [4:0] index;
wire [2:0] tag;
reg read_mm, write_mm, updata, refill,   update;
wire cache_hit;
//wire mem_rdy;
wire [WIDTH-1:0] mem_out;
		//FSM signals 	
reg [2:0]	cur_state,nxt_state;
localparam	 IDLE   = 2'b00,
                 READ   = 2'b01,
                 WRITE  = 2'b10;
                 
// Cache controller state machine, for loops counters 
reg [1:0] state; // 2-bit state: 00=idle, 01=reading, 10=writing
integer i , j , m, count;

			// instances of sub modules like controller and main memory 
dmm mm (.clk(clk), .addr(addr1), .rst(rst), .DataIn(DataIn), .DataOut(mem_out), .WrtEn(write_mm), .RdEn(read_mm));
always @ (posedge clk or negedge rst)
begin 
 if (!rst) begin 

       //DataOut  <= 0;
     for ( i = 0 ; i < WIDTH; i = i+1 )begin
         for ( j = 0 ; j < DIPTH; j = j+1 )begin 
	   temp [i][j]<= 0;
         end
     end     
  end 
 else begin   
//            if (processor_stall == 1) begin 
          	 if (update == 1) begin // write data_in into the cache memory 
		   //DataOut <= temp [2**index][2**offset]; 
		     temp [index][offset] <= DataIn; 
		     //cache_rdy <= 1; 
          	 end 
		else if (refill == 1) begin 
		      temp [index][offset] <= mem_out;
		      //cache_rdy <= 1;
              end 
	      //else begin  
		//DataOut <= temp [2**index][2**offset]; 
             
            //end 
  end
end  
always@(negedge clk or negedge rst)
        begin
                if (!rst)begin
		    processor_stall  <= 0;
		    count 	     <=	0;
		    //offset           <= 0;
     		   // index            <= 0 ;
       		  //  tag              <= 0;
                    cur_state        <= IDLE;
     		for ( i = 0 ; i < WIDTH; i = i+1 )begin 
			// reset the internal registers
       		  tag_array [i]  <= 0;
       		  valid_array[i] <= 0;
                end
		end
                else begin 
                    cur_state    <= nxt_state;
		    count       <= count +1;
                end
        end
always @(*) begin
     nxt_state = IDLE; // Idle state 
//        if (tag != tag_entry || valid_entry == 0 ) begin
//			cache_hit = 0; end
//        if (tag == tag_entry && valid_entry ==1)begin  // Idle state
//       			cache_hit = 1; end
        case (cur_state)
            IDLE: begin   
		 write_mm = 0;
		 read_mm  = 0;
		 refill   = 0;
		 update   = 0;
		 
                 processor_stall = 1'b0;
                 if ((read == 1) && (cache_hit == 0)) begin
                    // Cache miss, set stall
                    processor_stall = 1'b1;
                    nxt_state = READ; // Move to reading state
                end else if (write == 1 ) begin
                    // Cache hit for write
                    processor_stall = 1'b1;
                    nxt_state = WRITE; // Move to writing state
//                end else if (write && !cache_hit) begin
//                    // Cache miss for write
//                    processor_stall = 1'b1;
//                    nxt_state = WRITE; // Move to writing state
                //end else begin
                    // No operation
                   
                    //cache_hit <= 1'b0;
             end
                end
               
            READ:begin  // Reading state
		  read_mm = 1;
	          refill = 1;
		  tag_array [index] = tag; 
                  valid_array [index]=1 ;
		  if (count == 4)begin
		  // for (m = 0; m <4 ; m= m+1)begin
		      addr_temp = addr_temp + 1; 
                  // end
		  count <= 0;
		   end
//                      // Data from memory is available
// 		      processor_stall = 1'b0;
//		      refill = 0;
//		      read_mm = 0;
		  //  if (count == 4) begin
                    // addr_temp = addr_temp +1;end // Move back to idle state
		// else begin
			
			 nxt_state = IDLE;
			//end
		   
               end     
                
                
            WRITE: begin// Writing state
		 write_mm = 1;
                 if (cache_hit == 1)begin
		      update = 1;
		      tag_array [index] = tag; 
                      valid_array [index]=1;
//                        if (write == 0)begin
//				// Memory finished writing
//			    processor_stall = 1'b0;
//			    write_mm = 0;
//                   	    end 
		     //update = 0;
		      nxt_state = IDLE; // Move back to idle state
                end
		if (cache_hit == 0)begin 
		       if (write==0)begin
			 	///wait (count ==4);
		                //count <= 0;
				nxt_state = IDLE; // Move back to idle state
                    	      end
			else begin 
				nxt_state = WRITE; end
                end  

		
              end
	default:  nxt_state = IDLE;
				
        endcase
  
end
always @(*)begin 
addr_temp = addr; end
assign  mem_out     = mm.DataOut;
assign  offset      = (read == 1) && (cache_hit == 0)? addr_temp [1:0] : addr [1:0];
assign  index       = addr [6:2];
assign  tag         = addr [9:7];
assign  tag_entry   = tag_array [index];
assign  valid_entry = valid_array [index];
assign  cache_hit   = (tag == tag_entry && valid_entry == 1 );
assign  DataOut     = (read == 1) && (cache_hit == 0)? 0 : temp [index][offset];
assign  addr1       = (read == 1) && (cache_hit == 0)? addr_temp : addr;
endmodule 