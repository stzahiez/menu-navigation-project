###################################################################################
# Mentor Graphics Corporation
#
###################################################################################

#################
# Attributes
#################
set_attribute -name INFF -value "FALSE" -port -type string fpga_clk -design gatelevel 
set_attribute -name clk0_divide_by -value "3" -instance -type integer global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name clk0_duty_cycle -value "50" -instance -type integer global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name clk0_multiply_by -value "8" -instance -type integer global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name clk0_phase_shift -value "0" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name clk1_divide_by -value "1" -instance -type integer global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name clk1_duty_cycle -value "50" -instance -type integer global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name clk1_multiply_by -value "2" -instance -type integer global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name clk1_phase_shift -value "0" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name clk2_divide_by -value "5" -instance -type integer global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name clk2_duty_cycle -value "50" -instance -type integer global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name clk2_multiply_by -value "4" -instance -type integer global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name clk2_phase_shift -value "0" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name compensate_clock -value "CLK0" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name gate_lock_signal -value "NO" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name inclk0_input_frequency -value "20000" -instance -type integer global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name intended_device_family -value "Cyclone II" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name invalid_lock_multiplier -value "5" -instance -type integer global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name lpm_hint -value "CBX_MODULE_PREFIX=pll" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_activeclock -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_areset -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_clkbad0 -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_clkbad1 -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_clkloss -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_clkswitch -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_configupdate -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_fbin -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_inclk0 -value "PORT_USED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_inclk1 -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_locked -value "PORT_USED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_pfdena -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_phasecounterselect -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_phasedone -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_phasestep -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_phaseupdown -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_pllena -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_scanaclr -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_scanclk -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_scanclkena -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_scandata -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_scandataout -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_scandone -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_scanread -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_scanwrite -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_clk0 -value "PORT_USED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_clk1 -value "PORT_USED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_clk2 -value "PORT_USED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_clk3 -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_clk4 -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_clk5 -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_clkena0 -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_clkena1 -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_clkena2 -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_clkena3 -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_clkena4 -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_clkena5 -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_extclk0 -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_extclk1 -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_extclk2 -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name port_extclk3 -value "PORT_UNUSED" -instance -type string global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name valid_lock_multiplier -value "1" -instance -type integer global_nets_inst_clk_blk_inst_pll_inst_altpll_component -design gatelevel 
set_attribute -name address_reg_b -value "CLOCK1" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_wr_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name clock_enable_input_a -value "BYPASS" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_wr_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name clock_enable_input_b -value "BYPASS" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_wr_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name clock_enable_output_a -value "BYPASS" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_wr_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name clock_enable_output_b -value "BYPASS" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_wr_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name intended_device_family -value "Cyclone II" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_wr_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name numwords_a -value "1024" -instance -type integer mds_top_inst_mem_mng_inst_mem_ctrl_wr_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name numwords_b -value "512" -instance -type integer mds_top_inst_mem_mng_inst_mem_ctrl_wr_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name outdata_aclr_b -value "NONE" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_wr_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name outdata_reg_b -value "UNREGISTERED" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_wr_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name power_up_uninitialized -value "FALSE" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_wr_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name widthad_a -value "10" -instance -type integer mds_top_inst_mem_mng_inst_mem_ctrl_wr_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name widthad_b -value "9" -instance -type integer mds_top_inst_mem_mng_inst_mem_ctrl_wr_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name width_a -value "8" -instance -type integer mds_top_inst_mem_mng_inst_mem_ctrl_wr_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name width_b -value "16" -instance -type integer mds_top_inst_mem_mng_inst_mem_ctrl_wr_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name width_byteena_a -value "1" -instance -type integer mds_top_inst_mem_mng_inst_mem_ctrl_wr_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name address_reg_b -value "CLOCK1" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_rd_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name clock_enable_input_a -value "BYPASS" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_rd_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name clock_enable_input_b -value "BYPASS" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_rd_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name clock_enable_output_a -value "BYPASS" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_rd_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name clock_enable_output_b -value "BYPASS" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_rd_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name intended_device_family -value "Cyclone II" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_rd_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name numwords_a -value "512" -instance -type integer mds_top_inst_mem_mng_inst_mem_ctrl_rd_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name numwords_b -value "1024" -instance -type integer mds_top_inst_mem_mng_inst_mem_ctrl_rd_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name outdata_aclr_b -value "NONE" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_rd_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name outdata_reg_b -value "UNREGISTERED" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_rd_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name power_up_uninitialized -value "FALSE" -instance -type string mds_top_inst_mem_mng_inst_mem_ctrl_rd_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name widthad_a -value "9" -instance -type integer mds_top_inst_mem_mng_inst_mem_ctrl_rd_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name widthad_b -value "10" -instance -type integer mds_top_inst_mem_mng_inst_mem_ctrl_rd_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name width_a -value "16" -instance -type integer mds_top_inst_mem_mng_inst_mem_ctrl_rd_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name width_b -value "8" -instance -type integer mds_top_inst_mem_mng_inst_mem_ctrl_rd_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name width_byteena_a -value "1" -instance -type integer mds_top_inst_mem_mng_inst_mem_ctrl_rd_inst_ram1_inst_altsyncram_component -design gatelevel 
set_attribute -name intended_device_family -value "Cyclone II" -instance -type string mds_top_inst_disp_ctrl_inst_dc_fifo_inst_dcfifo_component -design gatelevel 
set_attribute -name lpm_hint -value "MAXIMIZE_SPEED=7," -instance -type string mds_top_inst_disp_ctrl_inst_dc_fifo_inst_dcfifo_component -design gatelevel 
set_attribute -name lpm_showahead -value "OFF" -instance -type string mds_top_inst_disp_ctrl_inst_dc_fifo_inst_dcfifo_component -design gatelevel 
set_attribute -name lpm_widthu -value "13" -instance -type integer mds_top_inst_disp_ctrl_inst_dc_fifo_inst_dcfifo_component -design gatelevel 
set_attribute -name overflow_checking -value "OFF" -instance -type string mds_top_inst_disp_ctrl_inst_dc_fifo_inst_dcfifo_component -design gatelevel 
set_attribute -name rdsync_delaypipe -value "5" -instance -type integer mds_top_inst_disp_ctrl_inst_dc_fifo_inst_dcfifo_component -design gatelevel 
set_attribute -name underflow_checking -value "OFF" -instance -type string mds_top_inst_disp_ctrl_inst_dc_fifo_inst_dcfifo_component -design gatelevel 
set_attribute -name use_eab -value "ON" -instance -type string mds_top_inst_disp_ctrl_inst_dc_fifo_inst_dcfifo_component -design gatelevel 
set_attribute -name write_aclr_synch -value "ON" -instance -type string mds_top_inst_disp_ctrl_inst_dc_fifo_inst_dcfifo_component -design gatelevel 
set_attribute -name wrsync_delaypipe -value "5" -instance -type integer mds_top_inst_disp_ctrl_inst_dc_fifo_inst_dcfifo_component -design gatelevel 
set_attribute -name input_power_up -value "high" -instance uart_serial_in_ibuf -design gatelevel 
set_attribute -name input_power_up -value "low" -instance dram_dq_tbuf(9) -design gatelevel 
set_attribute -name input_power_up -value "low" -instance dram_dq_tbuf(8) -design gatelevel 
set_attribute -name input_power_up -value "low" -instance dram_dq_tbuf(7) -design gatelevel 
set_attribute -name input_power_up -value "low" -instance dram_dq_tbuf(6) -design gatelevel 
set_attribute -name input_power_up -value "low" -instance dram_dq_tbuf(5) -design gatelevel 
set_attribute -name input_power_up -value "low" -instance dram_dq_tbuf(4) -design gatelevel 
set_attribute -name input_power_up -value "low" -instance dram_dq_tbuf(3) -design gatelevel 
set_attribute -name input_power_up -value "low" -instance dram_dq_tbuf(2) -design gatelevel 
set_attribute -name input_power_up -value "low" -instance dram_dq_tbuf(15) -design gatelevel 
set_attribute -name input_power_up -value "low" -instance dram_dq_tbuf(14) -design gatelevel 
set_attribute -name input_power_up -value "low" -instance dram_dq_tbuf(13) -design gatelevel 
set_attribute -name input_power_up -value "low" -instance dram_dq_tbuf(12) -design gatelevel 
set_attribute -name input_power_up -value "low" -instance dram_dq_tbuf(11) -design gatelevel 
set_attribute -name input_power_up -value "low" -instance dram_dq_tbuf(10) -design gatelevel 
set_attribute -name input_power_up -value "low" -instance dram_dq_tbuf(1) -design gatelevel 
set_attribute -name input_power_up -value "low" -instance dram_dq_tbuf(0) -design gatelevel 
set_attribute -name width_a -value "8" -instance -type integer mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name widthad_a -value "10" -instance -type integer mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name numwords_a -value "1024" -instance -type integer mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name outdata_reg_a -value "UNREGISTERED" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name address_aclr_a -value "NONE" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name outdata_aclr_a -value "NONE" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name indata_aclr_a -value "NONE" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name wrcontrol_aclr_a -value "NONE" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name byteena_aclr_a -value "NONE" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name width_byteena_a -value "1" -instance -type integer mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name width_b -value "8" -instance -type integer mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name widthad_b -value "10" -instance -type integer mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name numwords_b -value "1024" -instance -type integer mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name rdcontrol_reg_b -value "CLOCK1" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name address_reg_b -value "CLOCK1" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name outdata_reg_b -value "UNREGISTERED" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name outdata_aclr_b -value "NONE" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name rdcontrol_aclr_b -value "NONE" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name indata_reg_b -value "CLOCK1" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name wrcontrol_wraddress_reg_b -value "CLOCK1" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name byteena_reg_b -value "CLOCK1" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name indata_aclr_b -value "NONE" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name wrcontrol_aclr_b -value "NONE" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name byteena_aclr_b -value "NONE" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name width_byteena_b -value "1" -instance -type integer mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name address_aclr_b -value "NONE" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name byte_size -value "8" -instance -type integer mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name read_during_write_mode_mixed_ports -value "OLD_DATA" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name ram_block_type -value "AUTO" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name init_file -value "UNUSED" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name init_file_layout -value "UNUSED" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name maximum_depth -value "0" -instance -type integer mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name intended_device_family -value "Cyclone II" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 
set_attribute -name lpm_hint -value "UNUSED" -instance -type string mds_top_inst_rx_path_inst_ram_data/ix9899z34210 -design gatelevel 

