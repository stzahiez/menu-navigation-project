------------------------------------------------------------------------------------------------
-- Model Name 	:	update_upon_vsync_TB
-- File Name	:	update_upon_vsync_tb.vhd
-- Generated	:	30.05.2015
-- Author		:	Tzahi Ezra
-- Project		:	Menu-Navigation Project
------------------------------------------------------------------------------------------------
-- Description: update_apon_vsync block TB
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date		         Name									Description			
--			1.00		  30.05.2015	   	Tzahi Ezra			Creation

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- For to_unsigned() function 
use ieee.math_real.ALL;   -- For uniform, trunc functions



entity update_upon_vsync_TB is
end entity update_upon_vsync_TB;

architecture sim_update_upon_vsync_TB of update_upon_vsync_TB is
--#############################	Components	##############################################--
	  
  component update_upon_vsync
  generic(
    hor_width_g  : 		positive	:= 5; 	-- the width of horizonal output lines, needed to hold the maximum horizontal location value.
    ver_width_g  : 		positive	:= 4; 	-- the width of vertical output lines, needed to hold the maximum vertical location value.
    reset_polarity_g  : std_logic := '1'  -- the reset polarity of the system.   
    );
  port (
    reset	    : 		in std_logic; -- Asynchronous reset.
    vsync     :   in std_logic; -- --VSync Signal from the vesa gen ctrl block, indicates start of frame display, from the upper left corner on screen.
    x     :	  in std_logic_vector(hor_width_g-1 downto 0); -- The future horizontal location of the cursor in the frame.
    y   	: 		in std_logic_vector(ver_width_g-1 downto 0); -- The future vertical location of the cursor in the frame.
    x_updated   	: 		out std_logic_vector(hor_width_g-1 downto 0); -- The updated upon vsync horizontal location of the cursor in the frame.
    y_updated   	: 		out std_logic_vector(ver_width_g-1 downto 0) -- The updated upon vsync vertical location of the cursor in the frame.
    
  );
  end component update_upon_vsync;
  
  

 --############################# Constants ############################################--
  constant reset_polarity_c  : std_logic := '1';
  constant hor_width_c : 		positive	:= 5; 
  constant ver_width_c : 		positive	:= 4;
  constant hor_max_value_c : positive	:= 19; 
  constant real_hor_max_value_c  : real	:= 19.0;
  constant ver_max_value_c  : positive	:= 14;
  constant real_ver_max_value_c  : real	:= 14.0;
  constant max_interval_time_c  : real := 1000.0; -- Maximum time interval beteen button press check in ns 	  
  constant loop_size_c  : positive := 100;
  constant hor_width_zeros_c : std_logic_vector(hor_width_c-1 downto 0) := (others => '0');
  constant ver_width_zeros_c : std_logic_vector(ver_width_c-1 downto 0) := (others => '0'); 
  
 --#############################	Signals ##############################################--
	signal clk 				: 	 std_logic:= '0';
	signal reset     :   std_logic; 
	signal vsync     :   std_logic:= '0';
	signal x     :   std_logic_vector(hor_width_c-1 downto 0);
	signal y     :   std_logic_vector(ver_width_c-1 downto 0);
	signal x_updated     :   std_logic_vector(hor_width_c-1 downto 0);
	signal y_updated     :   std_logic_vector(ver_width_c-1 downto 0);
	
	
	
	begin
	
	--#############################	Instantiaion ##############################################--
	
