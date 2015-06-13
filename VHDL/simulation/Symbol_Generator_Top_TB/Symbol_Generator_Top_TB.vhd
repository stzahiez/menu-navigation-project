------------------------------------------------------------------------------------------------
-- Model Name 	:	Symbol_Generator_Top_TB
-- File Name	:	opcode_unite_tb.vhd
-- Generated	:	04.05.2012
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description: opcode unite TB
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date			Name								Description			
--			1.00		04.05.2012		Olga Liberman and Yoav Shvartz		Creation
--			1.01		27.10.2012		Olga Liberman						Symbol Generator inner blocks are encapsulated in the Symbol_Generator_Top block
--			1.02		28.10.2012		Olga Liberman						the top TB file has now all the generics of the design
--    1.03  08.06.2015  Tzahi Ezra         Adding the navigator component & the updated manager compnent to the TB, and also the DE2 buttons inputs
--                                         To the Symbol_Generator_Top component
------------------------------------------------------------------------------------------------
--	Todo:
--	(1)
--	(2)
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all ;
use ieee.math_real.all;
use ieee.math_real.ALL;   -- For uniform, trunc functions


entity Symbol_Generator_Top_TB is
generic(
	reset_polarity_g			:	std_logic 	:= '0'; 				-- Reset Polarity. '0' = Reset
	opcode_text_file_g			: 	string 		:= "test_001.txt";			-- path of the test file with all the opcodes for the parser
	init_reset_length_cycles_g	:	positive 	:= 4;					-- number of clock cycles that the reset is active at the begining
	clk_half_period_g			:	time		:= 5 ns;				-- the length in time of half period of the main clock of the system
	pixel_clk_half_period_g		:	time		:= 19.861 ns;			-- pixel clock for 640x480 @ 60 Hz = 25.175 MHz
	hor_active_pixels_g			:	positive	:= 640;					-- 800 active pixels per line
	ver_active_lines_g			:	positive	:= 480;					-- 600 active lines
	hor_left_border_g			:	natural		:= 0;					-- Horizontal Left Border (Pixels)
	hor_right_border_g			:	natural		:= 0;					-- Horizontal Right Border (Pixels)
	hor_back_porch_g			:	integer		:= 48;					-- Horizontal Back Porch (Pixels)
	hor_front_porch_g			:	integer		:= 16;					-- Horizontal Front Porch (Pixels)
	hor_sync_time_g				:	integer		:= 96;					-- Horizontal Sync Time (Pixels)
	ver_top_border_g			:	natural		:= 0;					-- Vertical Top Border (Lines)
	ver_buttom_border_g			:	natural		:= 0;					-- Vertical Bottom Border (Lines)
	ver_back_porch_g			:	integer		:= 31;					-- Vertical Back Porch (Lines)
	ver_front_porch_g			:	integer		:= 11;					-- Vertical Front Porch (Lines)
	ver_sync_time_g				:	integer		:= 2;					-- Vertical Sync Time (Lines)
	memory_file_g					: 	string 		:= "memory_new.txt";	-- text file that models the SDRAM, for the symbol sdram model
	log_file					:	string  	:= "log_file"			-- the prefix for the output log files of the display
	
);
end entity Symbol_Generator_Top_TB;

architecture sim_Symbol_Generator_Top_TB of Symbol_Generator_Top_TB is

