%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Model Name 	:	txt2bmp
% File Name	:	txt2bmp.m
% Generated	:	02.08.2012
% Author		:	Olga Liberman and Yoav Shvartz
% Project		:	Symbol Generator Project
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%
% Description:
% This function creates a bmp image file
% (with R rows and C columns) from the text file named
% txtfile.
% The name of the image file is exactly as the text file,
% with the suffix 'bmp'.
% Notice: txtfile is without the suffix 'txt' ,
% only the file name
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision:
% Number    Date            Name                Description
% 1.0       02.08.2012      Olga Liberman       Creation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      

function [] = txt2bmp( txtfile , R , C )

% illegal image size
if ( (R<=0) || (C<=0) )
    error('Illegal dimensions for the image!');
end

% open the text file in read permission
fid = fopen( strcat(txtfile,'.txt') , 'r');
im=uint8(zeros(R,C,3));
Block = 1;                                         % Initialize block index
while (~feof(fid))                                   % For each block:
    InputText = textscan(fid,'%s',C);
    A=InputText{1,1};
    if ( (size(A,1)==C) && (size(A,2)==1) )
        im(Block,:,1) = bin2dec((A(:,1)'));
        im(Block,:,2) = bin2dec((A(:,1)'));
        im(Block,:,3) = bin2dec((A(:,1)'));
        Block = Block+1;                               % Increment block index
    end
end
fclose(fid);

% save the image
imwrite(im, strcat(txtfile,'.bmp'), 'bmp');


end