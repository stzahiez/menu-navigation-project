------------------------------------------------------------------------------------------------
-- Model Name 	:	Opcode Store
-- File Name	:	opcode_store.vhd
-- Generated	:	18.3.2012
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description:
-- The main purpose of the Opcode Store is to store commands from the Opcode Unite block.
-- The reason we want store the commands before transferring them to the Main RAM is because
-- we don't want to override the current state of the display in the RAM, in case it is the middle of the frame.
-- We write to the RAM only at start of the frame – when VSYNC of the VESA is active.
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date		Name					Description			
--			1.00		12.4.2012	Yoav Shvartz		    Repairs 
--			2.00		22.08.2012	Olga Liberman			Addition of "vsync_out" port out to the File Log model
--			2.01		27.10.2012	Olga Liberman			start_trigger signal is changed to find rising edge of vsync (instead of falling edge, like before)
--			2.02		02.11.2012	Olga Liberman			fixing the bug with opcode packet that arrives during rising edge of vsync:
--															the solution is to work with fifo_used signal, instead of op_cnt
--			2.03		16.02.2013	Olga & Yoav				the depth of the fifo was increased from 300 to 400
--
------------------------------------------------------------------------------------------------
--	Todo:
--			(1) define what is the optimal fifo depth. 
------------------------------------------------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all ;

entity opcode_store is
  port (
    clk : in std_logic;	 								-- clock in domain 133Mhz.
    reset_n : in std_logic; 							-- asynchronous reset. 
    op_cnt : in std_logic_vector(9 downto 0);   		-- number of total changes X 3: 1 change (24 bits) = add/remove 1 symbol ( 24 bits are being sent in 3 packs of 8 bits)
    op_str_valid : in std_logic; 						-- connected from opcode_unite block, opu_wr_en signal
    op_str_data_in : in std_logic_vector(23 downto 0); 	-- connected from opcode_unite block, opu_data_out signal
    op_str_rd_start : in std_logic; 					-- connected from VESA controller, vsync signal
    ram_addr_wr : out std_logic_vector(8 downto 0);  	-- ram's address to be written into. 
    ram_wr_en : out std_logic;							-- ram write enable
    ram_data : out std_logic_vector(12 downto 0);		-- data sent to ram
    mng_en : out std_logic;								-- activating Read_Manager 
    op_str_empty : out std_logic;						-- FIFO is empty (debug)
    op_str_full : out std_logic;						-- FIFO is full (debug)
    op_str_used : out std_logic_vector(9 downto 0);		-- current number of elements in FIFO (debug)
	vsync_out	:	out std_logic
  );
end entity opcode_store;

