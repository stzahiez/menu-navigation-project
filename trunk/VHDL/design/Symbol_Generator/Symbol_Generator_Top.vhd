------------------------------------------------------------------------------------------------
-- Model Name 	:	Symbol_Generator_Top_TB
-- File Name	:	opcode_unite_tb.vhd
-- Generated	:	27.10.2012
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description:
-- The top block that unites all the Symbol Generator internal blocks
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		 Date			Name				Description			
--			1.00		 27.10.2012		Olga Liberman		Creation
--
------------------------------------------------------------------------------------------------
--	Todo:
--	(1) 
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Symbol_Generator_Top is
	generic(
		-- generic values for resolution 640x480 @ 60 Hz
		hor_active_pixels_g		:	positive	:= 640;				--640 active pixels per line
		ver_active_lines_g		:	positive	:= 480;				--480 active lines
		hor_left_border_g		:	natural		:= 0;				--Horizontal Left Border (Pixels)
		hor_right_border_g		:	natural		:= 0;				--Horizontal Right Border (Pixels)
		hor_back_porch_g		:	integer		:= 48;				--Horizontal Back Porch (Pixels)
		hor_front_porch_g		:	integer		:= 16;				--Horizontal Front Porch (Pixels)
		hor_sync_time_g			:	integer		:= 96;				--Horizontal Sync Time (Pixels)
		ver_top_border_g		:	natural		:= 0;				--Vertical Top Border (Lines)
		ver_buttom_border_g		:	natural		:= 0;				--Vertical Bottom Border (Lines)
		ver_back_porch_g		:	integer		:= 31;				--Vertical Back Porch (Lines)
		ver_front_porch_g		:	integer		:= 11;				--Vertical Front Porch (Lines)
		ver_sync_time_g			:	integer		:= 2				--Vertical Sync Time (Lines)
	);
	port (
		-- clock and reset
		clk					:	in std_logic; -- the main clock to which all the internal logic of the Symbol Generator block is synchronized.
		reset_n				:	in std_logic; -- asynchronous reset
		-- opcode_unite
		opu_data_in			:	in std_logic_vector(7 downto 0); -- data from wbs
		opu_data_in_valid	:	in std_logic; -- valid signal for data from wbs
		-- opcode_store
		op_cnt             	:	in std_logic_vector(9 downto 0); -- number of total changes X 3: 1 change (24 bits) = add/remove 1 symbol ( 24 bits are being sent in 3 packs of 8 bits)
		op_str_rd_start		:	in std_logic; -- connected from VESA controller, vsync signal
		vsync_trigger		:	out std_logic; -- rising edge of the vsync from VESA
		-- manager
		req_in_trg			:	in std_logic; -- This is a signal from the VESA Generator block. It indicates when to start preparing valid data in the Dual Clk FIFO for a req_lines_g lines in advance. (In our case it is 1 line in advance).
		sdram_data 			:	in std_logic_vector (7 downto 0); --this signal gets the data from sdram 
		sdram_data_valid	:	in std_logic; -- indicates when the data from the sdram is valid and we can store it in one of the fifos (a or b)
		sdram_addr_rd 		: 	out std_logic_vector (23 downto 0); --this signal is the full address in SDRAM: "00--bank(2)--row(12)--col(8)"
		sdram_rd_en		:	out std_logic; -- this signal is a valid signal for the sdram_addr_rd signal (for usage of WBS)
		-- mux2
		mux_dout_valid		:	out std_logic;
		mux_dout	  		:	out std_logic_vector(7 downto 0)
	);
end entity Symbol_Generator_Top;

