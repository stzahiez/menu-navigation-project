------------------------------------------------------------------------------------------------
-- Model Name 	:	Opcode Parser TB
-- File Name	:	opcode_parser_TB.vhd
-- Generated	:	26.10.2012
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description:
-- Test Bench environment for the opcode_parser model
-- Generates clock and reset 
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date		    Name				Description			
--			1.00		26.10.2012	  	Olga				Creation
--
------------------------------------------------------------------------------------------------
--	Todo:
--	(1) 

------------------------------------------------------------------------------------------------


library ieee;
use IEEE.std_logic_1164.all;

entity opcode_parser_TB is
end entity opcode_parser_TB;

architecture sim_opcode_parser_TB of opcode_parser_TB is

--#############################	Components	##############################################--

component opcode_parser
	generic(
		opcode_text_file	: 	string := "test_001.txt";
		clk_half_period		:	time	:= 5 ns
	);
	port (
		clk : in std_logic; -- the main clock to which all the internal logic of the Symbol Generator block is synchronized.
		reset_n : in std_logic; -- asynchronous reset
		data_out : out std_logic_vector(7 downto 0);
		data_valid : out std_logic;
		opcode_count : out std_logic_vector(9 downto 0)
	);
end component opcode_parser;

--#############################	Signals ##############################################--

--Clock and Reset
signal clk				:	std_logic := '0';
signal reset_n			:	std_logic := '1';
-- data out
signal data_out			: 	std_logic_vector(7 downto 0); -- This signal is an enable signal to write opcodes to the Opcode Store block. It is active when a new opcode was united and is ready to be stored in the FIFO.
signal data_valid		: 	std_logic; -- The data signal is the united Opcode to be stored in the Opcode store block.
signal opcode_count		:	std_logic_vector(9 downto 0);  -- counter signal to count the message packs from wbs

constant clk_half_period_c : time	:= 5 ns;

begin

--#############################	Instantiaion ##############################################--
opcode_parser_inst :  opcode_parser 
		generic map(
			opcode_text_file => "test_001.txt",
			clk_half_period => clk_half_period_c
		)
		
		port map
		(
			clk => clk,
			reset_n => reset_n,
			data_out => data_out,
			data_valid => data_valid,
			opcode_count => opcode_count
		);

clk_proc:
clk	<=	not clk after clk_half_period_c;

rst_proc:
reset_n	<=	'0', '1' after 4*clk_half_period_c;

end architecture sim_opcode_parser_TB;