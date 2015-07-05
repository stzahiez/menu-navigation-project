%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Model Name 	:	Load_SDRAM
% File Name	:	Load_SDRAM.m
% Generated	:	02.08.2012
% Author		:	Olga Liberman and Yoav Shvartz
% Project		:	Symbol Generator Project
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% 
%   Input parameters:
%             max
%                     total number of symbol images is max+1
%             prefix
%                     the prefix of the symbols file name
%             filename
%                     txt file that models the SDRAM memory,
%                     contains the symbols that are saved

%     The structure of the text file:
% 
%     address=00<2 bits for the bank><12 bits for the row><8 bits for the column>
%     <pixel 1, 8 bits>
%     <pixel 2, 8 bits>
%             ...
%             ...
%             ...
%     <pixel 32, 8 bits>
%     address=00<2 bits for the bank><12 bits for the row><8 bits for the column>
%     <pixel 1, 8 bits>
%     <pixel 2, 8 bits>
%             ...
%             ...
%             ...
%     <pixel 32, 8 bits>
%     (and follows...)
% 
%     the columns of the addresses are incresed by 16 words.
% 
%     Example for a text file is the memory.txt, supplied with this file.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision:
% Number		Date                  Name				Description
%   1.0                 02.08.2012          Olga               Creation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To Do:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = Load_SDRAM( filename , prefix , max )

if (max<=0)
    return
end

%Create_Symbols( prefix , max);

file = fopen( filename ,'wt');

% symbol n is saved in the rows 2*n and 2*n+1
for n=0:max
    if (n<10)
        symbol_name = strcat( prefix , '_0' , int2str(n) , '.bmp' );
    else
        symbol_name = strcat( prefix , '_' , int2str(n) , '.bmp' );
    end
    im = imread(symbol_name, 'bmp');
    for row=(2*n):(2*n+1);
        for i=0:15
            fprintf(file,'address=%s\n',dec2bin(row*256+16*i,24));
            for k=1:32
                    fprintf(file,'%s\n',dec2bin(im(i+1,k,1),8));
            end
        end
    end
end

fclose(file);