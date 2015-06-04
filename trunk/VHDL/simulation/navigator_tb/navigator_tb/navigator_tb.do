
vlib work
vmap work work
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/x_y_location/x_y_location.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/update_upon_vsync/update_upon_vsync.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/x_y_location_top/x_y_location_top.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/debouncer/debouncer.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/navigator.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/simulation/navigator_tb/navigator_tb/navigator_tb.vhd
vsim -voptargs=+acc work.navigator_tb

radix signal sim:/navigator_tb/hor_out  unsigned
radix signal sim:/navigator_tb/ver_out  unsigned
radix signal sim:/navigator_tb/hor_value  unsigned 
radix signal sim:/navigator_tb/ver_value  unsigned
radix signal sim:/navigator_tb/navigator_inst/hor_out   unsigned
radix signal sim:/navigator_tb/navigator_inst/ver_out  unsigned
radix signal sim:/navigator_tb/navigator_inst/x_out  unsigned
radix signal sim:/navigator_tb/navigator_inst/y_out  unsigned

add wave -r /*
add wave sim:/navigator_tb/direction_press_proc/*

run 100000 ns
echo "------- END OF X_Y_LOCTION_TOP_TB.DO FILE -------"