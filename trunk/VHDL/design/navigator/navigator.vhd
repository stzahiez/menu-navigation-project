------------------------------------------------------------------------------------------------
-- Model Name 	:	navigator
-- File Name	:	navigator.vhd
-- created	:	24.05.2015
-- Author		:	Tzahi Ezra
-- Project		:	Menu-Navigation project
------------------------------------------------------------------------------------------------
-- Description:
-- This block responsible for the cursor navigation.
-- 
-- The main functions of this block:
-- 1. Trigger a movement in the cursor location on the screen- right, left, up or down according to the button pressed, and only after 0.5 sec pressing time.
-- 2.	Holding the desired cursor's horizonal and vertical location X, Y (0<=X<=19, 0<=Y<=14) on the screen, and directing it to the manager  block, and to the software.


--
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date		         Name									Description			
--			1.00		  24.05.2015	   	Tzahi Ezra			Creation

library ieee;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- For "+", "-",... 
use ieee.numeric_std.all; -- For to_unsigned() function 


entity navigator is
  generic(
    hor_width_g  : 		positive	:= 5; 	-- the width of horizonal output lines, needed to hold the maximum horizontal location value.
    ver_width_g  : 		positive	:= 4; 	-- the width of vertical output lines, needed to hold the maximum vertical location value.
    reset_polarity_g  : std_logic := '1';  -- the reset polarity of the system.
    hor_max_value_g  : 		positive	:= 19; 	-- The maximum horizontal location value.
    ver_max_value_g  : 		positive	:= 14; 	-- The  maximum vertical location value.
    max_value_g  : 		positive	:= 50000000 -- The number of clk cycles to wait, before output a rectangular Pulse in width of one cycle.
    );
  port (
    clk 				: 		in std_logic; -- The main clock of the system. frequency 100Mhz.
    reset	    : 		in std_logic; -- Asynchronous reset.
    right     :   in bit; -- Right button signal from the DE2 board.
    left     :   in bit; -- Left button signal from the DE2 board.
    up     :   in bit; -- Up button signal from the DE2 board.
    down     :   in bit; -- Down button signal from the DE2 board.
    vsync     :   in std_logic; -- VSync Signal from the vesa gen ctrl block, indicates start of frame display, from the upper left corner on screen.
    hor_out   	 : 		out std_logic_vector(hor_width_g-1 downto 0); -- The future horizontal location of the cursor in the frame.
    ver_out   	 : 		out std_logic_vector(ver_width_g-1 downto 0) -- The future vertical location of the cursor in the frame.
  );
 end entity navigator;
 
 architecture  navigator_rtl of navigator is

--#############################	Components	##############################################--
	  
  component x_y_location_top 
	  generic(
      hor_width_g  : 		positive	:= hor_width_g; 	-- The width of horizonal output lines, needed to hold the maximum horizontal location value.
      ver_width_g  : 		positive	:= ver_width_g; 	-- The width of vertical output lines, needed to hold the maximum vertical location value.
      reset_polarity_g  : std_logic := reset_polarity_g;  -- The reset polarity of the system.
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
      vsync     :   in std_logic; -- VSync Signal from the vesa gen ctrl block, indicates start of frame display, from the upper left corner on screen.
      x_updated   	: 		out std_logic_vector(hor_width_g-1 downto 0); -- The future horizontal location of the cursor in the frame.
      y_updated   	: 		out std_logic_vector(ver_width_g-1 downto 0) -- The future vertical location of the cursor in the frame.
    );
  end component x_y_location_top;
  
  component debouncer is
  generic(
    max_value_g  : 		positive	:= max_value_g; 	-- Number of clk cycles to wait, before output a rectangular Pulse in width of one cycle.
    reset_polarity_g  :   std_logic := reset_polarity_g  -- The reset polarity that is used to determine which event causes the all the registers to be zero.		 
    );
  port (
    clk 				: 		in std_logic; -- The main clock of the system. frequency 100Mhz.
    reset     : 		in std_logic; -- Asynchronous reset.
    din	    : 		in bit; -- Input from a button on the DE2 board.
    dout   	: 		out bit -- That is a signal that used to trigger a change of the cursor X,Y location, according to the button pressed.
  );
 end component debouncer;
 
  

 ---------------------------- signals ---------------------------------------------
  signal right_trig      :   bit; -- Right enable.
  signal left_trig      :   bit; -- Left enable.
  signal up_trig      :   bit; -- Up enable.
  signal down_trig      :   bit; -- Down enable.
  signal x_out     :   std_logic_vector(hor_width_g-1 downto 0); -- A connection to hor_out 
  signal y_out     :   std_logic_vector(ver_width_g-1 downto 0); -- A connection to ver_out 

begin    

--#############################	Instantiaion ##############################################--

x_y_location_top_inst : x_y_location_top
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
	    vsync => vsync,
	    x_updated =>  x_out,
	    y_updated => y_out
	  );

right_debouncer_inst : debouncer
	  generic map(
	    max_value_g => max_value_g,
	    reset_polarity_g => reset_polarity_g
	  )
	  port map(
	    clk => clk,
	    reset => reset,
	    din => right,
	    dout => right_trig
	  );
	  
left_debouncer_inst : debouncer
	  generic map(
	    max_value_g => max_value_g,
	    reset_polarity_g => reset_polarity_g
	  )
	  port map(
	    clk => clk,
	    reset => reset,
	    din => left,
	    dout => left_trig
	  );

up_debouncer_inst : debouncer
	  generic map(
	    max_value_g => max_value_g,
	    reset_polarity_g => reset_polarity_g
	  )
	  port map(
	    clk => clk,
	    reset => reset,
	    din => up,
	    dout => up_trig
	  );
	
down_debouncer_inst : debouncer
	  generic map(
	    max_value_g => max_value_g,
	    reset_polarity_g => reset_polarity_g
	  )
	  port map(
	    clk => clk,
	    reset => reset,
	    din => down,
	    dout => down_trig
	  );
	  
	  hor_out <= x_out;
	  ver_out <= y_out;
	  
end architecture navigator_rtl;