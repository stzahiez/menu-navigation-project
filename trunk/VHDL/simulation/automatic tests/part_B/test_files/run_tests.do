# ########################################################################################### #
# ##################################### run_tests.do ######################################## #
# ########################################################################################### #
#
# Generated	:	20.03.2013
# Author	:	Olga Liberman and Yoav Shvartz
# Project	:	Symbol Generator Project
#
# ########################################################################################### #
# Description:
#
# The script works in the "test_files" directory and creates a log file named "log.txt",
# including the result of each test: PASS or FAIL.
#
# The script searches for the file "test.do" in the test_files directory. This file consists
# of a list of tests to perform.
# The structure of the "test.do" file:
# <test_name>
# 	  ...
# <test_name>
#
# The script performs each test from the list:
# 	- Runs the simulation with the relevant generic value for this test.
#
# ########################################################################################### #
# Revision:
#
# Number		Date		    Name				Description			
# 1.00			20.03.2013	  	Olga				Creation
# ########################################################################################### #



# file delete test_files/log.txt
# set fp_batch [open "test_files/log.txt" w]

set fp_test_list [open "test_files/tests.do" r]
set test_list [read $fp_test_list]
close $fp_test_list
puts "test list: $test_list"
# set test_num [expr (0)]
# set test_pass [expr (0)]
# set test_fail [expr (0)]

foreach test_name $test_list {
    puts "test_name: $test_name"
	
	#### generics
	# generic: file_max_idx_g
	set uart_tx_dir test_files/$test_name/uart_tx
	set uart_tx_file_list [glob -directory $uart_tx_dir *.txt]
	set uart_tx_file_num [llength  $uart_tx_file_list]
	# generic: uart_tx_file_g
	set uart_tx_file H:/Project/SG_Project/test_files/$test_name/uart_tx/uart_tx
	# generic: output_dir_g
	set output_dir H:/Project/SG_Project/test_files/$test_name/output/
	
	#### run simulation - without optimization
	vsim -novopt -gfile_max_idx_g=$uart_tx_file_num -guart_tx_file_g=$uart_tx_file -goutput_dir_g=$output_dir -t ns work.mds_top_tb
	# do do_files/SG_full_simulation.do
	run 300 ms
	quit -sim
	
	# # # # compare expected to output
	# # do check_test.do $test_name $log_file
	
	# # # check the result of the test
	# # set stars 0
	# # if [catch {set file_test_log [open "test_files/$test_name/${test_name}_log.txt" r]} res] {
		# # error "Warning: $res" }
	# # fconfigure $file_test_log -buffering line
	# # gets $file_test_log file_test_log_data
	# # while { $stars < 2 && $file_test_log_data != ""} {
		# # if { [string compare $file_test_log_data "***"]==0 && $stars==1 } {
			# # gets $file_test_log file_test_log_data
			# # gets $file_test_log file_test_log_data
			# # if { [string compare $file_test_log_data "PASS"]==0 } {
				# # puts $fp_batch "Summary of $test_name: PASS"
			# # } else {
				# # puts $fp_batch "Summary of $test_name: FAIL"
			# # }
			# # incr stars
		# # } elseif { [string compare $file_test_log_data "***"]==0 && $stars==0 } {
			# # incr stars
		# # }
		# # gets $file_test_log file_test_log_data
	# # }
	# # # puts $fp_batch "Summary of $test_name:"
	# # close $file_test_log
}
	
# # close $fp_batch
