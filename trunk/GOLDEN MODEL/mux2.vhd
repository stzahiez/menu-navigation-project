------------------------------------------------------------------------------------------------
-- Model Name 	:	mux2
-- File Name	:	mux2.vhd
-- Generated	:	11.6.2012
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description:
--
--
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date			Name								Description			
--			1.00		12.06.2012	   	Olga Liberman and Yoav Shvartz		Creation
--			2.00		13.06.2012		Olga Liberman and Yoav Shvartz		added the inputs: fifo_a_rd_en and fifo_b_rd_en
--			2.01		16.07.2012		Olga Liberman						fifo_a_rd_en and fifo_b_rd_en names are chamged to rd_en_a and rd_en_b
--																			width_g generic is added
--			2.02		13.02.2013		Olga & Yoav							adding another sample of data_valid from fifos A and B 
------------------------------------------------------------------------------------------------
--	Todo:
--	(1) maybe need to delay in 1-2 clocks the mux_dout (sample the fifo_x_rd_en signal), because of the fifo delay.
--	(2) 
--	(3)
------------------------------------------------------------------------------------------------


library ieee;
use IEEE.std_logic_1164.all;

entity mux2 is
	generic (
		width_g			:		positive	:= 8 							-- Width of data
	);
	port (
		clk 		    : 		in std_logic;                       		-- the main clock to which all the internal logic of the Symbol Generator block is synchronized.
		reset_n 	  	: 		in std_logic;                       		-- asynchronous reset
		mux_din_a 		: 		in std_logic_vector(width_g-1 downto 0);    -- data from fifo_a
		mux_din_b 		: 		in std_logic_vector(width_g-1 downto 0);    -- data from fifo_b
		--mux_sel 	  	: 		in std_logic;                       		-- selection of enteries: mux_sel='0' -> mux_din_a , mux_sel='1' -> mux_din_b
		rd_en_a 		: 		in std_logic; 								-- read enable to fifo a
		rd_en_b 		: 		in std_logic; 								-- read enable to fifo b
		fifo_a_dout_valid : in std_logic;
		fifo_b_dout_valid : in std_logic;
		mux_dout_valid: out std_logic;
		mux_dout	  	: 		out std_logic_vector(width_g-1 downto 0)    -- data out to DC FIFO
	);
  
end entity mux2;

architecture mux2_rtl of mux2 is

	--signal mux_din_a_i : std_logic_vector(7 downto 0);
	--signal mux_din_b_i : std_logic_vector(7 downto 0);
	signal fifo_a_dout_valid_d : std_logic;
	signal fifo_b_dout_valid_d : std_logic;
	signal fifo_a_dout_valid_dd : std_logic;
	signal fifo_b_dout_valid_dd : std_logic;

begin
  --mux_din_a_i <= mux_din_a;
  --mux_din_b_i <= mux_din_b;
	
	fifo_valid_proc : process(clk,reset_n)
	begin
		if (reset_n='0') then
			fifo_a_dout_valid_d <= '0';
			fifo_b_dout_valid_d <= '0';
			fifo_a_dout_valid_dd <= '0';
			fifo_b_dout_valid_dd <= '0';
			
		elsif rising_edge(clk) then
			fifo_a_dout_valid_d <= fifo_a_dout_valid;
			fifo_b_dout_valid_d <= fifo_b_dout_valid;
			
			fifo_a_dout_valid_dd <= fifo_a_dout_valid_d; ------------- 13.02.2013
			fifo_b_dout_valid_dd <= fifo_b_dout_valid_d; ------------- 13.02.2013
			
		end if;
	end process fifo_valid_proc;
	
	--mux_dout_valid <= ( fifo_a_dout_valid and fifo_a_dout_valid_d) or ( fifo_b_dout_valid and fifo_b_dout_valid_d); -- original
	mux_dout_valid <= ( fifo_a_dout_valid_d or  fifo_a_dout_valid_dd) or ( fifo_b_dout_valid_d or fifo_b_dout_valid_dd); ------------- 13.02.2013
	
	
	mux_proc: process(clk, reset_n)
    begin
		if (reset_n='0') then
			--mux_din_a_i <= (others=>'0');
			--mux_din_b_i <= (others=>'0');
			mux_dout <= (others=>'0');
		elsif rising_edge(clk) then
			
			-- if (mux_sel = '0') then
				-- mux_dout <= mux_din_a_i;
			-- elsif (mux_sel = '1') then
				-- mux_dout <= mux_din_b_i;
			-- end if;
			
			if ( rd_en_a = '1' ) then
				mux_dout <= mux_din_a;
			elsif ( rd_en_b = '1' ) then
				mux_dout <= mux_din_b;
			else
				mux_dout <= (others=>'0');
			end if;
			
		end if;
		
	end process mux_proc;  
  
end architecture mux2_rtl;
  