--#############################	Components	##############################################--
	
	component clk_reset_model is
		generic(
			reset_polarity_g			:	std_logic 	:= reset_polarity_g; --Reset Polarity. '0' = Reset
			init_reset_length_cycles_g	:	positive := init_reset_length_cycles_g;
			clk_half_period_g			:	time	:= clk_half_period_g;
			pixel_clk_half_period_g		:	time	:= pixel_clk_half_period_g -- pixel clock for 640x480 @ 60 Hz = 25.175 MHz
		);
		port (
			clk : out std_logic; -- the main clock to which all the internal logic of the Symbol Generator block is synchronized.
			pixel_clk : out std_logic; -- pixel clock for the VESA standard
			reset : out std_logic -- asynchronous reset
		);
	end component clk_reset_model;
	
	component Symbol_Generator_Top is
		generic(
			hor_active_pixels_g		:	positive	:= 800;				--800 active pixels per line
			ver_active_lines_g		:	positive	:= 600;				--600 active lines
			hor_left_border_g		:	natural		:= hor_left_border_g;				--Horizontal Left Border (Pixels)
			hor_right_border_g		:	natural		:= hor_right_border_g;				--Horizontal Right Border (Pixels)
			hor_back_porch_g		:	integer		:= 88;				--Horizontal Back Porch (Pixels)
			hor_front_porch_g		:	integer		:= 40;				--Horizontal Front Porch (Pixels)
			hor_sync_time_g			:	integer		:= 128;				--Horizontal Sync Time (Pixels)
			ver_top_border_g		:	natural		:= 0;				--Vertical Top Border (Lines)
			ver_buttom_border_g		:	natural		:= 0;				--Vertical Bottom Border (Lines)
			ver_back_porch_g		:	integer		:= 23;				--Vertical Back Porch (Lines)
			ver_front_porch_g		:	integer		:= 1;				--Vertical Front Porch (Lines)
			ver_sync_time_g			:	integer		:= 4;				--Vertical Sync Time (Lines)
		  hor_width_g  : 		positive := 5; 	-- The width of horizonal navigator's output lines, needed to hold the maximum horizontal cursor's location value.
      ver_width_g  : 		positive := 4; 	-- The width of vertical navigator's output lines, needed to hold the maximum vertical cursor's location value.
      reset_polarity_g  : std_logic := '0';  -- The reset polarity of the system.
		  max_value_g  : 		positive	:= 50000000 -- The number of clk cycles to wait, before output a rectangular Pulse in width of one cycle.
    
		);
		port(
		  -- inputs
			-- clock and reset
			clk					:	in std_logic; -- The main clock to which all the internal logic of the Symbol Generator block is synchronized.
			reset_n				:	in std_logic; -- Asynchronous reset
			-- opcode_unite
			opu_data_in			:	in std_logic_vector(7 downto 0); -- Data from wbs
			opu_data_in_valid	:	in std_logic; -- Valid signal for data from wbs
			-- opcode_store
			op_cnt             	:	in std_logic_vector(9 downto 0); -- Number of total changes X 3: 1 change (24 bits) = add/remove 1 symbol ( 24 bits are being sent in 3 packs of 8 bits)
			op_str_rd_start		:	in std_logic; -- Connected from VESA controller, vsync signal
			vsync_trigger		:	out std_logic; -- Rising edge of the vsync from VESA
			-- manager
			req_in_trg			:	in std_logic; -- This is a signal from the VESA Generator block. It indicates when to start preparing valid data in the Dual Clk FIFO for a req_lines_g lines in advance. (In our case it is 1 line in advance).
			sdram_data 			:	in std_logic_vector (7 downto 0); -- This signal gets the data from sdram 
			sdram_data_valid	:	in std_logic; -- Indicates when the data from the sdram is valid and we can store it in one of the fifos (a or b)
			-- navigator
			right     :   in bit; -- Right button signal from the DE2 board.
      left     :   in bit; -- Left button signal from the DE2 board.
      up     :   in bit; -- Up button signal from the DE2 board.
      down     :   in bit; -- Down button signal from the DE2 board.
      -- outputs
			sdram_addr_rd 		: 	out std_logic_vector (23 downto 0); -- This signal is the full address in SDRAM: "00--bank(2)--row(12)--col(8)"
			sdram_rd_en		:	out std_logic; -- This signal is a valid signal for the sdram_addr_rd signal (for usage of WBS)
			-- mux2
			mux_dout_valid		:	out std_logic;
			mux_dout	  		:	out std_logic_vector(7 downto 0)
		);
	end component Symbol_Generator_Top;
	
	component opcode_parser
		generic(
			opcode_text_file_g	: 	string := "test_001.txt";
			clk_half_period_g		:	time	:= clk_half_period_g
		);
		port (
			clk : in std_logic; -- The main clock to which all the internal logic of the Symbol Generator block is synchronized.
			reset_n : in std_logic; -- Asynchronous reset
			data_out : out std_logic_vector(7 downto 0);
			data_valid : out std_logic;
			opcode_count : out std_logic_vector(9 downto 0)
		);
	end component opcode_parser;
	
	
	component sdram_symbol_model is
		generic(
			memory_file_g	: 	string := memory_file_g
		);
		port(
			clk        : in  std_logic;
			reset_n    : in  std_logic;
			rd_addr    : in  std_logic_vector (23 downto 0);
			rd_en      : in  std_logic;
			data_out   : out std_logic_vector(7 downto 0);
			valid      : out std_logic
		);
	end component sdram_symbol_model;

	component file_log is
		generic(
			log_file			:       string  := "log_file"
		);
		port(
			clk					: 		in std_logic;
			reset_n				: 		in std_logic;
			-- fifo_a_rd_en 		: 		in std_logic; 						-- read enable to fifo a
			-- fifo_b_rd_en 		: 		in std_logic; 						-- read enable to fifo b
			mux_dout_valid		: 		in std_logic;
			mux_dout	  		: 		in std_logic_vector(7 downto 0);    -- data out to DC FIFO
			vsync				:		in std_logic
		);
	end component file_log;
	
	component vesa_gen_ctrl
		generic (
			reset_polarity_g		:	std_logic 	:= '0';				--Reset Polarity. '0' = Reset
			hsync_polarity_g		:	std_logic 	:= '1';				--Positive HSync
			vsync_polarity_g		:	std_logic 	:= '1';				--Positive VSync
			blank_polarity_g		:	std_logic	:= '0';				--When '0' - Blanking signal to the VGA
			
			red_default_color_g		:	natural 	:= 0;				--Default Red pixel for Frame
			green_default_color_g	:	natural 	:= 0;				--Default Green pixel for Frame
			blue_default_color_g	:	natural 	:= 0;				--Default Blue pixel for Frame
			
			red_width_g				:	positive 	:= 8;				--Default std_logic_vector size of Red Pixels
			green_width_g			:	positive 	:= 8;				--Default std_logic_vector size of Green Pixels
			blue_width_g			:	positive 	:= 8;				--Default std_logic_vector size of Blue Pixels
			req_delay_g				:	positive	:= 1;				--Number of clocks between the "req_data" request to the "data_valid" answer
			req_lines_g				:	positive	:= 3;				--Number of lines to request from image transmitter, to hold in its FIFO
							
			hor_active_pixels_g		:	positive	:= 800;				--800 active pixels per line
			ver_active_lines_g		:	positive	:= 600;				--600 active lines
			hor_left_border_g		:	natural		:= hor_left_border_g;				--Horizontal Left Border (Pixels)
			hor_right_border_g		:	natural		:= 0;				--Horizontal Right Border (Pixels)
			hor_back_porch_g		:	integer		:= 88;				--Horizontal Back Porch (Pixels)
			hor_front_porch_g		:	integer		:= hor_front_porch_g;				--Horizontal Front Porch (Pixels)
			hor_sync_time_g			:	integer		:= 128;				--Horizontal Sync Time (Pixels)
			ver_top_border_g		:	natural		:= 0;				--Vertical Top Border (Lines)
			ver_buttom_border_g		:	natural		:= 0;				--Vertical Bottom Border (Lines)
			ver_back_porch_g		:	integer		:= 23;				--Vertical Back Porch (Lines)
			ver_front_porch_g		:	integer		:= 1;				--Vertical Front Porch (Lines)
			ver_sync_time_g			:	integer		:= 4				--Vertical Sync Time (Lines)
		);
		port(	
				--Clock, Reset
				clk			:		in std_logic;										--Pixel Clock
				reset		:		in std_logic;										--Reset

				--Input RGB
				r_in		:		in std_logic_vector(red_width_g - 1 downto 0);		--Input R Pixel
				g_in		:		in std_logic_vector(green_width_g - 1 downto 0);	--Input G Pixel
				b_in		:		in std_logic_vector(blue_width_g - 1 downto 0);		--Input B Pixel

				--Frame Border (Size of frame)
				left_frame	:		in std_logic_vector(integer(ceil(log(real(hor_active_pixels_g)) / log(2.0))) - 1 downto 0);	--Left frame border
				upper_frame	:		in std_logic_vector(integer(ceil(log(real(ver_active_lines_g)) / log(2.0))) - 1 downto 0);	--Upper frame border
				right_frame	:		in std_logic_vector(integer(ceil(log(real(hor_active_pixels_g)) / log(2.0))) - 1 downto 0);	--Right frame border
				lower_frame	:		in std_logic_vector(integer(ceil(log(real(ver_active_lines_g)) / log(2.0))) - 1 downto 0);	--Lower frame border
				
				--Image Enable. Required both enables to be '1' in order to enable image
				vesa_en		:		in std_logic;										--Enable VESA to transmit image
				image_tx_en	:		in std_logic;										--Image transmitter is enabled

				--Handshake
				data_valid	:		in std_logic;										--Data is valid (If not - BLACK will be shown)
				req_data	:		out std_logic;										--Request for data
				pixels_req	:		out std_logic_vector(integer(ceil(log(real(hor_active_pixels_g*req_lines_g)) / log(2.0))) - 1 downto 0); --Request for PIXELS*LINES pixels from FIFO
				req_ln_trig	:		out std_logic;										--Trigger to image transmitter, to load its FIFO with new data

				--Output RGB
				r_out		:		out std_logic_vector(red_width_g - 1 downto 0);		--Output R Pixel
				g_out		:		out std_logic_vector(green_width_g - 1 downto 0);   --Output G Pixel
				b_out		:		out std_logic_vector(blue_width_g - 1 downto 0);  	--Output B Pixel
				
				--Blanking signal
				blank		:		out std_logic;										--Blanking signal
					
				--Sync Signals				
				hsync		:		out std_logic;										--HSync Signal
				vsync		:		out std_logic										--VSync Signal
		);
	end component vesa_gen_ctrl;

