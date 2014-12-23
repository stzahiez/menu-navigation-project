file = fopen('memory.txt','wt');

%% black symbol
row=0;
for i=0:15
    fprintf(file,'address=%s\n',dec2bin(row*256+16*i,24));
    for k=1:32
            fprintf(file,'%s\n',dec2bin(0,8));
    end
end
row=1;
for i=0:15
    fprintf(file,'address=%s\n',dec2bin(row*256+16*i,24));
    for k=1:32
            fprintf(file,'%s\n',dec2bin(0,8));
    end
end

%% symbol 1
row=2;
for i=0:15
    fprintf(file,'address=%s\n',dec2bin(row*256+16*i,24));
    for k=1:32
            fprintf(file,'%s\n',dec2bin(i+k,8));
    end
end
row=3;
for i=0:15
    fprintf(file,'address=%s\n',dec2bin(row*256+16*i,24));
    for k=1:32
            fprintf(file,'%s\n',dec2bin(i+k,8));
    end
end

fclose(file)
