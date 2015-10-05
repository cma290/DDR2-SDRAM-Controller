module ddr2_init_engine_DW01_inc_0 (
	A, 
	SUM);
   input [16:0] A;
   output [16:0] SUM;

   // Internal wires
   wire carry_16_;
   wire carry_15_;
   wire carry_14_;
   wire carry_13_;
   wire carry_12_;
   wire carry_11_;
   wire carry_10_;
   wire carry_9_;
   wire carry_8_;
   wire carry_7_;
   wire carry_6_;
   wire carry_5_;
   wire carry_4_;
   wire carry_3_;
   wire carry_2_;

   HAX1 U1_1_15 (.YS(SUM[15]), 
	.YC(carry_16_), 
	.B(carry_15_), 
	.A(A[15]));
   HAX1 U1_1_14 (.YS(SUM[14]), 
	.YC(carry_15_), 
	.B(carry_14_), 
	.A(A[14]));
   HAX1 U1_1_13 (.YS(SUM[13]), 
	.YC(carry_14_), 
	.B(carry_13_), 
	.A(A[13]));
   HAX1 U1_1_12 (.YS(SUM[12]), 
	.YC(carry_13_), 
	.B(carry_12_), 
	.A(A[12]));
   HAX1 U1_1_11 (.YS(SUM[11]), 
	.YC(carry_12_), 
	.B(carry_11_), 
	.A(A[11]));
   HAX1 U1_1_10 (.YS(SUM[10]), 
	.YC(carry_11_), 
	.B(carry_10_), 
	.A(A[10]));
   HAX1 U1_1_9 (.YS(SUM[9]), 
	.YC(carry_10_), 
	.B(carry_9_), 
	.A(A[9]));
   HAX1 U1_1_8 (.YS(SUM[8]), 
	.YC(carry_9_), 
	.B(carry_8_), 
	.A(A[8]));
   HAX1 U1_1_7 (.YS(SUM[7]), 
	.YC(carry_8_), 
	.B(carry_7_), 
	.A(A[7]));
   HAX1 U1_1_6 (.YS(SUM[6]), 
	.YC(carry_7_), 
	.B(carry_6_), 
	.A(A[6]));
   HAX1 U1_1_5 (.YS(SUM[5]), 
	.YC(carry_6_), 
	.B(carry_5_), 
	.A(A[5]));
   HAX1 U1_1_4 (.YS(SUM[4]), 
	.YC(carry_5_), 
	.B(carry_4_), 
	.A(A[4]));
   HAX1 U1_1_3 (.YS(SUM[3]), 
	.YC(carry_4_), 
	.B(carry_3_), 
	.A(A[3]));
   HAX1 U1_1_2 (.YS(SUM[2]), 
	.YC(carry_3_), 
	.B(carry_2_), 
	.A(A[2]));
   HAX1 U1_1_1 (.YS(SUM[1]), 
	.YC(carry_2_), 
	.B(A[0]), 
	.A(A[1]));
   XOR2X1 U1 (.Y(SUM[16]), 
	.B(A[16]), 
	.A(carry_16_));
endmodule

