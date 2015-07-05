function [] = Load_Symbols_Func(symbol_num)
fid = fopen('H:\Project\Project Files\Matlab\create_uart_tx_files\uart_files\uart_tx_1_load_symbols.txt', 'w');  % open the file with write permission

for i = 0:symbol_num % first symbol is balck
% % for i = 1:symbol_num % first symbol is white
    % constants
    sof = 100; % SOF value
    eof = 200;
    %type = 128; % type=0x80 -> write to register
    type = 0; % type=0x00 -> write to register
    %SG_reg_addr = 16; % SG register base address for burst write
    addr = 0;
    length = 32*32 - 1; % number of pixels in every symbol = 1023
    length_msb = floor(length/256);
    length_lsb = length - 256*length_msb;

    % crc sum
    crc_sum = type + addr + length_msb + length_lsb;

    fprintf(fid, '#Chunk\r\n');
    fprintf(fid, '#SOF\r\n'); %write #SOF 
    fprintf(fid, '%02X\r\n',sof ); %write SOF value
    fprintf(fid, '#Type\r\n'); %write #Type
    fprintf(fid, '%02X\r\n',type); %write Type value
    fprintf(fid, '#Address\r\n'); %write #Adress
    fprintf(fid, '%02X\r\n',0); %write address Value
    fprintf(fid, '%02X\r\n',addr); %write address Value
    fprintf(fid, '#Length\r\n'); %write #Length
    fprintf(fid, '%02X\t%02X\r\n',length_msb,length_lsb ); %write length of burst: 1023 (decimal) equals 03FF  (hex)
    fprintf(fid, '#Payload\r\n'); %write #Payload
    
    if (i<10)
        s=imread(strcat('H:\Project\Project Files\Matlab\create_uart_tx_files\symbols\symbol_0',num2str(i),'.bmp'));
    else
        s=imread(strcat('H:\Project\Project Files\Matlab\create_uart_tx_files\symbols\symbol_',num2str(i),'.bmp'));
    end
    s=s(:,:,1);
    for j = 1:32
        for k =1:32
            fprintf(fid,'%02X\r\n',s(j,k));
            crc_sum = crc_sum + double(s(j,k)); 
        end
    end
    
    fprintf(fid, '#CRC\r\n'); %write #CRC
    crc = mod(crc_sum,256); % calcultae crc = (type +length + address + payload) mod 256
    fprintf(fid, '%02X\r\n',crc ); %write CRC value
    fprintf(fid, '#EOF\r\n'); %write #EOF
    fprintf(fid, '%02X\r\n',eof ); %write EOF value
    
end

% summary
sof = 100; % SOF value
eof = 200;
type = 2; % type=0x00 -> write to register
addr = 0;
length = 2 - 1; % number of pixels in every symbol = 1023
length_msb = floor(length/256);
length_lsb = length - 256*length_msb;
% 
fprintf(fid, '#Summay\r\n'); %write #CRC
fprintf(fid, '#SOF\r\n'); %write #SOF 
fprintf(fid, '%02X\r\n',sof ); %write SOF value
fprintf(fid, '#Type\r\n'); %write #Type
fprintf(fid, '%02X\r\n',type); %write Type value
fprintf(fid, '#Address\r\n'); %write #Adress
fprintf(fid, '%02X\r\n',0); %write address Value
fprintf(fid, '%02X\r\n',addr); %write address Value
fprintf(fid, '#Length\r\n'); %write #Length
fprintf(fid, '%02X\t%02X\r\n',length_msb,length_lsb ); %write length of burst: 1023 (decimal) equals 03FF  (hex)
crc_sum = type + addr + length_msb + length_lsb; % crc sum
fprintf(fid, '#Payload\r\n'); %write #Payload
fprintf(fid,'%02X\r\n',48);
fprintf(fid,'%02X\r\n',0);
crc_sum = crc_sum + 1 + 2 + 0; % crc sum
fprintf(fid, '#CRC\r\n'); %write #CRC
crc = mod(crc_sum,256); % calcultae crc = (type +length + address + payload) mod 256
fprintf(fid, '%02X\r\n',crc ); %write CRC value
fprintf(fid, '#EOF\r\n'); %write #EOF
fprintf(fid, '%02X\r\n',eof ); %write EOF value


fclose(fid);
