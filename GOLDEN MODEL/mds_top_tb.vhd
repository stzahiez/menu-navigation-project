------------------------------------------------------------------------------------------------
-- Model Name 	:	Modular Decompression System TOP TB
-- File Name	:	mds_top_tb.vhd
-- Generated	:	25.5.2011
-- Author		:	Beeri Schreiber and Alon Yavich
-- Project		:	RunLen Project
------------------------------------------------------------------------------------------------
-- Description: Modular Decompression System TOP TB
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date		Name					Description			
--			1.00		25.5.2011	Beeri Schreiber			Creation
--			2.00		20.03.2013	Olga Liberman			New generics: uart_tx_file_g and output_dir_g
--			2.01		22.03.2013	Olga Liberman			mds_top: new output port 'programming_indication_led'
--
------------------------------------------------------------------------------------------------
--	Todo:
--			(1)
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.ALL;   -- For uniform, trunc functions

entity mds_top_tb is
	generic (
			uart_tx_delay_g		:	positive	:= 133333;			--Clock cycles between two transmissions
			file_max_idx_g		:	positive 	:= 4;				-- uri ran Maximum file index
			uart_tx_file_g		:	string 		:= "P:/Menu_Navigation_Projectwc/trunk/VHDL/simulation/automatic tests/part_B/test_files/test_0/uart_tx/uart_tx"; 	--File name to be transmitted -- 20.03.2013 olga
			output_dir_g		:	string		:= "P:/Menu_Navigation_Projectwc/trunk/VHDL/simulation/automatic tests/part_B/test_files/test_0/output/"	--Name of the outpuhe output direct directory -- 20.03.2013 olga
		);
end entity mds_top_tb;

architecture sim_mds_top_tb of mds_top_tb is

--############################# Constants ############################################--	

--constant rep_size_c		:	positive	:= 8;				-- uri ran 2^8=256 => Maximum of 267 repetitions for pixel / line
constant baudrate_c		:	positive := 115200 * 40;
constant uart_period_c	:	time := (1 sec) / real(baudrate_c);
constant clk_half_period_c : time	:= 5 ns; -- clock 100MHz
constant pixel_clk_half_period_c : time	:= 19.861 ns; -- pixel clock for 640x480 @ 60 Hz = 25.175 MHz
constant loop_size_c  : positive := 100; 
constant num_of_directions_c  : real := 4.0;
constant double_max_value_time_real_c  : 		real	:= 1000000000.0;
constant max_interval_time_c  : real := 1000.0; -- Maximum time interval beteen button press check in ns 	  


--#############################	Components	##############################################--