architecture opcode_store_rtl of opcode_store is
  
  component general_fifo
	generic(	 
		reset_polarity_g	: std_logic	:= '0';	-- Reset Polarity
		width_g				: positive	:= 24; 	-- Width of data
		depth_g 			: positive	:= 300;	-- Maximum elements in FIFO
		log_depth_g			: natural	:= 9;	-- Logarithm of depth_g (Number of bits to represent depth_g. 2^9=512 > 300)
		almost_full_g		: positive	:= 8; 	-- Rise almost full flag at this number of elements in FIFO  , question - do we nedd this?
		almost_empty_g		: positive	:= 1 	-- Rise almost empty flag at this number of elements in FIFO , question - do we nedd this?
		);
	port(
		 clk 		: in 	std_logic;									-- Clock
		 rst 		: in 	std_logic;                                  -- Reset
		 din 		: in 	std_logic_vector (width_g-1 downto 0);      -- Input Data
		 wr_en 		: in 	std_logic;                                  -- Write Enable
		 rd_en 		: in 	std_logic;                                  -- Read Enable (request for data)
		 flush		: in	std_logic;									-- Flush data
		 dout 		: out 	std_logic_vector (width_g-1 downto 0);	    -- Output Data
		 dout_valid	: out 	std_logic;                                  -- Output data is valid
		 afull  	: out 	std_logic;                                  -- FIFO is almost full
		 full 		: out 	std_logic;	                                -- FIFO is full
		 aempty 	: out 	std_logic;                                  -- FIFO is almost empty
		 empty 		: out 	std_logic;                                  -- FIFO is empty
		 used 		: out 	std_logic_vector (log_depth_g  downto 0) 	-- Current number of elements is FIFO. Note the range. In case depth_g is 2^x, then the extra bit will be used
	     );
	end component general_fifo;
  
  signal op_cnt_i : std_logic_vector (9 downto 0);			-- internal register to sample the op_cnt input
  signal counter : std_logic_vector (9 downto 0);			-- counts number of changes in the current frame
  signal start_trigger   : std_logic; 						-- The derivative of op_str_rd_start which connected to vsync (we check when it changes from 0 to 1)  
  signal start_trigger_1 : std_logic; 						-- The derivative of op_str_rd_start which connected to vsync (we check when it changes from 0 to 1) 
  signal start_trigger_2 : std_logic; 						-- The derivative of op_str_rd_start which connected to vsync (we check when it changes from 0 to 1) 
  signal start_trigger_3 : std_logic; 						-- The derivative of op_str_rd_start which connected to vsync (we check when it changes from 0 to 1) 
  signal flush_fifo : std_logic; 							-- FIFO flush data
  signal din_fifo : std_logic_vector ( 23 downto 0 );		-- data to FIFO sent from opcode_unite
  signal wr_en_fifo : std_logic;   							-- write enable FIFO	
  signal rd_en_fifo : std_logic;							-- read  enable FIFO
  signal dout_fifo : std_logic_vector( 23 downto 0);		-- data sent to RAM300
  signal dout_valid_fifo : std_logic;       				-- data valid to RAM300
  signal fifo_full : std_logic;   							-- FIFO is full
  signal fifo_empty : std_logic;							-- FIFO is empty
  signal rd_en_fifo_i : std_logic;							-- sampling of rd_en_fifo
  signal rd_mng_1 : std_logic; 								-- internal signal to create a delay of 2 clocks in mng_en
  signal rd_mng_2 : std_logic; 								-- internal signal to create a delay of 2 clocks in mng_en
  signal fifo_used : std_logic_vector(9 downto 0);			-- sample fifo_used signal at the begining of each vsync
  signal fifo_used_s : std_logic_vector(9 downto 0);		-- sample fifo_used signal at the begining of each vsync

  
  -- constant three_c : std_logic_vector ( 9 downto 0) := ("0000000011") ;
  
  
