# ########################################################################################### #
# ##################################### check_test.do ####################################### #
# ########################################################################################### #
# Generated	:	29.10.2012
# Author	:	Olga Liberman and Yoav Shvartz
# Project	:	Symbol Generator Project
# ########################################################################################### #
# Description:
#
# The script recieves 2 argumants:
# 	1. name of the test - the name of the relevant directory under "test_files" directory
#		*** this directory will be reffered as "the test directory" ***
# 	2. the prefix of the log files
# 		for example, if the log files have the names: log_file_00.txt , log_file_01.txt , ...
# 		then the prefix is "log_file"
#
# The script expects the directories of "expected" and "output" under the test directory.
# for example, if the test name is "test_1", then these directories
# should exist: "test_1/expected" and "test_1/output".
#
# The script compares the pairs of log files from expected and output directories.
#
# The script saves a log file under the test directory, including the result of each
# compare (PASS or FAIL), and if FAIL - then also the line where the failure happened.
#
# ########################################################################################### #
# Revision:
# Number		Date		    Name				Description			
# 1.00			29.10.2012	  	Olga				Creation
# ########################################################################################### #


if {$argc == 2} {
	
	set test_result PASS
	
	set test_name $1
	set log_file $2
	
	file delete test_files/$test_name/${test_name}_log.txt
	if [catch {set fp_test_log [open "test_files/$test_name/${test_name}_log.txt" w]} res] {
		error "Warning: $res" }
	# set fp_test_log [open "test_files/$test_name/${test_name}_log.txt" w]
	puts $fp_test_log "##################### Log file for test: $test_name #####################"
	
	set total_frames 0
	set frames_passed 0
	set frames_failed 0
	
	set expected_files [glob test_files/$test_name/expected/*.txt]
	# puts "$test_name - expected: $expected_files" 
	set output_files [glob test_files/$test_name/output/*.txt]
	# puts "$test_name - output: $output_files"
	
	if {[llength $expected_files] == 0} {   
	puts "error! - no files in the expected directory for test $test_name"
	puts $fp_test_log "error! - no files in the expected directory for test $test_name"
	} elseif {[llength $output_files] == 0} {   
	puts "error! - no files in the output directory for test $test_name"
	puts $fp_test_log "error! - no files in the output directory for test $test_name"
	} else {
		
		# take the minimum number count between expected and output
		if {[llength $expected_files] < [llength $output_files]} {
			set max_counter [llength $expected_files]
		} else {
			set max_counter [llength $output_files]
		}
		
		for {set counter 0} {$counter < $max_counter} {incr counter} {
		
			# build the name
			if { $counter < 10 } {
				set log_file_name ${log_file}_0${counter}.txt
			} else {
				set log_file_name ${log_file}_${counter}.txt
			}
			# puts "log file name is $log_file_name"
			
			# size check
			set expected_size [file size test_files/$test_name/expected/$log_file_name]
			# puts "expected size $expected_size"
			set output_size [file size test_files/$test_name/output/$log_file_name]
			# puts "output size $output_size"
			if {$expected_size != $output_size} {
				puts "FAIL - size mismatch"
				set test_result FAIL
				if { $counter < 10 } {	
					puts $fp_test_log "frame 0${counter}: FAIL (size mismatch)"
				} else {
					puts $fp_test_log "frame ${counter}: FAIL (size mismatch)"
				}
				
			} else {
				# compare the log files
				
				if [catch { open "test_files/$test_name/expected/$log_file_name" r } res] {
					error "Error: $res"
				} else {
					set fp_expected [open "test_files/$test_name/expected/$log_file_name" r] }
				
				if [catch {open "test_files/$test_name/output/$log_file_name" r} res] {
					error "Error: $res"
				} else {
					set fp_output [open "test_files/$test_name/output/$log_file_name" r] }
				
				fconfigure $fp_expected -buffering line
				fconfigure $fp_output -buffering line
				gets $fp_expected data_expected
				gets $fp_output data_output
				set line_cnt 1
				while { $data_expected != "" && $data_output != ""} { # while not eof
					# gets $fp data
					if { [string compare $data_expected $data_output]!=0 } {
						puts "$test_name FAIL - line $line_cnt doesn't match"
						if { $counter < 10 } {	
							puts $fp_test_log "frame 0${counter}: FAIL (line $line_cnt doesn't match)"
						} else {
							puts $fp_test_log "frame ${counter}: FAIL (line $line_cnt doesn't match)"
						}
						set test_result FAIL
						break
					} else {
						gets $fp_expected data_expected
						gets $fp_output data_output
						incr line_cnt; # line_cnt++
						}
					}
				
				
				if { $data_expected != "" && $data_output == ""} {
					puts "$test_name FAIL - line $line_cnt doesn't match"
					if { $counter < 10 } {	
						puts $fp_test_log "frame 0${counter}: FAIL (line $line_cnt doesn't match)"
					} else {
						puts $fp_test_log "frame ${counter}: FAIL (line $line_cnt doesn't match)"
					}
					set test_result FAIL
				} elseif { $data_expected == "" && $data_output != ""} {
					puts "$test_name FAIL - line $line_cnt doesn't match"
					if { $counter < 10 } {	
						puts $fp_test_log "frame 0${counter}: FAIL (line $line_cnt doesn't match)"
					} else {
						puts $fp_test_log "frame ${counter}: FAIL (line $line_cnt doesn't match)"
					}
					set test_result FAIL
				} elseif { [string compare $test_result PASS]==0 } {
					if { $counter < 10 } {
						puts $fp_test_log "frame 0${counter}: PASS"
					} else {
						puts $fp_test_log "frame ${counter}: PASS"
					}
				}
				
				close $fp_expected
				close $fp_output
				# puts "$test_name result = $test_result"
			}
			incr total_frames
			if { [string compare $test_result PASS]==0 } {
				incr frames_passed
			} else {
				incr frames_failed
			}
		}
	}
	
	puts $fp_test_log "***"
	puts $fp_test_log "total frames: $total_frames"
	puts $fp_test_log "frames passed: $frames_passed"
	puts $fp_test_log "frames failed: $frames_failed"
	puts $fp_test_log "***"
	if { $frames_failed==0 && $total_frames!=0 } {
		puts $fp_test_log "final result:"
		puts $fp_test_log "PASS"
	} else {
		puts $fp_test_log "final result:"
		puts $fp_test_log "FAIL"
	}
	
	close $fp_test_log
}