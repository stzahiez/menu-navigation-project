------------------------------------------------------------------------------------------------
-- Model Name 	:	Manager
-- File Name	:	manager.vhd
-- Generated	:	27.3.2012
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description:
-- reading data from the RAM, sending a request to SDRAM through WBM , receiving symbols from SDRAM 
-- through WBM, saving it in internal FIFOs, sending it to VESA according to certain algorithm.
-- The Manager block is the controlling "brain" of the Symbol Generator block.
-- The main functions of this block:
-- 1.	Calculating the row in the RAM, from which it manages the read. Including asserting the RAM_rd_en signal for the RAM.
-- 2.	Receiving the address of the symbol in the SDRAM from the RAM, and calculating the row and column in the SDRAM according to the current video row in the display frame.
-- 3.	Managing the toggling between the two FIFOs, using a final state machine. This FSM controls in each state, to which FIFO we write and from which FIFO we read the data. This involves also asserting the control signals of both FIFOs (read and write enable).
--
--
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date		    Name									Description			
--			1.00		27.3.2012	   	Olga Liberman and Yoav Shvartz			Creation
--			1.01		12.4.2012	   	Olga Liberman							Aesthetics: header, comments, ports and signals names, synchronic fsm
--    		1.02		08.05.2012   	Olga Liberman and Yoav Shvartz    
--			1.03		16.07.2012		Olga Liberman							Generics added
--			1.04		27.10.2012		Olga Liberman							req_in_trg is from another clock domain - it is filtered and we use its rising edge only
--			1.05		28.10.2012		Olga Liberman							new signal req_in_trg_counter is added: counts the req_in_trg that arrive from VESA
--			1.06        13.02.2013     	Olga Liberman and Yoav Shvartz			in process counters_proc: changing the conditions for increasing the counters 
--			1.07		11.03.2013		Olga									I changed the value of sdram_wait_c from 55 to 100
--			1.08		12.03.2013		Olga & Yoav								integration changes with beeri external environment. 
--			1.09		19.03.2013		Olga									In process sdram_wait_proc: using counter only for backup, but counting the data valid for most of the time
--			1.10		04.06.2015		Tzahi								Adding 2 ports for horizonal and vertical location of cursor symbol, hor_location & ver_location.
--    1.11		04.06.2015		Tzahi								Adding a sdram mux signal, sdram_mux_out, used to used to assign the a & b fifo's with sdram_data or its inversion,
--                                   if the internal count of sym_row & sym_col reaches hor_location & ver_location in corespondance.
--    1.12  04.06.2015		Tzahi        Adding a symbol inversion process, sym_inversion process, which describes the behaviour of the sdram mux.
--    1.13  13.06.2015		Tzahi        Changing the sym_inversion process, such that the mux selector would be '1' if sym_row=ver_location & sym_col=(hor_location+1).

------------------------------------------------------------------------------------------------
--	Todo:
--	(1) rd_mng_fsm_proc: maybe to add "if (fifo_x_full='0') then wr_en='1'..." - to enable write to fifo only if it's not full
--	(2) to sample req_in_trg, because it comes from another clock domain
--	(3) when row_count reaches the max 480, need to reset the counter
--	(4)	
------------------------------------------------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;

entity manager is
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
	  mng_en 				: 		in std_logic; -- Trigger signal from opcode_store to start the FSM
	  sdram_data 			: 		in std_logic_vector (7 downto 0); -- This signal gets the data from sdram 
	  sdram_data_valid	:		in std_logic; -- Indicates when the data from the sdram is valid and we can store it in one of the fifos (a or b)
	  fifo_a_empty		:		in std_logic; -- Fifo a empty indication
	  fifo_b_empty		:		in std_logic; -- Fifo b empty indication
	  hor_location	    : 	 in std_logic_vector(5-1 downto 0);
	  ver_location	    : 	 in std_logic_vector(4-1 downto 0);
    ram_rd_en_out 		: 		out std_logic; -- This signal is sent to the RAM. It is an enable signal for reading from the RAM.
    ram_addr_rd 		: 		out std_logic_vector(8 downto 0); -- This signal is sent to the RAM. It indicates the row in the RAM from which we want to read.  
    fifo_a_rd_en 		: 		out std_logic; -- read enable to fifo a
	  fifo_a_wr_en 		: 		out std_logic; -- Write enable to fifo a
	  fifo_a_data_in 		: 		out std_logic_vector(7 downto 0); -- Data in to fifo a
	  fifo_b_rd_en 		: 		out std_logic; -- Read enable to fifo b
	  fifo_b_wr_en 		: 		out std_logic; -- Write enable to fifo b
	  fifo_b_data_in 		: 		out std_logic_vector(7 downto 0); -- Data in to fifo b
	  sdram_addr_rd 		: 		out std_logic_vector (23 downto 0); -- This signal is the full address in SDRAM: "00--bank(2)--row(12)--col(8)"
	  sdram_rd_en_out		:		out std_logic -- this signal is a valid signal for the sdram_addr_rd signal (for usage of WBS)
	);
