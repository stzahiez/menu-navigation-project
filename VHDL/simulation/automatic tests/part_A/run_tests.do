# ########################################################################################### #
# ##################################### run_tests.do ####################################### #
# ########################################################################################### #
# Generated	:	29.10.2012
# Author	:	Olga Liberman and Yoav Shvartz
# Project	:	Symbol Generator Project
# ########################################################################################### #
# Description:
#
# The script works in the "test_files" directory and creates a log file named "log.txt",
# including the result of each test: PASS or FAIL.
#
# ########################################################################################### #
# Revision:
# Number		Date		    Name				Description			
# 1.00			29.10.2012	  	Olga				Creation
# ########################################################################################### #



file delete test_files/log.txt
set fp_batch [open "test_files/log.txt" w]

# #########################

set fp_test_list [open "test_files/tests.do" r]
set test_list [read $fp_test_list]
close $fp_test_list

# set test_num [expr (0)]
# set test_pass [expr (0)]
# set test_fail [expr (0)]

foreach test_line $test_list {
    # puts "test line: $test_line"
	set line_list [split $test_line ,]
	set test_name [lindex $line_list 0]
	set log_file [lindex $line_list 1]
	# puts "test_name = $test_name , log_file = $log_file"
	
	
	# do arg.do $test_name $log_file
	set test_file test_files/$test_name/$test_name.txt
	set output_path test_files/$test_name/output/$log_file
	vsim -gopcode_text_file_g=$test_file -glog_file_g=$output_path -t ns -voptargs=+acc work.symbol_generator_top_tb
	# do symbol_generator_debug.do
	run 17 ms
	quit -sim
	
	# # compare expected to output
	do check_test.do $test_name $log_file
	
	# check the result of the test
	set stars 0
	if [catch {set file_test_log [open "test_files/$test_name/${test_name}_log.txt" r]} res] {
		error "Warning: $res" }
	fconfigure $file_test_log -buffering line
	gets $file_test_log file_test_log_data
	while { $stars < 2 && $file_test_log_data != ""} {
		if { [string compare $file_test_log_data "***"]==0 && $stars==1 } {
			gets $file_test_log file_test_log_data
			gets $file_test_log file_test_log_data
			if { [string compare $file_test_log_data "PASS"]==0 } {
				puts $fp_batch "Summary of $test_name: PASS"
			} else {
				puts $fp_batch "Summary of $test_name: FAIL"
			}
			incr stars
		} elseif { [string compare $file_test_log_data "***"]==0 && $stars==0 } {
			incr stars
		}
		gets $file_test_log file_test_log_data
	}
	# puts $fp_batch "Summary of $test_name:"
	close $file_test_log
}
	
close $fp_batch