--############################# Constants ############################################--	
	constant clk_half_period_c : time	:= 5 ns; -- clock 100MHz
	constant pixel_clk_half_period_c : time	:= 19.861 ns; -- pixel clock for 640x480 @ 60 Hz = 25.175 MHz
	constant loop_size_c  : positive := 100; 
  constant num_of_directions_c  : real := 4.0;
  constant double_max_value_time_real_c  : 		real	:= 1000000000.0;
  constant max_interval_time_c  : real := 1000.0; -- Maximum time interval beteen button press check in ns 	  
  
--#############################	Signals ##############################################--
	
	-- inputs
	-- clock and reset
	signal clk  			:	std_logic := '0';
	signal reset_n			    :	std_logic := '1';
  signal pixel_clk			:	std_logic := '0';
	-- opcode_unite
	signal opu_data_in		    :	std_logic_vector(7 downto 0); -- data from wbs
	signal opu_data_in_valid	:	std_logic;
  -- opcode_store
  signal op_cnt               :   std_logic_vector(9 downto 0);   	-- number of total changes X 3: 1 change (24 bits) = add/remove 1 symbol ( 24 bits are being sent in 3 packs of 8 bits)
	signal op_str_rd_start      :   std_logic; 	
	signal vsync_trigger		:	std_logic;
	-- manager
	signal req_in_trg           :   std_logic:= '0'; -- request in trigger from VESA for a new video row
	signal sdram_data           :   std_logic_vector (7 downto 0):= (others=>'0'); --this signal gets the data from sdram 
	signal sdram_data_valid     :   std_logic:= '0'; -- indicates when the data from the sdram is valid and we can store it in one of the fifos (a or b)
	-- navigator
	signal right     :   bit; -- Right button signal from the DE2 board.
  signal left     :   bit; -- Left button signal from the DE2 board.
  signal up     :   bit; -- Up button signal from the DE2 board.
  signal down     :   bit; -- Down button signal from the DE2 board.
  -- outputs  
	signal sdram_addr_rd 		: 	 std_logic_vector (23 downto 0):= (others=>'0'); -- This signal is the full address in SDRAM: "00--bank(2)--row(12)--col(8)"
	signal sdram_rd_en			:		 std_logic:= '0'; -- This signal is a valid signal for the sdram_addr_rd signal (for usage of WBS)

	signal mux_dout             : std_logic_vector(7 downto 0); 
	signal mux_dout_valid		: std_logic;

