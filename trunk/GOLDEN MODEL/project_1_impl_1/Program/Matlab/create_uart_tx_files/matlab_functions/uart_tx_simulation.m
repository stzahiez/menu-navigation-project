%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% This code creates a uart text file for test_3.txt frames %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clc

fid = fopen('uart_tx_1.txt', 'w');  % open the file with write permission

% constants
sof = 100; % SOF value
eof = 200;
type = 128; % type=0x80 -> write to register
SG_reg_addr = 16; % SG register base address for burst write

%% frame #1 - create black screen
length = 900-1;
length_msb = floor(length/256);
length_lsb = length - 256*length_msb;
% crc sum
crc_sum = type + SG_reg_addr + length_msb + length_lsb;
fprintf(fid, '#Chunk\r\n');
fprintf(fid, '#SOF\r\n'); %write #SOF 
fprintf(fid, '%02X\r\n',sof ); %write SOF value
fprintf(fid, '#Type\r\n'); %write #Type
fprintf(fid, '%02X\r\n',type); %write Type value
fprintf(fid, '#Address\r\n'); %write #Adress
fprintf(fid, '%02X\r\n',0); %write address Value
fprintf(fid, '%02X\r\n',SG_reg_addr); %write address Value
fprintf(fid, '#Length\r\n'); %write #Length
fprintf(fid, '%02X\t%02X\r\n',length_msb,length_lsb); %write length of burst: 3 and 132 (decimal) equals 0900 (hex)
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


%% frame #2
length = 12-1;
length_msb = floor(length/256);
length_lsb = length - 256*length_msb;
% crc sum
crc_sum = type + SG_reg_addr + length_msb + length_lsb;
fprintf(fid, '#Chunk\r\n');
fprintf(fid, '#SOF\r\n'); %write #SOF 
fprintf(fid, '%02X\r\n',sof ); %write SOF value
fprintf(fid, '#Type\r\n'); %write #Type
fprintf(fid, '%02X\r\n',type); %write Type value
fprintf(fid, '#Address\r\n'); %write #Adress
fprintf(fid, '%02X\r\n',0); %write address Value
fprintf(fid, '%02X\r\n',SG_reg_addr); %write address Value
fprintf(fid, '#Length\r\n'); %write #Length
fprintf(fid, '%02X\t%02X\r\n',length_msb,length_lsb); %write length of burst: 3 and 132 (decimal) equals 0900 (hex)
fprintf(fid, '#Payload\r\n'); %write #Payload

% change
add = 1; % 0=romove , 1=add
symbol = 1; % number of the symbol to add
x = 0; % x coordinate, range: [0,19]
y = 0; % y coordinate, range: [0,14]
add_bin = dec2bin(add);
symbol_bin = dec2bin(symbol,13);
x_bin = dec2bin(x,5);
y_bin = dec2bin(y,4);
part1 = bin2dec(strcat('0',add_bin,symbol_bin(1:6)));
part2 = bin2dec(strcat(symbol_bin(7:13),y_bin(1)));
part3 = bin2dec(strcat(y_bin(2:4),x_bin));
fprintf(fid, '%02X\r\n',part1);
fprintf(fid, '%02X\r\n',part2);
fprintf(fid, '%02X\r\n',part3);
crc_sum = crc_sum + part1 + part2 + part3;

% change
add = 1; % 0=romove , 1=add
symbol = 2; % number of the symbol to add
x = 19; % x coordinate, range: [0,19]
y = 0; % y coordinate, range: [0,14]
add_bin = dec2bin(add);
symbol_bin = dec2bin(symbol,13);
x_bin = dec2bin(x,5);
y_bin = dec2bin(y,4);
part1 = bin2dec(strcat('0',add_bin,symbol_bin(1:6)));
part2 = bin2dec(strcat(symbol_bin(7:13),y_bin(1)));
part3 = bin2dec(strcat(y_bin(2:4),x_bin));
fprintf(fid, '%02X\r\n',part1);
fprintf(fid, '%02X\r\n',part2);
fprintf(fid, '%02X\r\n',part3);
crc_sum = crc_sum + part1 + part2 + part3;

% change
add = 1; % 0=romove , 1=add
symbol = 2; % number of the symbol to add
x = 0; % x coordinate, range: [0,19]
y = 14; % y coordinate, range: [0,14]
add_bin = dec2bin(add);
symbol_bin = dec2bin(symbol,13);
x_bin = dec2bin(x,5);
y_bin = dec2bin(y,4);
part1 = bin2dec(strcat('0',add_bin,symbol_bin(1:6)));
part2 = bin2dec(strcat(symbol_bin(7:13),y_bin(1)));
part3 = bin2dec(strcat(y_bin(2:4),x_bin));
fprintf(fid, '%02X\r\n',part1);
fprintf(fid, '%02X\r\n',part2);
fprintf(fid, '%02X\r\n',part3);
crc_sum = crc_sum + part1 + part2 + part3;

% change
add = 1; % 0=romove , 1=add
symbol = 2; % number of the symbol to add
x = 19; % x coordinate, range: [0,19]
y = 14; % y coordinate, range: [0,14]
add_bin = dec2bin(add);
symbol_bin = dec2bin(symbol,13);
x_bin = dec2bin(x,5);
y_bin = dec2bin(y,4);
part1 = bin2dec(strcat('0',add_bin,symbol_bin(1:6)));
part2 = bin2dec(strcat(symbol_bin(7:13),y_bin(1)));
part3 = bin2dec(strcat(y_bin(2:4),x_bin));
fprintf(fid, '%02X\r\n',part1);
fprintf(fid, '%02X\r\n',part2);
fprintf(fid, '%02X\r\n',part3);
crc_sum = crc_sum + part1 + part2 + part3;

