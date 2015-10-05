####################################################################################
#
# EE-577b - Fall 2011
# Project phase1
#
####################################################################################

# Setting variables for synthesis
set design_name ddr2_controller ;
set clk_period 2.6;
set posedge 0.0;
set negedge [expr $clk_period * 0.7];

analyze -f verilog ./src/SSTL18DDR2.v;
analyze -f verilog ./src/SSTL18DDR2DIFF.v;
analyze -f verilog ./src/SSTL18DDR2INTERFACE_RTL.v;
analyze -f verilog ./src/FIFO.v;
analyze -f verilog ./src/ddr2_init_engine.v;
analyze -f verilog ./src/Processing_logic.v;
analyze -f verilog ./src/ddr2_ring_buffer8.v;

read_verilog ./src/ddr2_controller.v ;

set_dont_touch [ find cell process_logic_ddr2/ring_buffer/DELAY*]
get_attribute [ find cell process_logic_ddr2/ring_buffer/DELAY*] dont_touch

set_dont_touch [ find cell process_logic_ddr2/clk_buffer*]
get_attribute [ find cell process_logic_ddr2/clk_buffer*] dont_touch

# set_dont_touch [ find cell process_logic_ddr2/clk_buffer2/DELAY*]
# get_attribute [ find cell process_logic_ddr2/clk_buffer2/DELAY*] dont_touch

# Setting $design_name as current working design.
# Use this command before setting any constraints.
current_design $design_name ;

# If you have multiple instances of the same module,
# use this so that DesignCompiler optimizea each instance separately
uniquify ;

# Linking your design into the cells in standard cell libraries.
# This command checks whether your design can be compiled
# with the target libraries specified in the .synopsys_dc.setup file.
link ;

# Setting timing constraints for sequential logic.
# => clock period, input delay, output delay

# (1) Setting clock period.
create_clock -name "CLK" -period $clk_period -waveform [list $posedge $negedge] [get_ports CLK];

# (2) Setting addtional constraints for clock signal,
# so that clock network should be ideal network without any buffers.
set_dont_touch_network CLK ;
set_ideal_network CLK ;

# (3) Setting input path delays on input ports(except clock) relative to a clock edge .
# Input signals will arrive after this delay.
set_input_delay 0.5 -max -clock CLK [remove_from_collection [all_inputs] [get_ports "CLK"]] ;

# (4) Setting output path delays on output ports relative to a clock edge.
# output signals should be generated before this delay.
set_output_delay 0.3 -clock CLK [all_outputs] ;

# "check_design" checks the internal representation of the
# current design for consistency and issues error and
# warning messages as appropriate.
check_design > report/$design_name.check_design ;

# Perforing synthesis and optimization on the current_design.
compile ;

# For better synthesis result, use "compile_ultra" command.
# compile_ultra is doing automatic ungrouping during optimization,
# therefore sometimes it's hard to figure out the critical path 
# from the synthesized netlist.
# So, use "compile" command for HW#5.

# Writing the synthesis result into Synopsys db format
# You can read the saved db file into DesignCompiler later using
# "read_db" command for further analysis (timing, area...).
write -xg_force_db -format db -hierarchy -out db/$design_name.db ;

# Generating timing and are report of the synthezied design.
report_timing > report/$design_name.timing ;
report_area > report/$design_name.area ;

# Writing synthesized gate-level verilog netlist.
# This verilog netlist will be used for post-synthesis gate-level simulation.
change_names -rules verilog -hierarchy ;
write -format verilog -hierarchy -out netlist/$design_name.syn.v ;

# Writing Standard Delay Format (SDF) back-annotation file.
# This delay information can be used for post-synthesis simulation.
write_sdf sdf/$design_name.sdf;