begin

--#############################	Instantiaion ##############################################--
	
	clk_reset_model_inst : clk_reset_model
		generic map(
			reset_polarity_g => reset_polarity_g, -- '0' = Reset
			init_reset_length_cycles_g => init_reset_length_cycles_g,
			clk_half_period_g => clk_half_period_g,
			pixel_clk_half_period_g => pixel_clk_half_period_g
		)
		port map(
			clk => clk,
			pixel_clk => pixel_clk,
			reset => reset_n
		);
		
	Symbol_Generator_Top_inst : Symbol_Generator_Top
	generic map(
		-- generic values for resolution 640x480 @ 60 Hz
			hor_active_pixels_g => hor_active_pixels_g,				--640 active pixels per line
			ver_active_lines_g => 480,				--480 active lines
			hor_left_border_g => hor_left_border_g,				--Horizontal Left Border (Pixels)
			hor_right_border_g => 0,				--Horizontal Right Border (Pixels)
			hor_back_porch_g => hor_back_porch_g,				--Horizontal Back Porch (Pixels)
			hor_front_porch_g => hor_front_porch_g,				--Horizontal Front Porch (Pixels)
			hor_sync_time_g => 96,				--Horizontal Sync Time (Pixels)
			ver_top_border_g => 0,				--Vertical Top Border (Lines)
			ver_buttom_border_g => 0,				--Vertical Bottom Border (Lines)
			ver_back_porch_g => 31,				--Vertical Back Porch (Lines)
			ver_front_porch_g => 11,				--Vertical Front Porch (Lines)
			ver_sync_time_g => 2,				--Vertical Sync Time (Lines)
			hor_width_g  => 5, 	-- The width of horizonal navigator's output lines, needed to hold the maximum horizontal cursor's location value.
      ver_width_g  => 4, 	-- The width of vertical navigator's output lines, needed to hold the maximum vertical cursor's location value.
      reset_polarity_g  => '0',  -- The reset polarity of the system.
		  max_value_g  => 50000000
	)
	port map(
		clk		=> 		clk,   
		reset_n		=> 		reset_n,
		opu_data_in 	=> 		opu_data_in,
		opu_data_in_valid 	=> 		opu_data_in_valid,
		op_cnt  => 		op_cnt,      
		op_str_rd_start 	=> 		op_str_rd_start,
		vsync_trigger 	=> 		vsync_trigger,
		req_in_trg 	=> 		req_in_trg,
		sdram_data 	=> 		sdram_data,
		right 	=>  right,   
    left 	=>  left,
    up  =>  up,
    down  =>  down,
    sdram_data_valid	=> 		sdram_data_valid,
		sdram_addr_rd		=> 		sdram_addr_rd,
		sdram_rd_en			=> 		sdram_rd_en,
		mux_dout_valid		=>		mux_dout_valid,
		mux_dout	  		=> 		mux_dout    	  -- Data out to DC FIFO
	);
	
	opcode_parser_inst :  opcode_parser 
		generic map(
			opcode_text_file_g	=>	opcode_text_file_g,
			clk_half_period_g	=>	clk_half_period_g
		)
		
		port map
		(
			clk => clk,
			reset_n => reset_n,
			data_out => opu_data_in,
			data_valid => opu_data_in_valid,
			opcode_count => op_cnt
		);
		
	sdram_symbol_model_inst : sdram_symbol_model
	generic map(
	  memory_file_g =>   memory_file_g
	)
	port map(
		clk         => clk,   
		reset_n     => reset_n,   
		rd_addr     => sdram_addr_rd, 
		rd_en       => sdram_rd_en,  
		data_out    => sdram_data,
		valid       => sdram_data_valid
	);

	file_log_inst: file_log
		generic map(
			log_file		=>      log_file
		)
		port map(
			clk 		    => 		clk,          -- the main clock to which all the internal logic of the Symbol Generator block is synchronized.
			reset_n 	  	=> 		reset_n,      
			mux_dout_valid	=>		mux_dout_valid,
			mux_dout	  	=>		mux_dout,			-- data out to DC FIFO
			vsync			=>		vsync_trigger
		);

	vesa_gen_ctrl_inst :  vesa_gen_ctrl 
		generic map(
			reset_polarity_g => '0',				--Reset Polarity. '0' = Reset
			hsync_polarity_g => '1',				--Positive HSync
			vsync_polarity_g => '1',				--Positive VSync
			blank_polarity_g => '0',				--When '0' - Blanking signal to the VGA
			
			red_default_color_g => 0,				--Default Red pixel for Frame
			green_default_color_g => 0,				--Default Green pixel for Frame
			blue_default_color_g => 0,				--Default Blue pixel for Frame
			
			red_width_g => 8,				--Default std_logic_vector size of Red Pixels
			green_width_g => 8,				--Default std_logic_vector size of Green Pixels
			blue_width_g => 8,				--Default std_logic_vector size of Blue Pixels
			req_delay_g => 1,				--Number of clocks between the "req_data" request to the "data_valid" answer
			req_lines_g => 1,				--Number of lines to request from image transmitter, to hold in its FIFO
			
			-- generic values for resolution 640x480 @ 60 Hz
			hor_active_pixels_g => hor_active_pixels_g,				--640 active pixels per line
			ver_active_lines_g => 480,				--480 active lines
			hor_left_border_g => hor_left_border_g,				--Horizontal Left Border (Pixels)
			hor_right_border_g => 0,				--Horizontal Right Border (Pixels)
			hor_back_porch_g => hor_back_porch_g,				--Horizontal Back Porch (Pixels)
			hor_front_porch_g => hor_front_porch_g,				--Horizontal Front Porch (Pixels)
			hor_sync_time_g => 96,				--Horizontal Sync Time (Pixels)
			ver_top_border_g => 0,				--Vertical Top Border (Lines)
			ver_buttom_border_g => 0,				--Vertical Bottom Border (Lines)
			ver_back_porch_g => 31,				--Vertical Back Porch (Lines)
			ver_front_porch_g => 11,				--Vertical Front Porch (Lines)
			ver_sync_time_g => 2				--Vertical Sync Time (Lines)
			
			---------------------------------- beeri values --------------------------------
			-- req_lines_g => 2,				--Number of lines to request from image transmitter, to hold in its FIFO
			
			-- -- generic values for resolution 640x480 @ 60 Hz
			-- hor_active_pixels_g => 800,				--640 active pixels per line
			-- ver_active_lines_g => 600,				--480 active lines
			-- hor_left_border_g => 0,				--Horizontal Left Border (Pixels)
			-- hor_right_border_g => 0,				--Horizontal Right Border (Pixels)
			-- hor_back_porch_g => 88,				--Horizontal Back Porch (Pixels)
			-- hor_front_porch_g => 40,				--Horizontal Front Porch (Pixels)
			-- hor_sync_time_g => 128,				--Horizontal Sync Time (Pixels)
			-- ver_top_border_g => 0,				--Vertical Top Border (Lines)
			-- ver_buttom_border_g => 0,				--Vertical Bottom Border (Lines)
			-- ver_back_porch_g => 23,				--Vertical Back Porch (Lines)
			-- ver_front_porch_g => 1,				--Vertical Front Porch (Lines)
			-- ver_sync_time_g => 4				--Vertical Sync Time (Lines)
			--------------------------------------------------------------------------------
		)
		
		port map
		(
			--Clock, Reset
			clk			=>		pixel_clk, --Pixel Clock
			reset		=>		reset_n, --Reset

			--Input RGB
			r_in		=>		(others => '0'), --Input R Pixel
			g_in		=>		(others => '0'), --Input G Pixel
			b_in		=>		(others => '0'), --Input B Pixel

			--Frame Border (Size of frame)
			left_frame	=>		(others => '0'),	--Left frame border
			upper_frame	=>		(others => '0'), --Upper frame border
			right_frame	=>		(others => '0'), --Right frame border
			lower_frame	=>		(others => '0'), --Lower frame border
			
			--Image Enable. Required both enables to be '1' in order to enable image
			vesa_en		=>		'1', --Enable VESA to transmit image
			image_tx_en	=>		'1', --Image transmitter is enabled

			--Handshake
			data_valid	=>		'0', --Data is valid (If not - BLACK will be shown)
			req_data	=>		open, --Request for data
			pixels_req	=>		open, --Request for PIXELS*LINES pixels from FIFO
			req_ln_trig	=>		req_in_trg, --Trigger to image transmitter, to load its FIFO with new data

			--Output RGB
			r_out		=>		open, --Output R Pixel
			g_out		=>		open, --Output G Pixel
			b_out		=>		open, --Output B Pixel
			
			--Blanking signal
			blank		=>		open, --Blanking signal
				
			--Sync Signals				
			hsync		=>		open, --HSync Signal
			vsync		=>		op_str_rd_start
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
		  wait until clk = '1';
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
  
		  

	-- unite_proc: process 
		-- -- -- variable col_loop : std_logic_vector(4 downto 0);
		-- -- -- variable row_loop : std_logic_vector(3 downto 0);
	-- begin
	  -- -- -- -- ram_addr_rd <= "000000000";
		-- -- -- -- -- op_str_rd_start  <= '0';
		-- -- -- wait for 1 ms;
		
		-- -- -- ------------------------ initialize black screen ---------------------------
		-- -- -- wait for 200 ns;
		-- -- -- -- -- op_cnt <= "1110000100"; -- 900
		-- -- -- for row in 0 to 14 loop
			-- -- -- for col	in 0 to 19 loop
				-- -- -- row_loop := std_logic_vector(to_unsigned(row,4));
				-- -- -- col_loop := std_logic_vector(to_unsigned(col,5));
				-- -- -- -- add , addr = 0 (means row 0-1 in SDRAM)
				-- -- -- -- -- opu_data_in <= "00000000"; --MSB
				-- -- -- -- -- opu_data_in_valid <= '1';
				-- -- -- wait for 10 ns;
				-- -- -- opu_data_in_valid <= '0';
				-- -- -- wait for 10 ns;
				-- -- -- opu_data_in <= "0000101"&row_loop(3);
				-- -- -- opu_data_in_valid <= '1';
				-- -- -- wait for 10 ns;
				-- -- -- opu_data_in_valid <= '0';
				-- -- -- wait for 10 ns;
				-- -- -- opu_data_in <= row_loop(2 downto 0)&col_loop(4 downto 0); --LSB
				-- -- -- opu_data_in_valid <= '1';
				-- -- -- wait for 10 ns;
				-- -- -- opu_data_in_valid <= '0';
				-- -- -- wait for 10 ns;
			-- -- -- end loop;
		-- -- -- end loop;
	  
		-- -- -- wait for 500 us;
		-- -- -- -- front porch apporx. 300 us
		-- -- -- --wait for 1500 us;
		
		-- -- -- wait for 50 ns;
		-- -- -- op_str_rd_start  <= '1';
		-- -- -- wait for 20 ns;
		-- -- -- op_str_rd_start  <= '0';
		
		-- -- -- wait for 500 us;
		-- -- -- -- front porch apporx. 300 us
		-- -- -- --wait for 1500 us;
		
		  -- -- -- -- loop to reach a new video frame
		-- -- -- for i in 479 downto 0 loop
			-- -- -- wait for 13 us;
			-- -- -- req_in_trg <= '1';
			-- -- -- wait for 10 ns;
			-- -- -- req_in_trg <= '0';
		-- -- -- end loop;
		
		-- -- -- ------------------------------------------------------------------------
		
		-- -- -- -- packet of 9 bytes (= 3 opcodes)
		-- -- -- op_cnt <= "0000001001"; -- 9
		
		-- -- -- -- add , addr = 7 , x = 3 , y = 2  
		-- -- -- opu_data_in <= "01000000"; --MSB
		-- -- -- opu_data_in_valid <= '1';
		-- -- -- wait for 10 ns;
		-- -- -- opu_data_in_valid <= '0';
		-- -- -- wait for 10 ns;
		-- -- -- opu_data_in <= "00011110";
		-- -- -- opu_data_in_valid <= '1';
		-- -- -- wait for 10 ns;
		-- -- -- opu_data_in_valid <= '0';
		-- -- -- wait for 10 ns;
		-- -- -- opu_data_in <= "01100010"; --LSB
		-- -- -- opu_data_in_valid <= '1';
		-- -- -- wait for 10 ns;
		-- -- -- opu_data_in_valid <= '0';
		-- -- -- wait for 10 ns;
		
		-- -- -- -- add , addr = 3 , x = 5 , y = 1
		-- -- -- opu_data_in <= "01000000"; 
		-- -- -- opu_data_in_valid <= '1';
		-- -- -- wait for 10 ns;
		-- -- -- opu_data_in_valid <= '0';
		-- -- -- wait for 10 ns;
		-- -- -- opu_data_in <= "01100110";
		-- -- -- opu_data_in_valid <= '1';
		-- -- -- wait for 10 ns;
		-- -- -- opu_data_in_valid <= '0';
		-- -- -- wait for 10 ns;
		-- -- -- opu_data_in <= "10100001";
		-- -- -- opu_data_in_valid <= '1';
		-- -- -- wait for 10 ns;
		-- -- -- opu_data_in_valid <= '0';
		-- -- -- wait for 10 ns;
		
		-- -- -- --reset_n	<=	'0';
		
		-- -- -- -- remove , addr = 3 , x = 5 , y = 1 
		-- -- -- opu_data_in <= "00000000";
		-- -- -- opu_data_in_valid <= '1';
		-- -- -- wait for 10 ns;
		-- -- -- opu_data_in_valid <= '0';
		-- -- -- wait for 10 ns;
		-- -- -- opu_data_in <= "00000110";
		-- -- -- opu_data_in_valid <= '1';
		-- -- -- wait for 10 ns;
		-- -- -- opu_data_in_valid <= '0';
		-- -- -- wait for 10 ns;
		-- -- -- opu_data_in <= "10100001";
		-- -- -- opu_data_in_valid <= '1';
		-- -- -- wait for 10 ns;
		-- -- -- opu_data_in_valid <= '0';
		-- -- -- wait for 10 ns;
		
		-- -- -- wait for 500 us;
		-- -- -- -- front porch apporx. 300 us
		-- -- -- --wait for 1500 us;
		
		-- -- -- wait for 50 ns;
		-- -- -- op_str_rd_start  <= '1';
		-- -- -- wait for 20 ns;
		-- -- -- op_str_rd_start  <= '0';
		
		-- -- -- wait for 500 us;
		-- -- -- -- front porch apporx. 300 us
		-- -- -- --wait for 1500 us;
		
		  -- -- -- -- loop to reach a new video frame
		-- -- -- for i in 479 downto 0 loop
			-- -- -- wait for 13 us;
			-- -- -- req_in_trg <= '1';
			-- -- -- wait for 10 ns;
			-- -- -- req_in_trg <= '0';
		-- -- -- end loop;
		
		-----------------------------------------------------------------------
		-- -- -- initialize the screen with black symbols
		
		-- -- -- packet of 900 bytes (= 300 opcode)
		-- -- op_cnt <= "1110000100"; -- 900
		
		-- -- for row in 0 to 14 loop
			-- -- for col	in 0 to 19 loop
				-- -- row_loop := std_logic_vector(to_unsigned(row,4));
				-- -- col_loop := std_logic_vector(to_unsigned(col,5));
				-- -- -- add , addr = 0 (means row 0-1 in SDRAM)
				-- -- opu_data_in <= "01000000"; --MSB
				-- -- opu_data_in_valid <= '1';
				-- -- wait for 10 ns;
				-- -- opu_data_in_valid <= '0';
				-- -- wait for 10 ns;
				-- -- opu_data_in <= "0001001"&row_loop(3);
				-- -- opu_data_in_valid <= '1';
				-- -- wait for 10 ns;
				-- -- opu_data_in_valid <= '0';
				-- -- wait for 10 ns;
				-- -- opu_data_in <= row_loop(2 downto 0)&col_loop(4 downto 0); --LSB
				-- -- opu_data_in_valid <= '1';
				-- -- wait for 10 ns;
				-- -- opu_data_in_valid <= '0';
				-- -- wait for 10 ns;
			-- -- end loop;
		-- -- end loop;
				   
		-- -- -----------------------------------------------------------------------
		
		
		-- -- -- -- -- packet of 3 bytes (= 1 opcode)
		-- -- -- -- op_cnt <= "0000000011"; -- 3
		
		-- -- -- -- -- add , addr = 1 (means row 2-3 in SDRAM) , x = 0 , y = 0  
		-- -- -- -- opu_data_in <= "01000000"; --MSB
		-- -- -- -- opu_data_in_valid <= '1';
		-- -- -- -- wait for 10 ns;
		-- -- -- -- opu_data_in_valid <= '0';
		-- -- -- -- wait for 10 ns;
		-- -- -- -- opu_data_in <= "00000010";
		-- -- -- -- opu_data_in_valid <= '1';
		-- -- -- -- wait for 10 ns;
		-- -- -- -- opu_data_in_valid <= '0';
		-- -- -- -- wait for 10 ns;
		-- -- -- -- opu_data_in <= "00000000"; --LSB
		-- -- -- -- opu_data_in_valid <= '1';
		-- -- -- -- wait for 10 ns;
		-- -- -- -- opu_data_in_valid <= '0';
		-- -- -- -- wait for 10 ns;
		
		-- -- wait for 50 ns;
		-- -- op_str_rd_start  <= '1';
		-- -- wait for 20 ns;
		-- -- op_str_rd_start  <= '0';
		
		-- -- wait for 200 ns;
		
		-- -- op_cnt <= "1110000100"; -- 900
		
		-- -- for row in 0 to 14 loop
			-- -- for col	in 0 to 19 loop
				-- -- row_loop := std_logic_vector(to_unsigned(row,4));
				-- -- col_loop := std_logic_vector(to_unsigned(col,5));
				-- -- -- add , addr = 0 (means row 0-1 in SDRAM)
				-- -- opu_data_in <= "01000000"; --MSB
				-- -- opu_data_in_valid <= '1';
				-- -- wait for 10 ns;
				-- -- opu_data_in_valid <= '0';
				-- -- wait for 10 ns;
				-- -- opu_data_in <= "0000101"&row_loop(3);
				-- -- opu_data_in_valid <= '1';
				-- -- wait for 10 ns;
				-- -- opu_data_in_valid <= '0';
				-- -- wait for 10 ns;
				-- -- opu_data_in <= row_loop(2 downto 0)&col_loop(4 downto 0); --LSB
				-- -- opu_data_in_valid <= '1';
				-- -- wait for 10 ns;
				-- -- opu_data_in_valid <= '0';
				-- -- wait for 10 ns;
			-- -- end loop;
		-- -- end loop;
	  
	  -- -- -- loop to reach a new video frame
		-- -- for i in 479 downto 0 loop
			-- -- wait for 13 us;
			-- -- req_in_trg <= '1';
			-- -- wait for 10 ns;
			-- -- req_in_trg <= '0';
		-- -- end loop;
		
		-- -- wait for 500 us;
		-- -- -- front porch apporx. 300 us
		-- -- --wait for 1500 us;
		
		-- -- wait for 50 ns;
		-- -- op_str_rd_start  <= '1';
		-- -- wait for 20 ns;
		-- -- op_str_rd_start  <= '0';
		
		-- -- wait for 500 us;
		-- -- -- front porch apporx. 300 us
		-- -- --wait for 1500 us;
		
		  -- -- -- loop to reach a new video frame
		-- -- for i in 479 downto 0 loop
			-- -- wait for 13 us;
			-- -- req_in_trg <= '1';
			-- -- wait for 10 ns;
			-- -- req_in_trg <= '0';
		-- -- end loop;
		
		-- -- wait for 200 ns;
		
		-- -- ---------------------- remove the corners -------------------------
		-- -- op_cnt <= "0000001100"; -- 12
		-- -- --
		-- -- row_loop := std_logic_vector(to_unsigned(0,4));
		-- -- col_loop := std_logic_vector(to_unsigned(0,5));
		-- -- opu_data_in <= "00000000"; --MSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= "0001111"&row_loop(3);
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= row_loop(2 downto 0)&col_loop(4 downto 0); --LSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- --
		-- -- row_loop := std_logic_vector(to_unsigned(0,4));
		-- -- col_loop := std_logic_vector(to_unsigned(19,5));
		-- -- opu_data_in <= "00000000"; --MSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= "0011100"&row_loop(3);
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= row_loop(2 downto 0)&col_loop(4 downto 0); --LSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- --
		-- -- row_loop := std_logic_vector(to_unsigned(14,4));
		-- -- col_loop := std_logic_vector(to_unsigned(0,5));
		-- -- opu_data_in <= "00000000"; --MSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= "0011100"&row_loop(3);
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= row_loop(2 downto 0)&col_loop(4 downto 0); --LSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- row_loop := std_logic_vector(to_unsigned(14,4));
		-- -- col_loop := std_logic_vector(to_unsigned(19,5));
		-- -- opu_data_in <= "00000000"; --MSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= "0010000"&row_loop(3);
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= row_loop(2 downto 0)&col_loop(4 downto 0); --LSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		
		-- -- wait for 500 us;
		-- -- -- front porch apporx. 300 us
		-- -- --wait for 1500 us;
		
		-- -- wait for 50 ns;
		-- -- op_str_rd_start  <= '1';
		-- -- wait for 20 ns;
		-- -- op_str_rd_start  <= '0';
		
		-- -- wait for 500 us;
		-- -- -- front porch apporx. 300 us
		-- -- --wait for 1500 us;
		
		  -- -- -- loop to reach a new video frame
		-- -- for i in 479 downto 0 loop
			-- -- wait for 13 us;
			-- -- req_in_trg <= '1';
			-- -- wait for 10 ns;
			-- -- req_in_trg <= '0';
		-- -- end loop;
		
		-- -- wait for 200 ns;
		
		-- -- --------------------- add 8 symbols ----------------------
		-- -- op_cnt <= "0000011000"; -- 24
		-- -- --
		-- -- row_loop := std_logic_vector(to_unsigned(0,4));
		-- -- col_loop := std_logic_vector(to_unsigned(1,5));
		-- -- opu_data_in <= "01000000"; --MSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= "0000001"&row_loop(3);
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= row_loop(2 downto 0)&col_loop(4 downto 0); --LSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- --
		-- -- row_loop := std_logic_vector(to_unsigned(1,4));
		-- -- col_loop := std_logic_vector(to_unsigned(0,5));
		-- -- opu_data_in <= "01000000"; --MSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= "0000010"&row_loop(3);
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= row_loop(2 downto 0)&col_loop(4 downto 0); --LSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- --
		-- -- row_loop := std_logic_vector(to_unsigned(0,4));
		-- -- col_loop := std_logic_vector(to_unsigned(18,5));
		-- -- opu_data_in <= "01000000"; --MSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= "0000011"&row_loop(3);
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= row_loop(2 downto 0)&col_loop(4 downto 0); --LSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- --
		-- -- row_loop := std_logic_vector(to_unsigned(1,4));
		-- -- col_loop := std_logic_vector(to_unsigned(19,5));
		-- -- opu_data_in <= "01000000"; --MSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= "0000100"&row_loop(3);
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= row_loop(2 downto 0)&col_loop(4 downto 0); --LSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- --
		-- -- row_loop := std_logic_vector(to_unsigned(13,4));
		-- -- col_loop := std_logic_vector(to_unsigned(0,5));
		-- -- opu_data_in <= "01000000"; --MSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= "0001001"&row_loop(3);
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= row_loop(2 downto 0)&col_loop(4 downto 0); --LSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- --
		-- -- row_loop := std_logic_vector(to_unsigned(14,4));
		-- -- col_loop := std_logic_vector(to_unsigned(1,5));
		-- -- opu_data_in <= "01000000"; --MSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= "0000110"&row_loop(3);
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= row_loop(2 downto 0)&col_loop(4 downto 0); --LSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- --
		-- -- row_loop := std_logic_vector(to_unsigned(13,4));
		-- -- col_loop := std_logic_vector(to_unsigned(19,5));
		-- -- opu_data_in <= "01000000"; --MSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= "0000111"&row_loop(3);
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= row_loop(2 downto 0)&col_loop(4 downto 0); --LSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- --
		-- -- row_loop := std_logic_vector(to_unsigned(14,4));
		-- -- col_loop := std_logic_vector(to_unsigned(18,5));
		-- -- opu_data_in <= "01000000"; --MSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= "0001000"&row_loop(3);
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		-- -- opu_data_in <= row_loop(2 downto 0)&col_loop(4 downto 0); --LSB
		-- -- opu_data_in_valid <= '1';
		-- -- wait for 10 ns;
		-- -- opu_data_in_valid <= '0';
		-- -- wait for 10 ns;
		
		-- -- wait for 500 us;
		-- -- -- front porch apporx. 300 us
		-- -- --wait for 1500 us;
		
		-- -- wait for 50 ns;
		-- -- op_str_rd_start  <= '1';
		-- -- wait for 20 ns;
		-- -- op_str_rd_start  <= '0';
		
		-- -- wait for 500 us;
		-- -- -- front porch apporx. 300 us
		-- -- --wait for 1500 us;
		
		  -- -- -- loop to reach a new video frame
		-- -- for i in 479 downto 0 loop
			-- -- wait for 13 us;
			-- -- req_in_trg <= '1';
			-- -- wait for 10 ns;
			-- -- req_in_trg <= '0';
		-- -- end loop;
		
		-- -- wait for 200 ns;

	--	wait;
		
--	end process unite_proc;

end architecture sim_Symbol_Generator_Top_TB;

