Email: 
cma290@usc.edu 
apeter@usc.edu

1.Pre-syn simulation:
put ddr2_controller_tb.v in "RTL" to "tb" folder;
put all other files in "RTL" to "design" folder;
> source .cshrc
> source setup.csh
> cd simulation_folder
> make sim

2.Post-syn simulation:
put ddr2_controller_tb.v in "POST" to "tb" folder;
put all other files in "POST" to "design" folder;
> source .cshrc
> source setup.csh
> cd post_simulation_folder
> make sim