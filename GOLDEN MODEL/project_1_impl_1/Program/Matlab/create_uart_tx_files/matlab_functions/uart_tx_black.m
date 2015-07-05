%% create black screen
clear all
clc

fid = fopen('H:\Project\\Project Files\Matlab\create_uart_tx_files\uart_files\uart_tx_1_black.txt', 'w');  % open the file with write permission

% constants
sof = 100; % SOF value
eof = 200;
type = 128; % type=0x80 -> write to register
SG_reg_addr = 16; % SG register base address for burst write
black_length = 900-1;
black_length_msb = floor(black_length/256);
black_length_lsb = black_length - 256*black_length_msb;

% crc sum
crc_sum = type + SG_reg_addr + black_length_msb + black_length_lsb;

fprintf(fid, '#Chunk\r\n');
fprintf(fid, '#SOF\r\n'); %write #SOF 
fprintf(fid, '%02X\r\n',sof ); %write SOF value
fprintf(fid, '#Type\r\n'); %write #Type
fprintf(fid, '%02X\r\n',type); %write Type value
fprintf(fid, '#Address\r\n'); %write #Adress
fprintf(fid, '%02X\r\n',0); %write address Value
fprintf(fid, '%02X\r\n',SG_reg_addr); %write address Value
fprintf(fid, '#Length\r\n'); %write #Length
fprintf(fid, '%02X\t%02X\r\n',black_length_msb,black_length_lsb ); %write length of burst: 3 and 132 (decimal) equals 0900 (hex)
fprintf(fid, '#Payload\r\n'); %write #Payload

for x=0:19
    for y=0:14
        x_bin = dec2bin(x,5);
        y_bin = dec2bin(y,4);
        zero7 = dec2bin(0,7);
        part1 = 0;
        part2 = bin2dec(strcat(zero7,y_bin(1)));
        part3 = bin2dec(strcat(y_bin(2:4),x_bin));
        fprintf(fid, '%02X\r\n',part1);
        fprintf(fid, '%02X\r\n',part2);
        fprintf(fid, '%02X\r\n',part3);
        crc_sum = crc_sum + part1 + part2 + part3;
    end
end

fprintf(fid, '#CRC\r\n'); %write #CRC
crc = mod(crc_sum,256); % calcultae crc = (type +length + address + payload) mod 256
fprintf(fid, '%02X\r\n',crc ); %write CRC value
fprintf(fid, '#EOF\r\n'); %write #EOF
fprintf(fid, '%02X\r\n',eof ); %write EOF value

fclose(fid);
