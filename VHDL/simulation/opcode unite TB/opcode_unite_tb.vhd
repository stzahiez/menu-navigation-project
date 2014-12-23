------------------------------------------------------------------------------------------------
-- Model Name 	:	opcode unite TB
-- File Name	:	opcode_unite_tb.vhd
-- Generated	:	20.4.2012
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description: opcode unite TB
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

entity opcode_unite_tb is
end entity opcode_unite_tb;

architecture sim_opcode_unite_tb of opcode_unite_tb is

--#############################	Components	##############################################--

component opcode_unite

	port (
			clk				: 	in 		std_logic; -- the main clock to which all the internal logic of the Symbol Generator block is synchronized.
			reset_n			: 	in 		std_logic; -- asynchronous reset
			opu_data_in			: 	in 		std_logic_vector(7 downto 0); -- data from wbs
			opu_data_in_valid	: 	in 		std_logic; -- valid signal for data from wbs
			opu_data_in_cnt		: 	in 		std_logic_vector(9 downto 0); -- number of changes in bytes - 1, each change is 3 bytes
			opu_wr_en			: 	out 	std_logic; -- This signal is an enable signal to write opcodes to the Opcode Store block. It is active when a new opcode was united and is ready to be stored in the FIFO.
			opu_data_out		: 	out 	std_logic_vector(23 downto 0); -- The data signal is the united Opcode to be stored in the Opcode store block.
			counter				:	out 	std_logic_vector(9 downto 0) := (others => '0');  -- counter signal to count the message packs from wbs
      test :out std_logic := '0'		
		);
end component opcode_unite;

--#############################	Signals ##############################################--

--Clock and Reset
signal clk				:	std_logic := '0';
signal reset_n			:	std_logic := '1';
-- data in
signal opu_data_in			:	std_logic_vector(7 downto 0); -- data from wbs
signal opu_data_in_valid	:	std_logic;
signal opu_data_in_cnt		: 	std_logic_vector(9 downto 0); -- number of changes in bytes - 1, each change is 3 bytes
-- data out
signal opu_wr_en			: 	std_logic; -- This signal is an enable signal to write opcodes to the Opcode Store block. It is active when a new opcode was united and is ready to be stored in the FIFO.
signal opu_data_out			: 	std_logic_vector(23 downto 0); -- The data signal is the united Opcode to be stored in the Opcode store block.
signal counter				:	std_logic_vector(9 downto 0) := (others => '0');  -- counter signal to count the message packs from wbs


begin

--#############################	Instantiaion ##############################################--
opcode_unite_inst :  opcode_unite port map
		(
			clk => clk,
			reset_n => reset_n,
			opu_data_in => opu_data_in,
			opu_data_in_valid => opu_data_in_valid,
			opu_data_in_cnt => opu_data_in_cnt,
			opu_wr_en => opu_wr_en,
			opu_data_out => opu_data_out,
			counter => counter
		);

clk_proc:
clk	<=	not clk after 5 ns;

rst_proc:
reset_n	<=	'0', '1' after 20 ns;

			
unite_proc: process 
begin
	
	opu_data_in <= "11111111";
	opu_data_in_valid <= '0';
	opu_data_in_cnt <= "0000000011"; -- 3
	wait for 40 ns;
	opu_data_in_valid <= '1';
	wait for 10 ns;
	opu_data_in_valid <= '0';
	wait for 20 ns;
	opu_data_in <= "01010101";
	opu_data_in_valid <= '1';
	opu_data_in_cnt <= "0000000011"; -- 3
	wait for 10 ns;
	opu_data_in_valid <= '0';
	wait for 30 ns;
	opu_data_in <= "11110000";
	opu_data_in_valid <= '1';
	opu_data_in_cnt <= "0000000011"; -- 3
	wait for 10 ns;
	opu_data_in_valid <= '0';
	wait;
	
end process unite_proc;

end architecture sim_opcode_unite_tb;