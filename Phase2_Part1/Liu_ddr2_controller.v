



module ddr2_controller(
   // Outputs
   dout, raddr, fillcount, empty, ready, ck_pad, ckbar_pad,
   cke_pad, csbar_pad, rasbar_pad, casbar_pad, webar_pad, ba_pad,
   a_pad, dm_pad, odt_pad,validout,
   // Inouts
   dq_pad, dqs_pad, dqsbar_pad,
   // Inputs
   clk, reset, read, cmd, din, addr, initddr, op,sz
   );
   
///////////////////////////////task1: determine the parameters ///////////////////////////////////////
   parameter BL = 8; // Burst Lenght = 4
   parameter BT = 0;   // Burst Type = Sequential
   parameter CL = 4;  // CAS Latency (CL) = 4
   parameter AL = 4;  // Posted CAS# Additive Latency (AL) = 4
/////////////////////////////////////////////////////////////////////////////////////////////////////

   input 	 clk;
   input 	 reset;
   input 	 read;
   input [2:0] cmd;
   input [15:0] din;
   input [24:0] addr;
   output [15:0] dout;
   output [24:0] raddr;
   output [6:0]  fillcount;
   output 		 empty;
   input 		 initddr;
   output 		 ready;

   output 		 ck_pad;     //the outputs of SSTL18DDR2INTERFACE. it connects to the DDR2
   output 		 ckbar_pad;
   output 		 cke_pad;
   output 		 csbar_pad;
   output 		 rasbar_pad;
   output 		 casbar_pad;
   output 		 webar_pad;
   output [1:0]  ba_pad;
   output [12:0] a_pad;
   inout [15:0]  dq_pad;
   inout [1:0] 	 dqs_pad;
   inout [1:0] 	 dqsbar_pad;
   output [1:0]  dm_pad;
   output 		 odt_pad;
   
   //add more signals
   input[1:0] sz;
   input[2:0] op;
   output validout;
   
   reg validout;

  
   /*autowire*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [15:0]		dataOut;				// From XDFIN of fifo.v
   wire [15:0]			dq_o;					// From XSSTL of SSTL18DDR2INTERFACE.v
   wire [1:0]			dqs_o;					// From XSSTL of SSTL18DDR2INTERFACE.v
   wire [1:0]			dqsbar_o;				// From XSSTL of SSTL18DDR2INTERFACE.v
   wire					data_empty;				// From XDFIN of fifo.v
   wire [5:0]	CMD_fillcount, RETURN_fillcount;		// From XDFIN of fifo.v
	wire [6:0]	fillcount;
   wire					full;				// From XDFIN of fifo.v
   // End of automatics
   
   wire 		 ri_i;					//the inputs of SSTL18DDR2INTERFACE
   wire 		 ts_i;   
   reg 		 ck_i;
   wire 		 cke_i;
   wire 		 csbar_i;
   wire 		 rasbar_i;
   wire 		 casbar_i;
   wire 		 webar_i;
   wire [1:0] 	 ba_i;
   wire [12:0] 	 a_i;
   wire [15:0] 	 dq_i;
   wire [1:0] 	 dqs_i;
   wire [1:0] 	 dqsbar_i;
   wire [1:0] 	 dm_i;
   wire 		 odt_i;


   reg ck;
   
   wire csbar, init_csbar;
   wire rasbar, init_rasbar;
   wire casbar, init_casbar;
   wire webar, init_webar;
   wire[1:0] ba, init_ba;
   wire[12:0] a,init_a;
   wire[1:0] dm, init_dm;
   wire init_cke;
   wire ri_con;
   wire ts_con;
   
   wire [32:0] CMD_data_in, CMD_data_out;
   wire [40:0] RETURN_data_in, RETURN_data_out;
   wire CMD_empty, CMD_full, RETURN_empty, RETURN_full;
   wire  IN_get,  CMD_get, RETURN_put,CMD_put;
   wire IN_put, RETURN_get;
   
   reg[4:0] blw_counter;
   reg blw_flag;
   

   // CK divider
   always @(posedge clk) 
       if(reset==1)
	       ck_i <= 0;
	   else
	       ck_i <= ~ck_i;  // 250 MHz Clock

	assign CMD_data_in = {addr,cmd,sz,op};
	assign IN_put = ((cmd==3'b010 || cmd == 3'b100 || blw_flag == 1)&& full != 1 && CMD_full !=1)? 1:0;
	assign CMD_put = ((cmd==3'b010 || cmd == 3'b001 || cmd == 3'b011 || cmd == 3'b100) && (CMD_full !=1))? 1:0;
	assign RETURN_get = (RETURN_empty!=1 &&  read == 1'b1)? 1:0;
	//assign validout = (RETURN_empty!=1 || (RETURN_empty==1 && RETURN_put == 1'b1 && read==1'b1))? 1:0;
	
	assign empty=~CMD_full;
	
	assign raddr=RETURN_data_out[40:16];
	assign dout=RETURN_data_out[15:0];
	
	always @(posedge clk)
	begin
		//validout <= (RETURN_empty!=1 || (RETURN_empty==1 && RETURN_put == 1'b1 && read==1'b1));
		validout <= (RETURN_empty != 1'b1);

	end
	
	always @(posedge clk)
	begin
		if(reset==1)
			begin
				blw_counter <= 0;
				blw_flag <= 0;
			end
		else
			begin
				if (cmd == 3'b100 && blw_flag == 0 && full != 1)
					begin
						blw_flag <= 1;
						if (sz == 2'b00)
							begin
								blw_counter <= 7;
							end
						else if (sz == 2'b01)
							begin
								blw_counter <= 15;
							end
						else if (sz == 2'b10)	
							begin
								blw_counter <= 23;
							end
						else if (sz == 2'b11)
							begin
								blw_counter <= 31;
							end
					end
				else if (blw_flag == 1 && blw_counter > 0 && full != 1)
					begin
						if (blw_counter > 1)
							blw_counter <= blw_counter - 1;
						else if(blw_counter == 1)
							begin
								blw_counter <= 0;
								blw_flag <= 0;
							end
					end
			end
	end
//Prcessing logic
	Processing_logic Processing(
								//output
								.DATA_get			(IN_get),
								.CMD_get			(CMD_get),
								.RETURN_put			(RETURN_put),
								.RETURN_address		(RETURN_data_in[40:16]),
								.RETURN_data		(RETURN_data_in[15:0]),
								.cs_bar				(csbar),
								.ras_bar			(rasbar),
								.cas_bar			(casbar),
								.we_bar				(webar),
								.BA					(ba),
								.A					(a),
								.DM					(dm),
								.DQS_out			(dqs_i),
								.DQ_out				(dq_i),
								.ts_con				(ts_con),
								
								//inputs
								.clk				(clk),
								.ck					(ck_i),
								.reset				(reset),
								.ready				(ready),
								.CMD_empty			(CMD_empty),
								.CMD_data_out		(CMD_data_out),
								.DATA_data_out		(dataOut),
								.RETURN_full		(RETURN_full),
								.DQS_in				(dqs_o),
								.DQ_in				(dq_o)
								);

///////////////////////////////task2: determine the FIFO connections ///////////////////////////////////
 // Input data FIFO
   FIFO #(.DEPTH_P2(6),.WIDTH(16)) FIFO_IN (/*autoinst*/
						  .clk					(clk),
						  .reset				(reset),
						  .data_in              (din),
						  .put  				(IN_put),
						  .get					(IN_get), //the output of processing_logic
						  //outputs
						  .data_out				(dataOut),
						  .empty			    (data_empty),
	  		   		      .full			     	(full),
						  .fillcount			(fillcount)
						  ); 
