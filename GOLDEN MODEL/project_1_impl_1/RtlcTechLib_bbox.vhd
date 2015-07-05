
-- 
-- Definition of  altpll
-- 
--      07/05/15 17:02:41
--      
--      Precision RTL Plus , 2014a.1_64-bit
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.VITAL_Timing.all;

entity altpll is 
   generic (bandwidth : integer := 0;
      bandwidth_type : string := "AUTO";
      c0_high : integer := 0;
      c0_initial : integer := 0;
      c0_low : integer := 0;
      c0_mode : string := "BYPASS";
      c0_ph : integer := 0;
      c0_test_source : integer := 5;
      c1_high : integer := 0;
      c1_initial : integer := 0;
      c1_low : integer := 0;
      c1_mode : string := "BYPASS";
      c1_ph : integer := 0;
      c1_test_source : integer := 5;
      c1_use_casc_in : string := "OFF";
      c2_high : integer := 0;
      c2_initial : integer := 0;
      c2_low : integer := 0;
      c2_mode : string := "BYPASS";
      c2_ph : integer := 0;
      c2_test_source : integer := 5;
      c2_use_casc_in : string := "OFF";
      c3_high : integer := 0;
      c3_initial : integer := 0;
      c3_low : integer := 0;
      c3_mode : string := "BYPASS";
      c3_ph : integer := 0;
      c3_test_source : integer := 5;
      c3_use_casc_in : string := "OFF";
      c4_high : integer := 0;
      c4_initial : integer := 0;
      c4_low : integer := 0;
      c4_mode : string := "BYPASS";
      c4_ph : integer := 0;
      c4_test_source : integer := 5;
      c4_use_casc_in : string := "OFF";
      c5_high : integer := 0;
      c5_initial : integer := 0;
      c5_low : integer := 0;
      c5_mode : string := "BYPASS";
      c5_ph : integer := 0;
      c5_test_source : integer := 5;
      c5_use_casc_in : string := "OFF";
      c6_high : integer := 0;
      c6_initial : integer := 0;
      c6_low : integer := 0;
      c6_mode : string := "BYPASS";
      c6_ph : integer := 0;
      c6_test_source : integer := 5;
      c6_use_casc_in : string := "OFF";
      c7_high : integer := 0;
      c7_initial : integer := 0;
      c7_low : integer := 0;
      c7_mode : string := "BYPASS";
      c7_ph : integer := 0;
      c7_test_source : integer := 5;
      c7_use_casc_in : string := "OFF";
      c8_high : integer := 0;
      c8_initial : integer := 0;
      c8_low : integer := 0;
      c8_mode : string := "BYPASS";
      c8_ph : integer := 0;
      c8_test_source : integer := 5;
      c8_use_casc_in : string := "OFF";
      c9_high : integer := 0;
      c9_initial : integer := 0;
      c9_low : integer := 0;
      c9_mode : string := "BYPASS";
      c9_ph : integer := 0;
      c9_test_source : integer := 5;
      c9_use_casc_in : string := "OFF";
      charge_pump_current : integer := 2
      ;
      charge_pump_current_bits : integer := 9999
      ;
      clk0_counter : string := "G0";
      clk0_divide_by : integer := 1;
      clk0_duty_cycle : integer := 50;
      clk0_multiply_by : integer := 1;
      clk0_output_frequency : integer := 0;
      clk0_phase_shift : string := "0";
      clk0_time_delay : string := "0"
      ;
      clk0_use_even_counter_mode : string := "OFF"
      ;
      clk0_use_even_counter_value : string := "OFF"
      ;
      clk1_counter : string := "G0";
      clk1_divide_by : integer := 1;
      clk1_duty_cycle : integer := 50;
      clk1_multiply_by : integer := 1;
      clk1_output_frequency : integer := 0;
      clk1_phase_shift : string := "0";
      clk1_time_delay : string := "0"
      ;
      clk1_use_even_counter_mode : string := "OFF"
      ;
      clk1_use_even_counter_value : string := "OFF"
      ;
      clk2_counter : string := "G0";
      clk2_divide_by : integer := 1;
      clk2_duty_cycle : integer := 50;
      clk2_multiply_by : integer := 1;
      clk2_output_frequency : integer := 0;
      clk2_phase_shift : string := "0";
      clk2_time_delay : string := "0"
      ;
      clk2_use_even_counter_mode : string := "OFF"
      ;
      clk2_use_even_counter_value : string := "OFF"
      ;
      clk3_counter : string := "G0";
      clk3_divide_by : integer := 1;
      clk3_duty_cycle : integer := 50;
      clk3_multiply_by : integer := 1;
      clk3_phase_shift : string := "0";
      clk3_time_delay : string := "0"
      ;
      clk3_use_even_counter_mode : string := "OFF"
      ;
      clk3_use_even_counter_value : string := "OFF"
      ;
      clk4_counter : string := "G0";
      clk4_divide_by : integer := 1;
      clk4_duty_cycle : integer := 50;
      clk4_multiply_by : integer := 1;
      clk4_phase_shift : string := "0";
      clk4_time_delay : string := "0"
      ;
      clk4_use_even_counter_mode : string := "OFF"
      ;
      clk4_use_even_counter_value : string := "OFF"
      ;
      clk5_counter : string := "G0";
      clk5_divide_by : integer := 1;
      clk5_duty_cycle : integer := 50;
      clk5_multiply_by : integer := 1;
      clk5_phase_shift : string := "0";
      clk5_time_delay : string := "0"
      ;
      clk5_use_even_counter_mode : string := "OFF"
      ;
      clk5_use_even_counter_value : string := "OFF"
      ;
      clk6_counter : string := "E0";
      clk6_divide_by : integer := 0;
      clk6_duty_cycle : integer := 50;
      clk6_multiply_by : integer := 0;
      clk6_phase_shift : string := "0"
      ;
      clk6_use_even_counter_mode : string := "OFF"
      ;
      clk6_use_even_counter_value : string := "OFF"
      ;
      clk7_counter : string := "E1";
      clk7_divide_by : integer := 0;
      clk7_duty_cycle : integer := 50;
      clk7_multiply_by : integer := 0;
      clk7_phase_shift : string := "0"
      ;
      clk7_use_even_counter_mode : string := "OFF"
      ;
      clk7_use_even_counter_value : string := "OFF"
      ;
      clk8_counter : string := "E2";
      clk8_divide_by : integer := 0;
      clk8_duty_cycle : integer := 50;
      clk8_multiply_by : integer := 0;
      clk8_phase_shift : string := "0"
      ;
      clk8_use_even_counter_mode : string := "OFF"
      ;
      clk8_use_even_counter_value : string := "OFF"
      ;
      clk9_counter : string := "E3";
      clk9_divide_by : integer := 0;
      clk9_duty_cycle : integer := 50;
      clk9_multiply_by : integer := 0;
      clk9_phase_shift : string := "0"
      ;
      clk9_use_even_counter_mode : string := "OFF"
      ;
      clk9_use_even_counter_value : string := "OFF"
      ;
      compensate_clock : string := "CLK0";
      down_spread : string := "0";
      dpa_divide_by : integer := 1;
      dpa_divider : integer := 0;
      dpa_multiply_by : integer := 0;
      e0_high : integer := 1;
      e0_initial : integer := 1;
      e0_low : integer := 1;
      e0_mode : string := "BYPASS";
      e0_ph : integer := 0;
      e0_time_delay : integer := 0;
      e1_high : integer := 1;
      e1_initial : integer := 1;
      e1_low : integer := 1;
      e1_mode : string := "BYPASS";
      e1_ph : integer := 0;
      e1_time_delay : integer := 0;
      e2_high : integer := 1;
      e2_initial : integer := 1;
      e2_low : integer := 1;
      e2_mode : string := "BYPASS";
      e2_ph : integer := 0;
      e2_time_delay : integer := 0;
      e3_high : integer := 1;
      e3_initial : integer := 1;
      e3_low : integer := 1;
      e3_mode : string := "BYPASS";
      e3_ph : integer := 0;
      e3_time_delay : integer := 0;
      enable0_counter : string := "L0";
      enable1_counter : string := "L0"
      ;
      enable_switch_over_counter : string := "OFF"
      ;
      extclk0_counter : string := "E0";
      extclk0_divide_by : integer := 1;
      extclk0_duty_cycle : integer := 50;
      extclk0_multiply_by : integer := 1
      ;
      extclk0_phase_shift : string := "0"
      ;
      extclk0_time_delay : string := "0";
      extclk1_counter : string := "E1";
      extclk1_divide_by : integer := 1;
      extclk1_duty_cycle : integer := 50;
      extclk1_multiply_by : integer := 1
      ;
      extclk1_phase_shift : string := "0"
      ;
      extclk1_time_delay : string := "0";
      extclk2_counter : string := "E2";
      extclk2_divide_by : integer := 1;
      extclk2_duty_cycle : integer := 50;
      extclk2_multiply_by : integer := 1
      ;
      extclk2_phase_shift : string := "0"
      ;
      extclk2_time_delay : string := "0";
      extclk3_counter : string := "E3";
      extclk3_divide_by : integer := 1;
      extclk3_duty_cycle : integer := 50;
      extclk3_multiply_by : integer := 1
      ;
      extclk3_phase_shift : string := "0"
      ;
      extclk3_time_delay : string := "0"
      ;
      feedback_source : string := "EXTCLK0";
      g0_high : integer := 1;
      g0_initial : integer := 1;
      g0_low : integer := 1;
      g0_mode : string := "BYPASS";
      g0_ph : integer := 0;
      g0_time_delay : integer := 0;
      g1_high : integer := 1;
      g1_initial : integer := 1;
      g1_low : integer := 1;
      g1_mode : string := "BYPASS";
      g1_ph : integer := 0;
      g1_time_delay : integer := 0;
      g2_high : integer := 1;
      g2_initial : integer := 1;
      g2_low : integer := 1;
      g2_mode : string := "BYPASS";
      g2_ph : integer := 0;
      g2_time_delay : integer := 0;
      g3_high : integer := 1;
      g3_initial : integer := 1;
      g3_low : integer := 1;
      g3_mode : string := "BYPASS";
      g3_ph : integer := 0;
      g3_time_delay : integer := 0;
      gate_lock_counter : integer := 0;
      gate_lock_signal : string := "NO"
      ;
      inclk0_input_frequency : integer := 0
      ;
      inclk1_input_frequency : integer := 0
      ;
      intended_device_family : string := "NONE"
      ;
      invalid_lock_multiplier : integer := 5;
      l0_high : integer := 1;
      l0_initial : integer := 1;
      l0_low : integer := 1;
      l0_mode : string := "BYPASS";
      l0_ph : integer := 0;
      l0_time_delay : integer := 0;
      l1_high : integer := 1;
      l1_initial : integer := 1;
      l1_low : integer := 1;
      l1_mode : string := "BYPASS";
      l1_ph : integer := 0;
      l1_time_delay : integer := 0;
      lock_high : integer := 1;
      lock_low : integer := 1;
      lock_window_ui : string := "0.05"
      ;
      lock_window_ui_bits : string := "UNUSED";
      loop_filter_c : integer := 5;
      loop_filter_c_bits : integer := 9999
      ;
      loop_filter_r : string := "1.000000"
      ;
      loop_filter_r_bits : integer := 9999;
      lpm_hint : string := "UNUSED";
      lpm_type : string := "altpll";
      m : integer := 0;
      m2 : integer := 1;
      m_initial : integer := 0;
      m_ph : integer := 0;
      m_test_source : integer := 5;
      m_time_delay : integer := 0;
      n : integer := 1;
      n2 : integer := 1;
      n_time_delay : integer := 0;
      operation_mode : string := "NORMAL";
      pfd_max : integer := 0;
      pfd_min : integer := 0;
      pll_type : string := "AUTO"
      ;
      port_activeclock : string := "PORT_CONNECTIVITY"
      ;
      port_areset : string := "PORT_CONNECTIVITY"
      ;
      port_clk0 : string := "PORT_CONNECTIVITY"
      ;
      port_clk1 : string := "PORT_CONNECTIVITY"
      ;
      port_clk2 : string := "PORT_CONNECTIVITY"
      ;
      port_clk3 : string := "PORT_CONNECTIVITY"
      ;
      port_clk4 : string := "PORT_CONNECTIVITY"
      ;
      port_clk5 : string := "PORT_CONNECTIVITY"
      ;
      port_clk6 : string := "PORT_CONNECTIVITY"
      ;
      port_clk7 : string := "PORT_CONNECTIVITY"
      ;
      port_clk8 : string := "PORT_CONNECTIVITY"
      ;
      port_clk9 : string := "PORT_CONNECTIVITY"
      ;
      port_clkbad0 : string := "PORT_CONNECTIVITY"
      ;
      port_clkbad1 : string := "PORT_CONNECTIVITY"
      ;
      port_clkena0 : string := "PORT_CONNECTIVITY"
      ;
      port_clkena1 : string := "PORT_CONNECTIVITY"
      ;
      port_clkena2 : string := "PORT_CONNECTIVITY"
      ;
      port_clkena3 : string := "PORT_CONNECTIVITY"
      ;
      port_clkena4 : string := "PORT_CONNECTIVITY"
      ;
      port_clkena5 : string := "PORT_CONNECTIVITY"
      ;
      port_clkloss : string := "PORT_CONNECTIVITY"
      ;
      port_clkswitch : string := "PORT_CONNECTIVITY"
      ;
      port_configupdate : string := "PORT_CONNECTIVITY"
      ;
      port_enable0 : string := "PORT_CONNECTIVITY"
      ;
      port_enable1 : string := "PORT_CONNECTIVITY"
      ;
      port_extclk0 : string := "PORT_CONNECTIVITY"
      ;
      port_extclk1 : string := "PORT_CONNECTIVITY"
      ;
      port_extclk2 : string := "PORT_CONNECTIVITY"
      ;
      port_extclk3 : string := "PORT_CONNECTIVITY"
      ;
      port_extclkena0 : string := "PORT_CONNECTIVITY"
      ;
      port_extclkena1 : string := "PORT_CONNECTIVITY"
      ;
      port_extclkena2 : string := "PORT_CONNECTIVITY"
      ;
      port_extclkena3 : string := "PORT_CONNECTIVITY"
      ;
      port_fbin : string := "PORT_CONNECTIVITY"
      ;
      port_fbout : string := "PORT_CONNECTIVITY"
      ;
      port_inclk0 : string := "PORT_CONNECTIVITY"
      ;
      port_inclk1 : string := "PORT_CONNECTIVITY"
      ;
      port_locked : string := "PORT_CONNECTIVITY"
      ;
      port_pfdena : string := "PORT_CONNECTIVITY"
      ;
      port_phasecounterselect : string := "PORT_CONNECTIVITY"
      ;
      port_phasedone : string := "PORT_CONNECTIVITY"
      ;
      port_phasestep : string := "PORT_CONNECTIVITY"
      ;
      port_phaseupdown : string := "PORT_CONNECTIVITY"
      ;
      port_pllena : string := "PORT_CONNECTIVITY"
      ;
      port_scanaclr : string := "PORT_CONNECTIVITY"
      ;
      port_scanclk : string := "PORT_CONNECTIVITY"
      ;
      port_scanclkena : string := "PORT_CONNECTIVITY"
      ;
      port_scandata : string := "PORT_CONNECTIVITY"
      ;
      port_scandataout : string := "PORT_CONNECTIVITY"
      ;
      port_scandone : string := "PORT_CONNECTIVITY"
      ;
      port_scanread : string := "PORT_CONNECTIVITY"
      ;
      port_scanwrite : string := "PORT_CONNECTIVITY"
      ;
      port_sclkout0 : string := "PORT_CONNECTIVITY"
      ;
      port_sclkout1 : string := "PORT_CONNECTIVITY"
      ;
      port_vcooverrange : string := "PORT_CONNECTIVITY"
      ;
      port_vcounderrange : string := "PORT_CONNECTIVITY"
      ;
      primary_clock : string := "INCLK0"
      ;
      qualify_conf_done : string := "OFF";
      scan_chain : string := "LONG"
      ;
      scan_chain_mif_file : string := "UNUSED"
      ;
      sclkout0_phase_shift : string := "0"
      ;
      sclkout1_phase_shift : string := "0"
      ;
      self_reset_on_gated_loss_lock : string := "OFF"
      ;
      self_reset_on_loss_lock : string := "OFF";
      skip_vco : string := "OFF";
      spread_frequency : integer := 0;
      ss : integer := 1;
      switch_over_counter : integer := 0
      ;
      switch_over_on_gated_lock : string := "OFF"
      ;
      switch_over_on_lossclk : string := "OFF"
      ;
      switch_over_type : string := "AUTO"
      ;
      using_fbmimicbidir_port : string := "OFF"
      ;
      valid_lock_multiplier : integer := 1;
      vco_center : integer := 0;
      vco_divide_by : integer := 0;
      vco_frequency_control : string := "AUTO";
      vco_max : integer := 0;
      vco_min : integer := 0;
      vco_multiply_by : integer := 0;
      vco_phase_shift_step : integer := 0;
      vco_post_scale : integer := 0
      ;
      vco_range_detector_high_bits : string := "UNUSED"
      ;
      vco_range_detector_low_bits : string := "UNUSED"
      ;
      width_clock : integer := 6;
      width_phasecounterselect : integer := 4) ;
   
   port (
      activeclock : OUT std_logic ;
      clk : OUT std_logic_vector (9 DOWNTO 0) ;
      clkbad : OUT std_logic_vector (1 DOWNTO 0) ;
      clkloss : OUT std_logic ;
      enable0 : OUT std_logic ;
      enable1 : OUT std_logic ;
      extclk : OUT std_logic_vector (3 DOWNTO 0) ;
      fbmimicbidir : OUT std_logic ;
      fbout : OUT std_logic ;
      locked : OUT std_logic ;
      phasedone : OUT std_logic ;
      scandataout : OUT std_logic ;
      scandone : OUT std_logic ;
      sclkout0 : OUT std_logic ;
      sclkout1 : OUT std_logic ;
      vcooverrange : OUT std_logic ;
      vcounderrange : OUT std_logic ;
      areset : IN std_logic := '0' ;
      clkena : IN std_logic_vector (5 DOWNTO 0) ;
      clkswitch : IN std_logic := '0' ;
      configupdate : IN std_logic := '0' ;
      extclkena : IN std_logic_vector (3 DOWNTO 0) ;
      fbin : IN std_logic := '1' ;
      inclk : IN std_logic_vector (1 DOWNTO 0) ;
      pfdena : IN std_logic := '1' ;
      phasecounterselect : IN std_logic_vector (3 DOWNTO 0) ;
      phasestep : IN std_logic := '1' ;
      phaseupdown : IN std_logic := '1' ;
      pllena : IN std_logic := '1' ;
      scanaclr : IN std_logic := '0' ;
      scanclk : IN std_logic := '0' ;
      scanclkena : IN std_logic := '1' ;
      scandata : IN std_logic := '0' ;
      scanread : IN std_logic := '0' ;
      scanwrite : IN std_logic := '0') ;attribute RTLC_TECH_CELL: boolean;
   attribute RTLC_TECH_CELL of 
      altpll : entity is true;
      end altpll ;

architecture NETLIST of altpll is       
      begin
      end NETLIST ;
      
