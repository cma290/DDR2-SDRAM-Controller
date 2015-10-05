module SSTL18DDR2INTERFACE(/*autoarg*/
						   // Outputs
						   ck_pad, ckbar_pad, cke_pad, csbar_pad, rasbar_pad, casbar_pad,
						   webar_pad, ba_pad, a_pad, dm_pad, odt_pad, dq_o, dqs_o, dqsbar_o,
						   // Inouts
						   dq_pad, dqs_pad, dqsbar_pad,
						   // Inputs
						   ri_i, ts_i, ck_i, cke_i, csbar_i, rasbar_i, casbar_i, webar_i,
						   ba_i, a_i, dq_i, dqs_i, dqsbar_i, dm_i, odt_i
						   );
   output    ck_pad;
   output    ckbar_pad;
   output    cke_pad;
   output    csbar_pad;
   output    rasbar_pad;
   output    casbar_pad;
   output    webar_pad;
   output [1:0] ba_pad;
   output [12:0] a_pad;
   inout [15:0]  dq_pad;
   inout [1:0] 	 dqs_pad;
   inout [1:0] 	 dqsbar_pad;
   output [1:0]  dm_pad;
   output 		 odt_pad;

   input 		 ri_i;
   input 		 ts_i;   
   input 		 ck_i;
   input 		 cke_i;
   input 		 csbar_i;
   input 		 rasbar_i;
   input 		 casbar_i;
   input 		 webar_i;
   input [1:0] 	 ba_i;
   input [12:0]  a_i;
   input [15:0]  dq_i;
   input [1:0] 	 dqs_i;
   input [1:0] 	 dqsbar_i;
   output [15:0] dq_o;
   output [1:0]  dqs_o;
   output [1:0]  dqsbar_o;
   input [1:0] 	 dm_i;
   input 		 odt_i;


   wire [12:0]		 a_o;
   wire [1:0] 			 ba_o;
   wire [1:0] 			 dm_o;
   
   
   

   SSTL18DDR2DIFF ck_sstl (.Z(ck_o), .PAD(ck_pad), .PADN(ckbar_pad), .A(ck_i), .RI(1'b0), .TS(1'b1));

   SSTL18DDR2 cke_sstl (.Z(cke_o), .PAD(cke_pad), .A(cke_i), .RI(1'b0), .TS(1'b1));
   SSTL18DDR2 casbar_sstl (.Z(casbar_o), .PAD(casbar_pad), .A(casbar_i), .RI(1'b0), .TS(1'b1));
   SSTL18DDR2 rasbar_sstl (.Z(rasbar_o), .PAD(rasbar_pad), .A(rasbar_i), .RI(1'b0), .TS(1'b1));
   SSTL18DDR2 csbar_sstl (.Z(csbar_o), .PAD(csbar_pad), .A(csbar_i), .RI(1'b0), .TS(1'b1));
   
   SSTL18DDR2 webar_sstl (.Z(webar_o), .PAD(webar_pad), .A(webar_i), .RI(1'b0), .TS(1'b1));
   SSTL18DDR2 odt_sstl (.Z(odt_o), .PAD(odt_pad), .A(odt_i), .RI(1'b0), .TS(1'b1));
   
   
   
   genvar 		 i;

   generate
	  for (i=0; i < 2; i=i+1) begin : BA
		 SSTL18DDR2 sstl_ba (.Z(ba_o[i]), .PAD(ba_pad[i]), .A(ba_i[i]), .RI(1'b0), .TS(1'b1));
	  end
   endgenerate


   generate
	  for (i=0; i < 13; i=i+1) begin : A
		 SSTL18DDR2 sstl_a (.Z(a_o[i]), .PAD(a_pad[i]), .A(a_i[i]), .RI(1'b0), .TS(1'b1));
	  end
   endgenerate

   generate
	  for (i=0; i < 16; i=i+1) begin : DQ
		 SSTL18DDR2 sstl_dq (.Z(dq_o[i]), .PAD(dq_pad[i]), .A(dq_i[i]), .RI(ri_i), .TS(ts_i));
	  end
   endgenerate
   
   generate
	  for (i=0; i < 2; i=i+1) begin : DQS
		 SSTL18DDR2 sstl_dqs (.Z(dqs_o[i]), .PAD(dqs_pad[i]), .A(dqs_i[i]), .RI(ri_i), .TS(ts_i));
	  end
   endgenerate
   
   generate
	  for (i=0; i < 2; i=i+1) begin : DQSBAR
		 SSTL18DDR2 sstl_dqsbar (.Z(dqsbar_o[i]), .PAD(dqsbar_pad[i]), .A(dqsbar_i[i]), .RI(ri_i), .TS(ts_i));
	  end
   endgenerate

   generate
	  for (i=0; i < 2; i=i+1) begin : DM
		 SSTL18DDR2 sstl_dm (.Z(dm_o[i]), .PAD(dm_pad[i]), .A(dm_i[i]), .RI(1'b0), .TS(1'b1));
	  end
   endgenerate
   
   
endmodule // SSTL18DDR2INTERFACE


