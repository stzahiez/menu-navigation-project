------------------------------------------------------------------------------------------------
-- Model Name 	:	clk_reset_model
-- File Name	:	clk_reset_model.vhd
-- Generated	:	27.10.2012
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description:
-- This file generates the clock and the initial reset for the TB system
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date			Name				Description			
--			1.00		27.10.2012		Olga Liberman		Creation
------------------------------------------------------------------------------------------------
--	Todo:
--	(1) 
------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all ;

entity clk_reset_model is
	generic(
		reset_polarity_g			:	std_logic 	:= '0'; --Reset Polarity. '0' = Reset
		init_reset_length_cycles_g	:	positive := 4;
		clk_half_period_g			:	time	:= 5 ns;
		pixel_clk_half_period_g		:	time	:= 19.861 ns -- pixel clock for 640x480 @ 60 Hz = 25.175 MHz
	);
	port (
		clk : out std_logic; -- the main clock to which all the internal logic of the Symbol Generator block is synchronized.
		pixel_clk : out std_logic; -- pixel clock for the VESA standard
		reset : out std_logic -- asynchronous reset
	);
  
end entity clk_reset_model;



architecture sim_clk_reset_model of clk_reset_model is
	signal clk_i : std_logic := '1';
	signal pixel_clk_i : std_logic := '1';
	
begin

	clk_proc:
	clk_i	<=	not clk_i after clk_half_period_g;
	clk <= clk_i;
	
	pixel_clk_proc:
	pixel_clk_i	<=	not pixel_clk_i after pixel_clk_half_period_g;
	pixel_clk <= pixel_clk_i;
	
	rst_proc:
	reset	<=	reset_polarity_g, not(reset_polarity_g) after init_reset_length_cycles_g*2*clk_half_period_g;

end architecture sim_clk_reset_model;