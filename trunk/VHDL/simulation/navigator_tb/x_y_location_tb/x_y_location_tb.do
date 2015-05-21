--cd C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/simulation/navigator_tb/x_y_location_tb
vlib work
vmap work work
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/x_y_location/x_y_location.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/simulation/navigator_tb/x_y_location_tb/x_y_location_tb.vhd
vsim -voptargs=+acc work.x_y_location_tb
add wave *
add wave  \sim:/x_y_location_tb/x_y_location_inst/curr_sm
run 1500 ns
echo "------- END OF X_Y_LOCTION_TB.DO FILE -------"