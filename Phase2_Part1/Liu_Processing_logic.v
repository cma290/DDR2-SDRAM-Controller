module Processing_logic(
   // Outputs
   DATA_get, 
   CMD_get,
   RETURN_put, 
   RETURN_address, RETURN_data,  //construct RETURN_data_in
   cs_bar, ras_bar, cas_bar, we_bar,  // read/write function
   BA, A, DM,
   DQS_out, DQ_out,
   ts_con,

   // Inputs
   clk, ck, reset, ready, 
   CMD_empty, CMD_data_out, DATA_data_out,
   RETURN_full,
   DQS_in, DQ_in
   );

   parameter BL = 4'b1000; // Burst Lenght = 8
   parameter BT = 1'b0;   // Burst Type = Sequential
   parameter CL = 3'b100;  // CAS Latency (CL) = 4
   parameter AL = 3'b100;  // Posted CAS# Additive Latency (AL) = 4

   
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
   wire[2:0] CMD;
   reg[2:0] Pointer;
   reg[6:0] state;
   reg[5:0] count;
   reg[15:0] refresh_count;
   reg[5:0] ref_ref_count;  
   reg idle_flag;
   reg idle_count;
   //----------------phase2part2 signals-----------------------//
   wire[1:0] sz;
   reg[1:0] block_count; //sz=00:block_counter=0;sz=01:block_counter=1; sz=10:block_counter=2;sz=11:block_counter=3;
   reg[2:0] CMD_saved;
   reg[1:0] sz_saved;
   reg blr_start;
   //------------------------------------------------------------//
   
   parameter IDLE=7'b0000001, ACT=7'b0000010, SCR=7'b0000100,SCW=7'b0001000,REF=7'b0010000,BLR=7'b0100000,BLW=7'b1000000;
   parameter max_refresh_count = 3906;
   parameter min_ref_ref_count = 53; //refresh-to-active or to refresh interval, 512Mb=105ns
assign CMD = CMD_data_out[7:5];
//--------------------phase2part2 assignment---------------------//
assign sz=CMD_data_out[4:3];
//---------------------------------------------------------------//

