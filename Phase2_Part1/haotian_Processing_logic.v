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
   parameter CL = 3'b011;  // CAS Latency (CL) = 3
   parameter AL = 3'b001;  // Posted CAS# Additive Latency (AL) = 1

//  read timing
    parameter tRCD = 4'b0110; //6 clocks row to column latency
    parameter tCK = 2'b10; // 2 clocks for tCK
    parameter tACT = 1;
    parameter tNOP1 = tCK+tACT; // time issue the nop after activate
    parameter tREAD = tRCD-(AL*2)+tACT;// time issue read command
    parameter tNOP2 = tREAD+2;// time issue nop after read
    parameter tLISTEN = tNOP2+CL*2;// time issue listen
    parameter tDQr = tLISTEN+1; // time DQ will arrive we can read from denila

// write timing
//  parameter tACT = 1; //time issue act command
    parameter tNOP3 = tCK+tACT;  // time issue nop after activate 3
    parameter tWRITE = tRCD-(AL*2)+tACT; // time issue write command 5
    parameter tNOP4 = tWRITE+2;  // time issue nop after write command 7 
    parameter tDQw=tACT+tWRITE+(AL+CL-1)*2-1; // time DQ will arrive we can write to denila 11 

/*
// refresh
    parameter Refresh_Max = 2800; //The Max interval of refresh command
    parameter Refresh_tRFC = 42; // The time refresh command will take
*/

//state
   parameter  init = 4'b0000,   idle = 4'b0001,   fetch = 4'b0010, precharge = 4'b0011, 
              refresh=4'b0100,  scalarRead = 4'b0101, scalarWrite = 4'b0111,
              blockRead = 4'b1000, blockWrite = 4'b1001;

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

   reg [2:0] Pointer;
   reg [3:0] state;
   reg [6:0] count_rd;
   reg [6:0] count_wr;
   reg [24:0] rd_addr;
   reg [24:0] wr_addr;
   /*
   reg [12:0] refresh_count; //count interval of each refresh 
   reg [5:0] refresh_Tcount;  // count refresh command time 
   */