architecture rtl_Symbol_Generator_Top of Symbol_Generator_Top is

	--#############################	Components	##############################################--

	component opcode_unite
		port (
				clk			       	: 	in 		std_logic; -- the main clock to which all the internal logic of the Symbol Generator block is synchronized.
				reset_n		    	: 	in 		std_logic; -- asynchronous reset
				opu_data_in			    : 	in 		std_logic_vector(7 downto 0); -- data from wbs
				opu_data_in_valid	: 	in 		std_logic; -- valid signal for data from wbs
				--opu_data_in_cnt	 	: 	in 		std_logic_vector(9 downto 0); -- number of changes in bytes - 1, each change is 3 bytes
				opu_wr_en			      : 	out 	std_logic; -- This signal is an enable signal to write opcodes to the Opcode Store block. It is active when a new opcode was united and is ready to be stored in the FIFO.
				opu_data_out		    : 	out 	std_logic_vector(23 downto 0) -- The data signal is the united Opcode to be stored in the Opcode store block.
				--counter				:	out 	std_logic_vector(9 downto 0) := (others => '0');  -- counter signal to count the message packs from wbs
			);
	end component opcode_unite;


	component opcode_store
		port (
				clk            		: in    std_logic;	 					-- clock in domain 133Mhz.
		  reset_n        			: in    std_logic; 						-- asynchronous reset. 
				op_cnt             	: in    std_logic_vector(9 downto 0);   	-- number of total changes X 3: 1 change (24 bits) = add/remove 1 symbol ( 24 bits are being sent in 3 packs of 8 bits)
				op_str_valid       	: in    std_logic; 						-- connected from opcode_unite block, opu_wr_en signal
				op_str_data_in     	: in    std_logic_vector(23 downto 0); 	-- connected from opcode_unite block, opu_data_out signal
				op_str_rd_start    	: in    std_logic; 						-- connected from VESA controller, vsync signal
				ram_addr_wr        	: out   std_logic_vector(8 downto 0);  	-- ram's address to be written into. 
				ram_wr_en          	: out   std_logic;					 	-- ram write enable
				ram_data           	: out   std_logic_vector(12 downto 0);	-- data sent to ram
				mng_en          	: out   std_logic;						-- activating Read_Manager 
				op_str_empty       	: out   std_logic;						-- FIFO is empty (debug)
				op_str_full        	: out   std_logic;						-- FIFO is full (debug)
				op_str_used        	: out   std_logic_vector(9 downto 0);		-- current number of elements in FIFO (debug)	
				vsync_out			: out std_logic
			);
	end component opcode_store;

	component RAM_300 
	  port (
		clk              	: in std_logic;	 						
		reset_n          	: in std_logic; 						
		ram_wr_en           : in  std_logic;
		ram_addr_wr         : in  std_logic_vector(8 downto 0);
		ram_addr_rd         : in  std_logic_vector(8 downto 0);
		ram_rd_en           : in  std_logic;
		ram_data_in         : in  std_logic_vector(12 downto 0);
		ram_data_out        : out std_logic_vector(12 downto 0)
	  );
	end component RAM_300;

	component manager is
		generic(
			sym_row_g		: 		positive	:= 15; 	-- Total symbol row count for the frame
			sym_col_g		: 		positive	:= 20; 	-- Total symol column count for the frame
			inside_row_g	: 		positive	:= 32; 	-- Total row count inside the symbol
			sdram_burst_g	: 		positive	:= 16; 	-- The length of the burst from SDRAM (in words = 16 bits)
			-- generic values for resolution 640x480 @ 60 Hz
			hor_active_pixels_g		:	positive	:= 640;				--640 active pixels per line
			ver_active_lines_g		:	positive	:= 480;				--480 active lines
			hor_left_border_g		:	natural		:= 0;				--Horizontal Left Border (Pixels)
			hor_right_border_g		:	natural		:= 0;				--Horizontal Right Border (Pixels)
			hor_back_porch_g		:	integer		:= 48;				--Horizontal Back Porch (Pixels)
			hor_front_porch_g		:	integer		:= 16;				--Horizontal Front Porch (Pixels)
			hor_sync_time_g			:	integer		:= 96;				--Horizontal Sync Time (Pixels)
			ver_top_border_g		:	natural		:= 0;				--Vertical Top Border (Lines)
			ver_buttom_border_g		:	natural		:= 0;				--Vertical Bottom Border (Lines)
			ver_back_porch_g		:	integer		:= 31;				--Vertical Back Porch (Lines)
			ver_front_porch_g		:	integer		:= 11;				--Vertical Front Porch (Lines)
			ver_sync_time_g			:	integer		:= 2				--Vertical Sync Time (Lines)
		);
		port (
			clk 				: 		in std_logic; -- The main clock to which all the internal logic of the Symbol Generator block is synchronized.
			reset_n 			: 		in std_logic; -- Asynchronous reset 
			ram_data_out 		: 		in std_logic_vector(12 downto 0); -- This signal is sent from the RAM . It represents the data readed from the RAM (represent the first row in which the symbol is saved in SDRAM). 
			req_in_trg 			: 		in std_logic; -- This is a signal from the VESA Generator block. It indicates when to start preparing valid data in the Dual Clk FIFO for a req_lines_g lines in advance. (In our case it is 1 line in advance).
			mng_en 				: 		in std_logic; --
			sdram_data 			: 		in std_logic_vector (7 downto 0); --this signal gets the data from sdram 
			sdram_data_valid	:		in std_logic; -- indicates when the data from the sdram is valid and we can store it in one of the fifos (a or b)
			--fifo_a_used			:		in std_logic_vector(10 downto 0); -- fifo a used signal
			--fifo_a_full			:		in std_logic; -- fifo a full indication
			fifo_a_empty		:		in std_logic; -- fifo a empty indication
			--fifo_b_used			:		in std_logic_vector(10 downto 0); -- fifo b used signal
			--fifo_b_full			:		in std_logic; -- fifo b full indication
			fifo_b_empty		:		in std_logic; -- fifo b empty indication
			ram_rd_en_out 		: 		out std_logic; -- This signal is sent to the RAM. It is an enable signal for reading from the RAM.
			ram_addr_rd 		: 		out std_logic_vector(8 downto 0); -- This signal is sent to the RAM. It indicates the row in the RAM from which we want to read.  
			fifo_a_rd_en 		: 		out std_logic; -- read enable to fifo a
			fifo_a_wr_en 		: 		out std_logic; -- write enable to fifo a
			fifo_a_data_in 		: 		out std_logic_vector(7 downto 0); -- data in to fifo a
			fifo_b_rd_en 		: 		out std_logic; -- read enable to fifo b
			fifo_b_wr_en 		: 		out std_logic; -- write enable to fifo b
			fifo_b_data_in 		: 		out std_logic_vector(7 downto 0); -- data in to fifo b
			sdram_addr_rd 		: 		out std_logic_vector (23 downto 0); --this signal is the full address in SDRAM: "00--bank(2)--row(12)--col(8)"
			sdram_rd_en_out		:		out std_logic -- this signal is a valid signal for the sdram_addr_rd signal (for usage of WBS)
			--mux_sel         	: 		out std_logic
		);
	end component manager;

	component general_fifo is 
		generic(	 
			reset_polarity_g	: std_logic	:= '0';	-- Reset Polarity
			width_g				: positive	:= 8; 	-- Width of data
			depth_g 			: positive	:= 640;	-- Maximum elements in FIFO
			log_depth_g			: natural	:= 10;	-- Logarithm of depth_g (Number of bits to represent depth_g. 2^4=16 > 9)
			almost_full_g		: positive	:= 8; 	-- Rise almost full flag at this number of elements in FIFO
			almost_empty_g		: positive	:= 1 	-- Rise almost empty flag at this number of elements in FIFO
			);
		 port(
			clk 				: in 	std_logic;									-- Clock
			rst 				: in 	std_logic;                                  -- Reset
			din 				: in 	std_logic_vector (width_g-1 downto 0);      -- Input Data
			wr_en 				: in 	std_logic;                                  -- Write Enable
			rd_en 				: in 	std_logic;                                  -- Read Enable (request for data)
			flush				: in	std_logic;									-- Flush data
			dout 				: out 	std_logic_vector (width_g-1 downto 0);	    -- Output Data
			dout_valid			: out 	std_logic;                                  -- Output data is valid
			afull  				: out 	std_logic;                                  -- FIFO is almost full
			full 				: out 	std_logic;	                                -- FIFO is full
			aempty 				: out 	std_logic;                                  -- FIFO is almost empty
			empty 				: out 	std_logic;                                  -- FIFO is empty
			used 				: out 	std_logic_vector (log_depth_g  downto 0) 	-- Current number of elements is FIFO. Note the range. In case depth_g is 2^x, then the extra bit will be used
			 );
	end component general_fifo;

	component mux2 is
		generic (
			width_g				:		positive	:= 8 					-- Width of data
		);
		port (
			clk 		    	: in 	std_logic;                       		-- the main clock to which all the internal logic of the Symbol Generator block is synchronized.
			reset_n 	  		: in 	std_logic;                       		-- asynchronous reset
			mux_din_a 			: in 	std_logic_vector(width_g-1 downto 0);  -- data from fifo_a
			mux_din_b 			: in 	std_logic_vector(width_g-1 downto 0);  -- data from fifo_b
			--mux_sel 	  		: in 	std_logic;                       		-- selection of enteries: mux_sel='0' -> mux_din_a , mux_sel='1' -> mux_din_b
			rd_en_a 			: in	std_logic; 						-- read enable to fifo a
			rd_en_b 			: in 	std_logic; 						-- read enable to fifo b
			fifo_a_dout_valid 	: in std_logic;
			fifo_b_dout_valid 	: in std_logic;
			mux_dout_valid		: out std_logic;
			mux_dout	  		: out std_logic_vector(width_g-1 downto 0)  --data out to DC FIFO
		);
	end component mux2;


	--#############################	Signals ##############################################--

	signal opu_data_in_cnt		: 	std_logic_vector(9 downto 0); -- number of changes in bytes - 1, each change is 3 bytes
	signal opu_wr_en		    : 	std_logic; -- This signal is an enable signal to write opcodes to the Opcode Store block. It is active when a new opcode was united and is ready to be stored in the FIFO.
	signal opu_data_out		    : 	std_logic_vector(23 downto 0); -- The data signal is the united Opcode to be stored in the Opcode store block.
	-- signals counter			:	std_logic_vector(9 downto 0) := (others => '0');  -- counter signal to count the message packs from wbs

	signal ram_addr_wr          :   std_logic_vector(8 downto 0);  		-- ram's address to be written into. 
	signal ram_wr_en            :   std_logic;							-- ram write enable
	signal mng_en               :   std_logic;							-- activating Read_Manager 
	signal op_str_empty         :   std_logic;							-- FIFO is empty (debug)
	signal op_str_full          :   std_logic;							-- FIFO is full (debug)
	signal op_str_used          :   std_logic_vector(9 downto 0);		-- current number of elements in FIFO (debug)	

	signal ram_addr_rd          :   std_logic_vector(8 downto 0);
	signal ram_data_in          :   std_logic_vector(12 downto 0);
	signal ram_data_out         :   std_logic_vector(12 downto 0);
	signal ram_rd_en            :   std_logic;

	signal fifo_a_used			:		 std_logic_vector(10 downto 0):= (others=>'0'); -- fifo a used signal
	signal fifo_a_full			:		 std_logic:= '0'; -- fifo a full indication
	signal fifo_a_empty		    :   std_logic:= '0'; -- fifo a empty indication
	signal fifo_b_used			:		 std_logic_vector(10 downto 0):= (others=>'0'); -- fifo b used signal
	signal fifo_b_full			:		 std_logic:= '0'; -- fifo b full indication
	signal fifo_b_empty		    :		 std_logic:= '0'; -- fifo b empty indication
	signal fifo_a_rd_en 		:   std_logic:= '0'; -- read enable to fifo a
	signal fifo_a_wr_en 		:   std_logic:= '0'; -- write enable to fifo a
	signal fifo_a_data_in 		:   std_logic_vector(7 downto 0):= (others=>'0'); -- data in to fifo a
	signal fifo_b_rd_en 		: 		std_logic:= '0'; -- read enable to fifo b
	signal fifo_b_wr_en 		:   std_logic:= '0'; -- write enable to fifo b
	signal fifo_b_data_in 		:   std_logic_vector(7 downto 0):= (others=>'0'); -- data in to fifo b
	--signal mux_sel            :   std_logic;

	signal fifo_a_flush         :   std_logic := '0';
	signal fifo_b_flush         :   std_logic := '0';
	signal fifo_a_dout			:	  std_logic_vector (7 downto 0);
	signal fifo_b_dout		    :	  std_logic_vector (7 downto 0);

	signal fifo_a_dout_valid 	: std_logic;
	signal fifo_b_dout_valid 	: std_logic;
	-- signal fifo_a_dout_valid_d 	: std_logic;
	-- signal fifo_b_dout_valid_d 	: std_logic;

