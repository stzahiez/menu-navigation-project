------------------------------------------------------------------------------------------------
-- Model Name 	:	x_y_location
-- File Name	:	x_y_location.vhd
-- created	:	07.05.2015
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
--			1.00		  30.05.2015	   	Tzahi Ezra			Creation

library ieee;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- For "+", "-",... 
use ieee.numeric_std.all; -- For to_unsigned() function 


entity x_y_location is
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
    x_out   	: 		out std_logic_vector(hor_width_g-1 downto 0); -- The future horizontal location of the cursor in the frame.
    y_out   	: 		out std_logic_vector(ver_width_g-1 downto 0) -- The future vertical location of the cursor in the frame.
  );
 end entity x_y_location;
 
 architecture  x_y_location_rtl of x_y_location is
 
 ---------------------------- signals ---------------------------------------------
type state_t is (right_st, left_st, upper_st, lower_st, upper_right_st, upper_left_st,
lower_right_st, lower_left_st, inner_st); -- enum type for fsm states
signal curr_sm 			: 	state_t;
signal x_int  : std_logic_vector(hor_width_g-1 downto 0); --this signal connects between the component's FSM and the X register.
signal y_int  : std_logic_vector(ver_width_g-1 downto 0); --this signal connects between the component's FSM and the Y register.


