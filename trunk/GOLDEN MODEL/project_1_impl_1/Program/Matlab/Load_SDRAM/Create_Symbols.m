%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Model Name 	:	Create_Symbols
% File Name	:	Create_Symbols.m
% Generated	:	02.08.2012
% Author		:	Olga Liberman and Yoav Shvartz
% Project		:	Symbol Generator Project
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% This function creates symbol images size 32*32 pixels
% of grayscale bmp format.
% The file name of the symbols has the structure:
% <prefix>_<2 digits num>.bmp
% prefix - the prefix, is an input parameter
% The 2-digits-num of each symbol is increased by 1.
% The max input parameter defines the total number
% of symbol images created by the function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision:
% Number        Date            Name                Description
% 1.0           02.08.2012      Olga Liberman       Creation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = Create_Symbols( prefix , max)

if (max<=0)
    return
end

n=0;

%% create black symbol no.1
if (max>=n)
    if (n<10)
        filename=strcat(prefix,'_0',int2str(n),'.bmp');
    else
        filename=strcat(prefix,'_',int2str(n),'.bmp');
    end
    im = uint8(zeros(32,32,3));
    imwrite( im , filename , 'bmp');
    n=n+1;
end

%% create white symbol no.2
if (max>=n)
    if (n<10)
        filename=strcat(prefix,'_0',int2str(n),'.bmp');
    else
        filename=strcat(prefix,'_',int2str(n),'.bmp');
    end
    im = uint8(255*ones(32,32,3));
    imwrite( im , filename , 'bmp');
	n=n+1;
end


%% create gray dark symbol no.3
if (max>=n)
    if (n<10)
        filename=strcat(prefix,'_0',int2str(n),'.bmp');
    else
        filename=strcat(prefix,'_',int2str(n),'.bmp');
    end
    im = uint8(100*ones(32,32,3));
    imwrite( im , filename , 'bmp');
	n=n+1;
end

%% create gray light symbol no.4
if (max>=n)
    if (n<10)
        filename=strcat(prefix,'_0',int2str(n),'.bmp');
    else
        filename=strcat(prefix,'_',int2str(n),'.bmp');
    end
    im = uint8(190*ones(32,32,3));
    imwrite( im , filename , 'bmp');
	n=n+1;
end

%% create chess symbol no.5
if (max>=n)
    if (n<10)
        filename=strcat(prefix,'_0',int2str(n),'.bmp');
    else
        filename=strcat(prefix,'_',int2str(n),'.bmp');
    end
    im = uint8(zeros(32,32,3));
    for row=1:32
        for col=1:32
            if ((mod(row,2)==0)&&(mod(col,2)==0))
                im(row,col,:)=256;
            else
                im(row,col,:)=0;
            end
        end
    end
    imwrite( im , filename , 'bmp');
    n=n+1;
end

%% create horizontal stripes symbol no.6
if (max>=n)
    if (n<10)
        filename=strcat(prefix,'_0',int2str(n),'.bmp');
    else
        filename=strcat(prefix,'_',int2str(n),'.bmp');
    end
    im = uint8(zeros(32,32,3));
    for row=1:32
        for col=1:32
            if (mod(row,2)==0)
                im(row,col,:)=256;
            else
                im(row,col,:)=0;
            end
        end
    end
    imwrite( im , filename , 'bmp');
    n=n+1;
end

%% create vertical stripes symbol no.7
if (max>=n)
    if (n<10)
        filename=strcat(prefix,'_0',int2str(n),'.bmp');
    else
        filename=strcat(prefix,'_',int2str(n),'.bmp');
    end
    im = uint8(zeros(32,32,3));
    for row=1:32
        for col=1:32
            if (mod(col,2)==0)
                im(row,col,:)=256;
            else
                im(row,col,:)=0;
            end
        end
    end
    imwrite( im , filename , 'bmp');
    n=n+1;
end


%% create horizontal shade symbol no.8
if (max>=n)
    if (n<10)
        filename=strcat(prefix,'_0',int2str(n),'.bmp');
    else
        filename=strcat(prefix,'_',int2str(n),'.bmp');
    end
    im = uint8(zeros(32,32,3));
    for row=1:32
        for col=1:32
            im(row,col,:)=8*row+col;
        end
    end
    imwrite( im , filename , 'bmp');
    n=n+1;
end

%% create vertical shade symbol no.9
if (max>=n)
    if (n<10)
        filename=strcat(prefix,'_0',int2str(n),'.bmp');
    else
        filename=strcat(prefix,'_',int2str(n),'.bmp');
    end
    im = uint8(zeros(32,32,3));
    for row=1:32
        for col=1:32
            im(row,col,:)=8*col+row;
        end
    end
    imwrite( im , filename , 'bmp');
    n=n+1;
end


%% create horizontal shade symbol no.10
if (max>=n)
    if (n<10)
        filename=strcat(prefix,'_0',int2str(n),'.bmp');
    else
        filename=strcat(prefix,'_',int2str(n),'.bmp');
    end
    im = uint8(zeros(32,32,3));
    for row=1:32
        for col=1:32
            im(row,col,:)=4*(row+col);
        end
    end
    imwrite( im , filename , 'bmp');
    n=n+1;
end

%% create bebug symbol of the form: no.11
% 
%         1 2 3 ... 32
%         1 2 3 ... 32
%         .
%         .
%         .
%         1 2 3 ... 32
%
if (max>=n)
    if (n<10)
        filename=strcat(prefix,'_0',int2str(n),'.bmp');
    else
        filename=strcat(prefix,'_',int2str(n),'.bmp');
    end
    im = uint8(zeros(32,32,3));
    for row=1:32
        count=1;
        for col=1:32
            im(row,col,:)=count;
            count=count+1;
        end
    end
    imwrite( im , filename , 'bmp');
    n=n+1;
end