fprintf(fid, '#CRC\r\n'); %write #CRC
crc = mod(crc_sum,256); % calcultae crc = (type +length + address + payload) mod 256
fprintf(fid, '%02X\r\n',crc ); %write CRC value
fprintf(fid, '#EOF\r\n'); %write #EOF
fprintf(fid, '%02X\r\n',eof ); %write EOF value


%% frame #3
length = 12-1;
length_msb = floor(length/256);
length_lsb = length - 256*length_msb;
% crc sum
crc_sum = type + SG_reg_addr + length_msb + length_lsb;
fprintf(fid, '#Chunk\r\n');
fprintf(fid, '#SOF\r\n'); %write #SOF 
fprintf(fid, '%02X\r\n',sof ); %write SOF value
fprintf(fid, '#Type\r\n'); %write #Type
fprintf(fid, '%02X\r\n',type); %write Type value
fprintf(fid, '#Address\r\n'); %write #Adress
fprintf(fid, '%02X\r\n',0); %write address Value
fprintf(fid, '%02X\r\n',SG_reg_addr); %write address Value
fprintf(fid, '#Length\r\n'); %write #Length
fprintf(fid, '%02X\t%02X\r\n',length_msb,length_lsb); %write length of burst: 3 and 132 (decimal) equals 0900 (hex)
fprintf(fid, '#Payload\r\n'); %write #Payload

% change
add = 1; % 0=romove , 1=add
symbol = 3; % number of the symbol to add
x = 1; % x coordinate, range: [0,19]
y = 1; % y coordinate, range: [0,14]
add_bin = dec2bin(add);
symbol_bin = dec2bin(symbol,13);
x_bin = dec2bin(x,5);
y_bin = dec2bin(y,4);
part1 = bin2dec(strcat('0',add_bin,symbol_bin(1:6)));
part2 = bin2dec(strcat(symbol_bin(7:13),y_bin(1)));
part3 = bin2dec(strcat(y_bin(2:4),x_bin));
fprintf(fid, '%02X\r\n',part1);
fprintf(fid, '%02X\r\n',part2);
fprintf(fid, '%02X\r\n',part3);
crc_sum = crc_sum + part1 + part2 + part3;

% change
add = 1; % 0=romove , 1=add
symbol = 6; % number of the symbol to add
x = 19; % x coordinate, range: [0,19]
y = 1; % y coordinate, range: [0,14]
add_bin = dec2bin(add);
symbol_bin = dec2bin(symbol,13);
x_bin = dec2bin(x,5);
y_bin = dec2bin(y,4);
part1 = bin2dec(strcat('0',add_bin,symbol_bin(1:6)));
part2 = bin2dec(strcat(symbol_bin(7:13),y_bin(1)));
part3 = bin2dec(strcat(y_bin(2:4),x_bin));
fprintf(fid, '%02X\r\n',part1);
fprintf(fid, '%02X\r\n',part2);
fprintf(fid, '%02X\r\n',part3);
crc_sum = crc_sum + part1 + part2 + part3;

% change
add = 1; % 0=romove , 1=add
symbol = 7; % number of the symbol to add
x = 1; % x coordinate, range: [0,19]
y = 14; % y coordinate, range: [0,14]
add_bin = dec2bin(add);
symbol_bin = dec2bin(symbol,13);
x_bin = dec2bin(x,5);
y_bin = dec2bin(y,4);
part1 = bin2dec(strcat('0',add_bin,symbol_bin(1:6)));
part2 = bin2dec(strcat(symbol_bin(7:13),y_bin(1)));
part3 = bin2dec(strcat(y_bin(2:4),x_bin));
fprintf(fid, '%02X\r\n',part1);
fprintf(fid, '%02X\r\n',part2);
fprintf(fid, '%02X\r\n',part3);
crc_sum = crc_sum + part1 + part2 + part3;

% change
add = 1; % 0=romove , 1=add
symbol = 5; % number of the symbol to add
x = 18; % x coordinate, range: [0,19]
y = 14; % y coordinate, range: [0,14]
add_bin = dec2bin(add);
symbol_bin = dec2bin(symbol,13);
x_bin = dec2bin(x,5);
y_bin = dec2bin(y,4);
part1 = bin2dec(strcat('0',add_bin,symbol_bin(1:6)));
part2 = bin2dec(strcat(symbol_bin(7:13),y_bin(1)));
part3 = bin2dec(strcat(y_bin(2:4),x_bin));
fprintf(fid, '%02X\r\n',part1);
fprintf(fid, '%02X\r\n',part2);
fprintf(fid, '%02X\r\n',part3);
crc_sum = crc_sum + part1 + part2 + part3;

fprintf(fid, '#CRC\r\n'); %write #CRC
crc = mod(crc_sum,256); % calcultae crc = (type +length + address + payload) mod 256
fprintf(fid, '%02X\r\n',crc ); %write CRC value
fprintf(fid, '#EOF\r\n'); %write #EOF
fprintf(fid, '%02X\r\n',eof ); %write EOF value


%% Prepare summary chunk


%% finish file
fclose(fid);