set_attribute -name width_a -value "8" -instance -type integer mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name widthad_a -value "10" -instance -type integer mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name numwords_a -value "1024" -instance -type integer mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name outdata_reg_a -value "UNREGISTERED" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name address_aclr_a -value "NONE" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name outdata_aclr_a -value "NONE" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name indata_aclr_a -value "NONE" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name wrcontrol_aclr_a -value "NONE" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name byteena_aclr_a -value "NONE" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name width_byteena_a -value "1" -instance -type integer mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name width_b -value "8" -instance -type integer mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name widthad_b -value "10" -instance -type integer mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name numwords_b -value "1024" -instance -type integer mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name rdcontrol_reg_b -value "CLOCK1" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name address_reg_b -value "CLOCK1" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name outdata_reg_b -value "UNREGISTERED" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name outdata_aclr_b -value "NONE" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name rdcontrol_aclr_b -value "NONE" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name indata_reg_b -value "CLOCK1" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name wrcontrol_wraddress_reg_b -value "CLOCK1" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name byteena_reg_b -value "CLOCK1" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name indata_aclr_b -value "NONE" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name wrcontrol_aclr_b -value "NONE" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name byteena_aclr_b -value "NONE" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name width_byteena_b -value "1" -instance -type integer mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name address_aclr_b -value "NONE" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name byte_size -value "8" -instance -type integer mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name read_during_write_mode_mixed_ports -value "OLD_DATA" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name ram_block_type -value "AUTO" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name init_file -value "UNUSED" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name init_file_layout -value "UNUSED" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name maximum_depth -value "0" -instance -type integer mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name intended_device_family -value "Cyclone II" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 
set_attribute -name lpm_hint -value "UNUSED" -instance -type string mds_top_inst_tx_path_inst_ram_data/ix9899z34209 -design gatelevel 