component mds_top
	generic (
				sys_clk_g			:	positive	:= 100000000;		--100MHz for System
--				rep_size_g			:	positive	:= 8;				--2^7=128 => Maximum of 128 repetitions for pixel / line
				baudrate_g			:	positive	:= 115200
			);
	port	(
				--Clock and Reset from system
				clk_133				:	in std_logic;
				clk_100				:	in std_logic;
				clk_40				:	in std_logic;
				rst_133				:	in std_logic;
				rst_100				:	in std_logic;
				rst_40				:	in std_logic;
				
				-- DE2 buttons to Display Controller block
				right       :	in bit; -- Right button signal from the DE2 board.  
				left        :	in bit; -- Left button signal from the DE2 board.  
				up          :	in bit; -- Up button signal from the DE2 board.  
				down        :	in bit; -- Down button signal from the DE2 board.  
				
				--Clock and Reset to SDRAM, VESA
				clk_sdram_out		:	out std_logic;
				clk_vesa_out		:	out std_logic;

				--UART
				uart_serial_in		:	in std_logic;
				uart_serial_out		:	out std_logic;
				
				--SDRAM Signals
				dram_addr			:	out std_logic_vector (11 downto 0);		--Address (12 bit)
				dram_bank			:	out std_logic_vector (1 downto 0);		--Bank
				dram_cas_n			:	out std_logic;							--Column Address is being transmitted
				dram_cke			:	out std_logic;							--Clock Enable
				dram_cs_n			:	out std_logic;							--Chip Select (Here - Mask commands)
				dram_dq				:	inout std_logic_vector (15 downto 0);	--Data in / Data out
				dram_ldqm			:	out std_logic;							--Byte masking
				dram_udqm			:	out std_logic;							--Byte masking
				dram_ras_n			:	out std_logic;							--Row Address is being transmitted
				dram_we_n			:	out std_logic;							--Write Enable
				
				--VESA signals
					--Output RGB
				r_out				:	out std_logic_vector(9 downto 0);		--Output R Pixel
				g_out				:	out std_logic_vector(9 downto 0);   	--Output G Pixel
				b_out				:	out std_logic_vector(9 downto 0);  		--Output B Pixel
				
					--Blanking signal
				blank				:	out std_logic;										--Blanking signal
					
					--Sync Signals			
				hsync				:	out std_logic;										--HSync Signal
				vsync				:	out std_logic;										--VSync Signal

				--Debug Ports
				dbg_rx_path_cyc		:	out std_logic;							--RX Path WBM_CYC_O for debug
				dbg_type_reg_mem	:	out std_logic_vector (7 downto 0);		--Mem_Management Type Register value for Debug
				dbg_type_reg_disp	:	out std_logic_vector (7 downto 0);		--Display Type Register value for Debug
				dbg_type_reg_tx		:	out std_logic_vector (7 downto 0);		--RX_Path Type Register value for Debug
				dbg_sdram_active		:	out std_logic;							--'1' when WBM_CYC_O from mem_mng_top to SDRAM is active
				dbg_disp_active		:	out std_logic;							--'1' when WBM_CYC_O from disp_ctrl_top to INTERCON_Y is active
				dbg_icy_bus_taken	:	out std_logic;							--'1' when INTERCON_Y is taken, '0' otherwise
				dbg_icz_bus_taken	:	out std_logic;							--'1' when INTERCON_Z is taken, '0' otherwise
				dbg_wr_bank_val		:	out std_logic;							--Write SDRAM Bank Value
				dbg_rd_bank_val     :	out std_logic;							--Expected Read SDRAM Bank Value
				dbg_actual_wr_bank	:	out std_logic;							--Actual read bank
				dbg_actual_rd_bank	:	out std_logic;							--Actual Written bank
				programming_indication_led 	: out std_logic -- blinks at a predefiened frequency - an indication for successfull programming on FPGA
			);
end component mds_top;

component uart_tx_gen_model 
   generic (
            --File name explanasion:
			--File name is being named <file_name_g>_<file_idx>.<file_extension_g>
			--i.e: uart_tx_1.txt, uart_tx_2.txt ....
			--file_max_idx_g is the maximum index for files. For example: suppose this
			--parameter is 2, then transmission file order will be:
			-- (1)uart_tx_1.txt (2)uart_tx_2.txt (3) uart_tx_1.txt (4) uart_tx_2.txt ...
			file_name_g			:		string 		:= "P:/Menu_Navigation_Projectwc/trunk/VHDL/simulation/automatic tests/part_B/test_files/test_0/uart_tx"; 		--File name to be transmitted
			file_extension_g	:		string		:= "txt";			--File extension
			file_max_idx_g		:		positive	:= 2;				--Maximum file index.
			delay_g				:		positive	:= 10;				--Number of clock cycles delay between two files transmission
			 
			clock_period_g		:		time		:= 8.68 us;			--8.68us = 115,200 Bits/sec
			parity_en_g			:		natural range 0 to 1 := 0; 		--1 to Enable parity bit, 0 to disable parity bit
			parity_odd_g		:		boolean 	:= false; 			--TRUE = odd, FALSE = even
			msb_first_g			:		boolean 	:= false; 			--TRUE = MSB First, FALSE = LSB first
			uart_idle_g			:		std_logic 	:= '1' 				--Idle line value
           );
   port
   	   (
   	        system_clk	:	in std_logic := '0'; 				--System clock, for Valid for one clock
		    uart_out	:	out std_logic := '1';				--Serial data out (UART)
		    value		:	out std_logic_vector (7 downto 0) := (others => '0'); 	--Transmitted value (For user convenience - to see the transmitted value)
		    valid		:	out std_logic := '0'				--Valid value (8 bit) - Active for one clock (For Parallel data simulation)
   	   );
end component uart_tx_gen_model;

