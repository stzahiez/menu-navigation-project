------------------------------------------------------------------------------------------------
-- Model Name 	:	SG_WBM_IF
-- File Name	:	SG_WBM_IF.vhd
-- Generated	:	09.03.2013
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description:
-- This block is the interface of the Symbol Generator with WBM.
-- When SDRAM read requested, the block initializes write to debug address register in the mem_mng_top,
-- and then starts the read transaction on the WBM interface. The result is a read dransaction in debug
-- mode from the addresswhich was written in the appropriate register previousely.
--
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date			Name				Description			
--			1.00		09.03.2013		Olga Liberman		Creation - use tmp address for SDRAM read
--			1.01		17.03.2013		Olga Liberman		Use real SDRAM address for read, and not tmp
--
------------------------------------------------------------------------------------------------
--	Todo:
--	(1) 
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

entity SG_WBM_IF is
	generic(
		read_length_g		:	integer range 1 to 1024 := 32 			-- read length equals to num of pixels in 1 row of symbol
	);
	port (
		-- clock and reset
		clk					:	in std_logic; 							-- main clock
		reset_n				:	in std_logic; 							-- asynchronous reset
		-- vsync
		vsync				:	in std_logic;
		-- Wishbone Master to Memory Management block
		wbm_dat_i			:	in std_logic_vector (7 downto 0);		--Data in (8 bits)
		wbm_stall_i			:	in std_logic;							--Slave is not ready to receive new data 
		wbm_ack_i			:	in std_logic;							--Input data has been successfuly acknowledged
		wbm_err_i			:	in std_logic;							--Error: Address should be incremental, but receives address was not as expected (0 --> 1023)
		wbm_adr_o			:	out std_logic_vector (9 downto 0);		--Address
		wbm_tga_o			:	out std_logic_vector (9 downto 0);		--Address Tag : Read burst length-1 (0 represents 1 byte, 3FF represents 1023 bytes)
		wbm_cyc_o			:	out std_logic;							--Cycle command from WBM
		wbm_stb_o			:	out std_logic;							--Strobe command from WBM
		wbm_tgc_o			:	out std_logic;							--Cycle Tag
		wbm_dat_o			:	out std_logic_vector (7 downto 0);		--Data Out for writing to registers (8 bits) 
		wbm_we_o			:	out std_logic;							--Write Enable	
		-- SDRAM read address from SG_Top
		sdram_addr_rd 		: 	in std_logic_vector (23 downto 0); 		--SDRAM address: "00--bank(2)--row(12)--col(8)"
		sdram_rd_en			:	in std_logic; 							--SDRAM address is valid
		-- SDRAM data to SG_Top
		sdram_data 			:	out std_logic_vector (7 downto 0); 		--SDRAM data
		sdram_data_valid	:	out std_logic 							--SDRAM data valid
	);
end entity SG_WBM_IF;

architecture rtl_SG_WBM_IF of SG_WBM_IF is
	
	------------------------------	Constants	--------------------------------
	constant dbg_reg_adr_c	:	std_logic_vector(9 downto 0) := "0000000010";
	constant dbg_reg_tga_c	:	std_logic_vector(9 downto 0) := "0000000010";
	constant tmp_sdram_adr	:	std_logic_vector(23 downto 0) := x"000201";
	
	constant dbg_type_adr_c	:	std_logic_vector(9 downto 0) := "0000001101"; -- D
	constant dbg_type_tga_c	:	std_logic_vector(9 downto 0) := "0000000000";
	constant dbg_type_dat_c	:	std_logic_vector(7 downto 0) := "00000001";
	constant undbg_type_dat_c	:	std_logic_vector(7 downto 0) := "00000000";
	
	------------------------------	Types	------------------------------------
	type wbm_states is (
							wbm_idle_st,	--Idle - wait for line trigger from VESA generator
							wbm_dbg_adr_st,--Write to Debug Address Reg the address for read
							wbm_dbg_adr_end_cyc_st,
							wbm_dbg_type_st,
							wbm_dbg_type_end_cyc_st,
							wbm_init_rx_st,	--Initilize read burst from SDRAM
							wbm_rx_st,		--Receive data from SDRAM and count pixels
							end_cyc_st,		--Wait for end of cycle, to negate CYC_O
							wbm_undbg_type_st,
							wbm_undbg_type_end_cyc_st,
							restart_st	--Restart from start of SDRAM
						);
	
	------------------------------	Signals	------------------------------------
	--FSM
	signal cur_st			:	wbm_states;							--FSM	
	signal ack_cnt		:	std_logic_vector (10 downto 0);		--Number of received ACK / ERR (0 to 1024)
	signal err_i_status		:	std_logic;
	signal cyc_internal		:	std_logic;							--Internal wishbone cycle
	signal stb_internal		:	std_logic;							--Internal wishbone strobe
	signal we_internal		:	std_logic;							--Internal wishbone WE
	signal adr_internal		:	std_logic_vector (9 downto 0);		--WBM Address to slave 
	signal dbg_adr 			: 	std_logic_vector (23 downto 0);		--
	signal dbg_cnt			:	natural;
	
	--constant vsync_cnt_c 	: integer := 4095; -- synth
	constant vsync_cnt_c 	: integer := 3; -- simulation
	
	signal vsync_cnt 		: integer range 0 to vsync_cnt_c;
	signal vsync_en 		: std_logic;
	
