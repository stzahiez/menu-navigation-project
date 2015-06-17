------------------------------------------------------------------------------------------------
-- Model Name 	:	RAM 300x13
-- File Name	:	opcode_store.vhd
-- Generated	:	04.05.2012
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description:
--
-- RAM size: 300 x 13 (rows x bits)
--
-- The RAM stores the current display
-- Each row matches respectively to a symbol on the display:
-- row 0 to symbol (0,0)
-- row 1 to symbol (0,1)
-- ...
-- row 299 to symbol (14,19)
-- Each row stores the address of the wanted symbol in the SDRAM
--
-- Note: no "read enable" is needed
-- If the read address is valid, then the data will be on the ram_data_out signal 
--
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		 Date		        Name								      Description			
--			1.00		  	04.05.2012	   	Olga Liberman			Creation
-- 			2.00			16.07.2012		Olga Liberman			The block is separated to 2 processes: write and read.
--																	The reset was deleted from sensitivity list
------------------------------------------------------------------------------------------------
--	Todo:
--			(1) 
--
------------------------------------------------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all ;

entity RAM_300 is
  port (
    clk        : in  std_logic;	 							--System clock
	reset_n    : in  std_logic; 							--System Reset
    ram_addr_wr    : in  std_logic_vector(8 downto 0);		--Input address for write
	ram_wr_en      : in  std_logic;							--Enable signal for write
	ram_data_in    : in  std_logic_vector(12 downto 0);		--Input data for write
	ram_rd_en      : in  std_logic;							--Enable signal for read
    ram_addr_rd    : in  std_logic_vector(8 downto 0);		--Input address for read
    ram_data_out   : out std_logic_vector(12 downto 0)		--Output data
  );
end entity RAM_300;

architecture RAM_300_rtl of RAM_300 is
  
  type ram_type is array (0 to 299) of std_logic_vector(12 downto 0);
  signal mem : ram_type; 
  
begin

    -- ram_proc: process(clk,reset_n) is
    -- begin
		-- if (reset_n='0') then
			-- ram_data_out <= (others=>'0');
			-- -- for i in 0 to 299 loop
				-- -- mem(i) <= (others=>'0');
			-- -- end loop;
		-- elsif rising_edge(clk) then
			-- if ( (ram_wr_en = '1') and ( to_integer(unsigned(ram_addr_wr)) < 300 ) ) then
				-- mem(to_integer(unsigned(ram_addr_wr))) <= ram_data_in;
			-- end if;
			-- if ( (ram_rd_en = '1') and (to_integer(unsigned(ram_addr_rd)) < 300 ) )  then
				-- ram_data_out <= mem(to_integer(unsigned(ram_addr_rd)));
			-- end if;
		-- end if;
    -- end process ram_proc;
	
	write_proc: process(clk) is
    begin
		if rising_edge(clk) then
			if ( (ram_wr_en = '1') and ( to_integer(unsigned(ram_addr_wr)) < 300 ) ) then
				mem(to_integer(unsigned(ram_addr_wr))) <= ram_data_in;
			end if;
		end if;
	end process write_proc;
	
	read_proc: process(clk, reset_n) is
    begin
		if (reset_n='0') then
			ram_data_out <= (others=>'0');
		elsif rising_edge(clk) then
			if ( (ram_rd_en = '1') and (to_integer(unsigned(ram_addr_rd)) < 300 ) )  then
				ram_data_out <= mem(to_integer(unsigned(ram_addr_rd)));
			end if;
		end if;
	end process read_proc;
  
end architecture RAM_300_rtl;