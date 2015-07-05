function [] = tests_check_func(num_of_first_test,num_of_total_tests)


path = 'H:\Project\SG_Project\test_files'; %'H:\Project\SG_Project\test_files';
OK_tests = ones(1,num_of_total_tests + num_of_first_test - 1); % if test_i has an error, then OK_tests(i) = 0

for i = num_of_first_test:(num_of_total_tests + num_of_first_test - 1)
    expectedFolder = strcat(path,'\test_random_',num2str(i),'\expected');
    outputFolder = strcat(path,'\test_random_',num2str(i),'\output');
    expected_img = imread(strcat(expectedFolder,'\out_img_1.bmp'));
    expected_img_2D = expected_img(:,:,1);
    output_img = imread(strcat(outputFolder,'\out_img_1.bmp'));
    output_img_2D = output_img(:,:,1);
    expected_img_idx = 1;
    output_img_idx = 1;
    
    cd(expectedFolder);
    expected_img_num = length(dir('*.bmp'));
    cd(outputFolder);
    output_img_num = length(dir('*.bmp'));
    cd(path);
    
    while (( expected_img_idx <= expected_img_num ) && ( output_img_idx <= output_img_num ))
        temp = sum(sum(abs(double(expected_img_2D) - double(output_img_2D))));
        while ( temp == 0 )
            output_img_idx = output_img_idx + 1;
            if (exist(strcat(outputFolder,'\out_img_',num2str(output_img_idx),'.bmp')) ~= 0)
                output_img = imread(strcat(outputFolder,'\out_img_',num2str(output_img_idx),'.bmp'));
                output_img_2D = output_img(:,:,1);
                temp = sum(sum(abs(double(expected_img_2D) - double(output_img_2D))));
            else
                break;
            end;
        end;
        expected_img_idx = expected_img_idx + 1;
        if (exist(strcat(expectedFolder,'\out_img_',num2str(expected_img_idx),'.bmp')) ~= 0)  
            expected_img = imread(strcat(expectedFolder,'\out_img_',num2str(expected_img_idx),'.bmp'));
            expected_img_2D = expected_img(:,:,1);
        else
            break;
        end;
        temp = sum(sum(abs(double(expected_img_2D) - double(output_img_2D))));
        if ( temp ~= 0 )
               OK_tests(i) = 0; 
               break;
        end;
    end;
end;


if ( sum(OK_tests) == (num_of_total_tests + num_of_first_test - 1) ) 
    msgbox('All tests pass !!!','Status');
else
    msgbox('Some tests failed !!!','Status');
end;
cd('H:\Project\Project Files\Matlab\GUI\GUI - final');