begin
	
	--#############################	Instantiaion ##############################################--
	opcode_unite_inst :  opcode_unite 
	port map(
		clk            => clk,
		reset_n        => reset_n,
		opu_data_in        => opu_data_in,
		opu_data_in_valid  => opu_data_in_valid,
		--opu_data_in_cnt    => opu_data_in_cnt,
		opu_wr_en          => opu_wr_en,
		opu_data_out       => opu_data_out
		--counter => counter
	);

	opcode_store_inst :  opcode_store 
	port map(
		clk            		=> clk,       
		reset_n        		=> reset_n,     
		op_cnt             	=> op_cnt,          
		op_str_valid   		=> opu_wr_en,     
		op_str_data_in     	=> opu_data_out,    
		op_str_rd_start    	=> op_str_rd_start,   
		ram_addr_wr       	=> ram_addr_wr,     
		ram_wr_en          	=> ram_wr_en,      
		ram_data           	=> ram_data_in,       
		mng_en          	=> mng_en,           
		op_str_empty       	=> op_str_empty,
		op_str_full        	=> op_str_full,
		op_str_used        	=> op_str_used,
		vsync_out			=> vsync_trigger
			);

	RAM_300_inst :  RAM_300
	port map(
		clk              	=> clk,
		reset_n          	=> reset_n,
		ram_wr_en           => ram_wr_en,
		ram_addr_wr         => ram_addr_wr,      
		ram_addr_rd         => ram_addr_rd,
		ram_data_in         => ram_data_in,
		ram_data_out        => ram_data_out,
		ram_rd_en           => ram_rd_en  
	  );

	manager_inst : manager
	generic map(
			sym_row_g		=> 		15, 	-- Total symbol row count for the frame
			sym_col_g		=> 		20, 	-- Total symol column count for the frame
			inside_row_g	=> 		32, 	-- Total row count inside the symbol
			sdram_burst_g	=> 		16, 	-- The length of the burst from SDRAM (in words = 16 bits)
			-- generic values for resolution 640x480 @ 60 Hz
			hor_active_pixels_g => 640,				--640 active pixels per line
			ver_active_lines_g => 480,				--480 active lines
			hor_left_border_g => 0,				--Horizontal Left Border (Pixels)
			hor_right_border_g => 0,				--Horizontal Right Border (Pixels)
			hor_back_porch_g => 48,				--Horizontal Back Porch (Pixels)
			hor_front_porch_g => 16,				--Horizontal Front Porch (Pixels)
			hor_sync_time_g => 96,				--Horizontal Sync Time (Pixels)
			ver_top_border_g => 0,				--Vertical Top Border (Lines)
			ver_buttom_border_g => 0,				--Vertical Bottom Border (Lines)
			ver_back_porch_g => 31,				--Vertical Back Porch (Lines)
			ver_front_porch_g => 11,				--Vertical Front Porch (Lines)
			ver_sync_time_g => 2				--Vertical Sync Time (Lines)
		)
	port map(
		clk					=> clk,
		reset_n          	=> reset_n,
		ram_data_out        => ram_data_out,
		req_in_trg			=> req_in_trg,
		mng_en          	=> mng_en,
		sdram_data			=> sdram_data,
		sdram_data_valid	=> sdram_data_valid,
		--fifo_a_used			=> fifo_a_used,
		--fifo_a_full			=> fifo_a_full,
		fifo_a_empty		=> fifo_a_empty,
		--fifo_b_used			=> fifo_b_used,
		--fifo_b_full			=> fifo_b_full,
		fifo_b_empty		=> fifo_b_empty,
		ram_rd_en_out		=> ram_rd_en,
		ram_addr_rd			=> ram_addr_rd,
		fifo_a_rd_en		=> fifo_a_rd_en,
		fifo_a_wr_en		=> fifo_a_wr_en,
		fifo_a_data_in		=> fifo_a_data_in,
		fifo_b_rd_en		=> fifo_b_rd_en,
		fifo_b_wr_en		=> fifo_b_wr_en,
		fifo_b_data_in		=> fifo_b_data_in,
		sdram_addr_rd		=> sdram_addr_rd,
		sdram_rd_en_out		=> sdram_rd_en
		--mux_sel => mux_sel
	);
	
	fifo_A : general_fifo
		generic map(	 
			reset_polarity_g	=> '0',	-- Reset Polarity
			width_g				=> 8, 	-- Width of data
			depth_g 			=> 640,	-- Maximum elements in FIFO
			log_depth_g			=> 10,		-- Logarithm of depth_g (Number of bits to represent depth_g. 2^4=16 > 9)
			almost_full_g		=> 8, 	-- Rise almost full flag at this number of elements in FIFO
			almost_empty_g		=> 1 	-- Rise almost empty flag at this number of elements in FIFO
			)
		 port map(
			 clk 			=> 		clk,					-- Clock
			 rst 			=> 		reset_n,             -- Reset
			 din 			=> 		fifo_a_data_in,      -- Input Data
			 wr_en 			=> 		fifo_a_wr_en,        -- Write Enable
			 rd_en 			=> 		fifo_a_rd_en,        -- Read Enable (request for data)
			 flush			=> 		fifo_a_flush,		-- Flush data
			 dout 			=> 		fifo_a_dout,	    	-- Output Data
			 dout_valid		=> 		fifo_a_dout_valid,                -- Output data is valid
			 afull  		=> 		open,                -- FIFO is almost full
			 full 			=>  	fifo_a_full,        -- FIFO is full
			 aempty 		=> 		open,                -- FIFO is almost empty
			 empty 			=> 		fifo_a_empty,        -- FIFO is empty
			 used 			=> 		fifo_a_used  		-- Current number of elements is FIFO. Note the range. In case depth_g is 2^x, then the extra bit will be used
			 );

	fifo_B : general_fifo
		generic map(	 
			reset_polarity_g	=> '0',	-- Reset Polarity
			width_g				=> 8, 	-- Width of data
			depth_g 			=> 640,	-- Maximum elements in FIFO
			log_depth_g			=> 10,		-- Logarithm of depth_g (Number of bits to represent depth_g. 2^4=16 > 9)
			almost_full_g		=> 8, 	-- Rise almost full flag at this number of elements in FIFO
			almost_empty_g		=> 1 	-- Rise almost empty flag at this number of elements in FIFO
			)
		 port map(
			 clk 			=> 		clk,					-- Clock
			 rst 			=> 		reset_n,             -- Reset
			 din 			=> 		fifo_b_data_in,      -- Input Data
			 wr_en 			=> 		fifo_b_wr_en,        -- Write Enable
			 rd_en 			=> 		fifo_b_rd_en,        -- Read Enable (request for data)
			 flush			=> 		fifo_b_flush,		-- Flush data
			 dout 			=> 		fifo_b_dout,	    	-- Output Data
			 dout_valid		=> 		fifo_b_dout_valid,                -- Output data is valid
			 afull  		=> 		open,                -- FIFO is almost full
			 full 			=> 		fifo_b_full,         -- FIFO is full
			 aempty 		=> 		open,                -- FIFO is almost empty
			 empty 			=> 		fifo_b_empty,        -- FIFO is empty
			 used 			=> 		fifo_b_used  		-- Current number of elements is FIFO. Note the range. In case depth_g is 2^x, then the extra bit will be used
			 );
			 
	mux2_inst : mux2
		generic map(
			width_g			=>		8
		)
		port map(
			clk 		    => 		clk,          -- the main clock to which all the internal logic of the Symbol Generator block is synchronized.
			reset_n 	  	=> 		reset_n,         -- asynchronous reset
			mux_din_a 		=> 		fifo_a_dout,   -- data from fifo_a
			mux_din_b 		=> 		fifo_b_dout,   -- data from fifo_b
			--mux_sel 	  	=> 		mux_sel,     -- selection of enteries: mux_sel='0' -> mux_din_a , mux_sel='1' -> mux_din_b
			rd_en_a			=> 		fifo_a_rd_en,
			rd_en_b			=> 		fifo_b_rd_en,
			fifo_a_dout_valid => fifo_a_dout_valid,
			fifo_b_dout_valid => fifo_b_dout_valid,
			mux_dout_valid	=>		mux_dout_valid,
			mux_dout	  	=> 		mux_dout    	  --data out to DC FIFO
		);

end architecture rtl_Symbol_Generator_Top;