component vesa_pic_col 
	generic (
			reset_polarity_g		:	std_logic 	:= '0';				--Reset Polarity. '0' = Reset
			hsync_polarity_g		:	std_logic 	:= '1';				--Positive HSync
			vsync_polarity_g		:	std_logic 	:= '1';				--Positive VSync
			blank_polarity_g		:	std_logic	:= '0';				--When '0' - Blanking signal to the VGA
			
			red_width_g				:	positive 	:= 8;				--Default std_logic_vector size of Red Pixels
			green_width_g			:	positive 	:= 8;				--Default std_logic_vector size of Green Pixels
			blue_width_g			:	positive 	:= 8;				--Default std_logic_vector size of Blue Pixels
							
			hor_active_pixels_g		:	positive	:= 800;				--800 active pixels per line
			ver_active_lines_g		:	positive	:= 600;				--600 active lines
			hor_left_border_g		:	natural		:= 0;				--Horizontal Left Border
			hor_right_border_g		:	natural		:= 0;				--Horizontal Right Border
			hor_back_porch_g		:	integer		:= 88;				--Horizontal Back Porch (Pixels)
			hor_front_porch_g		:	integer		:= 40;				--Horizontal Front Porch (Pixels)
			hor_sync_time_g			:	integer		:= 128;				--Horizontal Sync Time (Pixels)
			ver_top_border_g		:	natural		:= 0;				--Vertical Top Border
			ver_buttom_border_g		:	natural		:= 0;				--Vertical Buttom Border
			ver_back_porch_g		:	integer		:= 23;				--Vertical Back Porch (Lines)
			ver_front_porch_g		:	integer		:= 1;				--Vertical Front Porch (Lines)
			ver_sync_time_g			:	integer		:= 4;				--Vertical Sync Time (Lines)
			
			file_dir_g				:	string		:= "P:/Menu_Navigation_Projectwc/trunk/VHDL/simulation/automatic tests/part_B/test_files/test_0/output/";
			file_prefix_g			:	string		:= "out_img"			--Image Prefix
			);
	port	(
			clk						:	in std_logic;					--Clock
			reset					:	in std_logic;
			hsync					:	in std_logic := not hsync_polarity_g;
			vsync					:	in std_logic := not vsync_polarity_g;
			blank					:	in std_logic := not blank_polarity_g;
			r_in					:	in std_logic_vector (red_width_g - 1 downto 0);
			g_in					:	in std_logic_vector (green_width_g - 1 downto 0);
			b_in					:	in std_logic_vector (blue_width_g - 1 downto 0)
			);
end component vesa_pic_col;

component global_nets_top
	generic (
			reset_polarity_g	:	std_logic := '0'		--When '0' - Reset
			);
	port (
			fpga_clk		:	in std_logic ;				--Input clock to the FPGA (50MHz)
			fpga_rst		:	in std_logic ;				--Input reset from FPGA
			sdram_clk		:	out std_logic ;				--Output SDRAM clock (133MHz)
			vesa_clk		:	out std_logic ;				--Output VESA clock (40MHz)
			sync_sdram_rst	:	out std_logic ;				--Output Synchronized reset - 133MHz
			sync_vesa_rst	:	out std_logic				--Output Synchronized reset - 40MHz
		);
end component global_nets_top;

component sdram_model
	GENERIC (
		addr_bits : INTEGER := 12;
		data_bits : INTEGER := 16 ;
		col_bits  : INTEGER := 8
		);
	PORT (
		Dq		: inout std_logic_vector (15 downto 0) := (others => 'Z');
		Addr    : in    std_logic_vector (11 downto 0) ;-- := (others => '0');
		Ba      : in    std_logic_vector(1 downto 0);-- := "00";
		Clk     : in    std_logic ;--:= '0';
		Cke     : in    std_logic ;--:= '0';
		Cs      : in    std_logic ;--:= '1';
		Ras     : in    std_logic ;--:= '0';
		Cas     : in    std_logic ;--:= '0';
		We      : in    std_logic ;--:= '0';
		Dqm     : in    std_logic_vector(1 downto 0)-- := (others => 'Z')
		);
	
END component;

--#############################	Signals ##############################################--

--Clock and Reset
signal clk_133			:	std_logic := '0';
signal rst_133			:	std_logic;
signal clk_100			:	std_logic := '0';
signal rst_100			:	std_logic;
signal clk_40			:	std_logic := '0';
signal rst_40			:	std_logic;

-- DE2 buttons to Display Controller block
signal right       :	bit; -- Right button signal from the DE2 board.  
signal left        :	bit; -- Left button signal from the DE2 board.  
signal up          :	bit; -- Up button signal from the DE2 board.  
signal down        :	bit; -- Down button signal from the DE2 board.  

