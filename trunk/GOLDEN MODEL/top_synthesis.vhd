------------------------------------------------------------------------------------------------
-- Model Name 	:	Top Synthesis
-- File Name	:	top_synthesis.vhd
-- Generated	:	27.3.2013
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description:
--
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date		    Name									Description			
--			1.00		27.3.2013	   	Olga Liberman and Yoav Shvartz			Creation
------------------------------------------------------------------------------------------------
--	Todo:
--	(1) 
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity top_synthesis is
	generic (
		sys_clk_g					:	positive	:= 100000000;				--100MHz for System
		baudrate_g					:	positive	:= 115200;					--UART
		reset_polarity_g			:	std_logic 	:= '0'						--When '0' - Reset
	);
	port(
		--Clock and Reset
		fpga_clk					:	in std_logic ;							--Input clock to the FPGA (50MHz)
		fpga_rst					:	in std_logic ;							--Input reset from FPGA
			
		-- DE2 buttons to Display Controller block
		right       :	in bit; -- Right button signal from the DE2 board.  
		left        :	in bit; -- Left button signal from the DE2 board.  
		up          :	in bit; -- Up button signal from the DE2 board.  
		down        :	in bit; -- Down button signal from the DE2 board.  

		--Clock and Reset to SDRAM, VESA
		clk_sdram_out				:	out std_logic;
		clk_vesa_out				:	out std_logic;

		--UART
		uart_serial_in				:	in std_logic;
		uart_serial_out				:	out std_logic;
				
		--SDRAM Signals
		dram_addr					:	out std_logic_vector (11 downto 0);		--Address (12 bit)
		dram_bank					:	out std_logic_vector (1 downto 0);		--Bank
		dram_cas_n					:	out std_logic;							--Column Address is being transmitted
		dram_cke					:	out std_logic;							--Clock Enable
		dram_cs_n					:	out std_logic;							--Chip Select (Here - Mask commands)
		dram_dq						:	inout std_logic_vector (15 downto 0);	--Data in / Data out
		dram_ldqm					:	out std_logic;							--Byte masking
		dram_udqm					:	out std_logic;							--Byte masking
		dram_ras_n					:	out std_logic;							--Row Address is being transmitted
		dram_we_n					:	out std_logic;							--Write Enable
		
		--VESA signals
		--Output RGB
		r_out						:	out std_logic_vector(9 downto 0);		--Output R Pixel
		g_out						:	out std_logic_vector(9 downto 0);   	--Output G Pixel
		b_out						:	out std_logic_vector(9 downto 0);  		--Output B Pixel
		--Blanking signal
		blank						:	out std_logic;							--Blanking signal
		--Sync Signals			
		hsync						:	out std_logic;							--HSync Signal
		vsync						:	out std_logic;							--VSync Signal
		
		--Debug Ports
		dbg_rx_path_cyc				:	out std_logic;							--RX Path WBM_CYC_O for debug
		--dbg_type_reg_mem			:	out std_logic_vector (7 downto 0);		--Mem_Management Type Register value for Debug
		--dbg_type_reg_disp			:	out std_logic_vector (7 downto 0);		--Display Type Register value for Debug
		--dbg_type_reg_tx				:	out std_logic_vector (7 downto 0);		--RX_Path Type Register value for Debug
		dbg_sdram_active				:	out std_logic;							--'1' when WBM_CYC_O from mem_mng_top to SDRAM is active
		dbg_disp_active				:	out std_logic;							--'1' when WBM_CYC_O from disp_ctrl_top to INTERCON_Y is active
		dbg_icy_bus_taken			:	out std_logic;							--'1' when INTERCON_Y is taken, '0' otherwise
		dbg_icz_bus_taken			:	out std_logic;							--'1' when INTERCON_Z is taken, '0' otherwise
		dbg_wr_bank_val				:	out std_logic;							--Expected Write SDRAM Bank Value
		dbg_rd_bank_val     		:	out std_logic;							--Expected Read SDRAM Bank Value
		dbg_actual_wr_bank			:	out std_logic;							--Actual read bank
		dbg_actual_rd_bank			:	out std_logic;							--Actual Written bank
		programming_indication_led 	:	out std_logic; -- blinks at a predefiened frequency - an indication for successfull programming on FPGA
		lsb_mem						:	out std_logic_vector(6 downto 0);
		msb_mem						:	out std_logic_vector(6 downto 0);
		lsb_disp					:	out std_logic_vector(6 downto 0);
		msb_disp					:	out std_logic_vector(6 downto 0);
		lsb_tx						:	out std_logic_vector(6 downto 0);
		msb_tx						:	out std_logic_vector(6 downto 0);
		lsb_version					:	out std_logic_vector(6 downto 0);
		msb_version					:	out std_logic_vector(6 downto 0)
	);