end entity manager;

architecture manager_rtl of manager is
	
	---------------------------- signals ---------------------------------------------
	type state_t is (idle_st, write_a_st, read_b_st, write_a_read_b_st, read_a_write_b_st ); -- enum type for fsm states
	signal current_sm 			: 	state_t;
	signal row_count			: 	integer range 0 to ver_active_lines_g+1000; 			-- Counts current row of video frame
	signal sym_row 				: 	integer range 0 to sym_row_g;  			-- The row in terms of symbols
	signal sym_col 				: 	integer range 0 to sym_col_g+1;  			-- The col in terms of symbols
	signal sym_col_i 			: 	integer range 0 to sym_col_g+1;  			-- The col in terms of symbols
	signal inside_row 			: 	integer range 0 to inside_row_g+1;  			-- The row inside the current symbol
	signal ram_rd_en  			: 	std_logic; -- This signal is sent to the RAM. It is an enable signal for reading from the RAM.
	signal ram_rd_en_i  		: 	std_logic; -- Samapling ram_rd_en output port
	-- Signal sdram_adr 			: 	std_logic_vector (23 downto 0); --this signal is the full address in SDRAM: "00--bank(2)--row(12)--col(8)"
	signal sdram_rd_en			: 	std_logic; -- This signal is a valid signal for the sdram_addr_rd signal (for usage of WBS)
	signal sdram_wait_counter	:	integer range 0 to 150;
	signal sdram_wait_counter_tmp	:	integer range 0 to 150;
	signal sdram_wait_count_en	: 	std_logic;
	signal sdram_ready			: 	std_logic;
	
	signal req_in_trg_dev   	: std_logic; -- The derivative of req_in_trg (change from 0 to 1)
	signal req_in_trg_1 		: std_logic; -- Sampling req_in_trg input
	signal req_in_trg_2 		: std_logic; -- Sampling req_in_trg input
	signal req_in_trg_3 		: std_logic; -- Sampling req_in_trg input
	signal req_in_trg_counter	: integer := 0 ;
	signal req_in_trg_dev_active   	: std_logic; 
	
	signal req_cnt : integer range 0 to 600;
	constant req_cnt_min_c : integer := 83; -- was 80
	constant req_cnt_max_c : integer := 563; -- was 560
	signal mng_en_internal : std_logic;
	signal req_cnt_small : std_logic;
	signal req_cnt_small_d : std_logic;
	signal sdram_mux_out : std_logic_vector (7 downto 0); -- This signal gets the data from sdram 
	
	---------------------------- constatnts -------------------------------------------
	-- constant const_19_c  	: integer := 19; 
	-- constant const_31_c  	: integer := 31;
	-- constant const_14_c  	: integer := 14;
	-- constant const_16_c  	: integer := 16;
	-- constant const_480_c 	: integer := 479;
	constant sdram_wait_c	: integer := 100; 	-- num. of clock to wait from one sdram request to another ( approx. 20 clks for SDRAM to respond + 32 pixels to deliver )
	constant x	: integer := 2; 
	constant y	: integer := 2; 

	-- not sure what it is:
  -- signal counter : unsigned(9 downto 0);
  -- signal start_trigger : std_logic; -- The derivative of op_str_rd_start which connected to vsync (we check when it changes from 0 to 1) 
  -- signal flush_fifo : std_logic; --???
  -- signal din_fifo : std_logic_vector (width_g-1 downto 0);
  -- signal wr_en_fifo : std_logic;   
  -- signal rd_en_fifo : std_logic;
  -- signal dout_fifo : std_logic_vector(23 downto 0);
  -- signal dout_valid_fifo : std_logic;       
  -- signal full_fifo : std_logic;   
  -- signal empty_fifo : std_logic;
  