begin
  
  general_fifo_inst :  general_fifo 
    generic map (
		  reset_polarity_g	=> '0',		-- Reset Polarity
		  width_g			=> 24, 				-- Width of data
		  depth_g 			=> 400,					-- Maximum elements in FIFO -------------------------------------------------16.02.2013
		  log_depth_g		=> 9,			-- Logarithm of depth_g (Number of bits to represent depth_g. 2^9=512 > 300)
		  almost_full_g		=> 8, 				-- Rise almost full flag at this number of elements in FIFO
		  almost_empty_g	=> 1 			-- Rise almost empty flag at this number of elements in FIFO
           )
		port map
		(
			clk 				=> 		clk	,						-- Clock
			rst 				=> 		reset_n,	 				-- Reset
			din 				=> 		din_fifo,		   			-- Input Data
			wr_en 				=> 		wr_en_fifo,					-- Write Enable
			rd_en 				=> 		rd_en_fifo, 				-- Read Enable (request for data)
			flush				=> 		flush_fifo,					-- Flush data
			dout 				=> 		dout_fifo, 					-- Output Data
			dout_valid			=> 		dout_valid_fifo,  			-- Output data is valid
			afull 				=> 		open,						-- FIFO is almost full
			full 				=> 		fifo_full,					-- FIFO is full
			aempty 				=> 		open, 						-- FIFO is almost empty
			empty				=>		fifo_empty,					-- FIFO is empty
			used				=>  	fifo_used					-- Current number of elements in FIFO. Note the range. In case depth_g is 2^x, then the extra bit will be used
		);
	
	------------------------------------------------------
	--checking when vsync is active (change from 0 to 1)-- 
	-- start_trigger signal is active for 1 clock
	------------------------------------------------------
	vsync_active_proc: process (clk, reset_n)
	begin
		if reset_n='0' then
			start_trigger <=  '0';
			start_trigger_1 <=  '0';			
			start_trigger_2 <=  '0';
			start_trigger_3 <=  '0';
		elsif rising_edge (clk) then
			start_trigger_1 <= op_str_rd_start;			--sampling start_trigger twice because start_trigger (VSYNC) operates at 40MHz and the clk 100MHz  
			start_trigger_2 <= start_trigger_1;
			start_trigger_3 <= start_trigger_2; 
		 	if ( (start_trigger_2 = '1')  and  (start_trigger_3 = '0')  ) then -- olga
				start_trigger <= '1';
			else
				start_trigger <= '0';
			end if; 
		end if;
	end process vsync_active_proc;
	
	vsync_out <= start_trigger;

	
	------------------------
	--writing data to fifo--
	------------------------
	write_to_fifo_proc: process(clk, reset_n)
    begin
		if reset_n='0' then
		   din_fifo <= (others => '0');
			 wr_en_fifo <= '0';
		elsif rising_edge (clk) then
		  din_fifo <= op_str_data_in;
			if (op_str_valid = '1') and (fifo_full = '0') then
				wr_en_fifo <= '1';
			else
				wr_en_fifo <= '0';
			end if;
		end if;		
	end process write_to_fifo_proc;
	
	fifo_status_proc:
	op_str_full <= fifo_full;
	op_str_empty <= fifo_empty;
	
	-- sample op_cnt only when finished to read the current opcodes in fifo
	op_cnt_proc: process (clk,reset_n)
	begin
		if reset_n='0' then
			op_cnt_i <= (others => '0');
		elsif rising_edge (clk) then
			--if (counter = op_cnt_i) then
			if (fifo_empty = '1') then
				op_cnt_i <= op_cnt;
			end if;
		end if;
	end process;
	
	op_str_used <= fifo_used;
	----------------------------------------------------------------------------------------------
	--reading data from fifo to ram:
	--first_n bit: indicating whether to remove ('0') or add ('1') the symbol 
	-- address = x*20 + y 
	--breaking the opcode to its different fields :  0/1 |  address of symbol in SDRAM | X | Y
  --need to use start_trigger
	-----------------------------------------------------------------------------------------------
	read_fifo_proc: process (clk, reset_n)
	begin
		if reset_n='0' then
			rd_en_fifo <= '0';
			rd_en_fifo_i <= '0';
			counter <= (others => '0');
			mng_en <= '0';
			rd_mng_1 <= '0';
			rd_mng_2 <= '0';
			flush_fifo <= '1';
			fifo_used_s <= (others => '0');
		elsif rising_edge (clk) then
			flush_fifo <= '0';
			if ( (start_trigger = '1') and (fifo_empty = '1') ) then -- new frame starts, but the display isn't changed
				rd_mng_1 <= '1';
			elsif ( (start_trigger = '1') and (fifo_empty = '0') ) then
				rd_en_fifo <='1';
				counter <= counter + 1; --counter <= counter + three_c;
				fifo_used_s <= fifo_used;
			--elsif ( (counter >0) and (counter <= op_cnt_i) and (fifo_empty = '0') ) then
			elsif ( (counter >0) and (counter <= fifo_used_s) and (fifo_empty = '0') ) then
				--if (counter = op_cnt_i) then
				if (counter = fifo_used_s) then
					rd_en_fifo <='0';
					counter <= (others => '0');
					rd_mng_1 <= '1';
				else
					rd_en_fifo <='1';
					counter <= counter + 1; --counter <= counter + three_c;
				end if;
			else
				rd_en_fifo <= '0';
				rd_mng_1 <= '0';	
			end if;
			
			rd_en_fifo_i <= rd_en_fifo;
			rd_mng_2 <= rd_mng_1;
			mng_en <= rd_mng_2;
		end if;
		
	end process read_fifo_proc;
	
	ram_write_proc: process (clk, reset_n)
	begin
		if reset_n='0' then
			ram_wr_en <= '0';
			ram_addr_wr <= (others => '1'); -- illegal address in RAM for debug purposes
			ram_data <= (others => '0');
		elsif rising_edge (clk) then
			
			if (rd_en_fifo_i='1') then
			  ram_wr_en <= '1';
				ram_addr_wr <= std_logic_vector( to_unsigned(20*to_integer(unsigned( dout_fifo(8 downto 5))) + to_integer(unsigned( dout_fifo(4 downto 0))),9) );
				-- bit 22 is the type bit: add or remove the symbol
				if ( dout_fifo(22)='0' ) then 
					ram_data <= (others => '0');
				else 
					ram_data <= ( dout_fifo(21 downto 9) );
				end if;
			else
			  ram_wr_en <= '0';
				ram_addr_wr <= (others => '1'); -- illegal address in RAM for debug purposes
				ram_data <= (others => '0');
			end if;
			
		end if;
	end process ram_write_proc;
    
  
end architecture opcode_store_rtl;  