module ddr2_init_engine (
	ready, 
	csbar, 
	rasbar, 
	casbar, 
	webar, 
	ba, 
	a, 
	odt, 
	cke, 
	clk, 
	reset, 
	init, 
	ck);
   output ready;
   output csbar;
   output rasbar;
   output casbar;
   output webar;
   output [1:0] ba;
   output [12:0] a;
   output odt;
   output cke;
   input clk;
   input reset;
   input init;
   input ck;

   // Internal wires
   wire clk__L2_N5;
   wire clk__L2_N4;
   wire clk__L2_N3;
   wire clk__L2_N2;
   wire clk__L2_N1;
   wire clk__L2_N0;
   wire clk__L1_N0;
   wire FE_UNCONNECTED_0;
   wire flag;
   wire RESET;
   wire INIT;
   wire n11;
   wire n12;
   wire n13;
   wire n14;
   wire n15;
   wire n16;
   wire n17;
   wire n18;
   wire n19;
   wire n20;
   wire n21;
   wire n22;
   wire n23;
   wire n24;
   wire n25;
   wire n26;
   wire n452;
   wire n453;
   wire n454;
   wire n455;
   wire n456;
   wire n457;
   wire n458;
   wire n459;
   wire n460;
   wire n461;
   wire n462;
   wire n463;
   wire n465;
   wire n466;
   wire n467;
   wire n468;
   wire n469;
   wire n470;
   wire n471;
   wire n472;
   wire n473;
   wire n474;
   wire n475;
   wire n476;
   wire n477;
   wire n478;
   wire n479;
   wire n480;
   wire n481;
   wire n482;
   wire n483;
   wire n484;
   wire n485;
   wire n486;
   wire n487;
   wire n488;
   wire n489;
   wire n490;
   wire n491;
   wire n492;
   wire n493;
   wire n494;
   wire n495;
   wire n496;
   wire n497;
   wire n498;
   wire n499;
   wire n500;
   wire n501;
   wire n502;
   wire n503;
   wire n504;
   wire n505;
   wire n506;
   wire n507;
   wire n508;
   wire n509;
   wire n510;
   wire n511;
   wire n512;
   wire n513;
   wire n514;
   wire n515;
   wire n516;
   wire n517;
   wire n518;
   wire n519;
   wire n520;
   wire n521;
   wire n522;
   wire n523;
   wire n524;
   wire n525;
   wire n526;
   wire n527;
   wire n528;
   wire n529;
   wire n530;
   wire n531;
   wire n532;
   wire n533;
   wire n534;
   wire n535;
   wire n536;
   wire n537;
   wire n538;
   wire n539;
   wire n540;
   wire n541;
   wire n542;
   wire n543;
   wire n544;
   wire n545;
   wire n546;
   wire n547;
   wire n548;
   wire n549;
   wire n550;
   wire n551;
   wire n552;
   wire n553;
   wire n554;
   wire n555;
   wire n556;
   wire n557;
   wire n558;
   wire n559;
   wire n560;
   wire n561;
   wire n562;
   wire n563;
   wire n564;
   wire n565;
   wire n566;
   wire n567;
   wire n568;
   wire n569;
   wire n570;
   wire n571;
   wire n572;
   wire n573;
   wire n574;
   wire n575;
   wire n576;
   wire n577;
   wire n578;
   wire n579;
   wire n580;
   wire n581;
   wire n582;
   wire n583;
   wire n584;
   wire n585;
   wire n586;
   wire n587;
   wire n588;
   wire n589;
   wire n590;
   wire n591;
   wire n592;
   wire n593;
   wire n594;
   wire n595;
   wire n596;
   wire n597;
   wire n598;
   wire n599;
   wire n600;
   wire n601;
   wire n602;
   wire n603;
   wire n604;
   wire n605;
   wire n606;
   wire n607;
   wire n608;
   wire n609;
   wire n610;
   wire n611;
   wire n612;
   wire n613;
   wire n614;
   wire n615;
   wire n616;
   wire n617;
   wire n618;
   wire n619;
   wire n620;
   wire n621;
   wire n622;
   wire n623;
   wire n624;
   wire n625;
   wire n626;
   wire n627;
   wire n628;
   wire n629;
   wire n630;
   wire n631;
   wire n632;
   wire n633;
   wire n634;
   wire n635;
   wire n636;
   wire n637;
   wire n638;
   wire n639;
   wire n640;
   wire n641;
   wire n642;
   wire n643;
   wire n644;
   wire n645;
   wire n646;
   wire n647;
   wire n648;
   wire n649;
   wire n650;
   wire n651;
   wire n652;
   wire n653;
   wire n654;
   wire n655;
   wire n656;
   wire n657;
   wire n658;
   wire n659;
   wire n660;
   wire n661;
   wire n662;
   wire n663;
   wire n664;
   wire n665;
   wire n666;
   wire n667;
   wire n668;
   wire n669;
   wire n670;
   wire n671;
   wire n672;
   wire [16:0] counter;

   BUFX2 clk__L2_I5 (.Y(clk__L2_N5), 
	.A(clk__L1_N0));
   BUFX2 clk__L2_I4 (.Y(clk__L2_N4), 
	.A(clk__L1_N0));
   BUFX2 clk__L2_I3 (.Y(clk__L2_N3), 
	.A(clk__L1_N0));
   BUFX2 clk__L2_I2 (.Y(clk__L2_N2), 
	.A(clk__L1_N0));
   BUFX2 clk__L2_I1 (.Y(clk__L2_N1), 
	.A(clk__L1_N0));
   BUFX2 clk__L2_I0 (.Y(clk__L2_N0), 
	.A(clk__L1_N0));
   BUFX2 clk__L1_I0 (.Y(clk__L1_N0), 
	.A(clk));
   DFFPOSX1 RESET_reg (.Q(RESET), 
	.D(reset), 
	.CLK(clk__L2_N4));
   DFFPOSX1 INIT_reg (.Q(INIT), 
	.D(init), 
	.CLK(clk__L2_N5));
   DFFPOSX1 flag_reg (.Q(flag), 
	.D(n671), 
	.CLK(clk__L2_N5));
   DFFPOSX1 counter_reg_0_ (.Q(counter[0]), 
	.D(n670), 
	.CLK(clk__L2_N4));
   DFFPOSX1 counter_reg_1_ (.Q(counter[1]), 
	.D(n669), 
	.CLK(clk__L2_N4));
   DFFPOSX1 counter_reg_2_ (.Q(counter[2]), 
	.D(n668), 
	.CLK(clk__L2_N3));
   DFFPOSX1 counter_reg_3_ (.Q(counter[3]), 
	.D(n667), 
	.CLK(clk__L2_N3));
   DFFPOSX1 counter_reg_4_ (.Q(counter[4]), 
	.D(n666), 
	.CLK(clk__L2_N2));
   DFFPOSX1 counter_reg_5_ (.Q(counter[5]), 
	.D(n665), 
	.CLK(clk__L2_N0));
   DFFPOSX1 counter_reg_6_ (.Q(counter[6]), 
	.D(n664), 
	.CLK(clk__L2_N0));
   DFFPOSX1 counter_reg_7_ (.Q(counter[7]), 
	.D(n663), 
	.CLK(clk__L2_N1));
   DFFPOSX1 counter_reg_8_ (.Q(counter[8]), 
	.D(n662), 
	.CLK(clk__L2_N0));
   DFFPOSX1 counter_reg_9_ (.Q(counter[9]), 
	.D(n661), 
	.CLK(clk__L2_N0));
   DFFPOSX1 counter_reg_10_ (.Q(counter[10]), 
	.D(n660), 
	.CLK(clk__L2_N1));
   DFFPOSX1 counter_reg_11_ (.Q(counter[11]), 
	.D(n659), 
	.CLK(clk__L2_N2));
   DFFPOSX1 counter_reg_12_ (.Q(counter[12]), 
	.D(n658), 
	.CLK(clk__L2_N2));
   DFFPOSX1 counter_reg_13_ (.Q(counter[13]), 
	.D(n657), 
	.CLK(clk__L2_N2));
   DFFPOSX1 counter_reg_14_ (.Q(counter[14]), 
	.D(n656), 
	.CLK(clk__L2_N3));
   DFFPOSX1 counter_reg_15_ (.Q(counter[15]), 
	.D(n655), 
	.CLK(clk__L2_N4));
   DFFPOSX1 counter_reg_16_ (.Q(counter[16]), 
	.D(n654), 
	.CLK(clk__L2_N5));
   DFFPOSX1 a_reg_10_ (.Q(a[10]), 
	.D(n653), 
	.CLK(clk__L2_N1));
   DFFPOSX1 a_reg_9_ (.Q(a[9]), 
	.D(n652), 
	.CLK(clk__L2_N1));
   DFFPOSX1 a_reg_7_ (.Q(a[7]), 
	.D(n651), 
	.CLK(clk__L2_N1));
   DFFPOSX1 a_reg_8_ (.Q(a[8]), 
	.D(n650), 
	.CLK(clk__L2_N1));
   DFFPOSX1 ready_reg (.Q(ready), 
	.D(n649), 
	.CLK(clk__L2_N0));
   DFFPOSX1 casbar_reg (.Q(casbar), 
	.D(n648), 
	.CLK(clk__L2_N2));
   DFFPOSX1 webar_reg (.Q(webar), 
	.D(n647), 
	.CLK(clk__L2_N4));
   DFFPOSX1 rasbar_reg (.Q(rasbar), 
	.D(n646), 
	.CLK(clk__L2_N4));
   DFFPOSX1 a_reg_12_ (.Q(a[12]), 
	.D(n645), 
	.CLK(clk__L2_N4));
   DFFPOSX1 a_reg_6_ (.Q(a[6]), 
	.D(n644), 
	.CLK(clk__L2_N5));
   DFFPOSX1 a_reg_4_ (.Q(a[4]), 
	.D(n643), 
	.CLK(clk__L2_N3));
   DFFPOSX1 a_reg_2_ (.Q(a[2]), 
	.D(n642), 
	.CLK(clk__L2_N5));
   DFFPOSX1 a_reg_0_ (.Q(a[0]), 
	.D(n641), 
	.CLK(clk__L2_N3));
   DFFPOSX1 a_reg_1_ (.Q(a[1]), 
	.D(n640), 
	.CLK(clk__L2_N3));
   DFFPOSX1 a_reg_3_ (.Q(a[3]), 
	.D(n639), 
	.CLK(clk__L2_N1));
   DFFPOSX1 a_reg_5_ (.Q(a[5]), 
	.D(n638), 
	.CLK(clk__L2_N3));
   DFFPOSX1 a_reg_11_ (.Q(a[11]), 
	.D(n637), 
	.CLK(clk__L2_N5));
   DFFPOSX1 cke_reg (.Q(cke), 
	.D(n636), 
	.CLK(clk__L2_N0));
   DFFPOSX1 odt_reg (.Q(odt), 
	.D(n635), 
	.CLK(clk__L2_N0));
   DFFPOSX1 ba_reg_1_ (.Q(ba[1]), 
	.D(n634), 
	.CLK(clk__L2_N2));
   DFFPOSX1 ba_reg_0_ (.Q(ba[0]), 
	.D(n633), 
	.CLK(clk__L2_N5));
   DFFPOSX1 csbar_reg (.Q(csbar), 
	.D(n632), 
	.CLK(clk__L2_N2));
   OAI21X1 U3 (.Y(n632), 
	.C(n454), 
	.B(n453), 
	.A(n452));
   OAI21X1 U5 (.Y(n633), 
	.C(n457), 
	.B(n456), 
	.A(n455));
   AOI21X1 U6 (.Y(n457), 
	.C(n459), 
	.B(n455), 
	.A(n458));
   OAI21X1 U9 (.Y(n634), 
	.C(n463), 
	.B(n462), 
	.A(n461));
   NAND2X1 U10 (.Y(n463), 
	.B(n672), 
	.A(ba[1]));
   OAI21X1 U12 (.Y(n635), 
	.C(n468), 
	.B(n467), 
	.A(n466));
   NAND2X1 U13 (.Y(n468), 
	.B(n454), 
	.A(odt));
   NAND2X1 U14 (.Y(n467), 
	.B(n470), 
	.A(n469));
   OAI21X1 U15 (.Y(n636), 
	.C(n473), 
	.B(n472), 
	.A(n471));
   NAND2X1 U16 (.Y(n473), 
	.B(n454), 
	.A(cke));
   NAND2X1 U17 (.Y(n472), 
	.B(n474), 
	.A(n469));
   NOR2X1 U18 (.Y(n469), 
	.B(n476), 
	.A(n475));
   NAND2X1 U19 (.Y(n471), 
	.B(n478), 
	.A(n477));
   OAI21X1 U20 (.Y(n637), 
	.C(n454), 
	.B(n479), 
	.A(n455));
   OAI21X1 U22 (.Y(n638), 
	.C(n481), 
	.B(n480), 
	.A(n455));
   OAI21X1 U24 (.Y(n639), 
	.C(n483), 
	.B(n482), 
	.A(n672));
   NAND2X1 U25 (.Y(n483), 
	.B(n672), 
	.A(a[3]));
   OAI21X1 U26 (.Y(n640), 
	.C(n481), 
	.B(n484), 
	.A(n455));
   OAI21X1 U28 (.Y(n641), 
	.C(n481), 
	.B(n485), 
	.A(n455));
   OAI21X1 U30 (.Y(n642), 
	.C(n487), 
	.B(n486), 
	.A(n455));
   AOI21X1 U31 (.Y(n487), 
	.C(RESET), 
	.B(n488), 
	.A(n459));
   NOR2X1 U32 (.Y(n459), 
	.B(n475), 
	.A(n462));
   NAND2X1 U33 (.Y(n462), 
	.B(n455), 
	.A(n489));
   OAI21X1 U35 (.Y(n643), 
	.C(n481), 
	.B(n490), 
	.A(n455));
   OAI21X1 U38 (.Y(n644), 
	.C(n454), 
	.B(n492), 
	.A(n455));
   OAI21X1 U40 (.Y(n645), 
	.C(n454), 
	.B(n493), 
	.A(n455));
   OAI21X1 U42 (.Y(n646), 
	.C(n496), 
	.B(n495), 
	.A(n494));
   NAND2X1 U43 (.Y(n496), 
	.B(n497), 
	.A(rasbar));
   NAND2X1 U44 (.Y(n495), 
	.B(n499), 
	.A(n498));
   OAI21X1 U45 (.Y(n647), 
	.C(n501), 
	.B(n500), 
	.A(n494));
   NAND2X1 U46 (.Y(n501), 
	.B(n497), 
	.A(webar));
   NAND2X1 U48 (.Y(n500), 
	.B(n502), 
	.A(n498));
   NAND2X1 U49 (.Y(n498), 
	.B(n503), 
	.A(n454));
   OAI21X1 U50 (.Y(n648), 
	.C(n505), 
	.B(n504), 
	.A(n452));
   OAI21X1 U51 (.Y(n505), 
	.C(n452), 
	.B(n499), 
	.A(n506));
   OAI21X1 U54 (.Y(n503), 
	.C(n474), 
	.B(n508), 
	.A(n507));
   NAND2X1 U55 (.Y(n508), 
	.B(n510), 
	.A(n509));
   NAND3X1 U57 (.Y(n502), 
	.C(n513), 
	.B(n512), 
	.A(n511));
   NAND2X1 U59 (.Y(n499), 
	.B(n515), 
	.A(n514));
   AOI21X1 U60 (.Y(n515), 
	.C(n518), 
	.B(n517), 
	.A(n516));
   OAI21X1 U61 (.Y(n518), 
	.C(n521), 
	.B(n520), 
	.A(n519));
   NAND3X1 U62 (.Y(n521), 
	.C(n523), 
	.B(n522), 
	.A(counter[5]));
   OAI21X1 U63 (.Y(n522), 
	.C(n524), 
	.B(n476), 
	.A(counter[4]));
   AOI21X1 U64 (.Y(n519), 
	.C(n526), 
	.B(counter[7]), 
	.A(n525));
   NOR2X1 U65 (.Y(n525), 
	.B(n528), 
	.A(n527));
   AOI21X1 U66 (.Y(n514), 
	.C(n530), 
	.B(n470), 
	.A(n529));
   OAI22X1 U67 (.Y(n530), 
	.D(n533), 
	.C(n532), 
	.B(n475), 
	.A(n531));
   AOI21X1 U68 (.Y(n531), 
	.C(n536), 
	.B(n535), 
	.A(n534));
   OAI21X1 U69 (.Y(n536), 
	.C(n539), 
	.B(n538), 
	.A(n537));
   NAND3X1 U70 (.Y(n539), 
	.C(n541), 
	.B(n540), 
	.A(counter[4]));
   NAND2X1 U71 (.Y(n538), 
	.B(n542), 
	.A(counter[6]));
   NAND3X1 U72 (.Y(n537), 
	.C(n488), 
	.B(n470), 
	.A(n543));
   OAI21X1 U73 (.Y(n535), 
	.C(n545), 
	.B(n544), 
	.A(counter[8]));
   AOI22X1 U74 (.Y(n545), 
	.D(n470), 
	.C(n547), 
	.B(n542), 
	.A(n546));
   NOR2X1 U76 (.Y(n546), 
	.B(n470), 
	.A(counter[6]));
   NAND3X1 U77 (.Y(n512), 
	.C(n551), 
	.B(n550), 
	.A(n549));
   NOR2X1 U78 (.Y(n551), 
	.B(n552), 
	.A(n548));
   NAND3X1 U79 (.Y(n511), 
	.C(n526), 
	.B(n543), 
	.A(counter[1]));
   NAND3X1 U81 (.Y(n553), 
	.C(n477), 
	.B(n475), 
	.A(counter[8]));
   NAND3X1 U83 (.Y(n544), 
	.C(n554), 
	.B(counter[4]), 
	.A(counter[6]));
   NOR2X1 U84 (.Y(n554), 
	.B(n556), 
	.A(n555));
   NAND2X1 U85 (.Y(n556), 
	.B(n557), 
	.A(n540));
   OAI21X1 U86 (.Y(n507), 
	.C(n559), 
	.B(n558), 
	.A(n533));
   OAI21X1 U88 (.Y(n649), 
	.C(n562), 
	.B(n561), 
	.A(n524));
   NAND2X1 U89 (.Y(n562), 
	.B(n454), 
	.A(ready));
   NAND3X1 U91 (.Y(n466), 
	.C(n474), 
	.B(counter[5]), 
	.A(n523));
   NAND3X1 U92 (.Y(n524), 
	.C(n488), 
	.B(n475), 
	.A(n543));
   OAI21X1 U93 (.Y(n650), 
	.C(n565), 
	.B(n564), 
	.A(n563));
   OAI21X1 U94 (.Y(n565), 
	.C(n563), 
	.B(n566), 
	.A(n529));
   OAI21X1 U97 (.Y(n651), 
	.C(n569), 
	.B(n568), 
	.A(n482));
   NAND2X1 U98 (.Y(n569), 
	.B(n568), 
	.A(a[7]));
   NAND2X1 U100 (.Y(n566), 
	.B(n460), 
	.A(n454));
   OAI21X1 U101 (.Y(n652), 
	.C(n571), 
	.B(n570), 
	.A(n568));
   NAND2X1 U102 (.Y(n571), 
	.B(n568), 
	.A(a[9]));
   OAI21X1 U105 (.Y(n563), 
	.C(n672), 
	.B(n573), 
	.A(n558));
   NAND2X1 U106 (.Y(n573), 
	.B(n560), 
	.A(n474));
   NOR2X1 U107 (.Y(n560), 
	.B(n543), 
	.A(n574));
   NAND2X1 U109 (.Y(n558), 
	.B(n555), 
	.A(n523));
   OAI21X1 U110 (.Y(n653), 
	.C(n578), 
	.B(n577), 
	.A(n576));
   OAI21X1 U111 (.Y(n578), 
	.C(n576), 
	.B(n572), 
	.A(n506));
   NAND2X1 U112 (.Y(n572), 
	.B(n460), 
	.A(n491));
   NAND2X1 U113 (.Y(n460), 
	.B(n489), 
	.A(n541));
   NOR2X1 U114 (.Y(n491), 
	.B(n579), 
	.A(RESET));
   OAI21X1 U116 (.Y(n576), 
	.C(n672), 
	.B(n575), 
	.A(n559));
   OAI21X1 U118 (.Y(n455), 
	.C(n454), 
	.B(n575), 
	.A(n509));
   NOR2X1 U119 (.Y(n509), 
	.B(n579), 
	.A(n580));
   OAI21X1 U120 (.Y(n579), 
	.C(n581), 
	.B(n470), 
	.A(n567));
   NAND3X1 U121 (.Y(n581), 
	.C(counter[7]), 
	.B(n516), 
	.A(n550));
   NAND3X1 U124 (.Y(n567), 
	.C(n547), 
	.B(n475), 
	.A(n549));
   NAND2X1 U127 (.Y(n476), 
	.B(counter[1]), 
	.A(counter[2]));
   AOI22X1 U129 (.Y(n583), 
	.D(n517), 
	.C(n541), 
	.B(n465), 
	.A(n584));
   OAI21X1 U130 (.Y(n517), 
	.C(n586), 
	.B(n585), 
	.A(n475));
   NAND3X1 U131 (.Y(n586), 
	.C(counter[4]), 
	.B(n540), 
	.A(n475));
   NAND2X1 U132 (.Y(n585), 
	.B(n470), 
	.A(counter[7]));
   AND2X1 U133 (.Y(n541), 
	.B(n488), 
	.A(n587));
   OAI21X1 U134 (.Y(n465), 
	.C(n588), 
	.B(n475), 
	.A(n582));
   NAND3X1 U135 (.Y(n588), 
	.C(n534), 
	.B(n475), 
	.A(n589));
   NAND2X1 U137 (.Y(n582), 
	.B(n587), 
	.A(counter[1]));
   NOR2X1 U138 (.Y(n587), 
	.B(counter[2]), 
	.A(n527));
   NOR2X1 U139 (.Y(n584), 
	.B(counter[4]), 
	.A(counter[7]));
   NAND3X1 U140 (.Y(n575), 
	.C(n592), 
	.B(n591), 
	.A(n590));
   NOR2X1 U141 (.Y(n592), 
	.B(n594), 
	.A(n593));
   NAND2X1 U142 (.Y(n594), 
	.B(n595), 
	.A(n489));
   NAND3X1 U144 (.Y(n593), 
	.C(n598), 
	.B(n597), 
	.A(n596));
   NOR2X1 U145 (.Y(n591), 
	.B(n600), 
	.A(n599));
   NOR2X1 U146 (.Y(n590), 
	.B(n602), 
	.A(n601));
   OAI21X1 U148 (.Y(n506), 
	.C(n604), 
	.B(n520), 
	.A(n603));
   NAND3X1 U149 (.Y(n604), 
	.C(n605), 
	.B(n552), 
	.A(n543));
   NOR2X1 U150 (.Y(n605), 
	.B(n574), 
	.A(n548));
   NAND3X1 U151 (.Y(n574), 
	.C(counter[3]), 
	.B(counter[1]), 
	.A(counter[4]));
   NAND3X1 U152 (.Y(n548), 
	.C(n606), 
	.B(n555), 
	.A(counter[8]));
   NOR2X1 U153 (.Y(n606), 
	.B(counter[7]), 
	.A(counter[9]));
   NAND2X1 U154 (.Y(n520), 
	.B(n488), 
	.A(counter[2]));
   AOI22X1 U155 (.Y(n603), 
	.D(counter[3]), 
	.C(n608), 
	.B(n523), 
	.A(n607));
   NOR2X1 U156 (.Y(n608), 
	.B(n470), 
	.A(n532));
   NAND2X1 U157 (.Y(n532), 
	.B(n540), 
	.A(n589));
   NAND3X1 U159 (.Y(n527), 
	.C(n609), 
	.B(counter[5]), 
	.A(counter[8]));
   NOR2X1 U160 (.Y(n609), 
	.B(counter[6]), 
	.A(counter[9]));
   NAND3X1 U162 (.Y(n610), 
	.C(n611), 
	.B(n478), 
	.A(counter[7]));
   NOR2X1 U163 (.Y(n611), 
	.B(n557), 
	.A(n552));
   NOR2X1 U164 (.Y(n607), 
	.B(n528), 
	.A(n555));
   NAND2X1 U165 (.Y(n528), 
	.B(n470), 
	.A(n475));
   OAI21X1 U166 (.Y(n654), 
	.C(n612), 
	.B(n602), 
	.A(n671));
   NAND2X1 U167 (.Y(n612), 
	.B(n613), 
	.A(n26));
   OAI21X1 U169 (.Y(n655), 
	.C(n614), 
	.B(n597), 
	.A(n671));
   NAND2X1 U170 (.Y(n614), 
	.B(n613), 
	.A(n25));
   OAI21X1 U172 (.Y(n656), 
	.C(n615), 
	.B(n596), 
	.A(n671));
   NAND2X1 U173 (.Y(n615), 
	.B(n613), 
	.A(n24));
   OAI21X1 U175 (.Y(n657), 
	.C(n616), 
	.B(n601), 
	.A(n671));
   NAND2X1 U176 (.Y(n616), 
	.B(n613), 
	.A(n23));
   OAI21X1 U178 (.Y(n658), 
	.C(n617), 
	.B(n598), 
	.A(n671));
   NAND2X1 U179 (.Y(n617), 
	.B(n613), 
	.A(n22));
   OAI21X1 U181 (.Y(n659), 
	.C(n618), 
	.B(n600), 
	.A(n671));
   NAND2X1 U182 (.Y(n618), 
	.B(n613), 
	.A(n21));
   OAI21X1 U184 (.Y(n660), 
	.C(n619), 
	.B(n599), 
	.A(n671));
   NAND2X1 U185 (.Y(n619), 
	.B(n613), 
	.A(n20));
   OAI21X1 U187 (.Y(n661), 
	.C(n620), 
	.B(n557), 
	.A(n671));
   NAND2X1 U188 (.Y(n620), 
	.B(n613), 
	.A(n19));
   OAI21X1 U190 (.Y(n662), 
	.C(n621), 
	.B(n478), 
	.A(n671));
   NAND2X1 U191 (.Y(n621), 
	.B(n613), 
	.A(n18));
   OAI21X1 U193 (.Y(n663), 
	.C(n622), 
	.B(n540), 
	.A(n671));
   NAND2X1 U194 (.Y(n622), 
	.B(n613), 
	.A(n17));
   OAI21X1 U196 (.Y(n664), 
	.C(n623), 
	.B(n552), 
	.A(n671));
   NAND2X1 U197 (.Y(n623), 
	.B(n613), 
	.A(n16));
   OAI21X1 U199 (.Y(n665), 
	.C(n624), 
	.B(n555), 
	.A(n671));
   NAND2X1 U200 (.Y(n624), 
	.B(n613), 
	.A(n15));
   OAI21X1 U202 (.Y(n666), 
	.C(n625), 
	.B(n470), 
	.A(n671));
   NAND2X1 U203 (.Y(n625), 
	.B(n613), 
	.A(n14));
   OAI21X1 U205 (.Y(n667), 
	.C(n626), 
	.B(n475), 
	.A(n671));
   NAND2X1 U206 (.Y(n626), 
	.B(n613), 
	.A(n13));
   OAI21X1 U208 (.Y(n668), 
	.C(n627), 
	.B(n543), 
	.A(n671));
   NAND2X1 U209 (.Y(n627), 
	.B(n613), 
	.A(n12));
   OAI21X1 U211 (.Y(n669), 
	.C(n628), 
	.B(n488), 
	.A(n671));
   NAND2X1 U212 (.Y(n628), 
	.B(n613), 
	.A(n11));
   OAI21X1 U214 (.Y(n670), 
	.C(n629), 
	.B(n595), 
	.A(n671));
   NAND2X1 U215 (.Y(n629), 
	.B(n613), 
	.A(n595));
   OAI21X1 U218 (.Y(n671), 
	.C(n494), 
	.B(n630), 
	.A(RESET));
   NAND2X1 U219 (.Y(n494), 
	.B(n454), 
	.A(flag));
   NAND2X1 U221 (.Y(n630), 
	.B(n631), 
	.A(INIT));
   INVX2 U4 (.Y(n453), 
	.A(csbar));
   INVX2 U7 (.Y(n458), 
	.A(n460));
   INVX2 U8 (.Y(n456), 
	.A(ba[0]));
   INVX2 U11 (.Y(n461), 
	.A(n465));
   INVX2 U21 (.Y(n479), 
	.A(a[11]));
   INVX2 U23 (.Y(n480), 
	.A(a[5]));
   INVX2 U27 (.Y(n484), 
	.A(a[1]));
   INVX2 U29 (.Y(n485), 
	.A(a[0]));
   INVX2 U34 (.Y(n486), 
	.A(a[2]));
   OR2X2 U36 (.Y(n481), 
	.B(n672), 
	.A(n491));
   INVX2 U37 (.Y(n490), 
	.A(a[4]));
   INVX2 U39 (.Y(n492), 
	.A(a[6]));
   INVX2 U41 (.Y(n493), 
	.A(a[12]));
   INVX2 U47 (.Y(n497), 
	.A(n498));
   INVX2 U52 (.Y(n504), 
	.A(casbar));
   INVX2 U53 (.Y(n452), 
	.A(n503));
   INVX2 U56 (.Y(n510), 
	.A(n502));
   INVX2 U58 (.Y(n513), 
	.A(n499));
   INVX2 U75 (.Y(n542), 
	.A(n548));
   INVX2 U80 (.Y(n526), 
	.A(n553));
   INVX2 U82 (.Y(n477), 
	.A(n544));
   INVX2 U87 (.Y(n533), 
	.A(n560));
   OR2X2 U90 (.Y(n561), 
	.B(n470), 
	.A(n466));
   INVX2 U95 (.Y(n529), 
	.A(n567));
   INVX2 U96 (.Y(n564), 
	.A(a[8]));
   INVX2 U99 (.Y(n482), 
	.A(n566));
   INVX2 U103 (.Y(n570), 
	.A(n572));
   INVX2 U104 (.Y(n568), 
	.A(n563));
   INVX2 U108 (.Y(n474), 
	.A(n575));
   INVX2 U115 (.Y(n577), 
	.A(a[10]));
   INVX2 U122 (.Y(n516), 
	.A(n582));
   INVX2 U123 (.Y(n550), 
	.A(n528));
   INVX2 U125 (.Y(n547), 
	.A(n532));
   INVX2 U126 (.Y(n549), 
	.A(n476));
   INVX2 U128 (.Y(n580), 
	.A(n583));
   INVX2 U136 (.Y(n534), 
	.A(n520));
   INVX2 U143 (.Y(n489), 
	.A(n494));
   INVX2 U147 (.Y(n559), 
	.A(n506));
   INVX2 U158 (.Y(n589), 
	.A(n527));
   INVX2 U161 (.Y(n523), 
	.A(n610));
   INVX2 U168 (.Y(n602), 
	.A(counter[16]));
   INVX2 U171 (.Y(n597), 
	.A(counter[15]));
   INVX2 U174 (.Y(n596), 
	.A(counter[14]));
   INVX2 U177 (.Y(n601), 
	.A(counter[13]));
   INVX2 U180 (.Y(n598), 
	.A(counter[12]));
   INVX2 U183 (.Y(n600), 
	.A(counter[11]));
   INVX2 U186 (.Y(n599), 
	.A(counter[10]));
   INVX2 U189 (.Y(n557), 
	.A(counter[9]));
   INVX2 U192 (.Y(n478), 
	.A(counter[8]));
   INVX2 U195 (.Y(n540), 
	.A(counter[7]));
   INVX2 U198 (.Y(n552), 
	.A(counter[6]));
   INVX2 U201 (.Y(n555), 
	.A(counter[5]));
   INVX2 U210 (.Y(n543), 
	.A(counter[2]));
   INVX2 U213 (.Y(n488), 
	.A(counter[1]));
   INVX2 U217 (.Y(n595), 
	.A(counter[0]));
   INVX2 U222 (.Y(n631), 
	.A(flag));
   ddr2_init_engine_DW01_inc_0 add_107 (.A({ counter[16],
		counter[15],
		counter[14],
		counter[13],
		counter[12],
		counter[11],
		counter[10],
		counter[9],
		counter[8],
		counter[7],
		counter[6],
		counter[5],
		counter[4],
		counter[3],
		counter[2],
		counter[1],
		counter[0] }), 
	.SUM({ n26,
		n25,
		n24,
		n23,
		n22,
		n21,
		n20,
		n19,
		n18,
		n17,
		n16,
		n15,
		n14,
		n13,
		n12,
		n11,
		FE_UNCONNECTED_0 }));
   INVX2 U223 (.Y(n672), 
	.A(n455));
   INVX2 U224 (.Y(n475), 
	.A(counter[3]));
   INVX2 U225 (.Y(n454), 
	.A(RESET));
   INVX2 U226 (.Y(n470), 
	.A(counter[4]));
   AND2X2 U227 (.Y(n613), 
	.B(n630), 
	.A(n671));
endmodule