// Command FIFO						  
      FIFO #(.DEPTH_P2(5),.WIDTH(33)) FIFO_CMD (/*autoinst*/
						  .clk					(clk),
						  .reset				(reset),
						  .data_in              (CMD_data_in),
						  .put  				(CMD_put),
						  .get					(CMD_get),
						  //outputs
						  .data_out				(CMD_data_out),
						  .empty			    (CMD_empty),
	  		   		      .full			     	(CMD_full),
						  .fillcount			(CMD_fillcount)
						  ); 
// Return DATA and address FIFO	
	   FIFO #(.DEPTH_P2(5),.WIDTH(41)) FIFO_RETURN (/*autoinst*/
						  .clk					(clk),
						  .reset				(reset),
						  .data_in              (RETURN_data_in),
						  .put  				(RETURN_put),
						  .get					(RETURN_get),
						  .data_out				(RETURN_data_out),
						  .empty			    (RETURN_empty),
	  		   		      .full			     	(RETURN_full),
						  .fillcount			(RETURN_fillcount)
						  ); 
						  
/////////////////////////////////////////////////////////////////////////////////////////////////////
   
   // DDR2 Initialization engine
   ddr2_init_engine XINIT (
						   // Outputs
						   .ready				(ready),
						   .csbar				(init_csbar),
						   .rasbar				(init_rasbar),
						   .casbar				(init_casbar),
						   .webar				(init_webar),
						   .ba					(init_ba[1:0]),
						   .a					(init_a[12:0]),
						   //.dm					(init_dm[1:0]),
						   .odt					(init_odt),
						   .ts_con				(init_ts_con),
						   .cke                 (init_cke),
						   // Inputs
						   .clk					(clk),
						   .reset				(reset),
						   .init				(initddr),
						   .ck					(ck_i)		   );


   // Output Mux for control signals
   assign 		 a_i 	  = (ready) ? a      : init_a;
   assign 		 ba_i 	  = (ready) ? ba     : init_ba;

   assign 		 csbar_i  = (ready) ? csbar  : init_csbar;
   assign 		 rasbar_i = (ready) ? rasbar : init_rasbar;
   assign 		 casbar_i = (ready) ? casbar : init_casbar;
   assign 		 webar_i  = (ready) ? webar  : init_webar;

   assign 		 cke_i 	  = init_cke;
   assign 		 odt_i 	  = init_odt;
   
   assign ri_con = 1;
   assign ri_i = ri_con;
   assign		dm_i	= (ready)? dm:init_dm;
	assign ts_i = (ready)?ts_con:init_ts_con;

   

   SSTL18DDR2INTERFACE XSSTL (/*autoinst*/
							  // Outputs
							  .ck_pad			(ck_pad),
							  .ckbar_pad		(ckbar_pad),
							  .cke_pad			(cke_pad),
							  .csbar_pad		(csbar_pad),
							  .rasbar_pad		(rasbar_pad),
							  .casbar_pad		(casbar_pad),
							  .webar_pad		(webar_pad),
							  .ba_pad			(ba_pad[1:0]),
							  .a_pad			(a_pad[12:0]),
							  .dm_pad			(dm_pad[1:0]),
							  .odt_pad			(odt_pad),
							  .dq_o				(dq_o[15:0]),
							  .dqs_o			(dqs_o[1:0]),
							  .dqsbar_o			(dqsbar_o[1:0]),
							  // Inouts
							  .dq_pad			(dq_pad[15:0]),
							  .dqs_pad			(dqs_pad[1:0]),
							  .dqsbar_pad		(/*dqsbar_pad[1:0]*/),
							  // Inputs
							  .ri_i				(ri_i),
							  .ts_i				(ts_i),
							  .ck_i				(ck_i),
							  .cke_i			(cke_i),
							  .csbar_i			(csbar_i),
							  .rasbar_i			(rasbar_i),
							  .casbar_i			(casbar_i),
							  .webar_i			(webar_i),
							  .ba_i				(ba_i[1:0]),
							  .a_i				(a_i[12:0]),
							  .dq_i				(dq_i[15:0]),
							  .dqs_i			(dqs_i[1:0]),
							  .dqsbar_i			(/*dqsbar_i[1:0]*/),
							  .dm_i				(dm_i[1:0]),
							  .odt_i			(odt_i));




   
   
endmodule // ddr2_controller
