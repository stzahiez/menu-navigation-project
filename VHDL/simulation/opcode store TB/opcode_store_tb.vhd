------------------------------------------------------------------------------------------------
-- Model Name 	:	opcode store TB
-- File Name	:	opcode_store_tb.vhd
-- Generated	:	20.4.2012
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description: opcode store TB
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date		Name								Description			
--			1.00		20.4.2012	Olga Liberman and Yoav Shvartz		Creation
------------------------------------------------------------------------------------------------
--	Todo:
--			(1)
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity opcode_store_tb is
end entity opcode_store_tb;

architecture sim_opcode_store_tb of opcode_store_tb is

--#############################	Components	##############################################--

component opcode_store

	port (
			clk            : in    std_logic;	 					-- clock in domain 133Mhz.
            reset_n        : in    std_logic; 						-- asynchronous reset. 
			op_cnt             : in    std_logic_vector(9 downto 0);   	-- number of total changes X 3: 1 change (24 bits) = add/remove 1 symbol ( 24 bits are being sent in 3 packs of 8 bits)
			op_str_valid       : in    std_logic; 						-- connected from opcode_unite block, opu_wr_en signal
			op_str_data_in     : in    std_logic_vector(23 downto 0); 	-- connected from opcode_unite block, opu_data_out signal
			op_str_rd_start    : in    std_logic; 						-- connected from VESA controller, vsync signal
			ram_adr_wr         : out   std_logic_vector(8 downto 0);  	-- ram's address to be written into. 
			ram_wr_en          : out   std_logic;					 	-- ram write enable
			ram_data           : out   std_logic_vector(12 downto 0);	-- data sent to ram
			rd_mng_en          : out   std_logic;						-- activating Read_Manager 
			op_str_ready       : out   std_logic; 						-- ????????????????? same as ram_wr_en ?????????????
			op_str_empty       : out   std_logic;						-- FIFO is empty (debug)
			op_str_full        : out   std_logic;						-- FIFO is full (debug)
			op_str_used        : out   std_logic_vector(8 downto 0)		-- current number of elements in FIFO (debug)	
		);
end component opcode_store;

--#############################	Signals ##############################################--

--Clock and Reset
signal clk				:	std_logic := '0';
signal reset_n			:	std_logic := '1';
-- data in
signal op_cnt               :   std_logic_vector(9 downto 0);   	-- number of total changes X 3: 1 change (24 bits) = add/remove 1 symbol ( 24 bits are being sent in 3 packs of 8 bits)
signal op_str_valid         :   std_logic; 						    -- connected from opcode_unite block, opu_wr_en signal
signal op_str_data_in       :   std_logic_vector(23 downto 0);   	-- connected from opcode_unite block, opu_data_out signal
signal op_str_rd_start      :   std_logic; 				         	-- connected from VESA controller, vsync signal
-- data out
signal ram_adr_wr           :   std_logic_vector(8 downto 0);  		-- ram's address to be written into. 
signal ram_wr_en            :   std_logic;							-- ram write enable
signal ram_data             :   std_logic_vector(12 downto 0);		-- data sent to ram
signal rd_mng_en            :   std_logic;							-- activating Read_Manager 
signal op_str_ready         :   std_logic; 							-- ????????????????? same as ram_wr_en ?????????????
signal op_str_empty         :   std_logic;							-- FIFO is empty (debug)
signal op_str_full          :   std_logic;							-- FIFO is full (debug)
signal op_str_used          :   std_logic_vector(8 downto 0);		-- current number of elements in FIFO (debug)	


begin

--#############################	Instantiaion ##############################################--
opcode_store_inst :  opcode_store port map
		(
			clk            => clk,       
            reset_n        => reset_n,     
			op_cnt             => op_cnt,          
			op_str_valid       => op_str_valid,     
			op_str_data_in     => op_str_data_in,    
			op_str_rd_start    => op_str_rd_start,   
			ram_adr_wr         => ram_adr_wr,     
			ram_wr_en          => ram_wr_en,      
			ram_data           => ram_data,       
			rd_mng_en          => rd_mng_en,       
			op_str_ready       => op_str_ready,     
			op_str_empty       => op_str_empty,
			op_str_full        => op_str_full,
			op_str_used        => op_str_used
		);

clk_proc:
clk	<=	not clk after 5 ns;

rst_proc:
reset_n	<=	'0', '1' after 20 ns;

			
store_proc: process 
begin
	op_str_rd_start  <= '0';
	op_cnt <= "0000001001"; -- total of 3 symbols  
	op_str_valid <= '0';
	op_str_data_in <= "010000000000111001100010"; -- add , addr = 7 , x = 3 , y = 2
	wait for 40 ns;
	op_str_valid <= '1';
	wait for 10 ns;
	op_str_valid <= '0';
	op_str_data_in <= "010000000000011010100001"; -- add , addr = 3 , x = 5 , y = 1
	wait for 20 ns;
	op_str_valid <= '1';
	wait for 10 ns;
	op_str_valid <= '0';
	op_str_data_in <= "000000000000011010100001"; -- remove , addr = 3 , x = 5 , y = 1
	wait for 20 ns;
	op_str_valid <= '1';
	wait for 10 ns;
	op_str_valid <= '0';
	wait;
	
end process store_proc;

end architecture sim_opcode_store_tb;