--UART
signal uart_serial_in	:	std_logic;
signal uart_serial_out	:	std_logic;
--SDRAM
signal dram_addr		:	std_logic_vector (11 downto 0);		
signal dram_bank		:	std_logic_vector (1 downto 0);		
signal dram_cas_n		:	std_logic;							
signal dram_cke			:	std_logic;							
signal dram_cs_n		:	std_logic;							
signal dram_dq			:	std_logic_vector (15 downto 0);	
signal dram_ldqm		:	std_logic;							
signal dram_udqm		:	std_logic;							
signal dram_ras_n		:	std_logic;							
signal dram_we_n		:	std_logic;							
--VESA
signal r_out			:	std_logic_vector(9 downto 0);	
signal g_out			:	std_logic_vector(9 downto 0);   
signal b_out			:	std_logic_vector(9 downto 0);  	
signal blank			:	std_logic;						
signal hsync			:	std_logic;						
signal vsync			:	std_logic;						

--Debug
signal dbg_rx_path_cyc	:	std_logic;							--RX Path WBM_CYC_O for debug
signal dbg_type_reg_disp:	std_logic_vector (7 downto 0);		--Display Type Register value for Debug
signal dbg_type_reg_mem	:	std_logic_vector (7 downto 0);		--Mem_Management Type Register value for Debug
signal dbg_type_reg_tx	:	std_logic_vector (7 downto 0);		--RX_Path Type Register value for Debug
signal dbg_sdram_active	:	std_logic;							--'1' when WBM_CYC_O from mem_mng_top to SDRAM is active
signal dbg_disp_active	:	std_logic;							--'1' when WBM_CYC_O from disp_ctrl_top to INTERCON_Y is active
signal dbg_icy_bus_taken:	std_logic;							--'1' when INTERCON_Y is taken, '0' otherwise
signal dbg_icz_bus_taken:	std_logic;							--'1' when INTERCON_Z is taken, '0' otherwise
signal dbg_wr_bank_val	:	std_logic;							--Expected Write SDRAM Bank Value
signal dbg_rd_bank_val  :	std_logic;							--Expected Read SDRAM Bank Value
signal dbg_actual_wr_bank  :	std_logic;						--Actual Read SDRAM Bank Value
signal dbg_actual_rd_bank  :	std_logic;						--Actual Read SDRAM Bank Value

signal programming_indication_led	:	std_logic; -- 22.03.2013

--#############################	Instantiaion ##############################################--
begin

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


uart_gen_inst :  uart_tx_gen_model generic map (
			file_name_g			=> uart_tx_file_g, 		--File name to be transmitted
			file_extension_g	=> "txt",			--File extension
			file_max_idx_g		=> file_max_idx_g,--Maximum file index.
			clock_period_g		=> uart_period_c,	--Uart clock
			delay_g				=> uart_tx_delay_g		--Number of clock cycles delay between two files transmission
           )
		port map
		(
			system_clk		=> clk_133,
			uart_out		=> uart_serial_in
		);

mds_top_inst	: mds_top
	generic map
	(
				--rep_size_g			=>	rep_size_c,
				baudrate_g			=>	baudrate_c
	)
	port map	(
				clk_133	            =>	clk_133,
				clk_100	            =>	clk_100,
        clk_40	            =>	clk_40,
        rst_133	            =>	rst_133,
        rst_100	            =>	rst_100,
        rst_40	            =>	rst_40,
        
        right                 =>	right,
        left                  =>	left, 
        up                    =>	up,
        down                  =>	down,        
				
				uart_serial_in		=>	uart_serial_in	,
				uart_serial_out		=>	uart_serial_out	,
				dram_addr			=>	dram_addr		,
				dram_bank			=>	dram_bank		,
				dram_cas_n			=>	dram_cas_n		,
				dram_cke			=>	dram_cke		,
				dram_cs_n			=>	dram_cs_n		,
				dram_dq				=>	dram_dq			,
				dram_ldqm			=>	dram_ldqm		,
				dram_udqm			=>	dram_udqm		,
				dram_ras_n			=>	dram_ras_n		,
				dram_we_n			=>	dram_we_n		,
				r_out				=>	r_out			,
				g_out				=>	g_out			,
				b_out				=>	b_out			,
				blank				=>	blank			,
				hsync				=>	hsync			,
				vsync				=>  vsync			,
				dbg_rx_path_cyc		=>	dbg_rx_path_cyc		,
                dbg_type_reg_disp	=>	dbg_type_reg_disp	,
                dbg_type_reg_mem	=>	dbg_type_reg_mem	,
                dbg_type_reg_tx		=>	dbg_type_reg_tx		,
                dbg_sdram_active		=>	dbg_sdram_active		,
                dbg_disp_active		=>	dbg_disp_active		,
				dbg_icy_bus_taken	=>	dbg_icy_bus_taken	,
				dbg_icz_bus_taken	=>	dbg_icz_bus_taken,	
				dbg_wr_bank_val 	=>	dbg_wr_bank_val,
				dbg_rd_bank_val 	=>	dbg_rd_bank_val,
				dbg_actual_wr_bank	=>	dbg_actual_wr_bank,
				dbg_actual_rd_bank  =>	dbg_actual_rd_bank,
				programming_indication_led => programming_indication_led
			);                      
		
