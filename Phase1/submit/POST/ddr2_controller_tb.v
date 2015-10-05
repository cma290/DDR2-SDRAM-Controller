`timescale 1ns/1ps
module tb;

reg clk, reset;
reg read;
reg[2:0] cmd;
reg[15:0] din;
reg[24:0] addr;
reg initddr;

wire [15:0] dout;
wire [24:0] raddr;
wire [6:0] fillcount;
wire notfull, ready, ck_pad, ckbar_pad, cke_pad, csbar_pad, rasbar_pad, casbar_pad, webar_pad;
wire [1:0] ba_pad;
wire [12:0] a_pad; 
wire [1:0] dm_pad;
wire odt_pad;
wire [15:0] dq_pad;
wire [1:0] dqs_pad, dqsbar_pad;


// Instantiate the DDR2 Controller Module

ddr2_controller DUT(
   // Outputs
   dout, raddr, fillcount, notfull, ready, ck_pad, ckbar_pad,
   cke_pad, csbar_pad, rasbar_pad, casbar_pad, webar_pad, ba_pad,
   a_pad, dm_pad, odt_pad,
   // Inouts
   dq_pad, dqs_pad, dqsbar_pad,
   // Inputs
   clk, reset, read, cmd, din, addr, initddr
   );
							
mt47h32m16_37e XDDR0 (.ck(ck_pad),
					  .ckbar(ckbar_pad),
					  .cke(cke_pad),
					  .csbar(csbar_pad),
					  .rasbar(rasbar_pad),
					  .casbar(casbar_pad),
					  .webar(webar_pad),
					  .ba(ba_pad),
					  .a(a_pad),
					  .dq(dq_pad),
					  .dqs(dqs_pad),
					  .dqsbar(dqsbar_pad),
					  .dm(dm_pad),
					  .odt(odt_pad));

always #1.3 clk= ~clk; // 500MHz (define clocks)

//inputs for starting initialization engine.
initial
	begin
		clk = 0; 
		reset=1; 
		initddr = 0;
		#20
		reset = 0;
		#50	
///////////////////////////////task: complete the testbench///////////////////////////////////////


		initddr = 1;    // start the initialization

		wait (ready == 1);   // how to determine initialization completed?

///////////////////////////////////////////////////////////////////////////////////////////////////
		$finish;
	end
	
endmodule