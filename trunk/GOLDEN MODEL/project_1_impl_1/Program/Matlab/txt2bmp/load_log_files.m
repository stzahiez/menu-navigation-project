R=480;
C=640;
test_start=6;
test_finish=8;
N=3;
for t=test_start:1:test_finish
    for i=0:1:N

        if i<10
            log_file = strcat('../../../Symbol_Generator_TB/test_files/test_',int2str(t),'/expected/log_file_0',int2str(i));
        else
            log_file = strcat('../../../Symbol_Generator_TB/test_files/test_',int2str(t),'/output/log_file_',int2str(i));
        end

        txt2bmp( log_file , R , C );

    end
end