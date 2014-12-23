;# sg_tb.do

# compile design
vcom opcode_unite.vhd
vcom general_fifo.vhd
vcom RAM_300.vhd
vcom opcode_store.vhd
vcom manager.vhd
vcom mux2.vhd

# compile TB
vcom txt_util.vhd
vcom sdram_symbol_model.vhd
vcom Symbol_Generator_Top_TB.vhd

echo "---------------COMPILATION IS OVER--------------------------"

vsim -t ns -voptargs=+acc work.symbol_generator_top_tb
add wave -r /*
run 1 ms