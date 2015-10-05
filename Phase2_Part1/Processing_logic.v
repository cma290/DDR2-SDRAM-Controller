module Processing_logic(
   // Outputs
   DATA_get, // when write
   CMD_get,	//fetch command
   RETURN_put, // when read out
   RETURN_address, RETURN_data,  //construct RETURN_data_in
   cs_bar, ras_bar, cas_bar, we_bar,  // read/write function, to the interface
   BA, A, DM, // A[12:0] row addr
   DQS_out, DQ_out, //for write op
   ts_con, // ??
   // Inputs
   clk, ck, reset, ready,  
   CMD_empty, CMD_data_out, DATA_data_out,
   RETURN_full,
   DQS_in, DQ_in
   );

   parameter BL = 3'b011; // Burst Lenght = 8
   parameter BT = 1'b0;   // Burst Type = Sequential
   parameter CL = 3'b011;  // CAS Latency (CL) = 3
   parameter AL = 3'b001;  // Posted CAS# Additive Latency (AL) = 1   
   //state
   parameter init = 4'b0000, idle = 4'b0001, fetch = 4'b0010, precharge = 4'b0011, 
			 refresh=4'b0100, scalarRead = 4'b0101, scalarWrite = 4'b0111, blockRead = 4'b1000, blockWrite = 4'b1001;
   
   input 	 clk, ck, reset, ready;
   input 	 CMD_empty, RETURN_full;
   input [32:0]	 CMD_data_out;
   input [15:0]  DATA_data_out;
   input [15:0]  DQ_in;
   input [1:0]   DQS_in;
 
   output reg CMD_get;
   output reg		 DATA_get, RETURN_put;
   output reg [24:0] RETURN_address;
   output wire [15:0] RETURN_data;
   output reg	cs_bar, ras_bar, cas_bar, we_bar;
   output reg [1:0]	 BA;
   output reg [12:0] A;
   output reg [1:0]	 DM;
   output reg [15:0]  DQ_out;
   output reg [1:0]   DQS_out;
   output reg ts_con;
   reg listen;
   reg DM_flag;
	
	reg [3:0]state;
	reg [4:0]count;
	reg [2:0]cmd;
	reg [2:0]Pointer;
	reg [24:0]addr;
	
always @(posedge clk)
begin 
	if(reset)
	  begin
	    state<= init;
	    addr <=0 ;
		CMD_get <= 0;
		DATA_get <= 0;
		count <= 0 ;
		{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// nop
		listen<= 0;
		Pointer <= 1;
		RETURN_put <= 0;
	  end
	else
		begin
		//state machine
			case (state)
				init: begin
					state <= ready? idle:init;
				
				end
				
				idle: begin
					//all banks precharged , table 36,37
					if (!CMD_empty) begin
						state <= fetch;
						//cmd <= CMD_data_out[7:5];
						//data <=DATA_data_out; //when write
					end
					count <= 0 ;
				end
				
				fetch: begin
				//note the async output of fifo
					if (CMD_data_out[7:5] == 0 || RETURN_full ) begin //NOP or output fifo no space
						state <= idle;
					end
					else if (CMD_data_out[7:5] == 1)begin //scalar read
						state <= scalarRead;
						addr <= CMD_data_out[32:8];// later put into return fifo with the corresponding data
					end
					CMD_get <= 1;
					DATA_get <= 1; //read command and data fifo
				end
				
				//precharge: begin 
				//	
				//end
				
				scalarRead: begin
					//activate
					{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0011;
					 A[12:0]<= addr[24:12]; //row address
					 BA <= addr[11:10];//bank addr
					//read after tRCD(15ns, 6 clk)
					count <= count + 1;
					if (count == 1) begin
						{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
					end
					else if(count == 5) begin
						{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101;
						A[9:0] <= addr[9:0]; //col addr
						A[10] <= 1; //auto precharge
						BA <= addr[11:10];
					end
					else if(count == 7) begin
						{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
					end
					else if(count == 12) begin //data coming
						listen<= 1;
					end
					else if(count == 13) begin //data ready
						Pointer <= 0;
					end
					else if(count == 14) begin //data ready
						 RETURN_put <= 1;
						 //RETURN_data_in={addr,RETURN_data}
					end					
			
				end
				
				scalarWrite: begin
			
				end
				
				default: begin
			
				end
			
			endcase
		
		end
end


ddr2_ring_buffer8 ring_buffer(RETURN_data, listen, DQS_in[0], Pointer[2:0], DQ_in, reset);


always @(negedge clk)
  begin
    DQ_out <= DATA_data_out;
    if(DM_flag)
        DM <= 2'b00;
    else
        DM <= 2'b11;	
  end
 
endmodule // ddr2_controller
