
vlib work
vmap work work
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/simulation/clk_reset_model/clk_reset_model.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/debouncer/debouncer.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/simulation/opcode_parser/txt_util.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/simulation/Video_Log/file_log.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/Symbol_Generator/general_fifo.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/Symbol_Generator/manager.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/Symbol_Generator/mux2.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/navigator.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/simulation/opcode_parser/opcode_parser.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/Symbol_Generator/opcode_store.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/Symbol_Generator/opcode_unite.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/Symbol_Generator/RAM_300.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/simulation/sdram_symbol_model/sdram_symbol_model.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/Symbol_Generator/Symbol_Generator_Top.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/simulation/Symbol_Generator_Top_TB/Symbol_Generator_Top_TB.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/update_upon_vsync/update_upon_vsync.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/simulation/vesa_gen_ctrl/vesa_gen_ctrl.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/x_y_location/x_y_location.vhd
vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/design/navigator/x_y_location_top/x_y_location_top.vhd

vcom -reportprogress 300 -work work C:/Users/tzahi/Dropbox/Menu_Navigation_Proj/menu-navigation-project/trunk/VHDL/simulation/Symbol_Generator_Top_TB/Symbol_Generator_Top_TB.vhd
vsim -voptargs=+acc work.symbol_generator_top_tb 

radix signal sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/manager_inst/ver_location   unsigned
radix signal sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/manager_inst/hor_location   unsigned

add wave sim:/symbol_generator_top_tb/* 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/manager_inst/ver_location 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/manager_inst/hor_location 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/manager_inst/sym_row 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/manager_inst/sym_col 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/manager_inst/row_count 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/fifo_a_rd_en 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/fifo_a_wr_en 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/fifo_a_data_in 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/fifo_b_rd_en 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/fifo_b_wr_en 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/fifo_b_data_in 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/manager_inst/current_sm 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/fifo_A/mem 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/fifo_A/write_addr 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/fifo_A/read_addr 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/fifo_B/mem 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/fifo_B/write_addr 
add wave sim:/symbol_generator_top_tb/Symbol_Generator_Top_inst/fifo_B/read_addr 

run 20 sec
echo "------- END OF SYMBOL_GENERATOR_TOP_TB.DO FILE -------"