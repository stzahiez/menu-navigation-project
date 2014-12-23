------------------------------------------------------------------------------------------------
-- Model Name 	:	Opcode Parser
-- File Name	:	opcode_parser.vhd
-- Generated	:	26.10.2012
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description:
-- Parser for the opcode text file
--
-- The language is:
-- 	1. -f opcode count iiii
--		-f means a start of a new frame
--		i = integer that indicates number of following opcodes in this frame (the number is in
--		bytes, means num of opcodes X 3)
-- 	2. -p bbbbbbbb
-- 		-p means opcode field
--		b = binary(0/1), this field is an opcode byte (start with MSB part of opcode)
-- 	3. -t wait T iiii
--		-t means time field
--		i = integer that indicates the num of clock cycles to wait
--		x = the time unis:
-- 	4. -e
--		a filed at the end of the text file, to show that the text file is finished correctly
-- 	5. -- comment
--		each line that starts with "--" is skipped from the parser model
--
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
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use work.txt_util.all;


entity opcode_parser is
	generic(
		opcode_text_file_g	: 	string := "test_001.txt";
		clk_half_period_g	:	time	:= 5 ns
	);
	port (
		clk : in std_logic; -- the main clock to which all the internal logic of the Symbol Generator block is synchronized.
		reset_n : in std_logic; -- asynchronous reset
		data_out : out std_logic_vector(7 downto 0) := (others => '0');
		data_valid : out std_logic := '0';
		opcode_count : out std_logic_vector(9 downto 0) := (others => '0')
	);
  
end entity opcode_parser;

architecture sim_opcode_parser of opcode_parser is


begin


parser_proc: process
    file file_pointer 				: text;
	variable flag_var		 		: string(1 to 2);
	variable tmp_14_var 			: string(1 to 14);
	variable opcode_count_char_var 	: string(1 to 4);
	variable opcode_count_int_var 	: integer := 0;
	variable tmp_1_var			 	: string(1 to 1);
    variable tmp_8_var			 	: string(1 to 8);
	variable data_out_bin			: std_logic_vector(7 downto 0);
	variable tmp_6_var			 	: string(1 to 6);
	variable tmp_char				: character;
	variable wait_int_var 			: integer := 0;
	variable tmp_2_var			 	: string(1 to 2);
	variable msg_line				: line;
	
	variable line_content_24 		: string(1 to 24);
	variable l		 				: line;
    variable j 						: integer := 0;
	variable w 						: integer := 0;
	--variable address 				: std_logic_vector (23 downto 0) := (others=>'0');
	
begin
	
	file_open(file_pointer,opcode_text_file_g,READ_MODE);
	print("file open");
	
	wait until rising_edge(clk) and reset_n='1';
	
	while not endfile(file_pointer) loop --till the end of file is reached continue.
			
			readline (file_pointer,l);  --Read the whole line from the file
			READ (l,flag_var); -- read 2 chars for flag
			while (flag_var = "--") loop
				readline (file_pointer,l);  --Read the whole line from the file
				READ (l,flag_var); -- read 2 chars for flag
			end loop;
			
			data_valid <= '0';
			
			CASE flag_var IS
			
				WHEN  "-f"  =>
					READ (l,tmp_14_var);
					READ (l,opcode_count_int_var);
					opcode_count <= std_logic_vector(to_unsigned(opcode_count_int_var, 10));
					
				WHEN  "-p"  =>
					READ (l,tmp_1_var);
					READ (l,tmp_8_var);
					data_out_bin := to_std_logic_vector(tmp_8_var);
					data_out <= data_out_bin;
					data_valid <= '1';
					
				WHEN  "-t"  =>
					READ (l,tmp_6_var);
					READ (l,tmp_2_var);
					tmp_char := tmp_2_var(1);
					-- print("the char is...");
					-- write(msg_line, tmp_char);
					-- writeline(output, msg_line);
					READ (l,wait_int_var);
					
					CASE tmp_char IS
						WHEN  'T' | 't'  => 
							-- print("wait for...");
							-- write(msg_line, wait_int_var*2);
							-- writeline(output, msg_line);
							if (wait_int_var>0) then
								wait for wait_int_var*2*clk_half_period_g;
							end if;
						-- WHEN  's' | 'S'  => wait for wait_int_var sec;
						-- WHEN  'm' | 'M'  => wait for wait_int_var ms;
						-- WHEN  'u' | 'U'  => wait for wait_int_var us;
						-- WHEN  'n' | 'N'  => wait for wait_int_var ns;
						-- WHEN  'p' | 'P'  => wait for wait_int_var ps;
						-- WHEN  'f' | 'F'  => wait for wait_int_var fs;
						WHEN others		 => NULL;
					END CASE;
				
				WHEN  "-e"  =>
					file_close(file_pointer);
					wait;
				
				WHEN OTHERS =>
					NULL;
				
			END CASE;
			
		wait until rising_edge(clk) and reset_n='1';
		
	end loop;
	
	file_close(file_pointer);
	wait;
	
	
end process parser_proc;



end architecture sim_opcode_parser;