begin
  
	
	req_in_trg_proc: process (clk, reset_n)
	begin
		if reset_n='0' then
			req_in_trg_dev <=  '0';
			req_in_trg_1 <=  '0';			
			req_in_trg_2 <=  '0';
			req_in_trg_3 <=  '0';
			req_in_trg_counter <= 0;
			req_in_trg_dev_active <= '0';
		elsif rising_edge (clk) then
			req_in_trg_1 <= req_in_trg;			--sampling req_in_trg twice because it arrives from a different clock domain (pixel clock)
			req_in_trg_2 <= req_in_trg_1;
			req_in_trg_3 <= req_in_trg_2; 
		 	if ( (req_in_trg_2 = '1')  and  (req_in_trg_3 = '0')  ) then 
				req_in_trg_dev <= '1';
				--req_in_trg_counter <= req_in_trg_counter + 1;
				if (req_in_trg_counter < ver_active_lines_g) then
					req_in_trg_counter <= req_in_trg_counter + 1;
				else
					req_in_trg_counter <= 1;
				end if;
				req_in_trg_dev_active <= '0';
			else
				req_in_trg_dev <= '0';
			end if; 
		end if;
	end process;
	
	
	-- count num of req_in_trig in one frame
	req_count: process (clk, reset_n)
	begin
		if reset_n='0' then
			req_cnt <= 0;
			req_cnt_small <= '0';
			req_cnt_small_d <= '0';
			mng_en_internal <= '0';
		elsif rising_edge (clk) then
			
			if (mng_en = '1') then
				req_cnt <= 1; -- 17.03.2013 olga
			elsif ( (req_in_trg_dev = '1') and (req_cnt > 0) and (req_cnt < req_cnt_max_c) ) then
				req_cnt <= req_cnt + 1;
			-- elsif (req_cnt > req_cnt_max_c) then -- 17.03.2013 olga
				-- req_cnt <= 0; -- 17.03.2013 olga
			end if;
			
			if (req_cnt < req_cnt_min_c) then
				req_cnt_small <= '1';
			else
				req_cnt_small <= '0';
			end if;
			req_cnt_small_d <= req_cnt_small;
			
			if ( (req_cnt_small_d='1') and (req_cnt_small='0') ) then
				mng_en_internal <= '1';
			else
				mng_en_internal <= '0';
			end if;
			
		end if;
	end process;
	
	
	
	---------------------------------------------------------------------------------
	----------------------------- Process rd_mng_fsm_proc	-------------------------
	---------------------------------------------------------------------------------
	-- The process is the fsm for toggling read and write using fifo a and fifo b
	---------------------------------------------------------------------------------
	rd_mng_fsm_proc: process(clk, reset_n)
	begin
	
		if (reset_n='0') then
			current_sm <= idle_st;
			-- reset output signals
			fifo_a_rd_en <='0';
			fifo_a_wr_en <='0';
			fifo_a_data_in <= (others =>'0');
			fifo_b_rd_en <='0';
			fifo_b_wr_en <='0';
			fifo_b_data_in <= (others =>'0');
					
		elsif rising_edge(clk) then
			case current_sm is
			
				-- idle state
				when idle_st =>
					fifo_a_rd_en <='0';
					fifo_a_wr_en <='0';
					fifo_a_data_in <= (others =>'0');
					fifo_b_rd_en <='0';
					fifo_b_wr_en <='0';
					fifo_b_data_in <= (others =>'0');
					-- -- if (mng_en='1') then -- 12.03.2013
					if (mng_en_internal='1') then -- 12.03.2013
						current_sm <= write_a_st;
					end if;
				
				when write_a_st =>
					fifo_a_rd_en <='0';
					if ( sdram_data_valid='1' ) then
						fifo_a_data_in <= sdram_mux_out;
						fifo_a_wr_en <='1';
					else
						fifo_a_data_in <= (others =>'0');
						fifo_a_wr_en <='0';
					end if;
					fifo_b_rd_en <='0';
					fifo_b_wr_en <='0';
					fifo_b_data_in <= (others =>'0');	
					if (req_in_trg_dev='1') then
						current_sm <= read_a_write_b_st;
					end if;
				
				when read_a_write_b_st =>
					if (fifo_a_empty='0') then
						fifo_a_rd_en <='1';
					else
						fifo_a_rd_en <='0';
					end if;
					fifo_a_wr_en <='0';
					fifo_a_data_in <= (others =>'0');
					fifo_b_rd_en <='0';
					if ( sdram_data_valid='1' ) then
						fifo_b_data_in <= sdram_mux_out;	
						fifo_b_wr_en <='1';
					else
						fifo_b_data_in <= (others =>'0');
						fifo_b_wr_en <='0';
					end if;
					if ((req_in_trg_dev='1')and(row_count /= ver_active_lines_g)) then 
						current_sm <= write_a_read_b_st;
					elsif  ((req_in_trg_dev='1')and(row_count = ver_active_lines_g)) then 
						current_sm <= read_b_st;
					end if;
					
				when write_a_read_b_st =>
					fifo_a_rd_en <='0';
					if ( sdram_data_valid='1' ) then
						fifo_a_data_in <= sdram_mux_out;
						fifo_a_wr_en <='1';
					else
						fifo_a_data_in <= (others =>'0');
						fifo_a_wr_en <='0';
					end if;
					if (fifo_b_empty='0') then
						fifo_b_rd_en <='1';
					else
						fifo_b_rd_en <='0';
					end if;
					fifo_b_wr_en <='0';
					fifo_b_data_in <= (others =>'0');	
					if (req_in_trg_dev='1') then
						current_sm <= read_a_write_b_st;
					end if;
					
				when read_b_st =>
					fifo_a_rd_en <='0';
					fifo_a_wr_en <='0';
					fifo_a_data_in <= (others =>'0');	
					if (fifo_b_empty='0') then
						fifo_b_rd_en <='1';
					else
						current_sm <= idle_st;
					end if;
					fifo_b_wr_en <='0';
					fifo_b_data_in <= (others =>'0');	
					
				when others => 
					current_sm <= idle_st;
					fifo_a_rd_en <='0';
					fifo_a_wr_en <='0';
					fifo_a_data_in <= (others =>'0');
					fifo_b_rd_en <='0';
					fifo_b_wr_en <='0';
					fifo_b_data_in <= (others =>'0');
					
			end case;
		end if;
	end process rd_mng_fsm_proc;
	
	-- implement a wait SDRAM counter, according to the sdram_wait_c constant
	-- -- -- sdram_wait_proc: process(clk, reset_n)
    -- -- -- begin
		-- -- -- if (reset_n='0') then
			-- -- -- sdram_wait_counter <= 0;
		-- -- -- elsif rising_edge (clk) then
			-- -- -- if ( (sdram_rd_en = '1') and (sdram_wait_counter = 0) ) then
				-- -- -- sdram_wait_counter <= sdram_wait_counter + 1;
			-- -- -- elsif ( (sdram_wait_counter > 0) and (sdram_wait_counter < sdram_wait_c) ) then
				-- -- -- sdram_wait_counter <= sdram_wait_counter + 1;
			-- -- -- else
				-- -- -- sdram_wait_counter <= 0;
			-- -- -- end if;
		-- -- -- end if;
	-- -- -- end process sdram_wait_proc;
	sdram_wait_proc: process(clk, reset_n)
    begin
		if (reset_n='0') then
			sdram_wait_count_en <= '0';
			sdram_wait_counter <= 0;
			sdram_wait_counter_tmp <= 0;
			sdram_ready <= '0';
		elsif rising_edge (clk) then
			if (sdram_rd_en = '1') then
				sdram_wait_count_en <= '1';
				sdram_wait_counter <= 0;
				sdram_wait_counter_tmp <= 0;
				sdram_ready <= '0';
			elsif (sdram_wait_count_en = '1') then
				sdram_wait_counter_tmp <= sdram_wait_counter_tmp + 1;
				if (sdram_wait_counter = 32)or(sdram_wait_counter_tmp = sdram_wait_c) then
					sdram_ready <= '1';
					sdram_wait_count_en <= '0';
					sdram_wait_counter <= 0;
				elsif (sdram_data_valid='1') then
					sdram_wait_counter <= sdram_wait_counter + 1;
				end if;
			elsif (sdram_ready='1') then
				sdram_ready <= '0';
			end if;
		end if;
	end process sdram_wait_proc;
	
	---------------------------------------------------------------------------------
	----------------------------- Process counters_proc	-------------------------
	---------------------------------------------------------------------------------
	-- implementing the counters of row and column
	---------------------------------------------------------------------------------
	counters_proc: process(clk, reset_n)
    begin
		if (reset_n='0') then
			sym_row <= 0; -- 0
			sym_col <= 0; -- 0
			sym_col_i <= 0;
			inside_row <= 0;
			row_count <= 0;
		elsif rising_edge (clk) then
			if (current_sm = read_b_st) then
				sym_row<= 0;
				sym_col <= 0;
				sym_col_i <= 0;
				inside_row <= 0;
				row_count <= 0;
			else	
				-- if ( ((mng_en='1') or (sdram_wait_counter = sdram_wait_c)) and ( sym_col < sym_col_g ) ) then --12.03.2013
				-- -- if ( ((mng_en_internal='1' and req_cnt /= req_cnt_min_c) or (sdram_wait_counter = sdram_wait_c)) and ( sym_col < sym_col_g ) ) then --12.03.2013
				if ( ((mng_en_internal='1' and req_cnt /= req_cnt_min_c) or (sdram_ready = '1')) and ( sym_col < sym_col_g ) ) then -- 19.03.2013
					sym_col <= sym_col + 1;
				elsif ( ( (req_in_trg_dev = '1') or (mng_en='1') ) and (req_cnt < req_cnt_max_c) ) then 
					sym_col <= 1;
				end if;
				
				-- if ( (current_sm = idle_st) and (mng_en='1')) or ( (current_sm /= idle_st) and (req_in_trg_dev = '1') ) then --12.03.2013
				if ( (current_sm = idle_st) and (mng_en_internal='1')) or ( (current_sm /= idle_st) and (req_in_trg_dev = '1') ) then --12.03.2013
				--if ( ((req_in_trg_dev = '1') or (mng_en='1'))) then --  means calculating address in the RAM and a new request to the sdram
					--sym_col <= sym_col + 1;
					--if ( sym_col = sym_col_g ) then -- maybe 20?
						--sym_col <= 0;
						inside_row <= inside_row +1;
						row_count <= row_count +1;
						if ( inside_row = inside_row_g ) then -- maybe 32?
							inside_row <= 1;
							sym_row <= sym_row + 1;
							if ( sym_row = sym_row_g-1 ) then -- maybe 15?
								sym_row <= 1;
							end if;
						end if;
					--end if;
				end if;	
				sym_col_i <= sym_col; -- sampling the sym_col signal
			end if;	
		end if;
	end process counters_proc;
	
	sdram_rd_en_out <= sdram_rd_en;
	
