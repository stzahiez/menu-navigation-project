function [] = random_tests_func(num_of_first_test,num_of_total_tests)

path = 'H:\Project\SG_Project\test_files'; %'H:\Project\SG_Project\test_files';

for i = num_of_first_test:(num_of_total_tests + num_of_first_test - 1)
    %create directories
    mkdir(path,strcat('\test_random_',num2str(i)));
    parentFolder = strcat(path,'\test_random_',num2str(i));
    mkdir(parentFolder,'uart_tx');
    mkdir(parentFolder,'expected');
    mkdir(parentFolder,'output');
    
    %copy initialization file uart_tx_1
    copyfile( 'uart_tx_1.txt',strcat(parentFolder,'\uart_tx') );
    copyfile( 'out_img_1.bmp',strcat(parentFolder,'\expected') );
    
    
    num_of_chunks = 1 + round(rand(1)*5); % number of chunks. each chunk in a different uart_txt_i.txt file 
    
    screen = imread('screen.bmp'); %480X640 black 
    
    for j = 1:num_of_chunks    
        
        file_UART = fopen( strcat(parentFolder,'\uart_tx\uart_tx_',num2str(j+1),'.txt'),'w');
        
        sof = 100;          % SOF value
        eof = 200;          % EOF value
        type = 128;         % type=0x80 -> write to register
        SG_reg_addr = 16;   % SG register base address for burst write
        num_of_op_in_1_chunk = round(rand(1)*300);   % num_of_op_in_1_chunk = number of opcode changes in 1 UART chunk. A random integer between 0 to 300 
        length = num_of_op_in_1_chunk*3 - 1;
        length_msb = floor(length/256);
        length_lsb = length - 256*length_msb;
        crc_sum = type + SG_reg_addr + length_msb + length_lsb;
        
        % adding new frame to UART file
        fprintf(file_UART, '#Chunk\r\n');
        fprintf(file_UART, '#SOF\r\n'); %write #SOF 
        fprintf(file_UART, '%02X\r\n',sof ); %write SOF value
        fprintf(file_UART, '#Type\r\n'); %write #Type
        fprintf(file_UART, '%02X\r\n',type); %write Type value
        fprintf(file_UART, '#Address\r\n'); %write #Adress
        fprintf(file_UART, '%02X\r\n',0); %write address Value
        fprintf(file_UART, '%02X\r\n',SG_reg_addr); %write address Value
        fprintf(file_UART, '#Length\r\n'); %write #Length
        fprintf(file_UART, '%02X\t%02X\r\n',length_msb,length_lsb );
        fprintf(file_UART, '#Payload\r\n'); %write #Payload
        
        % Changed_xy is a matrix (15,20). If Changed_xy(x,y) == 1, it means the coordinates (x,y) have already been changed and a different coordinates should be chosen   
        Changed_xy = zeros(15,20);
        
        for k = 1:num_of_op_in_1_chunk
            
            x = round(rand(1)*19);          %random x position between 0 to 19
            y = round(rand(1)*14);          %random y position between 0 to 14
            while (Changed_xy(y+1,x+1) == 1)
                x = round(rand(1)*19);          %random x position between 0 to 19
                y = round(rand(1)*14);          %random y position between 0 to 14
            end
            Changed_xy(y+1,x+1) = 1;
            
            add_remove = round(rand(1)*1);  %random number:  (add_remove = 0) => remove symbol, (add_remove = 1) => add symbol
            if (add_remove == 1)
                symbol_num = round(rand(1)*23);  %random symbol number between 0 to 23
            else
                symbol_num = 0;                 %symbol number 0 is a black 32X32 symbol
            end
            symbol_img = imread(strcat('H:\Project\Project Files\Matlab\GUI\GUI - final\symbols\symbol_',num2str(symbol_num),'.bmp'));
            symbol_img = symbol_img(:,:,1);
            screen( ( (y*32+1):(y+1)*32 ),( (x*32+1):(x+1)*32 ) ) = symbol_img; % y = rows , x = columns 
            symbol_num_bin = dec2base(symbol_num ,2 ,13);
            x_bin = dec2base(x, 2, 5);
            y_bin = dec2base(y, 2, 4);
            opcode=strcat('0',num2str(add_remove),symbol_num_bin,y_bin,x_bin);
            segment1 = bin2dec(opcode(1:8));    % segment 1 (MSB at first) 
            segment2 = bin2dec(opcode(9:16));   % segment 2 
            segment3 = bin2dec(opcode(17:24));  % segment 3 (LSB at last)
            fprintf(file_UART, '%02X\r\n',segment1);
            fprintf(file_UART, '%02X\r\n',segment2);
            fprintf(file_UART, '%02X\r\n',segment3);
            crc_sum = crc_sum + segment1 + segment2 + segment3;
        end
        fprintf(file_UART, '#CRC\r\n'); %write #CRC
        crc = mod(crc_sum,256); % calcultae crc = (type +length + address + payload) mod 256
        fprintf(file_UART, '%02X\r\n',crc ); %write CRC value
        fprintf(file_UART, '#EOF\r\n'); %write #EOF
        fprintf(file_UART, '%02X\r\n',eof ); %write EOF value    
        
        %creating expected image
        expected_im=imread('out_img_1.bmp'); %600X800 black
        expected_im=expected_im(:,:,1);
        expected_im( ((600-480)/2+1):((600-480)/2+480),((800-640)/2+1):((800-640)/2+640) ) = screen;
        imwrite( expected_im , strcat(parentFolder,'\expected\out_img_',num2str(j+1),'.bmp') , 'bmp');    
        
        fclose(file_UART);
    end

end

