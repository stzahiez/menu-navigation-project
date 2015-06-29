------------------------------------------------------------------------------------------------
-- Model Name 	:	update_upon_vsync
-- File Name	:	update_upon_vsync.vhd
-- created	:	07.05.2015
-- Author	: Tzahi Ezra
-- Project	: Menu-Navigation project
------------------------------------------------------------------------------------------------
-- Description:
-- This block responsible for outputting an updated X, Y values for cursor location, only upon vsync signal arrival.

-- The main functions of this block:
-- 1.	output the X, Y (0<=X<=19, 0<=Y<=14) location inputs when vsync signal is high.

--
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date		         Name									Description			
--			1.00		  07.05.2015	   	Tzahi Ezra			Creation

library ieee;
use IEEE.std_logic_1164.all;


entity update_upon_vsync is
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
 end entity update_upon_vsync;
 
 architecture  update_upon_vsync_rtl of update_upon_vsync is
   
 begin    
  process (vsync, reset)
  begin
		if (reset = reset_polarity_g) then
		  x_updated <= (others => '0');
      y_updated <= (others => '0');
      
      
    elsif (rising_edge(vsync)) then
      x_updated <= x; 
      y_updated <= y;
    end if;
  end process;
  
 end architecture update_upon_vsync_rtl;