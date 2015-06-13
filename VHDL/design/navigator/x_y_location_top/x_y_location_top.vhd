------------------------------------------------------------------------------------------------
-- Model Name 	:	x_y_location_top
-- File Name	:	x_y_location_top.vhd
-- created	:	01.06.2015
-- Author		:	Tzahi Ezra
-- Project		:	Menu-Navigation project
------------------------------------------------------------------------------------------------
-- Description:
-- This block responsible for calculating the desired location and save it to 2 registers, according to
-- the current location and the input that was asserted high, following a button press on one of the 
-- following buttons on the DE2 board: right, left, up or down.
-- 
-- The main functions of this block:
-- 1.	Calculating the horizonal and vertical location X, Y (0<=X<=19, 0<=Y<=14), and save it to 2 registers.


--
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date		         Name									Description			
--			1.00		  01.06.2015	   	Tzahi Ezra			Creation

library ieee;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- For "+", "-",... 
use ieee.numeric_std.all; -- For to_unsigned() function 


entity x_y_location_top is
  generic(
    hor_width_g  : 		positive	:= 5; 	-- The width of horizonal output lines, needed to hold the maximum horizontal location value.
    ver_width_g  : 		positive	:= 4; 	-- The width of vertical output lines, needed to hold the maximum vertical location value.
    reset_polarity_g  : std_logic := '1';  -- The reset polarity of the system.
    hor_max_value_g  : 		positive	:= 19; 	-- The maximum horizontal location value.
    ver_max_value_g  : 		positive	:= 14 	-- The  maximum vertical location value.
    );
  port (
    clk 				: 		in std_logic; -- The main clock of the system. frequency 100Mhz.
    reset	    : 		in std_logic; -- Asynchronous reset.
    right_trig     :   in bit; -- Right enable.
    left_trig     :   in bit; -- Left enable.
    up_trig     :   in bit; -- Up enable.
    down_trig     :   in bit; -- Down enable.
    vsync     :   in std_logic; -- VSync Signal from the vesa gen ctrl block, indicates start of frame display, from the upper left corner on screen.
    x_updated   	: 		out std_logic_vector(hor_width_g-1 downto 0); -- The future horizontal location of the cursor in the frame.
    y_updated   	: 		out std_logic_vector(ver_width_g-1 downto 0) -- The future vertical location of the cursor in the frame.
  );
 end entity x_y_location_top;
 
 architecture  x_y_location_top_rtl of x_y_location_top is
 

--#############################	Components	##############################################--
    
  component x_y_location 
	  generic(
	    hor_width_g  : 		positive	:= hor_width_g; 	-- The width of horizonal output lines, needed to hold the maximum horizontal location value.
      ver_width_g  : 		positive	:= ver_width_g; 	-- The width of horizonal output lines, needed to hold the maximum horizontal location value.
      reset_polarity_g  :   std_logic := reset_polarity_g;  -- The reset polarity of the system.
      hor_max_value_g  : 		positive	:= hor_max_value_g; 	-- The maximum horizontal location value.
      ver_max_value_g  : 		positive	:= ver_max_value_g 	-- The  maximum vertical location value.
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
  
  component update_upon_vsync
  generic(
    hor_width_g  : 		positive	:= hor_width_g; 	-- the width of horizonal output lines, needed to hold the maximum horizontal location value.
    ver_width_g  : 		positive	:= ver_width_g; 	-- the width of vertical output lines, needed to hold the maximum vertical location value.
    reset_polarity_g  : std_logic := reset_polarity_g  -- the reset polarity of the system.   
    );
  port (
    reset	    : 		in std_logic; -- Asynchronous reset.
    vsync     :   in std_logic; -- VSync Signal from the vesa gen ctrl block, indicates start of frame display, from the upper left corner on screen.
    x     :	  in std_logic_vector(hor_width_g-1 downto 0); -- The future horizontal location of the cursor in the frame.
    y   	: 		in std_logic_vector(ver_width_g-1 downto 0); -- The future vertical location of the cursor in the frame.
    x_updated   	: 		out std_logic_vector(hor_width_g-1 downto 0); -- The updated upon vsync horizontal location of the cursor in the frame.
    y_updated   	: 		out std_logic_vector(ver_width_g-1 downto 0) -- The updated upon vsync vertical location of the cursor in the frame.
    
  );
  end component update_upon_vsync;
  
--#############################	Signals ##############################################--
	

	signal x_out	    : 	 std_logic_vector(hor_width_g-1 downto 0);
	signal y_out   	 : 	 std_logic_vector(ver_width_g-1 downto 0);

	signal x_connect	    : 	 std_logic_vector(hor_width_g-1 downto 0);
	signal y_connect   	 : 	 std_logic_vector(ver_width_g-1 downto 0);

begin
	
--#############################	Instantiaion ##############################################--
	
	
	x_y_location_inst : x_y_location
	  generic map(
	    hor_width_g => hor_width_g,
	    ver_width_g => ver_width_g,
	    reset_polarity_g => reset_polarity_g,
	    hor_max_value_g => hor_max_value_g,
	    ver_max_value_g => ver_max_value_g
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
	  
	  update_upon_vsync_inst : update_upon_vsync
	  generic map(
	    hor_width_g => hor_width_g,
	    ver_width_g => ver_width_g,
	    reset_polarity_g => reset_polarity_g
	  )
	  port map(
	    reset => reset,
	    vsync => vsync,
	    x => x_out,
	    y => y_out,
	    x_updated => x_connect,
	    y_updated =>  y_connect
	  );
	  

	
	  x_updated <=  x_connect;
	  y_updated <= y_connect;
 
	  

end architecture x_y_location_top_rtl;
