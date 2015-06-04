------------------------------------------------------------------------------------------------
-- Model Name 	:	debouncer
-- File Name	:	debouncer.vhd
-- created	:	07.05.2015
-- Author		:	Tzahi Ezra
-- Project		:	Menu-Navigation project
------------------------------------------------------------------------------------------------
-- Description:
-- The debouncer counts how long its input is '1', and triggers when it reaches a defined value (in our case, 0.5 sec is used).
-- such that when it reaches the defined value, its output turns from '0' to '1' for 1 period , than return to '0'.
-- It works with the system frequency (100 MHz).
-- 
-- The main functions of this block:
-- 1.	Maintaining its output low, while its din(button on the DE2 board) input high, and the internal count haven't reach a defined value (0.5 sec).
-- inorder to filter button presses, shorter than the defined value (0.5 sec)

--
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date		         Name									Description			
--			1.00		  07.05.2015	   	Tzahi Ezra			Creation
library ieee;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;

entity debouncer is
  generic(
    max_value_g  : 		positive	:= 50; 	-- Number of clk cycles to wait, before output a rectangular Pulse in width of one cycle.
    reset_polarity_g  :   std_logic := '1'  -- The reset polarity that is used to determine which event causes the all the registers to be zero.		 
    );
  port (
    clk 				: 		in std_logic; -- The main clock of the system. frequency 100Mhz.
    reset     : 		in std_logic; -- Asynchronous reset.
    din	    : 		in bit; -- Input from a button on the DE2 board.
    dout   	: 		out bit -- That is a signal that used to trigger a change of the cursor X,Y location, according to the button pressed.
  );
 end entity debouncer;
 
 architecture  debouncer_rtl of debouncer is
 
 ---------------------------- signals ---------------------------------------------
signal int_count  : integer range 0 to max_value_g; -- This signal is internal count that is used to trigger an event to output a pulse in dout.

begin    
  process (clk, reset)
    begin
      if (reset = reset_polarity_g) then -- System reset
          dout <= '0';
          int_count <= 0;
      elsif rising_edge(clk) then
        dout <= '0';
        int_count <= 0; 
        if (din='1') then
          if (int_count=max_value_g) then
            dout <= '1';
            int_count <= 0; 
          else 
            int_count <= int_count+1;        
          end if;          
        end if;
      end if;
    end process;
  end architecture debouncer_rtl;
      