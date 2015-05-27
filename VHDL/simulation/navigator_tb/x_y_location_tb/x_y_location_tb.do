
vlib work
vmap work work
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/x_y_location/x_y_location.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/simulation/navigator_tb/x_y_location_tb/x_y_location_tb.vhd
vsim -voptargs=+acc work.x_y_location_tb

radix signal sim:/x_y_location_tb/hor_value unsigned
radix signal sim:/x_y_location_tb/ver_value unsigned
radix signal sim:/x_y_location_tb/x_y_location_inst/x_out unsigned
radix signal sim:/x_y_location_tb/x_y_location_inst/y_out unsigned
radix signal sim:/x_y_location_tb/x_y_location_inst/x_int unsigned
radix signal sim:/x_y_location_tb/x_y_location_inst/y_int unsigned

add wave sim:/x_y_location_tb/*
add wave sim:/x_y_location_tb/x_y_location_inst/*
add wave sim:/x_y_location_tb/direction_trig_proc/*

run 100000 ns
echo "------- END OF X_Y_LOCTION_TB.DO FILE -------"