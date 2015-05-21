------------------------------------------------------------------------------------------------
-- Model Name 	:	x_y_location_TB
-- File Name	:	x_y_location_tb.vhd
-- Generated	:	17.05.2015
-- Author		:	Tzahi Ezra
-- Project		:	Menu-Navigation Project
------------------------------------------------------------------------------------------------
-- Description: x_y_location block TB
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date		         Name									Description			
--			1.00		  17.05.2015	   	Tzahi Ezra			Creation

library ieee;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;

entity x_y_location_TB is
end entity x_y_location_TB;

architecture sim_x_y_location_TB of x_y_location_TB is
--#############################	Components	##############################################--
	  
  component x_y_location 
	  generic(
	    hor_width_g  : 		positive	:= 5; 	-- the width of horizonal output lines, needed to hold the maximum horizontal location value.
      ver_width_g  : 		positive	:= 4; 	-- the width of horizonal output lines, needed to hold the maximum horizontal location value.
      reset_polarity_g  :   std_logic := '1';  -- the reset polarity of the system.
      hor_max_value  : 		positive	:= 19; 	-- the maximum horizontal location value.
      ver_max_value  : 		positive	:= 14 	-- the  maximum vertical location value.
    );
    port (
      clk 				: 		in std_logic; -- The main clock of the system. frequency 100Mhz.
      reset	    : 		in std_logic; -- Asynchronous reset.
      right_trig     :   in bit; -- Right enable.
      left_trig     :   in bit; -- Left enable.
      up_trig     :   in bit; -- Up enable.
      down_trig     :   in bit; -- Down enable.
      x_out   	: 		out std_logic_vector(hor_width_g-1 downto 0); -- The future horizontal location of the cursor in the frame.
      y_out   	: 		out std_logic_vector(ver_width_g-1 downto 0) -- The future vertical location of the cursor in the frame.
  );
  end component x_y_location;

  --############################# Constants ############################################--
  constant hor_width_g  : 		positive	:= 5; 
  constant ver_width_g  : 		positive	:= 4;
  constant hor_width_zeros : std_logic_vector(hor_width_g-1 downto 0) := (others => '0');
	constant ver_width_zeros : std_logic_vector(ver_width_g-1 downto 0) := (others => '0');

	--#############################	Signals ##############################################--
	
	signal clk 				: 	 std_logic:= '0';
	signal reset     :   std_logic; 
	signal right_trig     :   bit := '0';
	signal left_trig     :   bit := '0';
	signal up_trig     :   bit := '0';
	signal down_trig     :   bit := '0';
	signal x_out	    : 	 std_logic_vector(hor_width_g-1 downto 0) := (others => '0');
	signal y_out   	 : 	 std_logic_vector(ver_width_g-1 downto 0) := (others => '0');
	