update_upon_vsync_inst : update_upon_vsync
	  generic map(
	    hor_width_g => hor_width_c,
	    ver_width_g => ver_width_c,
	    reset_polarity_g => reset_polarity_c
	  )
	  port map(
	    reset => reset,
	    vsync => vsync,
	    x => x,
	    y => y,
	    x_updated => x_updated,
	    y_updated =>  y_updated
	  );
	  
	  
	  --###############################processes#########################################
		-- Reset generator	
	  reset_proc: process
		begin
		reset <= not reset_polarity_c;
		wait for 1 ns;
		
		-- Check output data is '0' after reset signal goes high  
		reset <= reset_polarity_c;
    wait for 1 ns; 
    
		assert (x_updated = hor_width_zeros_c)
    report "Reset data output check error was found at: " & time'image(now) & " x_updated: " & integer'image(to_integer(unsigned(x_updated))) & " expected: 0 "
    severity error ;
    
    assert (y_updated = ver_width_zeros_c)
    report "Reset data output check error was found at: " & time'image(now) & " y_updated: " & integer'image(to_integer(unsigned(y_updated))) & " expected: 0 "    
    severity error ;
		
		reset <= not reset_polarity_c;
		wait;
    
		end process reset_proc;
		
		-- vsync generator	
	  vsync_proc: process
	  variable interval_rand_v : time range 0 ns to  1000 ns;
	  variable seed1_v, seed2_v : positive; -- Seed values for random generator rand2_v
	  variable rand1_v : real; -- Random real-number value in range 0 to 1.0
	  
		begin
		 
		 
	   for I in 0 to (loop_size_c -1)  loop
	     
       wait until clk = '1';	
		   vsync <= '1';
		   wait for 10 ns;   
	     vsync <= '0';
	     
	     assert (x_updated = x)
       report "updated data output check error was found at: " & time'image(now) & " x_updated: " & integer'image(to_integer(unsigned(x_updated))) & " expected: " & integer'image(to_integer(unsigned(x)))
       severity error ;
    
       assert (y_updated = y)
       report "updated data output check error was found at: " & time'image(now) & " y_updated: " & integer'image(to_integer(unsigned(y_updated))) & " expected: " & integer'image(to_integer(unsigned(y)))   
       severity error ;
		    
		   uniform(seed1_v, seed2_v, rand1_v);     
       interval_rand_v := trunc(max_interval_time_c*rand1_v)*1 ns; -- Rescale to 0..1000ns, find integer part

       wait for interval_rand_v;
     end loop;
        
    
		end process vsync_proc;
		
		x_y_proc: process
		variable seed1_v, seed2_v : positive; -- Seed values for random generator rand1_v
	  variable rand1_v : real; -- Random real-number value in range 0 to 1.0
	  variable int_x_rand_v : integer range 0 to hor_max_value_c;
	  variable seed3_v, seed4_v : positive; -- Seed values for random generator rand1_v
	  variable rand2_v : real; -- Random real-number value in range 0 to 1.0
		variable int_y_rand_v : integer range 0 to ver_max_value_c;
		variable seed5_v, seed6_v : positive; -- Seed values for random generator rand1_v
	  variable rand3_v : real; -- Random real-number value in range 0 to 1.0
	  variable interval_rand_v : time range 0 ns to 1000 ns;
		begin
		
		  wait until clk = '1';	    
	       	   
	    for I in 0 to (loop_size_c -1)  loop
        if rising_edge(clk) then
	      
		      uniform(seed1_v, seed2_v, rand1_v); -- Generate random number
          int_x_rand_v := integer(trunc(rand1_v*real_hor_max_value_c)); -- Rescale to 0..hor_max_value_c, find integer part
          x <= std_logic_vector(to_unsigned(int_x_rand_v, x'length));  -- Convert to std_logic_vector
		  
		      uniform(seed3_v, seed4_v, rand2_v); -- Generate random number
          int_y_rand_v := integer(trunc(rand2_v*real_ver_max_value_c)); -- Rescale to 0..ver_max_value_c, find integer part
          y <= std_logic_vector(to_unsigned(int_y_rand_v, y'length));  -- Convert to std_logic_vector
		  	 end if;
		  	    
      uniform(seed5_v, seed6_v, rand3_v);     
      interval_rand_v := trunc(max_interval_time_c*rand3_v)*1 ns; -- Rescale to 0..1000ns, find integer part

      wait for interval_rand_v;
       
    end loop;
    
  end process x_y_proc;
  
   
    -- clk generator
	  clk_proc: 
	  clk	<=	not clk after 5 ns;
    

end architecture sim_update_upon_vsync_TB;
