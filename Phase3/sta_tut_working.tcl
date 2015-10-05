#############################################################################
#
# EE577b Spring 2010
#
# This is a simple sample script file for PrimeTime
# Written by Ehsan Pakbaznia for EE577B Fall 2007
# Use this script template as an start poit and add/modify your own commands
#
#############################################################################

# Reading the design
# copy your synthesized verilog file in the ./designs/ before timing analysis
# NOTE: you should use your own design name "sta_tut.v" is just an example
read_verilog designs/ddr2_controller.syn.v ;

# Link the design with the library

link_design ddr2_init_engine;

# Create clock for your design
# NOTE: you should modify this command to put the appropraite clock period
# and to connect the clock to the appropriate port of your design
# this example creates a clock signal named "CLK" with period of 6.666 ns
# the created clock signal will be connected to the port "clk" of your design 
create_clock -period 2.6 -name CLK [get_ports clk];

# Set the clock latency
# with this command you can specify the delay between the edge of the system 
# clock (CLK) and the edge of the clock that gets to the sequential devices 
# inside your design

#set_clock_latency 0.1 CLK;
#set_dont_touch_network CLK ;

 set_clock_latency 0.5 CLK
# Here you should set your input delays using the set_input_delay coammand
# here is an example for a port "X" in your design

#set_input_delay 0.5 -max -clock CLK [remove_from_collection [all_inputs] [get_ports "clk"]] ;
set_input_delay 0.5 -clock CLK [remove_from_collection [all_inputs] [get_ports "clk"]];

# Here you should set your output delay constraints using the set_input_delay coammand
# here is an example that makes the required time for all the output ports 
# in your design to be 1.0 nanoseconds before the clock edge

set_output_delay 0.3 -clock CLK [all_outputs];

# Here you can add any other command that you wish to check and report
# here is just an example

report_timing;
check_timing;