end entity top_synthesis;

architecture top_synthesis_rtl of top_synthesis is

--#############################	Components	##############################################--

--component global_nets_top
--	generic(
--		reset_polarity_g			:	std_logic := '0'		--When '0' - Reset
--	);
--	port(
--		fpga_clk					:	in std_logic ;				--Input clock to the FPGA (50MHz)
--		fpga_rst					:	in std_logic ;				--Input reset from FPGA
	--	sdram_clk					:	out std_logic ;				--Output SDRAM clock (133MHz)
	--	system_clk					:	out std_logic ;				--Output System clock (100MHz)
	--	vesa_clk					:	out std_logic ;				--Output VESA clock (40MHz)
	--	sync_sdram_rst				:	out std_logic ;				--Output Synchronized reset - 133MHz
	--	sync_system_rst				:	out std_logic ;				--Output Synchronized reset - 100MHz
	--	sync_vesa_rst				:	out std_logic				--Output Synchronized reset - 40MHz
--	);
--end component global_nets_top;

component mds_top
	generic(
		sys_clk_g					:	positive	:= 100000000;		--100MHz for System
		baudrate_g					:	positive	:= 115200
	);
	port(
		--Clock and Reset from system
		clk_133						:	in std_logic;
		clk_100						:	in std_logic;
		clk_40						:	in std_logic;
		rst_133						:	in std_logic;
		rst_100						:	in std_logic;
		rst_40						:	in std_logic;
		
		-- DE2 buttons to Display Controller block
		right       :	in bit; -- Right button signal from the DE2 board.  
		left        :	in bit; -- Left button signal from the DE2 board.  
		up          :	in bit; -- Up button signal from the DE2 board.  
		down        :	in bit; -- Down button signal from the DE2 board.  

		--Clock and Reset to SDRAM, VESA
		clk_sdram_out				:	out std_logic;
		clk_vesa_out				:	out std_logic;
		
		--UART
		uart_serial_in				:	in std_logic;
		uart_serial_out				:	out std_logic;
		
		--SDRAM Signals
		dram_addr					:	out std_logic_vector (11 downto 0);		--Address (12 bit)
		dram_bank					:	out std_logic_vector (1 downto 0);		--Bank
		dram_cas_n					:	out std_logic;							--Column Address is being transmitted
		dram_cke					:	out std_logic;							--Clock Enable
		dram_cs_n					:	out std_logic;							--Chip Select (Here - Mask commands)
		dram_dq						:	inout std_logic_vector (15 downto 0);	--Data in / Data out
		dram_ldqm					:	out std_logic;							--Byte masking
		dram_udqm					:	out std_logic;							--Byte masking
		dram_ras_n					:	out std_logic;							--Row Address is being transmitted
		dram_we_n					:	out std_logic;							--Write Enable
		
		--VESA signals
			--Output RGB
		r_out						:	out std_logic_vector(9 downto 0);		--Output R Pixel
		g_out						:	out std_logic_vector(9 downto 0);   	--Output G Pixel
		b_out						:	out std_logic_vector(9 downto 0);  		--Output B Pixel
		
			--Blanking signal
		blank						:	out std_logic;										--Blanking signal
			
			--Sync Signals			
		hsync						:	out std_logic;										--HSync Signal
		vsync						:	out std_logic;										--VSync Signal

		--Debug Ports
		dbg_rx_path_cyc				:	out std_logic;							--RX Path WBM_CYC_O for debug
		dbg_type_reg_mem			:	out std_logic_vector (7 downto 0);		--Mem_Management Type Register value for Debug
		dbg_type_reg_disp			:	out std_logic_vector (7 downto 0);		--Display Type Register value for Debug
		dbg_type_reg_tx				:	out std_logic_vector (7 downto 0);		--RX_Path Type Register value for Debug
		dbg_sdram_active				:	out std_logic;							--'1' when WBM_CYC_O from mem_mng_top to SDRAM is active
		dbg_disp_active				:	out std_logic;							--'1' when WBM_CYC_O from disp_ctrl_top to INTERCON_Y is active
		dbg_icy_bus_taken			:	out std_logic;							--'1' when INTERCON_Y is taken, '0' otherwise
		dbg_icz_bus_taken			:	out std_logic;							--'1' when INTERCON_Z is taken, '0' otherwise
		dbg_wr_bank_val				:	out std_logic;							--Write SDRAM Bank Value
		dbg_rd_bank_val     		:	out std_logic;							--Expected Read SDRAM Bank Value
		dbg_actual_wr_bank			:	out std_logic;							--Actual read bank
		dbg_actual_rd_bank			:	out std_logic;							--Actual Written bank
		programming_indication_led 	: out std_logic; -- blinks at a predefiened frequency - an indication for successfull programming on FPGA
		dbg_version_reg				:	out std_logic_vector (7 downto 0)		--Version Register Value
			);