always @(posedge clk)
    if(reset) begin
        CMD_get <= 0;
        DATA_get <= 0;
        RETURN_put <= 0;
        {cs_bar,ras_bar,cas_bar,we_bar} <=  {1'b0,1'b1,1'b1,1'b1}; //NOP
        state <= init;
        listen <= 0;
        Pointer <= 0;
        count_rd <= 0;
        count_wr <= 0;
        DQS_out <= 0;
        ts_con <= 0;
        DM_flag <= 0;
        /*
        refresh_count <= 0;
        refresh_Tcount <= 0;
        */
	end
    else begin
        case(state) 
            init: begin
                state<= ready? idle:init;
            end

            idle: begin
                /*
                refresh_count <= refresh_count+1;
                if(refresh_count==Refresh_Max) begin
                    state <= refresh;
                end
                */
                DATA_get <= 0;
                if(CMD_empty==1) begin
                    state <= idle;
                end
                else begin
                    state <= fetch;
                end

            end

            fetch: begin
                /*
                refresh_count <= refresh_count +1;
                if(refresh_count==Refresh_Max) begin
                    state <= refresh;
                end
                */
                // NOP or RETURN FIFO full stay in fetch state
               
                if(CMD_data_out[7:5]==3'b000 || RETURN_full==1) begin 
                    state <= fetch;
                end
                //Command scalarRead, state to scalarRead
                else if(CMD_data_out[7:5] == 3'b001) begin
                    state <= scalarRead;
                    rd_addr <= CMD_data_out[32:8]; // store the address want to read
                    CMD_get <= 1;
                end
                //Command scalarWrite, state to scalarWrite
                else if(CMD_data_out[7:5] == 3'b010) begin
                    state <= scalarWrite;
                    wr_addr <= CMD_data_out[32:8];// store the address want to write
                    CMD_get <= 1;
                end
            end
            /*
            refresh: begin
                refresh_count <= 0;
                {cs_bar,ras_bar,cas_bar,we_bar} <= {1'b0,1'b0,1'b0,1'b1}; //refresh command
                if(refresh_Tcount==2) begin
                    {cs_bar,ras_bar,cas_bar,we_bar} <= {1'b0,1'b1,1'b1,1'b1}; // NOP
                end
                
                //refresh finish go to idle state else stay in refresh state
                if(refresh_Tcount>=Refresh_tRFC) begin
                    refresh_Tcount <= 0;
                    state <= idle;
                end
                else begin
                    refresh_Tcount <= refresh_Tcount+1;
                    state <= refresh;
                end
            end
            */

            scalarRead: begin
              
                //bank active
                CMD_get <= 0;
                if(count_rd==tACT) begin //1
                    {cs_bar,ras_bar,cas_bar,we_bar} <= {1'b0,1'b0,1'b1,1'b1}; //bank active
                    A <= rd_addr[24:12];
                    BA <= rd_addr[11:10];
                end

                //after tCK send NOP
                else if(count_rd==tNOP1) begin //3
                    {cs_bar,ras_bar,cas_bar,we_bar} <= {1'b0,1'b1,1'b1,1'b1}; // NOP
                end

                //after tRCD-AL send read
                else if(count_rd==tREAD) begin  //
                    {cs_bar,ras_bar,cas_bar,we_bar} <= {1'b0,1'b1,1'b0,1'b1}; // Read Operation
                    A[9:0] <= rd_addr[9:0]; //column address
                    A[10] <= 1; //auto precharge 
                end

                //after tCK send NOP
                else if(count_rd==tNOP2) begin
                    {cs_bar,ras_bar,cas_bar,we_bar} <= {1'b0,1'b1,1'b1,1'b1}; // NOP
                end

                //after tRCD+CL-1, send listen 
                else if(count_rd==tLISTEN) begin
                    listen <= 1;
                end

                //after tRCD+CL, dq will be available, set Pointer to point to the first element, 
                //set tscon to receive data from denila
                else if(count_rd==tDQr) begin
                    Pointer <= 0;
                    ts_con <= 0;
                end

                else if(count_rd==tDQr+1) begin
                    listen <= 0;
                end

                if(count_rd==tDQr+BL+1) begin
                    RETURN_address <= rd_addr;
                end

                //when all the data has been latched, return data and address to return FIFO
                if(count_rd==tDQr+BL+2) begin
                    RETURN_put <= 1;
                    count_rd <= count_rd+1;
                end

                if(count_rd==tDQr+BL+3) begin
                    RETURN_put <= 0;
                    state <= idle;
                    count_rd <= 0;
                end
                //keep state in scalarRead , keep counting the clk if not finish
                if(count_rd<=tDQr+BL+1) begin
                    state <= scalarRead;
                    count_rd <= count_rd +1;
                end
            end

     
            scalarWrite: begin
               ts_con <= 1;
               CMD_get <= 0;
               //bank active
                if(count_wr==tACT) begin //1
                    {cs_bar,ras_bar,cas_bar,we_bar} <= {1'b0,1'b0,1'b1,1'b1};  //bank active
                    A <= wr_addr[24:12];
                    BA <= wr_addr[11:10];
                end

                //after tCK send NOP1
                else if(count_wr==tNOP3) begin //3
                    {cs_bar,ras_bar,cas_bar,we_bar} <= {1'b0,1'b1,1'b1,1'b1}; // NOP
                end

                //after tRCD-AL send WRITE
                else if(count_wr==tWRITE) begin //5
                    {cs_bar,ras_bar,cas_bar,we_bar} <= {1'b0,1'b1,1'b0,1'b0}; // Write Operation
                    A[9:0] <= wr_addr[9:0]; //column address
                    A[10] <= 1; //auto precharge
                end 

                //after tCK send NOP2
                else if(count_wr==tNOP4) begin //7 
                    {cs_bar,ras_bar,cas_bar,we_bar} <= {1'b0,1'b1,1'b1,1'b1}; //NOP
                end


                //after tRCD+(CL-1) dq will be availbe to write into denila, set ts_con to tell denila receive data
                else if(count_wr==tDQw) begin //11
                    DM_flag <= 1;
                end

                else if(count_wr==tDQw+1) begin //12
                    DM_flag <= 0;
                end

                //generate the DQS signal
                if(count_wr>=tDQw+1 && count_wr< tDQw+BL+1) begin //13 - 21
                    DQS_out[0] <= ~DQS_out[0];
                    DQS_out[1] <= ~DQS_out[1];
                end

                //control the state
                if(count_wr<(tDQw+BL+14)) begin
                    state <= scalarWrite;
                    count_wr <= count_wr+1;
                end
                else if(count_wr>=(tDQw+BL+14)) begin
                    state <= idle;
                    count_wr <= 0;
                    DATA_get <= 1;
                    DQS_out <= 0;
                end 
            end 
        
        endcase
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