begin
	
	--#############################	Instantiaion ##############################################--
	
	x_y_location_inst : x_y_location
	  generic map(
	    hor_width_g => 5,
	    ver_width_g => 4,
	    reset_polarity_g => '1',
	    hor_max_value => 19,
	    ver_max_value => 14
	  )
	  port map(
	    clk => clk,
	    reset => reset,
	    right_trig => right_trig,
	    left_trig => left_trig,
	    up_trig => up_trig,
	    down_trig => down_trig,
	    x_out =>  x_out,
	    y_out => y_out
	  );
	  
	  --###############################process#########################################
		-- reset generator	
	reset_proc: process
		begin
		reset <= '0';
		wait for 1 ns;
		
		--check output data is '0' after reset signal goes high  
		reset <= '1';
		wait until clk ='0'; 
		
		assert (x_out = hor_width_zeros)
    report "Reset data output check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: 0 "
    severity error ;
    
    assert (y_out = ver_width_zeros)
    report "Reset data output check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: 0 "    
    severity error ;
		
		reset <= '0';
		wait for 5 ns;
		
		--check data is still '0' after reset signal goes low  
		
		wait until	reset = '0'; 
		
		assert (x_out = hor_width_zeros)
    report "Reset data output check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: 0  "     
    severity error ;
    
    assert (y_out = ver_width_zeros)
    report "Reset data output check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: 0 "   
    severity error ;
		
  		wait;
    
		end process reset_proc;
		
	  -- pressing generator
	  pressing_proc: process 
	  variable hor_value : std_logic_vector(hor_width_g-1 downto 0);
	  variable ver_value : std_logic_vector(ver_width_g-1 downto 0);
	
	  begin
	    
	    wait for  100 ns;
	    wait until clk ='1';
	    
	    -- Upper left corner, right press check
	    -- Check location, due to an initial right button press, while curr location is (x,y)=(0,0),right_trig = '1'
      right_trig <= '1';
      wait for 10 ns;
      right_trig <= '0';
      
      wait until clk = '0'; -- next falling edge
      hor_value := (0 => '1', others => '0'); 
      ver_value := (others => '0');
        
      assert (x_out = hor_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: 1 "     
      severity error ;
      
      assert (y_out = ver_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: 0 "     
      severity error ;
      
      
      wait for 105 ns;
      
      -- Check location, due to an up button press, while curr location is (x,y)=(1,0), up_trig = '1'     
      up_trig <= '1';
      wait for 10 ns;
      up_trig <= '0';
      
      wait until clk = '0'; --next falling edge
      hor_value := (1 => '1', others => '0');
      ver_value := (0 => '0', others => '1');
      
      assert (x_out = hor_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: 2 "    
      severity error ;
      
      assert (y_out = ver_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: ver_max_value "     
      severity error ;
      
      wait for 105 ns;
      
      
      -- Check location, due to an left button press, while curr location is (x,y)=(2,ver_max_value), left_trig = '1'     
      left_trig <= '1';
      wait for 10 ns;
      left_trig <= '0';
      
      wait until clk = '0'; --next faling edge
      hor_value := (0 => '1', others => '0');
      ver_value := (0 => '0', others => '1');
      
      assert (x_out = hor_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: 1 "     
      severity error ;
      
      assert (y_out = ver_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: ver_max_value "    
      severity error ;
      

      wait for 105 ns; 
           
      -- Check location, due to an left button press, while curr location is (x,y)=(1,ver_max_value), left_trig = '1'     
      left_trig <= '1';
      wait for 10 ns;
      left_trig <= '0';
      
      wait until clk = '0'; --next faling edge
      hor_value := (others => '0');
      ver_value := (0 => '0', others => '1');
      
      assert (x_out = hor_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: 0 "    
      severity error ;
      
      assert (y_out = ver_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: ver_max_value "     
      severity error ;
      

      wait for 105 ns; 
      
      -- Lower left corner, left press check   
      -- Check location, due to an left button press, while curr location is (x,y)=(0,ver_max_value), left_trig = '1'     
      left_trig <= '1';
      wait for 10 ns;
      left_trig <= '0';
      
      wait until clk = '0'; --next faling edge
      hor_value := (4 => '1', 1 =>'1', 0 =>'1', others => '0');
      ver_value := (1 => '0', others => '1');
      
      assert (x_out = hor_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: hor_max_value "    
      severity error ;
      
      assert (y_out = ver_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: ver_max_value-1 "   
      severity error ;
      
      wait for 105 ns; 
      
      -- Check location, due to an right button press, while curr location is (x,y)=(hor_max_value,ver_max_value-1), right_trig = '1'     
      right_trig <= '1';
      wait for 10 ns;
      right_trig <= '0';
      
      wait until clk = '0'; -- next faling edge
      hor_value := (others => '0');
      ver_value := (0 => '0', others => '1');
      
      assert (x_out = hor_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: 0 "     
      severity error ;
      
      assert (y_out = ver_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: ver_max_value "     
      severity error ;
      
      
      wait for 105 ns; 
      
      -- Lower left corner, down press check   
      -- Check location, due to an down button press, while curr location is (x,y)=(0,ver_max_value), down_trig = '1'     
      down_trig <= '1';
      wait for 10 ns;
      down_trig <= '0';

      wait until clk = '0'; --next faling edge
      hor_value := (4 => '1', 1 =>'1', 0 =>'1', others => '0');
      ver_value := (others => '0');
      
      assert (x_out = hor_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: hor_max_value "    
      severity error ;
      
      assert (y_out = ver_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: 0 "     
      severity error ;
      
      
      wait for 105 ns; 
           
      -- Upper right corner, right press check   
      -- Check location, due to an right button press, while curr location is (x,y)=(hor_max_value,0), right_trig = '1'     
      down_trig <= '1';
      wait for 10 ns;
      down_trig <= '0';
      
      wait until clk = '0'; --next faling edge
      hor_value := (4 => '1', 1 =>'1', 0 =>'1', others => '0');
      ver_value := (0 => '1', others => '0');
      
      assert (x_out = hor_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: hor_max_value "    
      severity error ;
      
      assert (y_out = ver_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: 1 "     
      severity error ;
            
      
      wait for 105 ns; 
      
      -- Check location, due to an up button press, while curr location is (x,y)=(hor_max_value,1), up_trig = '1'     
      up_trig <= '1';
      wait for 10 ns;
      up_trig <= '0';
      
      wait until clk = '0'; --next faling edge
      hor_value := (4 => '1', 1 =>'1', 0 =>'1', others => '0');
      ver_value := (others => '0');
      
      assert (x_out = hor_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: hor_max_value "    
      severity error ;
      
      assert (y_out = ver_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: 0 "     
      severity error ;
            
      
      wait for 100 ns;
      
      -- Upper left corner, up press check 
      -- Check location, due to an up button press, while curr location is (x,y)=(hor_max_value,0), up_trig = '1'     
      up_trig <= '1';
      wait for 10 ns;
      up_trig <= '0';
      
      wait until clk = '0'; --next faling edge
      hor_value := (others => '0');
      ver_value := (0 => '0', others => '1');
      
      assert (x_out = hor_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: 0 "    
      severity error ;
      
      assert (y_out = ver_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: ver_max_value "    
      severity error ;
            
      
      wait for 105 ns;
      
      -- Lower left corner, right press check
	    -- Check location, due to a right button press, while curr location is (x,y)=(0,ver_max_value),right_trig = '1'
      right_trig <= '1';
      wait for 10 ns;
      right_trig <= '0';
      
      wait until clk = '0'; -- next falling edge
      hor_value := (0 => '1', others => '0'); 
      ver_value := (0 => '0', others => '1');
        
      assert (x_out = hor_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: 1 "     
      severity error ;
      
      assert (y_out = ver_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: ver_max_value "     
      severity error ;
      
      
      wait for 105 ns;
  
      -- Check location, due to an down button press, while curr location is (x,y)=(1,ver_max_value), down_trig = '1'     
      down_trig <= '1';
      wait for 10 ns;
      down_trig <= '0';
      
      wait until clk = '0'; --next faling edge
      hor_value := (others => '0');
      ver_value := (others => '0');
      
      assert (x_out = hor_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: 0 "   
      severity error ;
      
      assert (y_out = ver_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: 0 "     
      severity error ;
            
      
     wait;
    end process pressing_proc; 
    
    -- clk generator
	  clk_proc: 
	  clk	<=	not clk after 5 ns;
    

      
end architecture sim_x_y_location_TB;