end component mds_top;

component hexss
	port(	
		din		: in std_logic_vector (3 downto 0); --Decimal Number
		ss		: out std_logic_vector (6 downto 0) := (others => '0') --Output to 7 Segment
	);
end component hexss;

--#############################	Signals	##############################################--

--Clocks and Resets
signal clk_133						:	std_logic := '0';
signal rst_133						:	std_logic;
signal clk_100						:	std_logic := '0';
signal rst_100						:	std_logic;
signal clk_40						:	std_logic := '0';
signal rst_40						:	std_logic;

		

--dbg type regs
signal dbg_type_reg_mem				:	std_logic_vector (7 downto 0);		--Mem_Management Type Register value for Debug
signal dbg_type_reg_disp			:	std_logic_vector (7 downto 0);		--Display Type Register value for Debug
signal dbg_type_reg_tx				:	std_logic_vector (7 downto 0);		--RX_Path Type Register value for Debug
signal dbg_version_reg				:	std_logic_vector (7 downto 0);		--RX_Path Type Register value for Debug

begin

--#############################	Instatiations	##############################################--
clk_proc1:
clk_133	<=	not clk_133 after 3.75 ns;
clk_proc2:
clk_100	<=	not clk_100 after 5 ns;
clk_proc3:
clk_40	<=	not clk_40 after 12.5 ns;

