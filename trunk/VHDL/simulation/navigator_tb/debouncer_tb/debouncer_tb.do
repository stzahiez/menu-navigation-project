cd C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/simulation/navigator_tb/debouncer_tb
vlib work
vmap work work
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/debouncer/debouncer.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/simulation/navigator_tb/debouncer_tb/debouncer_TB.vhd
vsim -voptargs=+acc work.debouncer_tb
add wave *
add wave  \sim:/debouncer_tb/debouncer_inst/int_count
run 500027100 ns
echo "------- END OF DEBOUNCER_TB.DO FILE -------"