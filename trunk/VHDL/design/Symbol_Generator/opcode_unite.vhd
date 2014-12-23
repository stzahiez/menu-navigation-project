------------------------------------------------------------------------------------------------
-- Model Name 	:	Opcode Unite
-- File Name	:	opcode_unite.vhd
-- Generated	:	16.3.2012
-- Author		:	Olga Liberman and Yoav Shvartz
-- Project		:	Symbol Generator Project
------------------------------------------------------------------------------------------------
-- Description:
-- OPU unites every 3 packs MPD into 1 opcode by a Finite State Machine (FSM) and writes data to Opcode Store.
-- When Wbs_adr_i [9..0] = OPU_address, then OPU is being activated.
-- Uniting the message packs is implemented using a fsm. each opcode is ready after mp3_st state.
-- When we reach state MPD3 then we have 1 opcode (24 bit).
-- We also implement a counter of received bytes: when the counter reaches   Wbs_tga_i, it means the last change (therefore the last opcode) was transmitted.
--
------------------------------------------------------------------------------------------------
-- Revision:
--			Number		Date		     Name								                      Description			
--			1.00		16.3.2012	  	Olga Liberman and Yoav Shvartz		Creation
--			1.01		12.4.2012	  	Olga Liberman						Aesthetics: header, comments, ports and signals names, synchronic fsm
--			2.00		20.4.2012	  	Olga Liberman and Yoav Shvartz		Wishbone signals are dealt in the upper level
--    		2.01   		08.05.2012  	Olga Liberman and Yoav Shvartz    	addition of "when others" to the case, default value to outputs
--			2.02		16.07.2012		Olga Liberman						Initialization of input ports is deleted
--
------------------------------------------------------------------------------------------------
--	Todo:
--	(1) The wbs signals should be dealt in the upper level, also the wbs_adr comparison
--		with our address.
--	(2) 
--	(3)
------------------------------------------------------------------------------------------------


library ieee;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity opcode_unite is

  port (
	clk : in std_logic; -- the main clock to which all the internal logic of the Symbol Generator block is synchronized.
	reset_n : in std_logic; -- asynchronous reset
	opu_data_in : in std_logic_vector(7 downto 0); -- data from wbs
	opu_data_in_valid : in std_logic; -- valid signal for data from wbs
	-- opu_data_in_cnt : in std_logic_vector(9 downto 0); -- number of changes in bytes - 1, each change is 3 bytes
	-- wbs_adr_i : in std_logic_vector(9 downto 0); -- this signal is sent from the WBS. It indicates the address of the Display Controller Top. With it we can know if our blocks inside Display Controller are requested – TBD with Beeri
	-- wbs_tga_i : in std_logic_vector(9 downto 0); -- this signal is sent from the WBS. It indicates how many words are there that are transmitted to us (in other words, it indicate the field Data_Length in the message pack).
	-- wbs_dat_i : in std_logic_vector(7 downto 0); -- this signal is sent from the WBS. It indicates the data itself from the field Payload in the message pack.
    -- wbs_cyc_i : in std_logic; -- this signal is sent from the WBS. It indicates the signal cycle required by the Wishbone protocol.
    -- wbs_stb_i : in std_logic; -- this signal is sent from the WBS. It indicates the signal strobe required by the Wishbone protocol.
    -- wbs_ack_o : out std_logic; -- The acknowledge signal required by the Wishbone protocol.
    -- wbs_stall_o : out std_logic; -- The stall signal required by the Wishbone protocol. It indicates that the slave is busy, therefore, the will be repeated until stall is low.
    -- wbs_err_o : out std_logic; -- The error signal required by the Wishbone protocol. TBD – how we use it?
    opu_wr_en : out std_logic; -- This signal is an enable signal to write opcodes to the Opcode Store block. It is active when a new opcode was united and is ready to be stored in the FIFO.
    opu_data_out : out std_logic_vector(23 downto 0) -- The data signal is the united Opcode to be stored in the Opcode store block.
    --opu_cnt : out std_logic_vector(9 downto 0) -- sampling the tga signal when data is active on the wbs
	--counter :out std_logic_vector(9 downto 0) := (others => '0');  -- counter signal to count the message packs from wbs
  );
  
