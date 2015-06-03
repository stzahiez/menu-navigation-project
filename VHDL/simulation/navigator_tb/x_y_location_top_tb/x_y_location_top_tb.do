
vlib work
vmap work work
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/x_y_location/x_y_location.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/update_upon_vsync/update_upon_vsync.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/x_y_location_top/x_y_location_top.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/simulation/navigator_tb/x_y_location_top_tb/x_y_location_top_tb.vhd
vsim -voptargs=+acc work.x_y_location_top_tb

radix signal sim:/x_y_location_top_tb/x_updated unsigned
radix signal sim:/x_y_location_top_tb/y_updated unsigned
radix signal sim:/x_y_location_top_tb/hor_value unsigned 
radix signal sim:/x_y_location_top_tb/ver_value unsigned
radix signal sim:/x_y_location_top_tb/x_y_location_top_inst/x_updated  unsigned
radix signal sim:/x_y_location_top_tb/x_y_location_top_inst/y_updated unsigned
radix signal sim:/x_y_location_top_tb/x_y_location_top_inst/x_out unsigned
radix signal sim:/x_y_location_top_tb/x_y_location_top_inst/y_out unsigned
radix signal sim:/x_y_location_top_tb/x_y_location_top_inst/x_connect unsigned
radix signal sim:/x_y_location_top_tb/x_y_location_top_inst/y_connect unsigned

add wave -r /*

run 100000 ns
echo "------- END OF X_Y_LOCTION_TOP_TB.DO FILE -------"