set_attribute -name width_a -value "8" -instance -type integer mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name widthad_a -value "4" -instance -type integer mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name numwords_a -value "9" -instance -type integer mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name outdata_reg_a -value "UNREGISTERED" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name address_aclr_a -value "NONE" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name outdata_aclr_a -value "NONE" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name indata_aclr_a -value "NONE" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name wrcontrol_aclr_a -value "NONE" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name byteena_aclr_a -value "NONE" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name width_byteena_a -value "1" -instance -type integer mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name width_b -value "8" -instance -type integer mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name widthad_b -value "4" -instance -type integer mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name numwords_b -value "9" -instance -type integer mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name rdcontrol_reg_b -value "CLOCK1" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name address_reg_b -value "CLOCK1" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name outdata_reg_b -value "UNREGISTERED" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name outdata_aclr_b -value "NONE" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name rdcontrol_aclr_b -value "NONE" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name indata_reg_b -value "CLOCK1" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name wrcontrol_wraddress_reg_b -value "CLOCK1" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name byteena_reg_b -value "CLOCK1" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name indata_aclr_b -value "NONE" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name wrcontrol_aclr_b -value "NONE" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name byteena_aclr_b -value "NONE" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name width_byteena_b -value "1" -instance -type integer mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name address_aclr_b -value "NONE" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name byte_size -value "8" -instance -type integer mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name read_during_write_mode_mixed_ports -value "OLD_DATA" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name ram_block_type -value "AUTO" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name init_file -value "UNUSED" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name init_file_layout -value "UNUSED" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name maximum_depth -value "0" -instance -type integer mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name intended_device_family -value "Cyclone II" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 
set_attribute -name lpm_hint -value "UNUSED" -instance -type string mds_top_inst_tx_path_inst_fifo_inst1_mem/ix9899z31085 -design gatelevel 

