------------------------------------------------------------------------------------------------
-- Model Name 	:	sdram symbol model
-- File Name	:	sdram_symbol_model.vhd
-- Generated	:	15.06.2012
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description:
-- The "File Log" model creates a text log file (using the generic for the name of the file)
-- 
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date		  Name				Description			
--			1.00		15.06.2012	  Yoav Shvartz 		Creation
--			2.00		22.08.2012	  Olga Liberman 		Creation

------------------------------------------------------------------------------------------------
--	Todo:
--	(1) 
--  (2) 
------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use std.textio.all;
use work.txt_util.all;
 
 
entity file_log is
	generic(
        log_file		:       string  := "log_file"
    );
	port(
		clk				: 		in std_logic;
		reset_n			: 		in std_logic;
		--fifo_a_rd_en 	: 		in std_logic; 						-- read enable to fifo a
		--fifo_b_rd_en 	: 		in std_logic; 						-- read enable to fifo b
		mux_dout_valid	: in std_logic;
		mux_dout	  	: 		in std_logic_vector(7 downto 0);    -- data out to DC FIFO
		vsync			:		in std_logic
	);
end file_log;
   
   
architecture log_to_file_rtl of file_log is
  
  
    -- signal clk            : std_logic := '0';
    -- signal reset_n        : std_logic := '0';
    -- signal fifo_a_rd_en 	: 		 std_logic; 						-- read enable to fifo a
    -- signal fifo_b_rd_en 	: 		 std_logic; 						-- read enable to fifo b
    -- signal mux_dout	  	: 		 std_logic_vector(7 downto 0);    -- data out to DC FIFO
	-- signal vsync : std_logic;
	file file_pointer : text;
	
begin


-- each vsync, create new text log file
create_file_proc: process( reset_n, vsync )
	variable cnt : integer := 0;
begin
	if (reset_n='0') and (cnt>0) then
		cnt := cnt + 10;
	elsif rising_edge(vsync) then
		-- if (not(file_pointer)) then
			file_close(file_pointer);
		-- end if;
		if cnt<10 then
			file_open(file_pointer,log_file&"_0"&str(cnt)&".txt",WRITE_MODE);
		else
			file_open(file_pointer,log_file&"_"&str(cnt)&".txt",WRITE_MODE);
		end if;
		cnt := cnt+1;
	end if;	
end process create_file_proc;

-- write data and control information to a file
receive_data_proc: process
	variable l: line;  
begin                                       
	
	wait until reset_n='1';
	while true loop  
		--wait until ( (clk = '1') and ( (fifo_a_rd_en = '1') or (fifo_b_rd_en = '1') ) );
		wait until ( (clk = '1') and (mux_dout_valid = '1') );
		-- if (rising_edge(fifo_a_rd_en) or rising_edge(fifo_b_rd_en)) then
			-- wait until clk = '1';
			-- wait until clk = '1';
		-- end if;
		wait until clk = '0';
		write(l, str(mux_dout) );
		writeline(file_pointer, l);
		-- print(file_pointer, str(mux_dout));
	end loop;

 end process receive_data_proc;
 
 
 
 
-----------------------------TB_start------------------------
-- clk_proc:
-- clk	<=	not clk after 5 ns;

-- rst_proc:
-- reset_n	<=	'1','0' after 20 ns, '1' after 40 ns;

-- -- the tests
-- assign_proc: process
-- begin
  -- -- fifo_a_rd_en <='0';
  -- -- fifo_b_rd_en <='0';
  -- -- symbol_num <= "0010";
  -- -- wait for 10 ns;
  -- -- mux_dout	<= "00000000";
  -- -- wait for 40 ns;
  -- -- fifo_a_rd_en <='1';
  -- -- wait for 10 ns;
  -- -- mux_dout	<= "10000001";
  -- -- wait for 10 ns;
  -- -- fifo_a_rd_en <='0';
  -- -- fifo_b_rd_en <='1';
  -- -- wait for 10 ns;
  -- -- mux_dout	<= "00000001";
  -- -- wait for 10 ns;

	-- fifo_a_rd_en <='0';
	-- fifo_b_rd_en <='0';
	-- mux_dout <= "00000000";
	-- vsync <= '0';
	-- wait for 50 ns;
	
	-- ---------------------------
		-- vsync <= '1';
		-- wait for 20 ns;
		-- vsync <= '0';
		-- wait for 20 ns;
		
		-- wait until clk = '1';
		-- fifo_a_rd_en <='1';
		-- wait for 10 ns;
		-- fifo_a_rd_en <='0';
		-- mux_dout <= "00000001";
		-- wait for 10 ns;
		
	-- ---------------------------
	
		-- vsync <= '1';
		-- wait for 20 ns;
		-- vsync <= '0';
		-- wait for 20 ns;
		
		-- wait until clk = '1';
		-- fifo_a_rd_en <='1';
		-- wait for 10 ns;
		-- mux_dout <= "00000001";
		-- fifo_a_rd_en <='0';
		-- wait for 10 ns;
		
		-- wait until clk = '1';
		-- fifo_a_rd_en <='1';
		-- wait for 10 ns;
		-- mux_dout <= "00000010";
		-- fifo_a_rd_en <='0';
		-- wait for 10 ns;
		
	-- ---------------------------
	
		-- vsync <= '1';
		-- wait for 20 ns;
		-- vsync <= '0';
		-- wait for 20 ns;
		
		-- wait until clk = '1';
		-- fifo_a_rd_en <='1';
		-- wait for 10 ns;
		-- mux_dout <= "00000001";
		-- fifo_a_rd_en <='0';
		-- wait for 10 ns;
		
		-- wait until clk = '1';
		-- fifo_a_rd_en <='1';
		-- wait for 10 ns;
		-- mux_dout <= "00000010";
		-- fifo_a_rd_en <='0';
		-- wait for 10 ns;
		
		-- wait until clk = '1';
		-- fifo_a_rd_en <='1';
		-- wait for 10 ns;
		-- mux_dout <= "00000011";
		-- fifo_a_rd_en <='0';
		-- wait for 10 ns;
		
	-- ---------------------------
	
		-- vsync <= '1';
		-- wait for 20 ns;
		-- vsync <= '0';
		-- wait for 20 ns;
		
		-- wait until clk = '1';
		-- fifo_a_rd_en <='1';
		-- wait for 10 ns;
		-- mux_dout <= "00000001";
		-- fifo_a_rd_en <='0';
		-- wait for 10 ns;
		
		-- wait until clk = '1';
		-- fifo_a_rd_en <='1';
		-- wait for 10 ns;
		-- mux_dout <= "00000010";
		-- fifo_a_rd_en <='0';
		-- wait for 10 ns;
		
		-- wait until clk = '1';
		-- fifo_a_rd_en <='1';
		-- wait for 10 ns;
		-- mux_dout <= "00000011";
		-- fifo_a_rd_en <='0';
		-- wait for 10 ns;
		
		-- wait until clk = '1';
		-- fifo_a_rd_en <='1';
		-- wait for 10 ns;
		-- mux_dout <= "00000100";
		-- fifo_a_rd_en <='0';
		-- wait for 10 ns;
		
		-- wait for 50 ns;
		

	
	-- vsync <= '0';
	-- wait for 300 ns;
	-- wait;
  
  
-- end process assign_proc;

-----------------------------TB_end------------------------

end architecture log_to_file_rtl;
 