always @(posedge clk)
begin
    if(reset)
	  begin
	    CMD_get <= 0;
		DATA_get <= 0;
		RETURN_put <= 0;
		{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111; //when reset, no operation(NOP)		
		DM_flag <= 1'b0;
		DQS_out <=0;
		ts_con <= 1'b1;  //to send NOP
		
		state <= IDLE;
		count <= 0;		
		refresh_count <=0;
		ref_ref_count <=0;
		listen <= 1'b0;
		idle_flag <=1'b0;
		idle_count <= 1'b0;
		//---------------part2-------------------//
		block_count <= 2'b00;
		CMD_saved <= 3'b000;
		sz_saved <= 2'b00;
		blr_start <= 1'b0;
		//----------------------------------------//
		
	  end
	else
		begin
		if(ready==1'b1)
		begin
		refresh_count <= refresh_count + 1;
		case(state)
		IDLE:	begin
					ts_con <= 1'b1;
					RETURN_put <= 1'b0;
					//if((refresh_count < max_refresh_count) && (ready == 1'b1) && (CMD_empty!=1'b1) && (done == 1'b1) &&((CMD==3'b001 && RETURN_full !=1'b1)||CMD==3'b010)) //ready:finish initialization; done: finish read or write
						if(refresh_count < max_refresh_count && block_count == 0) //the first 8 words
							begin 
								if((ready == 1'b1) && (CMD_empty!=1'b1))
									begin
										if(idle_flag == 1'b0)
											begin
												CMD_get <= 1'b1;
												count <= 0;
												idle_count <= idle_count + 1;
											end
									end
								if(idle_count == 1)
									begin
										idle_flag <=1'b1;
										CMD_get <= 1'b0;
										idle_count <= 0;
									end
								if(idle_flag == 1)
									begin
										idle_flag <= 1'b0;
										state <=ACT;
										CMD_saved <= CMD;  //part2
										sz_saved <= sz;
										block_count <= block_count + 1;     //when the first 8 words comes to act, block_count = 1;
										if(CMD == 3'b010 || CMD == 3'b100)  //part2 SCW || BLW
											begin
												DATA_get <= 1'b1;
											end
						 			end
						 end
						if ((refresh_count < max_refresh_count) && (block_count !=0))  //BLW/BLR
							begin
								state <= ACT;
								if(CMD_saved == 3'b100)		//BLW
									begin
										DATA_get <= 1'b1;
									end
								if(block_count == sz_saved)
									block_count <= 0;
								else
									block_count <= block_count + 1;
							end
						if(refresh_count >= max_refresh_count)
							begin
								if(ck==1)
									begin
										{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0001;//REFRESH
									end
								if (ck==0 && {cs_bar, ras_bar, cas_bar, we_bar} == 4'b0001)
									begin
										ref_ref_count <= 0;
										state <= REF;
									end

							end
					end

		ACT:	begin
					CMD_get <= 1'b0;
					DATA_get <= 1'b0;
					A <= CMD_data_out[32:20];		//row address
					BA <= CMD_data_out[19:18];    //select bank

						
					if(ck==1)          //The command gives to DDR at the negative edge of ck,then hold 1 clk.
						begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0011; //active(select bank and active row)
							count <= count + 1;
						end
					else if(ck==0 && count == 1)
						begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0011;
							if(CMD == 3'b001) state <= SCR;  //scalar read
							if (CMD == 3'b010) state <= SCW;  //scalar write
							if (CMD == 3'b011) state <= BLR;  //block read
							if (CMD == 3'b100) state <= BLW;   //block write
							count <= count + 1;
						end
					else
						{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;//nop
				end
				
		REF:	begin
					refresh_count <= 0;
					ref_ref_count <= ref_ref_count + 1;
					if(ref_ref_count ==0)
						begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111;//NOP
						end
					if(ref_ref_count == min_ref_ref_count)
						begin
							state <= IDLE;
							ref_ref_count <= 0;
						end
				end
				
		SCR:	begin
					count <= count + 1;
					if (count == 2)
						begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101; //read(select bank and column, and start read burst)
							BA <= CMD_data_out[19:18];			// bank address
							A[10:0] <= {1'b1,CMD_data_out[17:8]}; //column address					
						end
					if (count == 2+ 1*2)
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111; //NOP
					if (count == 2+2*(AL+CL)-1)   //17
						begin
							listen <= 1'b1;
						end
					if(count == 2+2*(AL+CL))	
						begin
							ts_con <=1'b0;  //18
						end
					if (count == 2 + 2*(AL+CL)+1) //19
						begin
							listen <= 1'b0;
						end
					if (count == 2+ 2*(AL + CL)+2) //20
						begin
							Pointer <= 3'b000;
						end
					if (count >= 2+2*(AL+CL)+BL+1)  //27
						begin
							if(RETURN_full !=1'b1)
								begin
									RETURN_put <= 1'b1;
									RETURN_address <= CMD_data_out[32:8];
									state <= IDLE;
									block_count <= 0;  //part2
								end
						end
				end
		
		SCW:	begin
					count <= count + 1;
					if(count == 2)
						begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100; //write(select bank and column, and start read burst)
							BA <= CMD_data_out[19:18];			// bank address
							A[10:0] <= {1'b1,CMD_data_out[17:8]}; //column address				
						end
					if(count == 2 + 1*2)
						begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111; //NOP
							DQS_out <= 2'b00;
						end
					if(count == 2+2*(AL+CL-1))	//16
						begin
							//ts_con <=1'b1;
							DM_flag <= 1'b1;
		
						end
					if(count == 2+2*(AL+CL-1)+1) //17
						begin
							DM_flag <= 1'b0;
						end
					if((count>=2+2*(AL+CL-1)+1) && (count <= 2+2*(AL+CL-1)+BL+1))  //17~25  create the strobe:4 ck
						begin
							DQS_out[0] <= ~DQS_out[0];
							DQS_out[1] <= ~DQS_out[1];
						end
					//if(count == 2+2*(AL+CL-1)+BL+1)  //25
					//	begin
					//		ts_con <= 1'b0;
					//	end
					if(count == 2+2*(AL+CL-1)+BL+2)	DQS_out <= 2'b00;  //25
						
					if(count >= (2+2*(AL+CL-1)+BL+2+8+8-5)) // p107  2+2*(AL+CL-1)+2+BL+2*WR+2*RP-3(IDLE)-2(ACT)=2+14+2+8+8+8-3-2=37
						begin
							state <= IDLE;
							block_count <= 0;
						end
				end
		
		BLR:	begin
					count <= count + 1;
					if (count == 2)
						begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0101; //read(select bank and column, and start read burst)
							BA <= CMD_data_out[19:18];			// bank address							
							//A[10:0] <= {1'b1,CMD_data_out[17:8]}; //column address
							A[10]<=1'b1;   //auto-precharge
							if(block_count >=1 && block_count <= 3)    //column address
								begin
									A[9:0] <=CMD_data_out[17:8]+BL*(block_count - 1);
								end
							if(block_count == 0)
								begin	
									A[9:0] <= CMD_data_out[17:8] + BL*3;
								end
						end
					if (count == 2+ 1*2)
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111; //NOP
					if (count == 2+2*(AL+CL)-1)   //17
						begin
							listen <= 1'b1;
						end
					if(count == 2+2*(AL+CL))	
						begin
							ts_con <=1'b0;  //18
						end
					if (count == 2 + 2*(AL+CL)+1) //19
						begin
							listen <= 1'b0;
						end
					if (count == 2+ 2*(AL + CL)+2) //20
						begin
							Pointer <= 3'b000;
							blr_start <= 1'b1;
						end
					if (blr_start == 1'b1)
						begin
							if(RETURN_full != 1'b1)
								begin
									//Pointer <= Pointer + 1;
									RETURN_put <= 1'b1;
									RETURN_address <={CMD_data_out[32:18],(A[9:0]+Pointer)};
									if(Pointer < 3'b111)
										Pointer <= Pointer + 1;
									else
										begin
											Pointer <= 3'b000;
											blr_start <= 1'b0;
											state <= IDLE;
										end
									
								end
							else
								RETURN_put <= 1'b0;
						end

				end
				
		BLW:	begin
					count <= count + 1;
					if(count == 2)
						begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0100; //write(select bank and column, and start read burst)
							BA <= CMD_data_out[19:18];			// bank address
							//A[10:0] <= {1'b1,CMD_data_out[17:8]}; //column address
							A[10]<=1'b1;   //auto-precharge
							if(block_count >=1 && block_count <= 3)    //column address
								begin
									A[9:0] <=CMD_data_out[17:8]+BL*(block_count - 1);
								end
							if(block_count == 0)
								begin	
									A[9:0] <= CMD_data_out[17:8] + BL*3;
								end
						end
					if(count == 2 + 1*2)
						begin
							{cs_bar, ras_bar, cas_bar, we_bar} <= 4'b0111; //NOP
							DQS_out <= 2'b00;
						end
					if(count == 2+2*(AL+CL-1))	//16
						begin
							//ts_con <=1'b1;
							DM_flag <= 1'b1;
		
						end
					//if(count == 2+2*(AL+CL-1)+1) //17
						//begin
						//	DM_flag <= 1'b0;
						//end
					if((count>=2+2*(AL+CL-1)+1) && (count <= 2+2*(AL+CL-1)+BL+1))  //17~25  create the strobe:4 ck
						begin
							DQS_out[0] <= ~DQS_out[0];
							DQS_out[1] <= ~DQS_out[1];
						end
				    if((count >= 2+2*(AL+CL-1)) && (count <= 2+2*(AL+CL-1)+BL-2))   //16~22
						DATA_get <= 1'b1;
					if (count == 2+2*(AL+CL-1)+BL-2 + 1)  //23
						DATA_get <= 1'b0;
					if (count == 2+2*(AL+CL-1)+BL)  //24
						DM_flag <= 1'b0;
					if(count == 2+2*(AL+CL-1)+BL+1)	DQS_out <= 2'b00;  //25
						
					if(count >= (2+2*(AL+CL-1)+BL+2+8+8-3)) // p107  2+2*(AL+CL-1)+2+BL+2*WR+2*RP-3(IDLE)-2(ACT)=2+14+2+8+8+8-3-2=37
						begin
							state <= IDLE;
						end
				end
		default: state <= IDLE;
		endcase
		end
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