vesa_pic_col_inst : vesa_pic_col	generic map
			(
				file_dir_g				=> output_dir_g,
				file_prefix_g			=> "out_img"			--Image Prefix
			)
		port map
			(
				clk						=>	clk_40,
				reset					=>	rst_40,
				hsync					=>	hsync,
				vsync					=>	vsync	,
				blank					=>	blank	,
				r_in					=>	r_out (9 downto 2)	,
				g_in					=>	g_out (9 downto 2)	,
				b_in					=>	b_out (9 downto 2)	
			);                      	

-- global_nets_inst : global_nets_top port map (
			-- fpga_clk		=>	clk_50,
			-- fpga_rst		=>	rst_50,
			-- sdram_clk		=>	clk_133,
			-- vesa_clk		=>	clk_40,
			-- sync_sdram_rst	=>	rst_133,
			-- sync_vesa_rst	=>	rst_40
		-- );		

sdram_model_inst : sdram_model port map (
									Dq		=> dram_dq,	
									Addr    => dram_addr,
									Ba      => dram_bank,
									Clk     => clk_133,
									Cke     => dram_cke,
									Cs      => dram_cs_n,
									Ras     => dram_ras_n,
									Cas     => dram_cas_n,
									We      => dram_we_n,
									Dqm(0)  => dram_ldqm,
									Dqm(1)  => dram_udqm
								);
--###############################process#########################################
			
				
  
 direction_press_proc: process
		variable seed1_v, seed2_v : positive; -- Seed values for random generator rand1_v
	  variable rand1_v : real; -- Random real-number value in range 0 to 1.0
	  variable direct_rand_v : integer range 0 to 3;
	  variable interval_rand_v : time range 0 ns to 1000 ns; -- Random time interval beteen button press check in ns 
	  variable seed3_v, seed4_v : positive; -- Seed values for random generator rand2_v
	  variable rand2_v : real; -- Random real-number value in range 0 to 1.0
	  variable seed5_v, seed6_v : positive; -- Seed values for random generator rand2_v
	  variable rand3_v : real; -- Random real-number value in range 0 to 1.0
	  variable press_time_rand_v : time range 0 ns to 1 sec; -- Random time for a press length
	  
		begin
		  wait until clk_100 = '1';
		  for I in 0 to (loop_size_c -1)  loop
		    
		    -- Generate random numbers
        uniform(seed1_v, seed2_v, rand1_v);     
	      direct_rand_v := integer(trunc(num_of_directions_c*rand1_v)); -- Rescale to 0..num_of_directions_c, find integer part
	      
	      uniform(seed5_v, seed6_v, rand3_v);     
	      press_time_rand_v := trunc(double_max_value_time_real_c*rand3_v)*1 ns; -- Rescale to 0..max_value_time_c, find integer part
	      
	      
 		    case direct_rand_v is
	        when 0 =>       
	          right <= '1';	      
            wait for press_time_rand_v;
	          right <= '0';    
          when 1 =>       
	          left <= '1';
	          wait for press_time_rand_v;
	          left <= '0';        
          when 2 =>       
	          up <= '1';
	          wait for press_time_rand_v;
            up <= '0';
          when 3 =>       
	          down <= '1';
	          wait for press_time_rand_v;
            down <= '0'; 
        end case;
       
        
        uniform(seed3_v, seed4_v, rand2_v);     
        interval_rand_v := trunc(max_interval_time_c*rand2_v)*1 ns; -- Rescale to 0..1000ns
        wait for interval_rand_v;
        
      end loop;
  end process direction_press_proc;
  
		  		
end architecture sim_mds_top_tb;