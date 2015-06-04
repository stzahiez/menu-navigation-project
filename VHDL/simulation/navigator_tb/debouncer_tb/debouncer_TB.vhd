------------------------------------------------------------------------------------------------
-- Model Name 	:	debouncer_TB
-- File Name	:	debouncer_TB.vhd
-- Generated	:	07.05.2015
-- Author		:	Tzahi Ezra
-- Project		:	Menu-Navigation Project
------------------------------------------------------------------------------------------------
-- Description: debouncer TB
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date		         Name									Description			
--			1.00		  07.05.2015	   	Tzahi Ezra			Creation

library ieee;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;

entity debouncer_TB is
end entity debouncer_TB;

architecture sim_debouncer_TB of debouncer_TB is

--############################# Constants ############################################--
  constant reset_polarity_c  : std_logic := '1';
  constant max_value_c  : 		positive	:= 50000000; 
  
--#############################	Components	##############################################--
	  
  component debouncer 
	  generic(
	    max_value_g  : 		positive	:= max_value_c; 	-- Number of clk cycles to wait, before output a rectangular Pulse in width of one cycle.
	    reset_polarity_g  :   std_logic := reset_polarity_c  -- The reset polarity that is used to determine which event causes the all the registers to be zero.		 
    );
    port (
      clk 				: 		in std_logic; -- The main clock of the system. frequency 100Mhz.
      reset     : 		in std_logic; -- Asynchronous reset.
      din	    : 		in bit; -- Input from a button on the DE2 board.
      dout   	: 		out bit -- That is a signal that used to trigger a change of the cursor X,Y location, according to the button pressed.
    );
  end component debouncer;


	--#############################	Signals ##############################################--
	
	signal clk 				: 	 std_logic:= '0';
	signal reset     :   std_logic; 
	signal din	    : 	 bit;
	signal dout   	 : 	 bit;
	


begin
	
	--#############################	Instantiaion ##############################################--
	
	debouncer_inst : debouncer
	  generic map(
	    max_value_g => max_value_c,
	    reset_polarity_g => reset_polarity_c
	  )
	  port map(
	    clk => clk,
	    reset => reset,
	    din => din,
	    dout => dout
	  );
	  
	  --###############################process#########################################
		-- reset generator	
		reset_proc: process
	  begin
		reset <= not reset_polarity_c;
		wait for 1 ns;
		
		--check data is '0' after reset signal goes high  
		reset <= reset_polarity_c;
		wait until	reset = reset_polarity_c; 
		
		assert (dout = '0')
    report "Reset data output check error was found at: " & time'image(now) & " dout: " & bit'image(dout) & " expected: '0' "     
    severity error ;
		
		wait for 5 ns;
		
		--check data is still '0' after reset signal goes low  
		reset <= not reset_polarity_c;
		wait until	reset = not reset_polarity_c; 
		
		assert (dout = '0')
    report "Reset data output check error was found at: " & time'image(now) & " dout: " & bit'image(dout) & " expected: '0' "     
    severity error ;
    
  		wait;
    
		end process reset_proc;
		
	  -- din generator
	  din_proc: process
	  begin
	    
	    --check initial response of dout, to an unpressed button: din = '0'
      din <= '0';
      wait until clk = '0'; --first faling edge
      
      assert (dout = '0')
      report "Pressing trigger concept check error was found at: " & time'image(now) & " dout: " & bit'image(dout) & " expected: '0' "     
      severity error ;
      
      wait for 13000 ns;
      
      --check if output goes high after less than .5 sec while din is high
      din <= '1';
      wait until clk = '0'; --next faling edge
      
      assert (dout = '0')
      report "Pressing trigger concept check error was found at: " & time'image(now) & " dout: " & bit'image(dout) & " expected: '0' "     
      severity error ;
      
      wait for 13000 ns;
      din <= '0';
      wait for 1000 ns;
      
      --check if after .5 sec from last time that the button was pressed, output goes high
      din <= '1';
      wait for 0.5 sec;
      wait until clk = '0';
      
      assert (dout = '1')
      report "Pressing trigger concept check error was found at: " & time'image(now)  & " dout: " & bit'image(dout) & " expected: '1' "     
      severity error ;
    
      wait;
    end process din_proc; 
    
    -- clk generator
	  clk_proc: 
	  clk	<=	not clk after 5 ns;
    

      
end architecture sim_debouncer_TB;