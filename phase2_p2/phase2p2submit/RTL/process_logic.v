// Cheng Ma

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
				/// read = 5, write = 7
   input 	 clk, ck, reset, ready;
   input 	 CMD_empty, RETURN_full;
   input [32:0]	 CMD_data_out;
   input [15:0]  DATA_data_out;
   input [15:0]  DQ_in;
   input [1:0]   DQS_in;
 
   output reg CMD_get;
   output reg		 DATA_get, RETURN_put;
   output wire [24:0] RETURN_address; // i changed this from reg to wire
	// ringbuffer data out -> return fifo data in 
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
	reg [6:0]count;
	reg [11:0]ref_cnt;//refresh count. max 2to12=4096
	reg [5:0]ref_state_cnt;
	reg [2:0]Pointer;
	reg [24:0]addr;
	//reg [11:0] refresh_cnt;
	//reg in_block;
	//reg [1:0] size_cnt;
	reg [1:0] size;
	//reg BA_copy; // to see if BA changed because of address increment, if different we need a new active
	// now assume BA will not change during a block op
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
		Pointer <= 0;
		RETURN_put <= 0;
		A <= 0;
		BA<= 0;
		DM_flag <= 0;
		ref_cnt <= 0;
	  end
	else begin
	//state machine
		case (state)
			init: begin
				state <= ready? idle:init;
			end
			
			idle: begin // s1 
				//all banks precharged , table 36,37
				CMD_get <= 0;
				DATA_get <= 0;
				if (ref_cnt >= (3000 -60 -10) ) begin // 7800n/2.6n = 3000 cycle, 60 for blockWrite size = 4, -10 for margin
					state <= refresh;
					ref_cnt<= 0;
					ref_state_cnt <= 0;
				end
				else begin
					ref_cnt <= ref_cnt+1;
					if (!CMD_empty) begin
						state <= fetch;
					end
					count <= 0 ;
				end
			end
			
			refresh : begin
				ref_state_cnt <= ref_state_cnt+1;
				if (ref_state_cnt == 0) begin
					if (ck ==1) begin
						{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0001; //refresh command
						 ref_state_cnt <=ref_state_cnt + 1;
					end
					else if (ck ==0) begin
						ref_state_cnt <= 0;// let the next ck = 1 catch it
					end
				end
				else if (ref_state_cnt == 2) begin
					{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
				end
				else if (ref_state_cnt == 42) begin //105ns for tREF
					state <= idle;
				end
			end
			
			fetch: begin //2
			//note the async output of fifo
				ref_cnt <= ref_cnt+1;
				if ( (CMD_data_out[7:5] == 0)|| RETURN_full ) begin //NOP or output fifo no space
					state <= idle;
				end
				else if (CMD_data_out[7:5] == 3'b001)begin //scalar read
					state <= scalarRead;
					addr <= CMD_data_out[32:8];// later put into return fifo with the corresponding data
				end
				else if (CMD_data_out[7:5] == 3'b010 )begin
				  state <= scalarWrite;
					addr <= CMD_data_out[32:8];
				end
				else if (CMD_data_out[7:5] == 3'b011 ) begin//BLR
					state <= blockRead;
					addr <= CMD_data_out[32:8];
					size <= CMD_data_out[4:3];
				end
				else if (CMD_data_out[7:5] == 3'b100 ) begin //BLW
					state <= blockWrite;
					addr <= CMD_data_out[32:8];
					size <= CMD_data_out[4:3];
					//size_cnt <= CMD_data_out[4:3];
				end
				 //read command and data fifo
			end
			
			
			scalarRead: begin //s5
				ref_cnt <= ref_cnt+1;
				ts_con <= 0;
				CMD_get <= 0; 
				//DATA_get <= 0;
				count <= count + 1; // smtimes will be overwrite if there is count assignment here after

				//activate. command should be two clk long, cover the ck rise edge on both sides
				if (count == 0 && ck == 1) begin // neg edge of ck. because ck changed after clk edge(clk generate ck)
					{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0011;
					A[12:0]<= addr[24:12]; //row address
					BA <= addr[11:10];//bank addr
					count<= count +1;
				end
				else if (count == 0 && ck ==0)begin
					count <= 0;// let the next ck = 1 catch it
				end
				//read after tRCD(15ns, 6 clk)
				// case count
				if (count == 2) begin
					{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
				end
				else if(count == 4) begin
					{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101;
					A[9:0] <= addr[9:0]; //col addr
					A[10] <= 1; //auto precharge
					BA <= addr[11:10];
				end
				else if(count == 6) begin
					{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
				end
				else if(count == 12) begin //data coming
					listen<= 1;
				end
				else if(count == 13) begin //data ready
					Pointer <= 0;
					 RETURN_put <= 1; /// found that there is setuptime vialation when put in this clock
					 listen<= 0;		//so just delay one
				end
				else if(count == 14) begin //data ready
					 RETURN_put <= 0;
				end	
				else if (count == 17) begin
					 CMD_get <= 1; // point to next cmd
				end
				else if (count == 24) begin // 18 to 24, maybe also need to change the last of blockRead
					count <= 0 ;
					 state <= idle;
					 CMD_get <= 0; //
				end
				// 1st edition timing:1,5,7,12,13,14
				//					  2,8,12,
					//				  2 6 8 13 14 15	
			end
			
			scalarWrite: begin
				ref_cnt <= ref_cnt+1;
				ts_con <= 1;
				CMD_get <= 0; 
				count <=count + 1;
				if (count == 0) begin
					if (ck ==1) begin
						{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0011;
						A[12:0]<= addr[24:12]; //row address (after provide the address, do I need to close the address line)
						BA <= addr[11:10];//bank addr
						 count <=count + 1;
					end
					else if (ck ==0) begin
						count <= 0;// let the next ck = 1 catch it
					end
				end
				
				else if (count == 2) begin
					{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
				end
				else if(count == 4) begin
					{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;//write command, AL=1
					A[9:0] <= addr[9:0]; //col addr
					A[10] <= 1; //auto precharge
					BA <= addr[11:10];
				end
				else if (count == 6) begin
				  {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;//NOP command
				end
				else if (count == 10) begin
				  DQS_out <= 2'b00; 
				  DM_flag <= 1;
				end
				else if (count == 11) begin
				  DM_flag <= 0;
				end					
				else if (count == 18) begin
					DQS_out <= 2'b00; 
				end
				else if (count == 19) begin
					ts_con <= 0;
				end
				else if (count == 31) begin
					CMD_get <= 1;
					DATA_get <= 1;  // move the data read pointer one step
				end					
				else if (count == 32) begin
					state <= idle;
					CMD_get <= 0;
					DATA_get <= 0; 
					count <= 0;
				end
				
				if (count >= 11 && count <= 17) begin
					DQS_out[0]<=~DQS_out[0];
					DQS_out[1]<=~DQS_out[1];
				end
				
			end

			blockWrite : begin
				ref_cnt <= ref_cnt+1;
				ts_con <= 1;
				count <=count + 1;
				if (count == 0) begin
				  case (ck)
					1: begin
						{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0011;
						A[12:0]<= addr[24:12]; //row address (after provide the address, do I need to close the address line)
						BA <= addr[11:10];//bank addr
						count <=count + 1;	end
					0: begin
						count <= 0;// let the next ck = 1 catch it
						end
						endcase
					end	
				else if (count == 2) begin
					{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
					end
				else begin // activate completed
					if (size == 0) begin
						if(count == 4) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;//write command, AL=1
							A[9:0] <= addr[9:0]; //col addr
							A[10] <= 1; //auto precharge when block = 8 words
							BA <= addr[11:10];
						end
						else if (count == 6) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;//NOP command
						end
						else if (count == 10) begin
							DQS_out <= 2'b00; 
							DM_flag <= 1;
							DATA_get <= 1; 
						end
						else if (count == 18) begin
							DQS_out <= 2'b00;
							DM_flag <= 0;
							DATA_get <= 0; 							
						end
						else if (count == 19) begin
							ts_con <= 0;
						end
						else if (count == 31) begin
							CMD_get <= 1;
						end					
						else if (count == 32) begin
						state <= idle;
						CMD_get <= 0;
						DATA_get <= 0; 
						count <= 0;
						end		
						
						if (count >= 11 && count <= 17) begin
							DQS_out[0]<=~DQS_out[0];
							DQS_out[1]<=~DQS_out[1];
						end
					end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////									
					else if (size == 1) begin
						if(count == 4) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;//write command, AL=1
							A[9:0] <= addr[9:0]; //col addr
							A[10] <= 0; //
							BA <= addr[11:10];
						end
						else if (count == 6) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;//NOP command
						end
						else if (count == 10) begin
							DQS_out <= 2'b00; 
							DM_flag <= 1;
							DATA_get <= 1; 
						end
						else if (count == 12) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;//write command, AL=1
							A[9:0] <= addr[9:0] + 8; //
							A[10] <= 1; //auto precharge
							BA <= addr[11:10];
						end	
						else if (count == 14) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;//NOP command
						end	
						else if (count == 18+8) begin
							DQS_out <= 2'b00;//close
							DM_flag <= 0; //close
							DATA_get <= 0; //close							
						end
						else if (count == 19+8) begin
							ts_con <= 0;
						end
						else if (count == 31+8) begin
							CMD_get <= 1;
							//DATA_get <= 1; now we need to get 8 data 
						end					
						else if (count == 32+8) begin
						state <= idle;
						CMD_get <= 0;
						DATA_get <= 0; 
						count <= 0;
						end		
						
						if (count > 10 && count < 18+8) begin
							DQS_out[0]<=~DQS_out[0];
							DQS_out[1]<=~DQS_out[1];
						end
					end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////	
// wat need to change: 1.auto pre 2 addr 3writecmmmand. 4 close time					
					else if (size == 2) begin
						if(count == 4) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;//write command, AL=1
							A[9:0] <= addr[9:0]; //col addr
							A[10] <= 0; //auto precharge 
							BA <= addr[11:10];
						end
						else if (count == 6) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;//NOP command
						end
						else if (count == 10) begin
							DQS_out <= 2'b00; 
							DM_flag <= 1;
							DATA_get <= 1; 
						end
						else if (count == 12) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;//write command, AL=1
							A[9:0] <= addr[9:0] + 8; //
							A[10] <= 0; //auto precharge
							BA <= addr[11:10];
						end	
						else if (count == 14) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;//NOP command
						end	
						else if (count == 12+8) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;//write command, AL=1
							A[9:0] <= addr[9:0] + 16; //
							A[10] <= 1; //auto precharge
							BA <= addr[11:10];
						end	
						else if (count == 14+8) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;//NOP command
						end
						
						else if (count == 18+16) begin
							DQS_out <= 2'b00;//close
							DM_flag <= 0; //close
							DATA_get <= 0; //close							
						end
						else if (count == 19+16) begin
							ts_con <= 0;
						end
						else if (count == 31+16) begin
							CMD_get <= 1;
							//DATA_get <= 1; now we need to get 8 data 
						end					
						else if (count == 32+16) begin
						state <= idle;
						CMD_get <= 0;
						DATA_get <= 0; 
						count <= 0;
						end		
						
						if (count > 10 && count < 18+16) begin
							DQS_out[0]<=~DQS_out[0];
							DQS_out[1]<=~DQS_out[1];
						end
					end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////						
					else if (size == 3) begin
						if(count == 4) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;//write command, AL=1
							A[9:0] <= addr[9:0]; //col addr
							A[10] <= 0; //auto precharge when block = 8 words
							BA <= addr[11:10];
						end
						else if (count == 6) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;//NOP command
						end
						else if (count == 10) begin
							DQS_out <= 2'b00; 
							DM_flag <= 1;
							DATA_get <= 1; 
						end
						else if (count == 12) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;//write command, AL=1
							A[9:0] <= addr[9:0] + 8; //
							A[10] <= 0; //auto precharge when block = 8 words
							BA <= addr[11:10];
						end	
						else if (count == 14) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;//NOP command
						end	
						else if (count == 12+8) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;//write command, AL=1
							A[9:0] <= addr[9:0] + 16; //
							A[10] <= 0; //auto precharge when block = 8 words
							BA <= addr[11:10];
						end	
						else if (count == 14+8) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;//NOP command
						end
						else if (count == 12+8+8) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100;//write command, AL=1
							A[9:0] <= addr[9:0] + 24; //
							A[10] <= 1; //auto precharge when block = 8 words
							BA <= addr[11:10];
						end	
						else if (count == 14+8+8) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;//NOP command
						end
						else if (count == 18+24) begin
							DQS_out <= 2'b00;//close
							DM_flag <= 0; //close
							DATA_get <= 0; //close							
						end
						else if (count == 19+24) begin
							ts_con <= 0;
						end
						else if (count == 31+24) begin
							CMD_get <= 1;
							//DATA_get <= 1; now we need to get 8 data 
						end					
						else if (count == 32+24) begin
						state <= idle;
						CMD_get <= 0;
						DATA_get <= 0; 
						count <= 0;
						end		
						
						if (count > 10 && count < 18+24) begin
							DQS_out[0]<=~DQS_out[0];
							DQS_out[1]<=~DQS_out[1];
						end
					end
				
				
				end
			end
			
			blockRead: begin
				ref_cnt <= ref_cnt+1;
				ts_con <= 0;
				count <= count + 1; // smtimes will be overwrite if there is count assignment here after
				//activate. command should be two clk long, cover the ck rise edge on both sides
				if (count == 0 ) begin // neg edge of ck. because ck changed after clk edge(clk generate ck)
					if (ck == 1) begin
						{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0011;
						A[12:0]<= addr[24:12]; //row address
						BA <= addr[11:10];//bank addr
						count<= count +1;
					end
					else if (ck ==0) begin
						count <= 0;// let the next ck = 1 catch it
					end
				end
				//read after tRCD(15ns, 6 clk)
				// case count
				else if (count == 2) begin
					{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
				end
				else begin
					if (size ==0) begin
						if(count == 4) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101;
							A[9:0] <= addr[9:0]; //col addr
							A[10] <= 1; //auto precharge //####################
							BA <= addr[11:10];
						end
						else if(count == 6) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
						end	
						//####################
						else if(count == 12) begin //data coming
							listen<= 1;
						end
						else if(count == 13) begin 
							RETURN_put <= 1; /// found that there is setuptime vialation when put in this clock
							listen<= 0;		//we reduced one clkbuff
						end
						else if (count == 20) begin //####################
							CMD_get <= 1; // point to next cmd
						end
						else if(count == 21) begin //####################
							RETURN_put <= 0; //close
							count <= 0 ;
							state <= idle;
							CMD_get <= 0; //
							Pointer <= Pointer+1;
						end	
						
						// addr ++ ptr++
						if (count >13 && count < 21) begin //####################
							addr <= addr+1;
							Pointer <= Pointer+1;
						end
					end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////					
					else if (size == 1) begin
						if(count == 4) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101;
							A[9:0] <= addr[9:0]; //col addr
							A[10] <= 0; //auto precharge //####################
							BA <= addr[11:10];
						end
						else if(count == 6) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
						end	
						//####################
						else if(count == 12) begin //data coming
							listen<= 1;
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101;
							A[9:0] <= addr[9:0] + 8; //col addr
							A[10] <= 1; //auto precharge //####################
							BA <= addr[11:10];
						end
						else if(count == 13) begin 
							RETURN_put <= 1; /// found that there is setuptime vialation when put in this clock
							listen<= 0;		//we reduced one clkbuff
						end
						else if(count == 14) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
						end	
						else if(count == 21) begin //####################
							 listen<= 1;	
						end
						else if(count == 22) begin //####################
							listen<= 0;	
						end
						else if (count == 20 +8) begin //####################
							CMD_get <= 1; // point to next cmd
						end
						else if(count == 21+8) begin //####################
							RETURN_put <= 0; //close
							count <= 0 ;
							state <= idle;
							CMD_get <= 0; //
							Pointer <= Pointer+1;
						end	
						
						// addr ++ ptr++
						if (count >13 && count < 21+8) begin //####################
							addr <= addr+1;
							Pointer <= Pointer+1;
						end
					end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////					
					else if (size == 2) begin
						if(count == 4) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101;  //read
							A[9:0] <= addr[9:0]; //col addr  
							A[10] <= 0; //auto precharge //####################
							BA <= addr[11:10];
						end
						else if(count == 6) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
						end	
						//####################
						else if(count == 12) begin //data coming
							listen<= 1;
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101; //read
							A[9:0] <= addr[9:0] + 8; //col addr
							A[10] <= 0; //auto precharge //####################
							BA <= addr[11:10];
						end
						else if(count == 13) begin 
							RETURN_put <= 1; /// found that there is setuptime vialation when put in this clock
							listen<= 0;		//we reduced one clkbuff
						end
						else if(count == 14) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
						end	
						else if(count == 20) begin //####################
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101;  //read
							A[9:0] <= addr[9:0] +10; //from the wave form  
							A[10] <= 1; //auto precharge //####################
							BA <= addr[11:10];	
						end
						else if(count == 21) begin //####################
							 listen<= 1;	//second listen pulse
						end
						else if(count == 22) begin //####################
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
							listen<= 0;	
						end
						else if(count == 21+8) begin //####################
							 listen<= 1;	//third listen pulse
						end
						else if(count == 22+8) begin //####################
							 listen<= 0;	
						end
						else if (count == 20 +16) begin //####################
							CMD_get <= 1; // point to next cmd
						end
						else if(count == 21+16) begin //####################
							RETURN_put <= 0; //close
							count <= 0 ;
							state <= idle;
							CMD_get <= 0; //
							Pointer <= Pointer+1;
						end	
						
						// addr ++ ptr++
						if (count >13 && count < 21+16) begin //####################
							addr <= addr+1;
							Pointer <= Pointer+1;
						end
					end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////					
					else if (size == 3) begin
						if(count == 4) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101;  //read
							A[9:0] <= addr[9:0]; //col addr  
							A[10] <= 0; //auto precharge //####################
							BA <= addr[11:10];
						end
						else if(count == 6) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
						end	
						//####################
						else if(count == 12) begin //data coming
							listen<= 1;
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101; //read
							A[9:0] <= addr[9:0] + 8; //col addr
							A[10] <= 0; //auto precharge //####################
							BA <= addr[11:10];
						end
						else if(count == 13) begin 
							RETURN_put <= 1; /// found that there is setuptime vialation when put in this clock
							listen<= 0;		//we reduced one clkbuff
						end
						else if(count == 14) begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
						end	
						else if(count == 20) begin //####################
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101;  //read
							A[9:0] <= addr[9:0] +10; //from the wave form  
							A[10] <= 0; //auto precharge //####################
							BA <= addr[11:10];	
						end
						else if(count == 21) begin //####################
							 listen<= 1;	//second listen pulse
						end
						else if(count == 22) begin //####################
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
							listen<= 0;	
						end
						else if(count == 20+8) begin //####################
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101;  //read
							A[9:0] <= addr[9:0] +10; //from the wave form  
							A[10] <= 1; //auto precharge //####################
							BA <= addr[11:10];	
						end
						
						else if(count == 21+8) begin //####################
							 listen<= 1;	//third listen pulse
						end
						else if(count == 22+8) begin //####################
							 {cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;// NOP command
							 listen<= 0;	
						end
						else if(count == 21+8+8) begin //####################
							 listen<= 1;	//third listen pulse
						end
						else if(count == 22+8+8) begin //####################
							 listen<= 0;	
						end
						else if (count == 20 +24) begin //####################
							CMD_get <= 1; // point to next cmd
						end
						else if(count == 21+24) begin //####################
							RETURN_put <= 0; //close
							count <= 0 ;
							state <= idle;
							CMD_get <= 0; //
							Pointer <= Pointer+1;
						end	
						
						// addr ++ ptr++
						if (count >13 && count < 21+24) begin //####################
							addr <= addr+1;
							Pointer <= Pointer+1;
						end
					end
				end
			end
			
			
			default: begin
				state <= idle;
			end
		
		endcase
	
	end
end

assign RETURN_address = addr; //+ Pointer;// when block write, addr+Pointer

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