begin
	
		------------------------------------------
	-- 12.03.2013
	delay_vsync_proc: process (clk, reset_n)
	begin
		if reset_n='0' then
			vsync_cnt <= 0;
			vsync_en <= '0';
		elsif rising_edge (clk) then
			if (vsync_cnt > (vsync_cnt_c-1) ) then
				vsync_en <= '1';
				vsync_cnt <= vsync_cnt;
			elsif (vsync = '1') then
				vsync_cnt <= vsync_cnt + 1;
				vsync_en <= '0';
			end if;
		end if;
	end process delay_vsync_proc;
	
	------------------------------------------
	
	
	--WBM_ADR_O
	wbm_adr_proc:
	wbm_adr_o	<=	adr_internal;
	
	--WBM_CYC_O
	wbm_cyc_proc:
	wbm_cyc_o	<=	cyc_internal and vsync_en;
	
	--WBM_STB_O
	wbm_stb_o_proc:
	wbm_stb_o	<= 	stb_internal and vsync_en;
	
	--WBM_WE_O
	wbm_we_proc:
	wbm_we_o	<=	we_internal;
	
	--SDRAM data valid
	sdram_data_valid_proc:
	sdram_data_valid	<=	cyc_internal and vsync_en and wbm_ack_i and not(we_internal);
	
	--SDRAM data
	sdram_data_proc:
	sdram_data	<=	wbm_dat_i when ( (cyc_internal='1') and (vsync_en='1') and (wbm_ack_i='1') and (we_internal='0') )
					else (others=>'0');
					

	----------------------------------------------------------------------------------------
	----------------------------		fsm_proc Process			------------------------
	----------------------------------------------------------------------------------------
	-- This is the main FSM Process
	----------------------------------------------------------------------------------------
	fsm_proc: process (clk, reset_n)
	variable cnt : integer := 0;
	begin
		if (reset_n='0') then
			cyc_internal<=	'0';
			stb_internal	<=	'0';
			wbm_tgc_o	<=	'0';
			cur_st		<=	wbm_idle_st;
			adr_internal <= (others => '0');
			wbm_tga_o <= (others => '0');
			wbm_dat_o <= (others => '0');
			dbg_adr <= (others => '0');
			we_internal <= '0';
			dbg_cnt <= 0;
			cnt := 0;
		elsif rising_edge (clk) then
			case cur_st is
				when wbm_idle_st =>
					cyc_internal<=	'0';
					stb_internal	<=	'0';
					wbm_tgc_o	<=	'0';
					we_internal <= '0';
					cnt := 0;
					dbg_adr <= (others => '0');
					if (sdram_rd_en='1') then
						dbg_adr <= sdram_addr_rd; -- latch the debug address
						-- -- -- dbg_adr <= tmp_sdram_adr; -- latch the debug address
						--wbm_dat_o <= sdram_addr_rd(8*cnt+7 downto 8*cnt);
						--wbm_dat_o <= tmp_sdram_adr(8*cnt+7 downto 8*cnt);
						adr_internal <= dbg_reg_adr_c;
						cur_st <= wbm_dbg_adr_st;
					end if;
				
				when wbm_dbg_adr_st =>
					cyc_internal<=	'1';
					stb_internal	<=	'1';
					wbm_tgc_o	<=	'1';
					wbm_tga_o <= dbg_reg_tga_c;
					we_internal <= '1';
					wbm_dat_o <= dbg_adr(8*cnt+7 downto 8*cnt);
					
					if (sdram_rd_en='1') then
						cyc_internal <= '0';
						stb_internal	<=	'0';
						cnt := 0;
						dbg_adr <= sdram_addr_rd; -- latch the debug address
						-- -- -- dbg_adr <= tmp_sdram_adr; -- latch the debug address
						adr_internal <= dbg_reg_adr_c;
						cur_st <= wbm_dbg_adr_st;
					elsif (wbm_stall_i='0') then
						if (cnt < 2) then
							cnt := cnt + 1;
							wbm_dat_o <= dbg_adr(8*cnt+7 downto 8*cnt);
							adr_internal <= adr_internal + 1;
							stb_internal <=	'1';

						else
							stb_internal	<=	'0';
							cur_st <= wbm_dbg_adr_end_cyc_st;
						end if;
					end if;
					
				
				when wbm_dbg_adr_end_cyc_st =>
					if (sdram_rd_en='1') then
						cyc_internal <= '0';
						stb_internal	<=	'0';
						cnt := 0;
						dbg_adr <= sdram_addr_rd; -- latch the debug address
						-- -- -- dbg_adr <= tmp_sdram_adr; -- latch the debug address
						adr_internal <= dbg_reg_adr_c;
						cur_st <= wbm_dbg_adr_st;
					elsif (err_i_status = '1') then					--An error has occured
						cyc_internal <= '0';
						cur_st <= wbm_idle_st;
					--elsif (adr_internal - dbg_reg_adr_c - '1' = ack_cnt - '1') then --Number of WBM_STB_O = WBM_ACK_I + WBM_ERR_I
					elsif ( CONV_INTEGER(dbg_reg_tga_c) = ack_cnt ) then --Number of WBM_STB_O = WBM_ACK_I
						cyc_internal <= '0';
						cur_st <= wbm_dbg_type_st;
					else
						cur_st <=	cur_st;
						cyc_internal <= '1';
					end if;
				
				when wbm_dbg_type_st =>
					cyc_internal<=	'1';
					stb_internal	<=	'1';
					wbm_tgc_o	<=	'1';
					wbm_tga_o <= dbg_type_tga_c;
					we_internal <= '1';
					adr_internal <= dbg_type_adr_c;
					wbm_dat_o <= dbg_type_dat_c;
					if (sdram_rd_en='1') then
						cyc_internal <= '0';
						stb_internal	<=	'0';
						cnt := 0;
						dbg_adr <= sdram_addr_rd; -- latch the debug address
						-- -- -- dbg_adr <= tmp_sdram_adr; -- latch the debug address
						adr_internal <= dbg_reg_adr_c;
						cur_st <= wbm_dbg_adr_st;
					elsif (wbm_stall_i='0') then
						stb_internal <=	'0';
						cur_st <= wbm_dbg_type_end_cyc_st;
					end if;
				
				when wbm_dbg_type_end_cyc_st =>
					if (sdram_rd_en='1') then
						cyc_internal <= '0';
						stb_internal	<=	'0';
						cnt := 0;
						dbg_adr <= sdram_addr_rd; -- latch the debug address
						-- -- -- dbg_adr <= tmp_sdram_adr; -- latch the debug address
						adr_internal <= dbg_reg_adr_c;
						cur_st <= wbm_dbg_adr_st;
					elsif (err_i_status = '1') then --An error has occured
						cyc_internal <= '0';
						cur_st <= wbm_idle_st;
					elsif (wbm_ack_i = '1') then 
						cyc_internal <= '0';
						cur_st <= wbm_init_rx_st;
					else
						cur_st <=	cur_st;
						cyc_internal <= '1';
					end if;
				
				when wbm_init_rx_st =>
					cyc_internal<=	'1';
					stb_internal	<=	'1';
					we_internal <= '0';
					wbm_tga_o <= conv_std_logic_vector(read_length_g, 10);
					wbm_tgc_o	<=	'0';
					cnt := 0;
					adr_internal <= (others => '0');
					cur_st	<=	wbm_rx_st;
				
				when wbm_rx_st	=>
					cyc_internal<=	'1';
					if (sdram_rd_en='1') then
						cyc_internal <= '0';
						stb_internal	<=	'0';
						cnt := 0;
						dbg_adr <= sdram_addr_rd; -- latch the debug address
						-- -- -- dbg_adr <= tmp_sdram_adr; -- latch the debug address
						adr_internal <= dbg_reg_adr_c;
						cur_st <= wbm_dbg_adr_st;
					elsif (err_i_status='1') then
						cyc_internal<= '0';
						stb_internal <=	'0';
						cur_st <= wbm_idle_st;
					elsif (wbm_stall_i='0') then
						--if (wbm_ack_i = '1') then
						cnt := cnt + 1;
						adr_internal <= adr_internal + 1;
						if (cnt = read_length_g) then
							stb_internal <=	'0';
							cur_st <= end_cyc_st;
						end if;
					end if;
						
				when end_cyc_st	=>
					cyc_internal <= '0';
					cur_st <= wbm_undbg_type_st;
				
				when wbm_undbg_type_st =>
					cyc_internal<=	'1';
					stb_internal	<=	'1';
					wbm_tgc_o	<=	'1';
					wbm_tga_o <= dbg_type_tga_c;
					we_internal <= '1';
					adr_internal <= dbg_type_adr_c;
					wbm_dat_o <= undbg_type_dat_c;
					if (sdram_rd_en='1') then
						cyc_internal <= '0';
						stb_internal	<=	'0';
						cnt := 0;
						dbg_adr <= sdram_addr_rd; -- latch the debug address
						-- -- -- dbg_adr <= tmp_sdram_adr; -- latch the debug address
						adr_internal <= dbg_reg_adr_c;
						cur_st <= wbm_dbg_adr_st;
					elsif (wbm_stall_i='0') then
						stb_internal <=	'0';
						cur_st <= wbm_undbg_type_end_cyc_st;
					end if;
				
				when wbm_undbg_type_end_cyc_st =>
					if (sdram_rd_en='1') then
						cyc_internal <= '0';
						stb_internal	<=	'0';
						cnt := 0;
						dbg_adr <= sdram_addr_rd; -- latch the debug address
						-- -- -- dbg_adr <= tmp_sdram_adr; -- latch the debug address
						adr_internal <= dbg_reg_adr_c;
						cur_st <= wbm_dbg_adr_st;
					elsif (err_i_status = '1') then --An error has occured
						cyc_internal <= '0';
						cur_st <= wbm_idle_st;
					elsif (wbm_ack_i = '1') then 
						cyc_internal <= '0';
						cur_st <= wbm_idle_st;
					else
						cur_st <=	cur_st;
						cyc_internal <= '1';
					end if;
					
				-- -- when restart_st	=>
					-- -- cyc_internal <= '1';
					-- -- stb_internal	<=	'1';
					-- -- we_internal <= '0';
					-- -- wbm_tga_o <= (others=>'0');
					-- -- wbm_tgc_o	<=	'0';
					-- -- if (wbm_stall_i='0') then
						-- -- stb_internal <=	'0';
						-- -- cur_st <= wbm_idle_st;
					-- -- end if;
				
				when others =>
					cur_st	<=	wbm_idle_st;
					report "Time: " & time'image(now) & "SG_WBM_IF : Unimplemented state has been detected" severity error;
				end case;
				
		end if;
	end process fsm_proc;
	
	
	----------------------------------------------------------------------------------------
	----------------------------		ack_cnt_proc Process			----------------
	----------------------------------------------------------------------------------------
	-- WBM_ACK_I and WBM_ERR_I counter
	----------------------------------------------------------------------------------------
	ack_cnt_proc: process (clk, reset_n)
	begin
		if (reset_n='0') then
			ack_cnt	<=	(others => '0');
		elsif rising_edge (clk) then
			if (cur_st = wbm_idle_st)or(sdram_rd_en='1') then
				ack_cnt	<= (others => '0');
			elsif (cur_st = wbm_dbg_adr_st) or (cur_st = wbm_dbg_adr_end_cyc_st) then
				--if (wbm_ack_i = '1') or (wbm_err_i = '1') then
				if (wbm_ack_i = '1') then
					ack_cnt	<=	ack_cnt + '1';
				else
					ack_cnt	<= ack_cnt;
				end if;
			else
				ack_cnt	<=	ack_cnt;
			end if;
		end if;
	end process ack_cnt_proc;
	
	
	---------------------------------------------------------------------------------
	----------------------------- Process err_i_proc	-----------------------------
	---------------------------------------------------------------------------------
	-- The process sniffs for WBM_ERR_I from SDRAM.
	---------------------------------------------------------------------------------
	err_i_proc: process (clk, reset_n)
	begin
		if (reset_n='0') then
			err_i_status	<= '0';
		elsif rising_edge (clk) then
			if (cur_st = wbm_idle_st)or(sdram_rd_en='1') then
				err_i_status	<= '0';
			else
				err_i_status	<= (err_i_status or wbm_err_i); --Sniff for WBM_ERR_I
			end if;
		end if;
	end process err_i_proc;
	
	
end architecture rtl_SG_WBM_IF;