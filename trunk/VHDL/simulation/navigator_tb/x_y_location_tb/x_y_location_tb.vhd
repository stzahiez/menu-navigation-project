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
use Ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- For "+", "-",... 
use ieee.numeric_std.all; -- For to_unsigned() function 
use ieee.math_real.ALL;   -- For uniform, trunc functions

entity x_y_location_TB is
end entity x_y_location_TB;

architecture sim_x_y_location_TB of x_y_location_TB is
--############################# Constants ############################################--
  constant reset_polarity_c  : std_logic := '1';
  constant hor_width_c  : 		positive	:= 5; 
  constant ver_width_c  : 		positive	:= 4;
  constant hor_width_zeros_c : std_logic_vector(hor_width_c-1 downto 0) := (others => '0');
  constant ver_width_zeros_c : std_logic_vector(ver_width_c-1 downto 0) := (others => '0');
  constant loop_size_c  : positive := 100; 
  constant num_of_directions_c  : real := 4.0;
  constant hor_max_value_c  : positive	:= 19; 
  constant ver_max_value_c  : positive	:= 14;
  constant max_interval_time_c  : real := 1000.0; -- Maximum time interval beteen button press check in ns 	  

--#############################	Components	##############################################--
	  
  component x_y_location 
	  generic(
	    hor_width_g  : 		positive	:= hor_width_c; 	-- The width of horizonal output lines, needed to hold the maximum horizontal location value.
      ver_width_g  : 		positive	:= ver_width_c; 	-- The width of horizonal output lines, needed to hold the maximum horizontal location value.
      reset_polarity_g  :   std_logic := reset_polarity_c;  -- The reset polarity of the system.
      hor_max_value_g  : 		positive	:= hor_max_value_c; 	-- The maximum horizontal location value.
      ver_max_value_g  : 		positive	:= ver_max_value_c 	-- The  maximum vertical location value.
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

   --############################# types ################################################--
	
	type direct_t is (right, left, up, down);-- Enum types for buttons pressed
	type state_t is (right_st, left_st, upper_st, lower_st, upper_right_st, upper_left_st,
  lower_right_st, lower_left_st, inner_st); -- Enum types for fsm states


	--#############################	Signals ##############################################--
	
	signal clk 				: 	 std_logic:= '0';
	signal reset     :   std_logic; 
	signal x_out	    : 	 std_logic_vector(hor_width_c-1 downto 0) := (others => '0');
	signal y_out   	 : 	 std_logic_vector(ver_width_c-1 downto 0) := (others => '0');
	signal curr_sm 			: 	state_t := upper_left_st;
	signal right_trig     :   bit := '0';
	signal left_trig     :   bit := '0';
	signal up_trig     :   bit := '0';
	signal down_trig     :   bit := '0';
	signal hor_value : std_logic_vector(hor_width_c-1 downto 0) := (others => '0');
	signal ver_value : std_logic_vector(ver_width_c-1 downto 0) := (others => '0');


		


begin
	
	--#############################	Instantiaion ##############################################--
	
	x_y_location_inst : x_y_location
	  generic map(
	    hor_width_g => hor_width_c,
	    ver_width_g => ver_width_c,
	    reset_polarity_g => reset_polarity_c,
	    hor_max_value_g => hor_max_value_c,
	    ver_max_value_g => ver_max_value_c
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
		-- Reset generator	
	reset_proc: process
		begin
		reset <= not reset_polarity_c;
		wait for 1 ns;
		
		-- Check output data is '0' after reset signal goes high  
		reset <= reset_polarity_c;
		wait for 1 ns; 
		
		assert (x_out = hor_width_zeros_c)
    report "Reset data output check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: 0 "
    severity error ;
    
    assert (y_out = ver_width_zeros_c)
    report "Reset data output check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: 0 "    
    severity error ;
		
		reset <= not reset_polarity_c;
		wait for 5 ns;
		
		-- Check data is still '0' after reset signal goes low  
		
		wait until	reset = '0'; 
		
		assert (x_out = hor_width_zeros_c)
    report "Reset data output check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: 0  "     
    severity error ;
    
    assert (y_out = ver_width_zeros_c)
    report "Reset data output check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: 0 "   
    severity error ;
		
  		wait;
    
		end process reset_proc;
		
		direction_trig_proc: process
		variable seed1_v, seed2_v : positive; -- Seed values for random generator rand1_v
	  variable rand1_v : real; -- Random real-number value in range 0 to 1.0
	  variable direct_rand_v : integer range 0 to 3;
	  variable interval_rand_v : time range 0 ns to 1000 ns; -- Random time interval beteen button press check in ns 
	  variable seed3_v, seed4_v : positive; -- Seed values for random generator rand2_v
	  variable rand2_v : real; -- Random real-number value in range 0 to 1.0
	  
		begin
		  wait until clk = '1';
		  for I in 0 to (loop_size_c -1)  loop
		    
		    -- Generate random numbers
        uniform(seed1_v, seed2_v, rand1_v);     
	      direct_rand_v := integer(trunc(num_of_directions_c*rand1_v)); -- Rescale to 0..3, find integer part
	      	      
 		    case direct_rand_v is
	        when 0 =>       
	          right_trig <= '1'; 
            wait for 10 ns;
	          right_trig <= '0';    
          when 1 =>       
	          left_trig <= '1';
	          wait for 10 ns;
	          left_trig <= '0';          
          when 2 =>       
	          up_trig <= '1';
            wait for 10 ns;
            up_trig <= '0';
          when 3 =>       
	          down_trig <= '1';
            wait for 10 ns;
            down_trig <= '0';
        end case;
        uniform(seed3_v, seed4_v, rand2_v);     
        interval_rand_v := trunc(max_interval_time_c*rand2_v)*1 ns; -- Rescale to 0..1000ns, find integer part

        wait for interval_rand_v;
        
      end loop;
  end process direction_trig_proc;
		

	  -- Pressing generator
	  fsm_proc: process
	  	  	
	  begin
	    
	    wait until clk = '1';	    
	       	   
	    for I in 0 to (loop_size_c -1)  loop
        if rising_edge(clk) then
	      case curr_sm is
			
			    -- upper left corner state (X=0, Y=0)
				  when upper_left_st =>
				    case right_trig&left_trig&up_trig&down_trig is
				    
				      -- right button pressed
				      when "1000" =>
				        curr_sm <= upper_st;
				        hor_value <= ( std_logic_vector(to_unsigned(1 , hor_width_c)) );
				        ver_value <= ( std_logic_vector(to_unsigned(0 , ver_width_c)) ); 
					  
					    -- left button pressed
				      when "0100" =>
				        curr_sm <= lower_right_st;
				        hor_value <= ( std_logic_vector(to_unsigned(hor_max_value_c , hor_width_c)) );
				        ver_value <= ( std_logic_vector(to_unsigned(ver_max_value_c , ver_width_c)) ); 
					  
					    -- up button pressed
					    when "0010" =>
				        curr_sm <= lower_st;
				        hor_value <= ( std_logic_vector(to_unsigned(1 , hor_width_c)) );
				        ver_value <= ( std_logic_vector(to_unsigned(ver_max_value_c , ver_width_c)) );   
					 
					    -- down button pressed
					    when "0001" =>
					      curr_sm <= left_st;
				        hor_value <= ( std_logic_vector(to_unsigned(0 , hor_width_c)) );
				        ver_value <= ( std_logic_vector(to_unsigned(1 , ver_width_c)) );
				  
				      when others =>
				        curr_sm <= upper_left_st;		    
            end case;
				    
				  -- upper right corner state (X=hor_max_value_c, Y=0)
			  when upper_right_st =>
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      curr_sm <= left_st;
				      hor_value <= ( std_logic_vector(to_unsigned(0 , hor_width_c)) );
				      ver_value <= ( std_logic_vector(to_unsigned(1 , ver_width_c)) ); 
					  
					  -- left button pressed
				    when "0100" =>
				      curr_sm <= upper_st;
				      hor_value <= ( std_logic_vector(to_unsigned(hor_max_value_c-1 , hor_width_c)) );
				      ver_value <= ( std_logic_vector(to_unsigned(0 , ver_width_c)) ); 
					  
					  -- up button pressed
					  when "0010" =>
				      curr_sm <= lower_left_st;
				      hor_value <= ( std_logic_vector(to_unsigned(0 , hor_width_c)) );
				      ver_value <= ( std_logic_vector(to_unsigned(ver_max_value_c , ver_width_c)) );   
					 
					  -- down button pressed
					  when "0001" =>
					    curr_sm <= right_st;
				      hor_value <= ( std_logic_vector(to_unsigned(hor_max_value_c , hor_width_c)) );
				      ver_value <= ( std_logic_vector(to_unsigned(1 , ver_width_c)) );
				 		when others =>
				      curr_sm <= upper_right_st;
          end case;
      
        -- lower right corner state (X=hor_max_value_c, Y=ver_max_value_c)
		    when lower_right_st =>
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      curr_sm <= upper_left_st;
				      hor_value <= ( std_logic_vector(to_unsigned(0 , hor_width_c)) );
				      ver_value <= ( std_logic_vector(to_unsigned(0 , ver_width_c)) ); 
					  
					  -- left button pressed
				    when "0100" =>
				      curr_sm <= lower_st;
				      hor_value <= ( std_logic_vector(to_unsigned(hor_max_value_c-1 , hor_width_c)) );
				      ver_value <= ( std_logic_vector(to_unsigned(ver_max_value_c , ver_width_c)) ); 
					  
					  -- up button pressed
					  when "0010" =>
				      curr_sm <= right_st;
				      hor_value <= ( std_logic_vector(to_unsigned(hor_max_value_c , hor_width_c)) );
				      ver_value <= ( std_logic_vector(to_unsigned(ver_max_value_c-1 , ver_width_c)) );   
					 
					  -- down button pressed
					  when "0001" =>
					    curr_sm <= upper_st;
				      hor_value <= ( std_logic_vector(to_unsigned(hor_max_value_c-1 , hor_width_c)) );
				      ver_value <= ( std_logic_vector(to_unsigned(0 , ver_width_c)) );
				 		when others =>
				      curr_sm <= lower_right_st;
          end case;
      
        -- lower left corner state (X=0, Y=ver_max_value_c)
		    when lower_left_st =>
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      curr_sm <= lower_st;
				      hor_value <= ( std_logic_vector(to_unsigned(1 , hor_width_c)) );
				      ver_value <= ( std_logic_vector(to_unsigned(ver_max_value_c , ver_width_c)) ); 
					  
					  -- left button pressed
				    when "0100" =>
				      curr_sm <= right_st;
				      hor_value <= ( std_logic_vector(to_unsigned(hor_max_value_c , hor_width_c)) );
				      ver_value <= ( std_logic_vector(to_unsigned(ver_max_value_c-1 , ver_width_c)) ); 
					  
					  -- up button pressed
					  when "0010" =>
				      curr_sm <= left_st;
				      hor_value <= ( std_logic_vector(to_unsigned(0 , hor_width_c)) );
				      ver_value <= ( std_logic_vector(to_unsigned(ver_max_value_c-1 , ver_width_c)) );   
					 
					  -- down button pressed
					  when "0001" =>
					    curr_sm <= upper_right_st;
				      hor_value <= ( std_logic_vector(to_unsigned(hor_max_value_c , hor_width_c)) );
				      ver_value <= ( std_logic_vector(to_unsigned(0 , ver_width_c)) );
				 		when others =>
				      curr_sm <= lower_left_st;
          end case;
          
        -- upper state (X=1..hor_max_value_c-1, Y=0)
		    when upper_st =>
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      hor_value <= hor_value + 1;
				      ver_value <= ( std_logic_vector(to_unsigned(0 , ver_width_c)) );
			
				      if (hor_value /= ( std_logic_vector(to_unsigned(hor_max_value_c-1 , hor_width_c)))) then
				        curr_sm <= upper_st;
				      else
				        curr_sm <= upper_right_st;
					    end if;
					    
					  -- left button pressed
				    when "0100" =>
				      hor_value <= hor_value - 1;
				      ver_value <= ( std_logic_vector(to_unsigned(0 , ver_width_c)) ); 
					    
					    if (hor_value /= ( std_logic_vector(to_unsigned(1 , hor_width_c)) )) then
				        curr_sm <= upper_st;
				      else
				        curr_sm <= upper_left_st;
					    end if;
					    
					  -- up button pressed
					  when "0010" =>
				      hor_value <= hor_value + 1;
				      ver_value <= ( std_logic_vector(to_unsigned(ver_max_value_c , ver_width_c)) );  
				      
				      if (hor_value /= ( std_logic_vector(to_unsigned(hor_max_value_c-1 , hor_width_c)) )) then
				        curr_sm <= lower_st;
				      else
				        curr_sm <= lower_right_st;
					    end if; 
					 
					  -- down button pressed
					  when "0001" =>
					    curr_sm <= inner_st;
				      ver_value <= ( std_logic_vector(to_unsigned(1 , ver_width_c)) );
				      
				 		when others =>
				      curr_sm <= upper_st;
          end case;
          
        -- right state (X=hor_max_value_c, Y=1..ver_max_value_c-1)
		    when right_st =>
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      hor_value <= ( std_logic_vector(to_unsigned(0 , hor_width_c)) );
				      ver_value <= ver_value + 1; 
				      
				      if (ver_value /= ( std_logic_vector(to_unsigned(ver_max_value_c-1 , ver_width_c)) )) then
				        curr_sm <= left_st;
				      else
				        curr_sm <= lower_left_st;
					    end if;
					  
					  -- left button pressed
				    when "0100" =>
				      curr_sm <= inner_st;
				      hor_value <= ( std_logic_vector(to_unsigned(hor_max_value_c-1 , hor_width_c)) );
					  
					  -- up button pressed
					  when "0010" =>				     
				      ver_value <= ver_value - 1; 
				      
				      if (ver_value /= ( std_logic_vector(to_unsigned(1 , ver_width_c)) )) then
				        curr_sm <= right_st;
				      else
				        curr_sm <= upper_right_st;
					    end if;
					 
					  -- down button pressed
					  when "0001" =>
				      ver_value <= ver_value + 1;
				      
				      if (ver_value /= ( std_logic_vector(to_unsigned(ver_max_value_c-1 , ver_width_c)) )) then
				        curr_sm <= right_st;
				      else
				        curr_sm <= lower_right_st;
					    end if;
					    
				 		when others =>
				      curr_sm <= right_st;
          end case;
        
        -- lower state (X=1..hor_max_value_c-1, Y=ver_max_value_c)  
    		  when lower_st => 
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      hor_value <= hor_value + 1;
					    
					    if (hor_value /= ( std_logic_vector(to_unsigned(hor_max_value_c-1 , hor_width_c)) )) then
				        curr_sm <= lower_st;
				      else
				        curr_sm <= lower_right_st;
					    end if;
					    
					  -- left button pressed
				    when "0100" =>
				      hor_value <= hor_value - 1;
              
              if (hor_value /= ( std_logic_vector(to_unsigned(1 , hor_width_c)) )) then
				        curr_sm <= lower_st;
				      else
				        curr_sm <= lower_left_st;
					    end if;
					    
					  
					  -- up button pressed
					  when "0010" =>
				      curr_sm <= inner_st;
				      ver_value <= ( std_logic_vector(to_unsigned(ver_max_value_c-1 , ver_width_c)) ); 
					 
					  -- down button pressed
					  when "0001" =>
					    hor_value <=  hor_value - 1;
				      ver_value <= ( std_logic_vector(to_unsigned(0 , ver_width_c)) );
				      
				      if (hor_value /= ( std_logic_vector(to_unsigned(1 , hor_width_c)) )) then
				        curr_sm <= upper_st;
				      else
				        curr_sm <= upper_left_st;
					    end if;
				      
				 		when others =>
				      curr_sm <= lower_st;
	        end case;
              
		    -- left state (X=0, Y=1..ver_max_value_c-1)  
    		  when left_st => 
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      curr_sm <= inner_st;
				      hor_value <= hor_value + 1;
					  
					  -- left button pressed
				    when "0100" =>
				      hor_value <= ( std_logic_vector(to_unsigned(hor_max_value_c , hor_width_c)) );
				      ver_value <= ver_value - 1;
				      
				      if (ver_value /= ( std_logic_vector(to_unsigned(1 , ver_width_c)) )) then
				        curr_sm <= right_st;
				      else
				        curr_sm <= upper_right_st;
					    end if;
					  
					  -- up button pressed
					  when "0010" =>
				      ver_value <= ver_value - 1;
				      
				      if (ver_value /= ( std_logic_vector(to_unsigned(1 , ver_width_c)) )) then
				        curr_sm <= left_st;
				      else
				        curr_sm <= upper_left_st;
					    end if;
					    
					  -- down button pressed
					  when "0001" =>
					    ver_value <= ver_value + 1;
					    
					    if (ver_value /= ( std_logic_vector(to_unsigned(ver_max_value_c-1 , ver_width_c)) )) then
				        curr_sm <= left_st;
				      else
				        curr_sm <= lower_left_st;
					    end if;					    
				 		
				 		when others =>
				      curr_sm <= left_st;
		     end case;
		     
		      -- inner state (X=1..hor_max_value_c-1, Y=1..ver_max_value_c-1)
		    when inner_st =>
				  case right_trig&left_trig&up_trig&down_trig is
				    
				    -- right button pressed
				    when "1000" =>
				      hor_value <= hor_value + 1; 
				      
				      if (hor_value /= ( std_logic_vector(to_unsigned(hor_max_value_c-1 , hor_width_c)) )) then
				        curr_sm <= inner_st;
				      else
				        curr_sm <= right_st;
					    end if;
					    
					  -- left button pressed
				    when "0100" =>
				      hor_value <= hor_value - 1;
				      
				      if (hor_value /= ( std_logic_vector(to_unsigned(1 , hor_width_c)) )) then
				        curr_sm <= inner_st;
				      else
				        curr_sm <= left_st;
					    end if;
				      					  
					  -- up button pressed
					  when "0010" =>
				      ver_value <= ver_value - 1;
				      
				      if (ver_value /= ( std_logic_vector(to_unsigned(1 , ver_width_c)) )) then
				        curr_sm <= inner_st;
				      else
				        curr_sm <= upper_st;
					    end if;  
					 
					  -- down button pressed
					  when "0001" =>
				      ver_value <= ver_value + 1;
				      
				      if (ver_value /= ( std_logic_vector(to_unsigned(ver_max_value_c-1 , ver_width_c)) )) then
				        curr_sm <= inner_st;
				      else
				        curr_sm <= lower_st;
					    end if;
					    
				 		when others =>
				      curr_sm <= inner_st;
          end case;
      end case;  
	    
	    wait until clk = '0';
	       
	      
      assert (x_out = hor_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " x_out: " & integer'image(to_integer(unsigned(x_out))) & " expected: " & integer'image(to_integer(unsigned(hor_value)))      
      severity error ;
      
      assert (y_out = ver_value)
      report "Pressing trigger concept check error was found at: " & time'image(now) & " y_out: " & integer'image(to_integer(unsigned(y_out))) & " expected: " & integer'image(to_integer(unsigned(ver_value)))      
      severity error ;

     end if;
      
    end loop;
      
    end process fsm_proc; 
    
    -- clk generator
	  clk_proc: 
	  clk	<=	not clk after 5 ns;
    

      
end architecture sim_x_y_location_TB;