end entity opcode_unite;

architecture opcode_unite_rtl of opcode_unite is

	--type state_t is (idle_st, mp1_st, mp2_st, mp3_st ); -- enum type for fsm states , mp = message pack
	type state_t is (idle_st, mp1_st, mp2_st ); -- enum type for fsm states , mp = message pack
	signal current_sm : state_t; -- current state in the fsm for uniting the opcode
	signal opcode : std_logic_vector(23 downto 0); -- internal signal connected to opu_data_out
	signal counter_i : std_logic_vector(9 downto 0); -- counter signal to count the message packs from wbs

  
begin

	------------------------------	Hidden processes	--------------------------
	--Output data
	opu_data_out_proc:
	opu_data_out <= opcode;
	--counter <= counter_i;
	

	---------------------------------------------------------------------------------
	----------------------------- Process opu_fsm_proc	-------------------------
	---------------------------------------------------------------------------------
	-- The process is the opcode unite fsm
	---------------------------------------------------------------------------------
	opu_fsm_proc: process(clk, reset_n)
    begin
      
		  --------------------------------------------------------
		  --------------- WISHBONE SIGNALS !!! -------------------
		  --------------   needed to be made   -------------------
		  -- wbs_ack_o <= '0';
		  -- wbs_stall_o <= '0';
		  -- wbs_err_o <= '0';
		  -- opu_wr_en <= '0';
		  --------------------------------------------------------
	  
		if reset_n='0' then
			current_sm <= idle_st;
			opcode <= (others=>'0');
			counter_i <= (others=>'0');
			opu_wr_en <= '0';
		elsif rising_edge(clk) then
      
      
			case current_sm is
				
				-- idle state
				when idle_st =>
					--if (counter_i=opu_data_in_cnt) then
					--	counter_i <= (others=>'0');
					--	end if;
					if ( opu_data_in_valid='1' ) then
						opcode(15 downto 0) <= (others=>'0'); -- reset the lower bits of the opcode register
						opcode(23 downto 16) <= opu_data_in; -- the higher bits receive the
            counter_i	<= unsigned(counter_i) + 1;
						current_sm <= mp1_st;
					else
						opcode <= (others=>'0');
						counter_i <= (others=>'0');
					end if;
					opu_wr_en <= '0';
					
				-- first packet of the current opcode (current change)
				when mp1_st =>
					if ( opu_data_in_valid='1' ) then
						opcode(15 downto 8) <= opu_data_in; -- reset the middle bits of the opcode register
						counter_i <= unsigned(counter_i) + 1;
						current_sm <= mp2_st;
					end if;
					opu_wr_en <= '0';
					
				-- second packet of the current opcode (current change)
				when mp2_st =>
					if ( opu_data_in_valid='1' ) then
						opcode(7 downto 0) <= opu_data_in; -- reset the lower bits of the opcode register
						counter_i <= unsigned(counter_i) + 1;
						opu_wr_en <= '1';
						current_sm <= idle_st;
					end if;
				
				-- third packet of the current opcode (current change)
				-- when mp3 =>
				  -- opcode(7 downto 0) <= wbs_dat_i;
				  -- counter <= counter + 1;
				  -- opu_wr_en <= '1'; -- the opcode is valid here and now we can write into the Opcode_Store  
				  -- if (wbs_cyc_i='1') and (wbs_stb_i='1') and (counter < wbs_tga_i) then
					-- current_sm <= mp1_st;
				  -- elsif (counter = wbs_tga_i) then -- we finished all the changes
					-- current_sm <= idle_st;
				  -- end if;
				  
				  when others =>
				    opu_wr_en <= '0';
				    opcode <= (others=>'0');
						counter_i <= (others=>'0');
						current_sm <= idle_st;
						
		
			  end case;
		end if;
  end process opu_fsm_proc;
  
end architecture opcode_unite_rtl;
  