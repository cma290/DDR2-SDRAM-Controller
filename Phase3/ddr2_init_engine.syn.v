
module ddr2_init_engine_DW01_inc_0 ( A, SUM );
  input [16:0] A;
  output [16:0] SUM;
  wire   carry_16_, carry_15_, carry_14_, carry_13_, carry_12_, carry_11_,
         carry_10_, carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_,
         carry_3_, carry_2_;

  HAX1 U1_1_15 ( .A(A[15]), .B(carry_15_), .YC(carry_16_), .YS(SUM[15]) );
  HAX1 U1_1_14 ( .A(A[14]), .B(carry_14_), .YC(carry_15_), .YS(SUM[14]) );
  HAX1 U1_1_13 ( .A(A[13]), .B(carry_13_), .YC(carry_14_), .YS(SUM[13]) );
  HAX1 U1_1_12 ( .A(A[12]), .B(carry_12_), .YC(carry_13_), .YS(SUM[12]) );
  HAX1 U1_1_11 ( .A(A[11]), .B(carry_11_), .YC(carry_12_), .YS(SUM[11]) );
  HAX1 U1_1_10 ( .A(A[10]), .B(carry_10_), .YC(carry_11_), .YS(SUM[10]) );
  HAX1 U1_1_9 ( .A(A[9]), .B(carry_9_), .YC(carry_10_), .YS(SUM[9]) );
  HAX1 U1_1_8 ( .A(A[8]), .B(carry_8_), .YC(carry_9_), .YS(SUM[8]) );
  HAX1 U1_1_7 ( .A(A[7]), .B(carry_7_), .YC(carry_8_), .YS(SUM[7]) );
  HAX1 U1_1_6 ( .A(A[6]), .B(carry_6_), .YC(carry_7_), .YS(SUM[6]) );
  HAX1 U1_1_5 ( .A(A[5]), .B(carry_5_), .YC(carry_6_), .YS(SUM[5]) );
  HAX1 U1_1_4 ( .A(A[4]), .B(carry_4_), .YC(carry_5_), .YS(SUM[4]) );
  HAX1 U1_1_3 ( .A(A[3]), .B(carry_3_), .YC(carry_4_), .YS(SUM[3]) );
  HAX1 U1_1_2 ( .A(A[2]), .B(carry_2_), .YC(carry_3_), .YS(SUM[2]) );
  HAX1 U1_1_1 ( .A(A[1]), .B(A[0]), .YC(carry_2_), .YS(SUM[1]) );
  XOR2X1 U1 ( .A(carry_16_), .B(A[16]), .Y(SUM[16]) );
  INVX1 U2 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module ddr2_init_engine ( ready, csbar, rasbar, casbar, webar, ba, a, odt, cke, 
        clk, reset, init, ck );
  output [1:0] ba;
  output [12:0] a;
  input clk, reset, init, ck;
  output ready, csbar, rasbar, casbar, webar, odt, cke;
  wire   flag, RESET, INIT, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n23, n24, n25, n26, n452, n453, n454, n455, n456, n457,
         n458, n459, n460, n461, n462, n463, n465, n466, n467, n468, n469,
         n470, n471, n472, n473, n474, n475, n476, n477, n478, n479, n480,
         n481, n482, n483, n484, n485, n486, n487, n488, n489, n490, n491,
         n492, n493, n494, n495, n496, n497, n498, n499, n500, n501, n502,
         n503, n504, n505, n506, n507, n508, n509, n510, n511, n512, n513,
         n514, n515, n516, n517, n518, n519, n520, n521, n522, n523, n524,
         n525, n526, n527, n528, n529, n530, n531, n532, n533, n534, n535,
         n536, n537, n538, n539, n540, n541, n542, n543, n544, n545, n546,
         n547, n548, n549, n550, n551, n552, n553, n554, n555, n556, n557,
         n558, n559, n560, n561, n562, n563, n564, n565, n566, n567, n568,
         n569, n570, n571, n572, n573, n574, n575, n576, n577, n578, n579,
         n580, n581, n582, n583, n584, n585, n586, n587, n588, n589, n590,
         n591, n592, n593, n594, n595, n596, n597, n598, n599, n600, n601,
         n602, n603, n604, n605, n606, n607, n608, n609, n610, n611, n612,
         n613, n614, n615, n616, n617, n618, n619, n620, n621, n622, n623,
         n624, n625, n626, n627, n628, n629, n630, n631, n632, n633, n634,
         n635, n636, n637, n638, n639, n640, n641, n642, n643, n644, n645,
         n646, n647, n648, n649, n650, n651, n652, n653, n654, n655, n656,
         n657, n658, n659, n660, n661, n662, n663, n664, n665, n666, n667,
         n668, n669, n670, n671, n672;
  wire   [16:0] counter;

  DFFPOSX1 RESET_reg ( .D(reset), .CLK(clk), .Q(RESET) );
  DFFPOSX1 INIT_reg ( .D(init), .CLK(clk), .Q(INIT) );
  DFFPOSX1 flag_reg ( .D(n671), .CLK(clk), .Q(flag) );
  DFFPOSX1 counter_reg_0_ ( .D(n670), .CLK(clk), .Q(counter[0]) );
  DFFPOSX1 counter_reg_1_ ( .D(n669), .CLK(clk), .Q(counter[1]) );
  DFFPOSX1 counter_reg_2_ ( .D(n668), .CLK(clk), .Q(counter[2]) );
  DFFPOSX1 counter_reg_3_ ( .D(n667), .CLK(clk), .Q(counter[3]) );
  DFFPOSX1 counter_reg_4_ ( .D(n666), .CLK(clk), .Q(counter[4]) );
  DFFPOSX1 counter_reg_5_ ( .D(n665), .CLK(clk), .Q(counter[5]) );
  DFFPOSX1 counter_reg_6_ ( .D(n664), .CLK(clk), .Q(counter[6]) );
  DFFPOSX1 counter_reg_7_ ( .D(n663), .CLK(clk), .Q(counter[7]) );
  DFFPOSX1 counter_reg_8_ ( .D(n662), .CLK(clk), .Q(counter[8]) );
  DFFPOSX1 counter_reg_9_ ( .D(n661), .CLK(clk), .Q(counter[9]) );
  DFFPOSX1 counter_reg_10_ ( .D(n660), .CLK(clk), .Q(counter[10]) );
  DFFPOSX1 counter_reg_11_ ( .D(n659), .CLK(clk), .Q(counter[11]) );
  DFFPOSX1 counter_reg_12_ ( .D(n658), .CLK(clk), .Q(counter[12]) );
  DFFPOSX1 counter_reg_13_ ( .D(n657), .CLK(clk), .Q(counter[13]) );
  DFFPOSX1 counter_reg_14_ ( .D(n656), .CLK(clk), .Q(counter[14]) );
  DFFPOSX1 counter_reg_15_ ( .D(n655), .CLK(clk), .Q(counter[15]) );
  DFFPOSX1 counter_reg_16_ ( .D(n654), .CLK(clk), .Q(counter[16]) );
  DFFPOSX1 a_reg_10_ ( .D(n653), .CLK(clk), .Q(a[10]) );
  DFFPOSX1 a_reg_9_ ( .D(n652), .CLK(clk), .Q(a[9]) );
  DFFPOSX1 a_reg_7_ ( .D(n651), .CLK(clk), .Q(a[7]) );
  DFFPOSX1 a_reg_8_ ( .D(n650), .CLK(clk), .Q(a[8]) );
  DFFPOSX1 ready_reg ( .D(n649), .CLK(clk), .Q(ready) );
  DFFPOSX1 casbar_reg ( .D(n648), .CLK(clk), .Q(casbar) );
  DFFPOSX1 webar_reg ( .D(n647), .CLK(clk), .Q(webar) );
  DFFPOSX1 rasbar_reg ( .D(n646), .CLK(clk), .Q(rasbar) );
  DFFPOSX1 a_reg_12_ ( .D(n645), .CLK(clk), .Q(a[12]) );
  DFFPOSX1 a_reg_6_ ( .D(n644), .CLK(clk), .Q(a[6]) );
  DFFPOSX1 a_reg_4_ ( .D(n643), .CLK(clk), .Q(a[4]) );
  DFFPOSX1 a_reg_2_ ( .D(n642), .CLK(clk), .Q(a[2]) );
  DFFPOSX1 a_reg_0_ ( .D(n641), .CLK(clk), .Q(a[0]) );
  DFFPOSX1 a_reg_1_ ( .D(n640), .CLK(clk), .Q(a[1]) );
  DFFPOSX1 a_reg_3_ ( .D(n639), .CLK(clk), .Q(a[3]) );
  DFFPOSX1 a_reg_5_ ( .D(n638), .CLK(clk), .Q(a[5]) );
  DFFPOSX1 a_reg_11_ ( .D(n637), .CLK(clk), .Q(a[11]) );
  DFFPOSX1 cke_reg ( .D(n636), .CLK(clk), .Q(cke) );
  DFFPOSX1 odt_reg ( .D(n635), .CLK(clk), .Q(odt) );
  DFFPOSX1 ba_reg_1_ ( .D(n634), .CLK(clk), .Q(ba[1]) );
  DFFPOSX1 ba_reg_0_ ( .D(n633), .CLK(clk), .Q(ba[0]) );
  DFFPOSX1 csbar_reg ( .D(n632), .CLK(clk), .Q(csbar) );
  OAI21X1 U3 ( .A(n452), .B(n453), .C(n454), .Y(n632) );
  OAI21X1 U5 ( .A(n455), .B(n456), .C(n457), .Y(n633) );
  AOI21X1 U6 ( .A(n458), .B(n455), .C(n459), .Y(n457) );
  OAI21X1 U9 ( .A(n461), .B(n462), .C(n463), .Y(n634) );
  NAND2X1 U10 ( .A(ba[1]), .B(n672), .Y(n463) );
  OAI21X1 U12 ( .A(n466), .B(n467), .C(n468), .Y(n635) );
  NAND2X1 U13 ( .A(odt), .B(n454), .Y(n468) );
  NAND2X1 U14 ( .A(n469), .B(n470), .Y(n467) );
  OAI21X1 U15 ( .A(n471), .B(n472), .C(n473), .Y(n636) );
  NAND2X1 U16 ( .A(cke), .B(n454), .Y(n473) );
  NAND2X1 U17 ( .A(n469), .B(n474), .Y(n472) );
  NOR2X1 U18 ( .A(n475), .B(n476), .Y(n469) );
  NAND2X1 U19 ( .A(n477), .B(n478), .Y(n471) );
  OAI21X1 U20 ( .A(n455), .B(n479), .C(n454), .Y(n637) );
  OAI21X1 U22 ( .A(n455), .B(n480), .C(n481), .Y(n638) );
  OAI21X1 U24 ( .A(n672), .B(n482), .C(n483), .Y(n639) );
  NAND2X1 U25 ( .A(a[3]), .B(n672), .Y(n483) );
  OAI21X1 U26 ( .A(n455), .B(n484), .C(n481), .Y(n640) );
  OAI21X1 U28 ( .A(n455), .B(n485), .C(n481), .Y(n641) );
  OAI21X1 U30 ( .A(n455), .B(n486), .C(n487), .Y(n642) );
  AOI21X1 U31 ( .A(n459), .B(n488), .C(RESET), .Y(n487) );
  NOR2X1 U32 ( .A(n462), .B(n475), .Y(n459) );
  NAND2X1 U33 ( .A(n489), .B(n455), .Y(n462) );
  OAI21X1 U35 ( .A(n455), .B(n490), .C(n481), .Y(n643) );
  OAI21X1 U38 ( .A(n455), .B(n492), .C(n454), .Y(n644) );
  OAI21X1 U40 ( .A(n455), .B(n493), .C(n454), .Y(n645) );
  OAI21X1 U42 ( .A(n494), .B(n495), .C(n496), .Y(n646) );
  NAND2X1 U43 ( .A(rasbar), .B(n497), .Y(n496) );
  NAND2X1 U44 ( .A(n498), .B(n499), .Y(n495) );
  OAI21X1 U45 ( .A(n494), .B(n500), .C(n501), .Y(n647) );
  NAND2X1 U46 ( .A(webar), .B(n497), .Y(n501) );
  NAND2X1 U48 ( .A(n498), .B(n502), .Y(n500) );
  NAND2X1 U49 ( .A(n454), .B(n503), .Y(n498) );
  OAI21X1 U50 ( .A(n452), .B(n504), .C(n505), .Y(n648) );
  OAI21X1 U51 ( .A(n506), .B(n499), .C(n452), .Y(n505) );
  OAI21X1 U54 ( .A(n507), .B(n508), .C(n474), .Y(n503) );
  NAND2X1 U55 ( .A(n509), .B(n510), .Y(n508) );
  NAND3X1 U57 ( .A(n511), .B(n512), .C(n513), .Y(n502) );
  NAND2X1 U59 ( .A(n514), .B(n515), .Y(n499) );
  AOI21X1 U60 ( .A(n516), .B(n517), .C(n518), .Y(n515) );
  OAI21X1 U61 ( .A(n519), .B(n520), .C(n521), .Y(n518) );
  NAND3X1 U62 ( .A(counter[5]), .B(n522), .C(n523), .Y(n521) );
  OAI21X1 U63 ( .A(counter[4]), .B(n476), .C(n524), .Y(n522) );
  AOI21X1 U64 ( .A(n525), .B(counter[7]), .C(n526), .Y(n519) );
  NOR2X1 U65 ( .A(n527), .B(n528), .Y(n525) );
  AOI21X1 U66 ( .A(n529), .B(n470), .C(n530), .Y(n514) );
  OAI22X1 U67 ( .A(n531), .B(n475), .C(n532), .D(n533), .Y(n530) );
  AOI21X1 U68 ( .A(n534), .B(n535), .C(n536), .Y(n531) );
  OAI21X1 U69 ( .A(n537), .B(n538), .C(n539), .Y(n536) );
  NAND3X1 U70 ( .A(counter[4]), .B(n540), .C(n541), .Y(n539) );
  NAND2X1 U71 ( .A(counter[6]), .B(n542), .Y(n538) );
  NAND3X1 U72 ( .A(n543), .B(n470), .C(n488), .Y(n537) );
  OAI21X1 U73 ( .A(counter[8]), .B(n544), .C(n545), .Y(n535) );
  AOI22X1 U74 ( .A(n546), .B(n542), .C(n547), .D(n470), .Y(n545) );
  NOR2X1 U76 ( .A(counter[6]), .B(n470), .Y(n546) );
  NAND3X1 U77 ( .A(n549), .B(n550), .C(n551), .Y(n512) );
  NOR2X1 U78 ( .A(n548), .B(n552), .Y(n551) );
  NAND3X1 U79 ( .A(counter[1]), .B(n543), .C(n526), .Y(n511) );
  NAND3X1 U81 ( .A(counter[8]), .B(n475), .C(n477), .Y(n553) );
  NAND3X1 U83 ( .A(counter[6]), .B(counter[4]), .C(n554), .Y(n544) );
  NOR2X1 U84 ( .A(n555), .B(n556), .Y(n554) );
  NAND2X1 U85 ( .A(n540), .B(n557), .Y(n556) );
  OAI21X1 U86 ( .A(n533), .B(n558), .C(n559), .Y(n507) );
  OAI21X1 U88 ( .A(n524), .B(n561), .C(n562), .Y(n649) );
  NAND2X1 U89 ( .A(ready), .B(n454), .Y(n562) );
  NAND3X1 U91 ( .A(n523), .B(counter[5]), .C(n474), .Y(n466) );
  NAND3X1 U92 ( .A(n543), .B(n475), .C(n488), .Y(n524) );
  OAI21X1 U93 ( .A(n563), .B(n564), .C(n565), .Y(n650) );
  OAI21X1 U94 ( .A(n529), .B(n566), .C(n563), .Y(n565) );
  OAI21X1 U97 ( .A(n482), .B(n568), .C(n569), .Y(n651) );
  NAND2X1 U98 ( .A(a[7]), .B(n568), .Y(n569) );
  NAND2X1 U100 ( .A(n454), .B(n460), .Y(n566) );
  OAI21X1 U101 ( .A(n568), .B(n570), .C(n571), .Y(n652) );
  NAND2X1 U102 ( .A(a[9]), .B(n568), .Y(n571) );
  OAI21X1 U105 ( .A(n558), .B(n573), .C(n672), .Y(n563) );
  NAND2X1 U106 ( .A(n474), .B(n560), .Y(n573) );
  NOR2X1 U107 ( .A(n574), .B(n543), .Y(n560) );
  NAND2X1 U109 ( .A(n523), .B(n555), .Y(n558) );
  OAI21X1 U110 ( .A(n576), .B(n577), .C(n578), .Y(n653) );
  OAI21X1 U111 ( .A(n506), .B(n572), .C(n576), .Y(n578) );
  NAND2X1 U112 ( .A(n491), .B(n460), .Y(n572) );
  NAND2X1 U113 ( .A(n541), .B(n489), .Y(n460) );
  NOR2X1 U114 ( .A(RESET), .B(n579), .Y(n491) );
  OAI21X1 U116 ( .A(n559), .B(n575), .C(n672), .Y(n576) );
  OAI21X1 U118 ( .A(n509), .B(n575), .C(n454), .Y(n455) );
  NOR2X1 U119 ( .A(n580), .B(n579), .Y(n509) );
  OAI21X1 U120 ( .A(n567), .B(n470), .C(n581), .Y(n579) );
  NAND3X1 U121 ( .A(n550), .B(n516), .C(counter[7]), .Y(n581) );
  NAND3X1 U124 ( .A(n549), .B(n475), .C(n547), .Y(n567) );
  NAND2X1 U127 ( .A(counter[2]), .B(counter[1]), .Y(n476) );
  AOI22X1 U129 ( .A(n584), .B(n465), .C(n541), .D(n517), .Y(n583) );
  OAI21X1 U130 ( .A(n475), .B(n585), .C(n586), .Y(n517) );
  NAND3X1 U131 ( .A(n475), .B(n540), .C(counter[4]), .Y(n586) );
  NAND2X1 U132 ( .A(counter[7]), .B(n470), .Y(n585) );
  AND2X1 U133 ( .A(n587), .B(n488), .Y(n541) );
  OAI21X1 U134 ( .A(n582), .B(n475), .C(n588), .Y(n465) );
  NAND3X1 U135 ( .A(n589), .B(n475), .C(n534), .Y(n588) );
  NAND2X1 U137 ( .A(counter[1]), .B(n587), .Y(n582) );
  NOR2X1 U138 ( .A(n527), .B(counter[2]), .Y(n587) );
  NOR2X1 U139 ( .A(counter[7]), .B(counter[4]), .Y(n584) );
  NAND3X1 U140 ( .A(n590), .B(n591), .C(n592), .Y(n575) );
  NOR2X1 U141 ( .A(n593), .B(n594), .Y(n592) );
  NAND2X1 U142 ( .A(n489), .B(n595), .Y(n594) );
  NAND3X1 U144 ( .A(n596), .B(n597), .C(n598), .Y(n593) );
  NOR2X1 U145 ( .A(n599), .B(n600), .Y(n591) );
  NOR2X1 U146 ( .A(n601), .B(n602), .Y(n590) );
  OAI21X1 U148 ( .A(n603), .B(n520), .C(n604), .Y(n506) );
  NAND3X1 U149 ( .A(n543), .B(n552), .C(n605), .Y(n604) );
  NOR2X1 U150 ( .A(n548), .B(n574), .Y(n605) );
  NAND3X1 U151 ( .A(counter[4]), .B(counter[1]), .C(counter[3]), .Y(n574) );
  NAND3X1 U152 ( .A(counter[8]), .B(n555), .C(n606), .Y(n548) );
  NOR2X1 U153 ( .A(counter[9]), .B(counter[7]), .Y(n606) );
  NAND2X1 U154 ( .A(counter[2]), .B(n488), .Y(n520) );
  AOI22X1 U155 ( .A(n607), .B(n523), .C(n608), .D(counter[3]), .Y(n603) );
  NOR2X1 U156 ( .A(n532), .B(n470), .Y(n608) );
  NAND2X1 U157 ( .A(n589), .B(n540), .Y(n532) );
  NAND3X1 U159 ( .A(counter[8]), .B(counter[5]), .C(n609), .Y(n527) );
  NOR2X1 U160 ( .A(counter[9]), .B(counter[6]), .Y(n609) );
  NAND3X1 U162 ( .A(counter[7]), .B(n478), .C(n611), .Y(n610) );
  NOR2X1 U163 ( .A(n552), .B(n557), .Y(n611) );
  NOR2X1 U164 ( .A(n555), .B(n528), .Y(n607) );
  NAND2X1 U165 ( .A(n475), .B(n470), .Y(n528) );
  OAI21X1 U166 ( .A(n671), .B(n602), .C(n612), .Y(n654) );
  NAND2X1 U167 ( .A(n26), .B(n613), .Y(n612) );
  OAI21X1 U169 ( .A(n671), .B(n597), .C(n614), .Y(n655) );
  NAND2X1 U170 ( .A(n25), .B(n613), .Y(n614) );
  OAI21X1 U172 ( .A(n671), .B(n596), .C(n615), .Y(n656) );
  NAND2X1 U173 ( .A(n24), .B(n613), .Y(n615) );
  OAI21X1 U175 ( .A(n671), .B(n601), .C(n616), .Y(n657) );
  NAND2X1 U176 ( .A(n23), .B(n613), .Y(n616) );
  OAI21X1 U178 ( .A(n671), .B(n598), .C(n617), .Y(n658) );
  NAND2X1 U179 ( .A(n22), .B(n613), .Y(n617) );
  OAI21X1 U181 ( .A(n671), .B(n600), .C(n618), .Y(n659) );
  NAND2X1 U182 ( .A(n21), .B(n613), .Y(n618) );
  OAI21X1 U184 ( .A(n671), .B(n599), .C(n619), .Y(n660) );
  NAND2X1 U185 ( .A(n20), .B(n613), .Y(n619) );
  OAI21X1 U187 ( .A(n671), .B(n557), .C(n620), .Y(n661) );
  NAND2X1 U188 ( .A(n19), .B(n613), .Y(n620) );
  OAI21X1 U190 ( .A(n671), .B(n478), .C(n621), .Y(n662) );
  NAND2X1 U191 ( .A(n18), .B(n613), .Y(n621) );
  OAI21X1 U193 ( .A(n671), .B(n540), .C(n622), .Y(n663) );
  NAND2X1 U194 ( .A(n17), .B(n613), .Y(n622) );
  OAI21X1 U196 ( .A(n671), .B(n552), .C(n623), .Y(n664) );
  NAND2X1 U197 ( .A(n16), .B(n613), .Y(n623) );
  OAI21X1 U199 ( .A(n671), .B(n555), .C(n624), .Y(n665) );
  NAND2X1 U200 ( .A(n15), .B(n613), .Y(n624) );
  OAI21X1 U202 ( .A(n671), .B(n470), .C(n625), .Y(n666) );
  NAND2X1 U203 ( .A(n14), .B(n613), .Y(n625) );
  OAI21X1 U205 ( .A(n671), .B(n475), .C(n626), .Y(n667) );
  NAND2X1 U206 ( .A(n13), .B(n613), .Y(n626) );
  OAI21X1 U208 ( .A(n671), .B(n543), .C(n627), .Y(n668) );
  NAND2X1 U209 ( .A(n12), .B(n613), .Y(n627) );
  OAI21X1 U211 ( .A(n671), .B(n488), .C(n628), .Y(n669) );
  NAND2X1 U212 ( .A(n11), .B(n613), .Y(n628) );
  OAI21X1 U214 ( .A(n671), .B(n595), .C(n629), .Y(n670) );
  NAND2X1 U215 ( .A(n10), .B(n613), .Y(n629) );
  OAI21X1 U218 ( .A(RESET), .B(n630), .C(n494), .Y(n671) );
  NAND2X1 U219 ( .A(flag), .B(n454), .Y(n494) );
  NAND2X1 U221 ( .A(INIT), .B(n631), .Y(n630) );
  INVX2 U4 ( .A(csbar), .Y(n453) );
  INVX2 U7 ( .A(n460), .Y(n458) );
  INVX2 U8 ( .A(ba[0]), .Y(n456) );
  INVX2 U11 ( .A(n465), .Y(n461) );
  INVX2 U21 ( .A(a[11]), .Y(n479) );
  INVX2 U23 ( .A(a[5]), .Y(n480) );
  INVX2 U27 ( .A(a[1]), .Y(n484) );
  INVX2 U29 ( .A(a[0]), .Y(n485) );
  INVX2 U34 ( .A(a[2]), .Y(n486) );
  OR2X2 U36 ( .A(n491), .B(n672), .Y(n481) );
  INVX2 U37 ( .A(a[4]), .Y(n490) );
  INVX2 U39 ( .A(a[6]), .Y(n492) );
  INVX2 U41 ( .A(a[12]), .Y(n493) );
  INVX2 U47 ( .A(n498), .Y(n497) );
  INVX2 U52 ( .A(casbar), .Y(n504) );
  INVX2 U53 ( .A(n503), .Y(n452) );
  INVX2 U56 ( .A(n502), .Y(n510) );
  INVX2 U58 ( .A(n499), .Y(n513) );
  INVX2 U75 ( .A(n548), .Y(n542) );
  INVX2 U80 ( .A(n553), .Y(n526) );
  INVX2 U82 ( .A(n544), .Y(n477) );
  INVX2 U87 ( .A(n560), .Y(n533) );
  OR2X2 U90 ( .A(n466), .B(n470), .Y(n561) );
  INVX2 U95 ( .A(n567), .Y(n529) );
  INVX2 U96 ( .A(a[8]), .Y(n564) );
  INVX2 U99 ( .A(n566), .Y(n482) );
  INVX2 U103 ( .A(n572), .Y(n570) );
  INVX2 U104 ( .A(n563), .Y(n568) );
  INVX2 U108 ( .A(n575), .Y(n474) );
  INVX2 U115 ( .A(a[10]), .Y(n577) );
  INVX2 U122 ( .A(n582), .Y(n516) );
  INVX2 U123 ( .A(n528), .Y(n550) );
  INVX2 U125 ( .A(n532), .Y(n547) );
  INVX2 U126 ( .A(n476), .Y(n549) );
  INVX2 U128 ( .A(n583), .Y(n580) );
  INVX2 U136 ( .A(n520), .Y(n534) );
  INVX2 U143 ( .A(n494), .Y(n489) );
  INVX2 U147 ( .A(n506), .Y(n559) );
  INVX2 U158 ( .A(n527), .Y(n589) );
  INVX2 U161 ( .A(n610), .Y(n523) );
  INVX2 U168 ( .A(counter[16]), .Y(n602) );
  INVX2 U171 ( .A(counter[15]), .Y(n597) );
  INVX2 U174 ( .A(counter[14]), .Y(n596) );
  INVX2 U177 ( .A(counter[13]), .Y(n601) );
  INVX2 U180 ( .A(counter[12]), .Y(n598) );
  INVX2 U183 ( .A(counter[11]), .Y(n600) );
  INVX2 U186 ( .A(counter[10]), .Y(n599) );
  INVX2 U189 ( .A(counter[9]), .Y(n557) );
  INVX2 U192 ( .A(counter[8]), .Y(n478) );
  INVX2 U195 ( .A(counter[7]), .Y(n540) );
  INVX2 U198 ( .A(counter[6]), .Y(n552) );
  INVX2 U201 ( .A(counter[5]), .Y(n555) );
  INVX2 U210 ( .A(counter[2]), .Y(n543) );
  INVX2 U213 ( .A(counter[1]), .Y(n488) );
  INVX2 U217 ( .A(counter[0]), .Y(n595) );
  INVX2 U222 ( .A(flag), .Y(n631) );
  ddr2_init_engine_DW01_inc_0 add_107 ( .A(counter), .SUM({n26, n25, n24, n23, 
        n22, n21, n20, n19, n18, n17, n16, n15, n14, n13, n12, n11, n10}) );
  INVX2 U223 ( .A(n455), .Y(n672) );
  INVX2 U224 ( .A(counter[3]), .Y(n475) );
  INVX2 U225 ( .A(RESET), .Y(n454) );
  INVX2 U226 ( .A(counter[4]), .Y(n470) );
  AND2X2 U227 ( .A(n671), .B(n630), .Y(n613) );
endmodule