begin    
  fsm_proc: process (clk, reset)
  begin
		if (reset = reset_polarity_g) then
		  curr_sm <= upper_left_st;
		  x_int <= (others => '0');
      y_int <= (others => '0');
      
      
    elsif rising_edge(clk) then
      case curr_sm is
			
			  -- upper left corner state (X=0, Y=0)
				when upper_left_st =>
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      curr_sm <= upper_st;
				      x_int <= ( std_logic_vector(to_unsigned(1 , hor_width_g)) );
				      y_int <= ( std_logic_vector(to_unsigned(0 , ver_width_g)) ); 
					  
					  -- left button pressed
				    when "0100" =>
				      curr_sm <= lower_right_st;
				      x_int <= ( std_logic_vector(to_unsigned(hor_max_value_g , hor_width_g)) );
				      y_int <= ( std_logic_vector(to_unsigned(ver_max_value_g , ver_width_g)) ); 
					  
					  -- up button pressed
					  when "0010" =>
				      curr_sm <= lower_st;
				      x_int <= ( std_logic_vector(to_unsigned(1 , hor_width_g)) );
				      y_int <= ( std_logic_vector(to_unsigned(ver_max_value_g , ver_width_g)) );   
					 
					  -- down button pressed
					   when "0001" =>
					    curr_sm <= left_st;
				      x_int <= ( std_logic_vector(to_unsigned(0 , hor_width_g)) );
				      y_int <= ( std_logic_vector(to_unsigned(1 , ver_width_g)) );
				  
				    when others =>
				      curr_sm <= upper_left_st;		    
      end case;
				      
			 -- upper right corner state (X=hor_max_value_g, Y=0)
			 when upper_right_st =>
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      curr_sm <= left_st;
				      x_int <= ( std_logic_vector(to_unsigned(0 , hor_width_g)) );
				      y_int <= ( std_logic_vector(to_unsigned(1 , ver_width_g)) ); 
					  
					  -- left button pressed
				    when "0100" =>
				      curr_sm <= upper_st;
				      x_int <= ( std_logic_vector(to_unsigned(hor_max_value_g-1 , hor_width_g)) );
				      y_int <= ( std_logic_vector(to_unsigned(0 , ver_width_g)) ); 
					  
					  -- up button pressed
					  when "0010" =>
				      curr_sm <= lower_left_st;
				      x_int <= ( std_logic_vector(to_unsigned(0 , hor_width_g)) );
				      y_int <= ( std_logic_vector(to_unsigned(ver_max_value_g , ver_width_g)) );   
					 
					  -- down button pressed
					  when "0001" =>
					    curr_sm <= right_st;
				      x_int <= ( std_logic_vector(to_unsigned(hor_max_value_g , hor_width_g)) );
				      y_int <= ( std_logic_vector(to_unsigned(1 , ver_width_g)) );
				 		when others =>
				      curr_sm <= upper_right_st;
          end case;
      
        -- lower right corner state (X=hor_max_value_g, Y=ver_max_value_g)
		  when lower_right_st =>
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      curr_sm <= upper_left_st;
				      x_int <= ( std_logic_vector(to_unsigned(0 , hor_width_g)) );
				      y_int <= ( std_logic_vector(to_unsigned(0 , ver_width_g)) ); 
					  
					  -- left button pressed
				    when "0100" =>
				      curr_sm <= lower_st;
				      x_int <= ( std_logic_vector(to_unsigned(hor_max_value_g-1 , hor_width_g)) );
				      y_int <= ( std_logic_vector(to_unsigned(ver_max_value_g , ver_width_g)) ); 
					  
					  -- up button pressed
					  when "0010" =>
				      curr_sm <= right_st;
				      x_int <= ( std_logic_vector(to_unsigned(hor_max_value_g , hor_width_g)) );
				      y_int <= ( std_logic_vector(to_unsigned(ver_max_value_g-1 , ver_width_g)) );   
					 
					  -- down button pressed
					  when "0001" =>
					    curr_sm <= upper_st;
				      x_int <= ( std_logic_vector(to_unsigned(hor_max_value_g-1 , hor_width_g)) );
				      y_int <= ( std_logic_vector(to_unsigned(0 , ver_width_g)) );
				 		when others =>
				      curr_sm <= lower_right_st;
          end case;
      
       -- lower left corner state (X=0, Y=ver_max_value_g)
		   when lower_left_st =>
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      curr_sm <= lower_st;
				      x_int <= ( std_logic_vector(to_unsigned(1 , hor_width_g)) );
				      y_int <= ( std_logic_vector(to_unsigned(ver_max_value_g , ver_width_g)) ); 
					  
					  -- left button pressed
				    when "0100" =>
				      curr_sm <= right_st;
				      x_int <= ( std_logic_vector(to_unsigned(hor_max_value_g , hor_width_g)) );
				      y_int <= ( std_logic_vector(to_unsigned(ver_max_value_g-1 , ver_width_g)) ); 
					  
					  -- up button pressed
					  when "0010" =>
				      curr_sm <= left_st;
				      x_int <= ( std_logic_vector(to_unsigned(0 , hor_width_g)) );
				      y_int <= ( std_logic_vector(to_unsigned(ver_max_value_g-1 , ver_width_g)) );   
					 
					  -- down button pressed
					  when "0001" =>
					    curr_sm <= upper_right_st;
				      x_int <= ( std_logic_vector(to_unsigned(hor_max_value_g , hor_width_g)) );
				      y_int <= ( std_logic_vector(to_unsigned(0 , ver_width_g)) );
				 		when others =>
				      curr_sm <= lower_left_st;
          end case;
          
      -- upper state (X=1..hor_max_value_g-1, Y=0)
		  when upper_st =>
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      x_int <= x_int + 1;
				      y_int <= ( std_logic_vector(to_unsigned(0 , ver_width_g)) );
			
				      if (x_int /= ( std_logic_vector(to_unsigned(hor_max_value_g-1 , hor_width_g)))) then
				        curr_sm <= upper_st;
				      else
				        curr_sm <= upper_right_st;
					    end if;
					    
					  -- left button pressed
				    when "0100" =>
				      x_int <= x_int - 1;
				      y_int <= ( std_logic_vector(to_unsigned(0 , ver_width_g)) ); 
					    
					    if (x_int /= ( std_logic_vector(to_unsigned(1 , hor_width_g)) )) then
				        curr_sm <= upper_st;
				      else
				        curr_sm <= upper_left_st;
					    end if;
					    
					  -- up button pressed
					  when "0010" =>
				      x_int <= x_int + 1;
				      y_int <= ( std_logic_vector(to_unsigned(ver_max_value_g , ver_width_g)) );  
				      
				      if (x_int /= ( std_logic_vector(to_unsigned(hor_max_value_g-1 , hor_width_g)) )) then
				        curr_sm <= lower_st;
				      else
				        curr_sm <= lower_right_st;
					    end if; 
					 
					  -- down button pressed
					  when "0001" =>
					    curr_sm <= inner_st;
				      y_int <= ( std_logic_vector(to_unsigned(1 , ver_width_g)) );
				      
				 		when others =>
				      curr_sm <= upper_st;
          end case;
          
      -- right state (X=hor_max_value_g, Y=1..ver_max_value_g-1)
		  when right_st =>
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      x_int <= ( std_logic_vector(to_unsigned(0 , hor_width_g)) );
				      y_int <= y_int + 1; 
				      
				      if (y_int /= ( std_logic_vector(to_unsigned(ver_max_value_g-1 , ver_width_g)) )) then
				        curr_sm <= left_st;
				      else
				        curr_sm <= lower_left_st;
					    end if;
					  
					  -- left button pressed
				    when "0100" =>
				      curr_sm <= inner_st;
				      x_int <= ( std_logic_vector(to_unsigned(hor_max_value_g-1 , hor_width_g)) );
					  
					  -- up button pressed
					  when "0010" =>				     
				      y_int <= y_int - 1; 
				      
				      if (y_int /= ( std_logic_vector(to_unsigned(1 , ver_width_g)) )) then
				        curr_sm <= right_st;
				      else
				        curr_sm <= upper_right_st;
					    end if;
					 
					  -- down button pressed
					  when "0001" =>
				      y_int <= y_int + 1;
				      
				      if (y_int /= ( std_logic_vector(to_unsigned(ver_max_value_g-1 , ver_width_g)) )) then
				        curr_sm <= right_st;
				      else
				        curr_sm <= lower_right_st;
					    end if;
					    
				 		when others =>
				      curr_sm <= right_st;
          end case;
        
        -- lower state (X=1..hor_max_value_g-1, Y=ver_max_value_g)  
    		  when lower_st => 
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      x_int <= x_int + 1;
					    
					    if (x_int /= ( std_logic_vector(to_unsigned(hor_max_value_g-1 , hor_width_g)) )) then
				        curr_sm <= lower_st;
				      else
				        curr_sm <= lower_right_st;
					    end if;
					    
					  -- left button pressed
				    when "0100" =>
				      x_int <= x_int - 1;
              
              if (x_int /= ( std_logic_vector(to_unsigned(1 , hor_width_g)) )) then
				        curr_sm <= lower_st;
				      else
				        curr_sm <= lower_left_st;
					    end if;
					    
					  
					  -- up button pressed
					  when "0010" =>
				      curr_sm <= inner_st;
				      y_int <= ( std_logic_vector(to_unsigned(ver_max_value_g-1 , ver_width_g)) ); 
					 
					  -- down button pressed
					  when "0001" =>
					    x_int <=  x_int - 1;
				      y_int <= ( std_logic_vector(to_unsigned(0 , ver_width_g)) );
				      
				      if (x_int /= ( std_logic_vector(to_unsigned(1 , hor_width_g)) )) then
				        curr_sm <= upper_st;
				      else
				        curr_sm <= upper_left_st;
					    end if;
				      
				 		when others =>
				      curr_sm <= lower_st;
	        end case;
              
		    -- left state (X=0, Y=1..ver_max_value_g-1)  
    		  when left_st => 
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      curr_sm <= inner_st;
				      x_int <= x_int + 1;
					  
					  -- left button pressed
				    when "0100" =>
				      x_int <= ( std_logic_vector(to_unsigned(hor_max_value_g , hor_width_g)) );
				      y_int <= y_int - 1;
				      
				      if (y_int /= ( std_logic_vector(to_unsigned(1 , ver_width_g)) )) then
				        curr_sm <= right_st;
				      else
				        curr_sm <= upper_right_st;
					    end if;
					  
					  -- up button pressed
					  when "0010" =>
				      y_int <= y_int - 1;
				      
				      if (y_int /= ( std_logic_vector(to_unsigned(1 , ver_width_g)) )) then
				        curr_sm <= left_st;
				      else
				        curr_sm <= upper_left_st;
					    end if;
					    
					  -- down button pressed
					  when "0001" =>
					    y_int <= y_int + 1;
					    
					    if (y_int /= ( std_logic_vector(to_unsigned(ver_max_value_g-1 , ver_width_g)) )) then
				        curr_sm <= left_st;
				      else
				        curr_sm <= lower_left_st;
					    end if;					    
				 		
				 		when others =>
				      curr_sm <= left_st;
		     end case;
		     
		      -- inner state (X=1..hor_max_value_g-1, Y=1..ver_max_value_g-1)
		    when inner_st =>
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      x_int <= x_int + 1; 
				      
				      if (x_int /= ( std_logic_vector(to_unsigned(hor_max_value_g-1 , hor_width_g)) )) then
				        curr_sm <= inner_st;
				      else
				        curr_sm <= right_st;
					    end if;
					  
					  -- left button pressed
				    when "0100" =>
				      x_int <= x_int - 1;
				      
				      if (x_int /= ( std_logic_vector(to_unsigned(1 , hor_width_g)) )) then
				        curr_sm <= inner_st;
				      else
				        curr_sm <= left_st;
					    end if;
				      					  
					  -- up button pressed
					  when "0010" =>
				      y_int <= y_int - 1; 
				      
				      if (y_int /= ( std_logic_vector(to_unsigned(1 , ver_width_g)) )) then
				        curr_sm <= inner_st;
				      else
				        curr_sm <= upper_st;
					    end if;   
					 
					  -- down button pressed
					  when "0001" =>
				      y_int <= y_int + 1;
				      
				      if (y_int /= ( std_logic_vector(to_unsigned(ver_max_value_g-1 , ver_width_g)) )) then
				        curr_sm <= inner_st;
				      else
				        curr_sm <= lower_st;
					    end if;
				      
				 		when others =>
				      curr_sm <= inner_st;
          end case;
      end case;
    end if;
  end process fsm_proc;
  x_out <= x_int;
  y_out <= y_int;
end architecture x_y_location_rtl;