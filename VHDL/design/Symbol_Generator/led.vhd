------------------------------------------------------------------------------------------------
-- Model Name 	:	LED
-- File Name	:	led.vhd
-- Generated	:	22.03.2013
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description:
-- The LED block is one of the system's clients.
-- The output 'led_out' is directed to a led in a flickering mode
-- The led changes its polarity in the frequency of timer_freq_g [Hz]
------------------------------------------------------------------------------------------------
-- Revision:
-- Number	Date		Name				Description
-- 1.00		22.03.2013	Olga Liberman		Creation
--
------------------------------------------------------------------------------------------------
--	Todo:
--
------------------------------------------------------------------------------------------------

library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all;

entity led is
	generic(
		reset_polarity_g	:	std_logic := '0'; -- reset polarity: '0' active low, '1' active high
		timer_freq_g		:	positive :=1;    -- timer_tick will raise for 1 sys_clk period every timer_freq_g. units: [Hz]
		clk_freq_g			:	positive :=100000000 -- the clock input to the block. this is the clock used in the system containing the timer unit. units: [Hz]
	);
	port(
		clk					:	in std_logic;	--System clock
		reset				:	in std_logic;	--System Reset
		enable        		:	in std_logic; --determines if the led is enabled
		led_out				:	out std_logic --this signals activates the led: '1' led is turned on, '0' led is turned off 
	);
	
end entity led;

architecture led_rtl of led is

------------------------- Constants	-------------------------
constant tick_cycle_c       :	natural := clk_freq_g/timer_freq_g; -- number of clk cycles in order to recieve a tick 

------------------------- Signals	-------------------------
-- timer
signal timer_counter		:	natural range 0 to tick_cycle_c;  --
signal timer_tick			:	std_logic;
-- led
signal led_i				:	std_logic;

begin

led_out <= led_i;

-------------------------------------------------------------
-- Implementing the timer_tick that is active for 1 clk in
-- frequency of timer_freq_g
timer_proc : process(clk, reset)
begin
		if (reset = reset_polarity_g) then
			timer_counter <= 0;
			timer_tick <= '0'; 
		elsif rising_edge(clk)then
			if (enable = '1') then
				if timer_counter = tick_cycle_c then
					timer_tick <= '1';
					timer_counter <=0;
				else
					timer_tick <= '0';
					timer_counter <= timer_counter +1;
				end if;
			else
				timer_counter <= 0;
				timer_tick <='0';
			end if; 
		end if;
end process timer_proc;


-------------------------------------------------------------
-- Implementing the led, which changes its polarity every time
-- the signal timer_tick is active
led_proc: process(clk, reset)
begin
	if (reset = reset_polarity_g) then
		led_i <= '0';
	elsif rising_edge(clk) then
		if (enable = '1') then
			if (timer_tick = '1') then
				led_i <= not(led_i);
			end if;
		else
			led_i <= '0';
		end if;
	end if;
end process led_proc;


end architecture led_rtl;