---------------------------------------------------------------------------------
	----------------------------- Process sym_inversion-------------------------
	---------------------------------------------------------------------------------
	-- invert the symbol if sym_row=hor_location and sym_col=ver_location
	---------------------------------------------------------------------------------
	sym_inversion_proc: process (clk, sym_row, sym_col)
	begin
		if rising_edge (clk) then
			if ((sym_row) = to_integer(unsigned(ver_location)) and (sym_col) = (to_integer(unsigned(hor_location))+1)) then 
				sdram_mux_out <= not(sdram_data);
			else 
				sdram_mux_out <= sdram_data;
			end if;	
		end if;
	end process sym_inversion_proc;
	---------------------------------------------------------------------------------
	----------------------------- Process ram_adr_proc	-------------------------
	---------------------------------------------------------------------------------
	-- calculate the address in RAM, and read from it
	---------------------------------------------------------------------------------
	ram_adr_proc: process (clk, reset_n)
	begin
		if (reset_n='0') then
			ram_addr_rd <= (others => '0');
			ram_rd_en <= '0'; 
			ram_rd_en_i <= '0'; 
			sdram_addr_rd <= (others => '0');
			sdram_rd_en <= '0';
		elsif rising_edge (clk) then
			-- change of the symbol block
			if (sym_col /= sym_col_i) then
				ram_addr_rd <= std_logic_vector(to_unsigned(20*sym_row + (sym_col-1),ram_addr_rd'length));-- + std_logic_vector(to_unsigned(),9);-- 20*x + y
				ram_rd_en <='1';
				sdram_rd_en <= '0';
				sdram_addr_rd <= (others => '0');
			-- receiving data from RAM
			elsif ((ram_rd_en_i = '1') and (ram_rd_en = '0')) then
				--wbm_start
				sdram_rd_en <= '1';
				-- 0 <= inside_row < 16
				if (inside_row=0) then																	-- 20.03.2013 olga
					sdram_addr_rd <= "00"&ram_data_out&'0'&( std_logic_vector(to_unsigned(0 , 8)) );	-- 20.03.2013 olga
				elsif ( (inside_row-1) < sdram_burst_g ) then											-- 20.03.2013 olga
				-- -- if ( (inside_row-1) < sdram_burst_g ) then
					sdram_addr_rd <= "00"&ram_data_out&'0'&( std_logic_vector(to_unsigned(sdram_burst_g*(inside_row-1) , 8)) ); -- where to put the "00": LSB (end) or MSB (start) ???
				-- 16 <= inside_row < 32
				else
					sdram_addr_rd <= "00"&ram_data_out&'1'&( std_logic_vector(to_unsigned(sdram_burst_g*((inside_row-1)-sdram_burst_g) , 8)) );
				end if;
			else
				ram_addr_rd <= (others => '0');
				ram_rd_en <= '0'; 
				sdram_rd_en <= '0';
				sdram_addr_rd <= (others => '0');
			end if;
			ram_rd_en_i <= ram_rd_en;
		end if;	
	end process ram_adr_proc;
    
	ram_rd_en_out <= ram_rd_en;
  
end architecture manager_rtl;
  