set_attribute -name width_a -value "13" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name widthad_a -value "9" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name numwords_a -value "300" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name outdata_reg_a -value "UNREGISTERED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name address_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name outdata_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name indata_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name wrcontrol_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name byteena_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name width_byteena_a -value "1" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name width_b -value "13" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name widthad_b -value "9" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name numwords_b -value "300" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name rdcontrol_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name address_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name outdata_reg_b -value "UNREGISTERED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name outdata_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name rdcontrol_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name indata_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name wrcontrol_wraddress_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name byteena_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name indata_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name wrcontrol_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name byteena_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name width_byteena_b -value "1" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name address_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name byte_size -value "8" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name read_during_write_mode_mixed_ports -value "OLD_DATA" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name ram_block_type -value "AUTO" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name init_file -value "UNUSED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name init_file_layout -value "UNUSED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name maximum_depth -value "0" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name intended_device_family -value "Cyclone II" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 
set_attribute -name lpm_hint -value "UNUSED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_mem/ix35369z18154 -design gatelevel 

set_attribute -name width_a -value "8" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name widthad_a -value "10" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name numwords_a -value "640" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name outdata_reg_a -value "UNREGISTERED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name address_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name outdata_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name indata_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name wrcontrol_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name byteena_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name width_byteena_a -value "1" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name width_b -value "8" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name widthad_b -value "10" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name numwords_b -value "640" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name rdcontrol_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name address_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name outdata_reg_b -value "UNREGISTERED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name outdata_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name rdcontrol_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name indata_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name wrcontrol_wraddress_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name byteena_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name indata_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name wrcontrol_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name byteena_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name width_byteena_b -value "1" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name address_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name byte_size -value "8" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name read_during_write_mode_mixed_ports -value "OLD_DATA" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name ram_block_type -value "AUTO" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name init_file -value "UNUSED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name init_file_layout -value "UNUSED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name maximum_depth -value "0" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name intended_device_family -value "Cyclone II" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 
set_attribute -name lpm_hint -value "UNUSED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_A_mem/ix9899z51759 -design gatelevel 

set_attribute -name width_a -value "8" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name widthad_a -value "10" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name numwords_a -value "640" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name outdata_reg_a -value "UNREGISTERED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name address_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name outdata_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name indata_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name wrcontrol_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name byteena_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name width_byteena_a -value "1" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name width_b -value "8" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name widthad_b -value "10" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name numwords_b -value "640" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name rdcontrol_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name address_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name outdata_reg_b -value "UNREGISTERED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name outdata_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name rdcontrol_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name indata_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name wrcontrol_wraddress_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name byteena_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name indata_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name wrcontrol_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name byteena_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name width_byteena_b -value "1" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name address_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name byte_size -value "8" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name read_during_write_mode_mixed_ports -value "OLD_DATA" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name ram_block_type -value "AUTO" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name init_file -value "UNUSED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name init_file_layout -value "UNUSED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name maximum_depth -value "0" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name intended_device_family -value "Cyclone II" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 
set_attribute -name lpm_hint -value "UNUSED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_fifo_B_mem/ix9899z51760 -design gatelevel 

set_attribute -name width_a -value "23" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name widthad_a -value "9" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name numwords_a -value "400" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name outdata_reg_a -value "UNREGISTERED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name address_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name outdata_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name indata_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name wrcontrol_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name byteena_aclr_a -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name width_byteena_a -value "1" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name width_b -value "23" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name widthad_b -value "9" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name numwords_b -value "400" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name rdcontrol_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name address_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name outdata_reg_b -value "UNREGISTERED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name outdata_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name rdcontrol_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name indata_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name wrcontrol_wraddress_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name byteena_reg_b -value "CLOCK1" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name indata_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name wrcontrol_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name byteena_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name width_byteena_b -value "1" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name address_aclr_b -value "NONE" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name byte_size -value "8" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name read_during_write_mode_mixed_ports -value "OLD_DATA" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name ram_block_type -value "AUTO" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name init_file -value "UNUSED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name init_file_layout -value "UNUSED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name maximum_depth -value "0" -instance -type integer mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name intended_device_family -value "Cyclone II" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 
set_attribute -name lpm_hint -value "UNUSED" -instance -type string mds_top_inst_disp_ctrl_inst_Symbol_Generator_Top_inst_opcode_store_inst_general_fifo_inst_mem/ix46338z44324 -design gatelevel 


##################
# Clocks
##################