rst_proc1:
rst_133	<=	'0', '1' after 20 ns;
rst_proc2:
rst_100	<=	'0', '1' after 20 ns;
rst_proc3:
rst_40	<=	'0', '1' after 20 ns;
--global_nets_inst : global_nets_top
	--generic map(
		--reset_polarity_g			=>	reset_polarity_g
--	)
	--port map (
--		fpga_clk					=>	fpga_clk,
	--	fpga_rst					=>	fpga_rst,
--		sdram_clk					=>	clk_133,
--		system_clk					=>	clk_100,
--		vesa_clk					=>	clk_40,
--		sync_sdram_rst				=>	rst_133,
--		sync_system_rst				=>	rst_100,
--		sync_vesa_rst				=>	rst_40
--	);	
		
		
mds_top_inst : mds_top
	generic map(
		sys_clk_g					=>	sys_clk_g,
		baudrate_g					=>	baudrate_g
	)
	port map(
		clk_133	            		=>	clk_133,
		clk_100	            		=>	clk_100,
		clk_40	            		=>	clk_40,
		rst_133	            		=>	rst_133,
		rst_100	            		=>	rst_100,
		rst_40	            		=>	rst_40,
	
		right                 =>	right,
    left                  =>	left, 
    up                    =>	up,
    down                  =>	down,
		
		clk_sdram_out				=>	clk_sdram_out,
		clk_vesa_out				=>	clk_vesa_out,
		uart_serial_in				=>	uart_serial_in	,
		uart_serial_out				=>	uart_serial_out	,
		dram_addr					=>	dram_addr		,
		dram_bank					=>	dram_bank		,
		dram_cas_n					=>	dram_cas_n		,
		dram_cke					=>	dram_cke		,
		dram_cs_n					=>	dram_cs_n		,
		dram_dq						=>	dram_dq			,
		dram_ldqm					=>	dram_ldqm		,
		dram_udqm					=>	dram_udqm		,
		dram_ras_n					=>	dram_ras_n		,
		dram_we_n					=>	dram_we_n		,
		r_out						=>	r_out			,
		g_out						=>	g_out			,
		b_out						=>	b_out			,
		blank						=>	blank			,
		hsync						=>	hsync			,
		vsync						=>  vsync			,
		dbg_rx_path_cyc				=>	dbg_rx_path_cyc		,
		dbg_type_reg_disp			=>	dbg_type_reg_disp	,
		dbg_type_reg_mem			=>	dbg_type_reg_mem	,
		dbg_type_reg_tx				=>	dbg_type_reg_tx		,
		dbg_sdram_active				=>	dbg_sdram_active		,
		dbg_disp_active				=>	dbg_disp_active		,
		dbg_icy_bus_taken			=>	dbg_icy_bus_taken	,
		dbg_icz_bus_taken			=>	dbg_icz_bus_taken,	
		dbg_wr_bank_val 			=>	dbg_wr_bank_val,
		dbg_rd_bank_val 			=>	dbg_rd_bank_val,
		dbg_actual_wr_bank			=>	dbg_actual_wr_bank,
		dbg_actual_rd_bank  		=>	dbg_actual_rd_bank,
		programming_indication_led	=>	programming_indication_led,
		dbg_version_reg				=>	dbg_version_reg
	);

--------------------- Memory Type Register --------------------------
lsb_mem_hexss_inst : hexss
	port map(
		din	            		=>	dbg_type_reg_mem(3 downto 0),
		ss	            		=>	lsb_mem
	);
msb_mem_hexss_inst : hexss
	port map(
		din	            		=>	dbg_type_reg_mem(7 downto 4),
		ss	            		=>	msb_mem
	);

--------------------- Display Type Register --------------------------
lsb_disp_hexss_inst : hexss
	port map(
		din	            		=>	dbg_type_reg_disp(3 downto 0),
		ss	            		=>	lsb_disp
	);
msb_disp_hexss_inst : hexss
	port map(
		din	            		=>	dbg_type_reg_disp(7 downto 4),
		ss	            		=>	msb_disp
	);

--------------------- TX Type Register --------------------------
lsb_tx_hexss_inst : hexss
	port map(
		din	            		=>	dbg_type_reg_tx(3 downto 0),
		ss	            		=>	lsb_tx
	);
msb_tx_hexss_inst : hexss
	port map(
		din	            		=>	dbg_type_reg_tx(7 downto 4),
		ss	            		=>	msb_tx
	);

--------------------- Memory Type Register --------------------------
lsb_version_hexss_inst : hexss
	port map(
		din	            		=>	dbg_version_reg(3 downto 0),
		ss	            		=>	lsb_version
	);
msb_version_hexss_inst : hexss
	port map(
		din	            		=>	dbg_version_reg(7 downto 4),
		ss	            		=>	msb_version
	);


end architecture top_synthesis_rtl;