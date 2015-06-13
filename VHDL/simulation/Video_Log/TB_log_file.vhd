library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


entity tb_file_log is
end tb_file_log;


architecture structure of tb_file_log is


component file_log
  generic (
           log_file:       string  := "res.log"
          );
  port(
		symbol_num		:	in	std_logic_vector(3 downto 0);		-- number of symbol
   clk              : in std_logic;
   reset_n              : in std_logic;
	  fifo_a_rd_en 	: 		in std_logic; 						-- read enable to fifo a
		fifo_b_rd_en 	: 		in std_logic; 						-- read enable to fifo b
		mux_dout	  	: 		in std_logic_vector(7 downto 0)    -- data out to DC FIFO
      );
end component;

	signal symbol_num		:		std_logic_vector(3 downto 0);		-- number of symbol
   signal clk              :  std_logic :='0' ;
   signal reset_n              :  std_logic;
	 signal fifo_a_rd_en 	: 		 std_logic; 						-- read enable to fifo a
	signal	fifo_b_rd_en 	: 		 std_logic; 						-- read enable to fifo b
	signal	mux_dout	  	: 		 std_logic_vector(7 downto 0);    -- data out to DC FIFO


begin


U_FILE_LOG: FILE_LOG
   port map (
     clk => clk,
    symbol_num  => symbol_num,
    reset_n  => reset_n,
    fifo_a_rd_en   => fifo_a_rd_en,
    fifo_b_rd_en   => fifo_b_rd_en,
	mux_dout   => mux_dout
   );

   clk_proc:
   clk	<=	not clk after 5 ns;
   reset_n	<=	'0', '1' after 20 ns;
   
   
   tb: process
  begin
  mux_dout	<= "00000000";
  fifo_a_rd_en <='0';
  fifo_b_rd_en <='0';
  symbol_num <= "0010";
  wait for 40 ns;
  mux_dout	<= "00000100";
  fifo_a_rd_en <='1';
  wait for 10 ns;
  mux_dout	<= "10000001";
  fifo_a_rd_en <='0';
  fifo_b_rd_en <='1';
  wait for 10 ns;
  mux_dout	<= "00000001";
  fifo_a_rd_en <='0';
  fifo_b_rd_en <='0';
    wait for 10 ns;
  fifo_b_rd_en <='1';
  wait for 10 ns;
  fifo_b_rd_en <='0';
	 wait for 100 ns;
    --assert false
    --report "End of TestBench"
    --severity failure;

  end process tb;
 




end structure;

