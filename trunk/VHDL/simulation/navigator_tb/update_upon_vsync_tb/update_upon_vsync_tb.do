
vlib work
vmap work work
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/update_upon_vsync/update_upon_vsync.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/simulation/navigator_tb/update_upon_vsync_tb/update_upon_vsync_tb.vhd
vsim -voptargs=+acc work.update_upon_vsync_tb

radix signal sim:/update_upon_vsync_tb/x  unsigned
radix signal sim:/update_upon_vsync_tb/y  unsigned
radix signal sim:/update_upon_vsync_tb/x_updated  unsigned
radix signal sim:/update_upon_vsync_tb/y_updated  unsigned

add wave sim:/update_upon_vsync_tb/*

run 100000 ns
echo "------- END OF UPDATE_UPON_VSYNC_TB.DO FILE -------"