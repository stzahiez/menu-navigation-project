------------------------------------------------------------------------------------------------
-- Model Name 	:	sdram symbol model
-- File Name	:	sdram_symbol_model.vhd
-- Generated	:	03.06.2012
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description: sdram model
-- This model recieves the read address from the manager block, and sends the required data
-- pixels from the symbol text files.
--
-- black symbol is saved in address 0x0...00 and 0x0...01
-- the other symbol is saved in adress 0x0...02 and 0x0...03
--
-- from the rd_en rising edge, a counter counts 20 clocks, and only then starts to send the data
-- length of 32 pixels
--
-- This model reads data from a text file which is a model to the memory
-- The structure of the text file:
--
-- address=00<2 bits for the bank><12 bits for the row><8 bits for the column>
-- <pixel 1: 8 bits>
-- <pixel 2: 8 bits>
		-- ...
		-- ...
		-- ...
-- <pixel 32: 8 bits>
-- address=00<2 bits for the bank><12 bits for the row><8 bits for the column>
-- <pixel 1: 8 bits>
-- <pixel 2: 8 bits>
		-- ...
		-- ...
		-- ...
-- <pixel 32: 8 bits>
-- (and follows...)
--
-- the columns of the addresses are incresed by 16 words.
--
-- Example for a text file is the memory.txt, supplied with this file.

------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date		  Name				Description			
--			1.00		03.06.2012	  Olga Liberman 	Creation
--			2.00		13.06.2012	  Olga Liberman		The model name changed to "SDRAM symbol model"
--														check of the address is on the row bits: address(21 downto 8) (instead of the the whole address)
--			3.00		15.06.2012	  Olga Liberman		New version of the sdram symbol model
--			3.01		27.08.2012	  Olga Liberman		After finding the wanted address, exit is implemented.
--														If address isn't found, comment is printed to the console.
------------------------------------------------------------------------------------------------
--	Todo:
--	(1) Add a feature to avoid comments during the memory txt (starting with "--" for example)
--  (2) 
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use std.textio.all;
use work.txt_util.all;


entity sdram_symbol_model is
    generic(
        memory_file_g		: 	string := "memory.txt" -- The name of the text file that models the SDRAM, found in the TB folder
    );
    port(
        clk        			: 	in  std_logic; -- The main clock to which all the internal logic of the Symbol Generator block is synchronized.
        reset_n      		: 	in  std_logic; -- Asynchronous reset, active when '0'
        rd_addr    			: 	in  std_logic_vector (23 downto 0); -- The address we want to read from the SDRAM
        rd_en      			: 	in  std_logic; -- Enable signal to read from the SDRAM, active state is '1'
        data_out   			: 	out std_logic_vector(7 downto 0); -- The data that is read from SDRAM
        valid      			: 	out std_logic -- Signal indicates when data_out signal is valid, active when '1'
    );
end entity sdram_symbol_model;

architecture sim_sdram_symbol_model of sdram_symbol_model is

    -- signal clk            : std_logic := '0';
    -- signal reset_n        : std_logic := '0';
    -- signal rd_addr    :   std_logic_vector (23 downto 0);
    -- signal rd_en      :   std_logic;
    signal address    :   std_logic_vector (23 downto 0);
	signal found_flag	:	boolean := FALSE; -- a flag if the wanted address was found in the memory text file, active when TRUE
	
	constant wait_for_data_c : natural := 20; -- number of clock cycles to wait until the SDRAM model start to search for data
	constant T_clock_c : time := 10 ns; -- the clock cycle in ns
            
begin

read_mem_proc: process
    file file_pointer 			: text;
    variable line_content_8 		: string(1 to 8);
	variable line_content_24 	: string(1 to 24);
	variable line_num 			: line;
    variable j 					: integer := 0;
	variable w 					: integer := 0;
	--variable address 			: std_logic_vector (23 downto 0) := (others=>'0');
	
begin
	--if rising_edge(rd_en) then
	valid <= '0';
	data_out  <= (others=>'0');
	--found_flag <= FALSE;
	wait until rising_edge(rd_en);
		
		-- sample the address
		address <= rd_addr;
		
		-- wait for 20 clocks
		for w in 1 to wait_for_data_c loop
			wait for T_clock_c;
		end loop;  
		
		file_open(file_pointer,memory_file_g,READ_MODE);   
		-- print("file open");
		while not endfile(file_pointer) loop --till the end of file is reached continue.
			readline (file_pointer,line_num);  --Read the whole line from the file
			READ (line_num,line_content_8);
			if (line_content_8="address=") then
				READ (line_num,line_content_24);
				if ( line_content_24=str(address) ) then
					-- print("address was found "& line_content_24);
					found_flag <= TRUE;
					-- read 32 pixels
					for j in 1 to 32 loop       
						readline (file_pointer,line_num);  --Read the whole line from the file
						READ (line_num,line_content_8);
						data_out <= to_std_logic_vector(line_content_8);
						valid <= '1';
						wait for T_clock_c;
					end loop;
					valid <= '0';
					data_out  <= (others=>'0');
					exit;
				end if;
			end if;
		end loop;
		
		file_close(file_pointer);  --after reading all the lines close the file. 
		if not(found_flag) then
			print("address was not found "& str(address));
		end if;
		found_flag <= FALSE;
		
	--end if;
end process read_mem_proc;


end architecture sim_sdram_symbol_model;

