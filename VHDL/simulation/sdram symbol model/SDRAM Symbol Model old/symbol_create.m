% sin image 32x32
image1 = 0.5 * sin([1:32]')*ones(1,32) + 0.5*ones([32 32]);
image2 = image';
im=image.*image2;
im256=256*im;
im8=uint8(im256);

file_1 = fopen('symbol_1.txt','wt');
for i=1:32
    for k=1:32
        if (i==32 && k==32)
            fprintf(file_1,'%s',dec2bin(im8(i,k),8));
        else
            fprintf(file_1,'%s\n',dec2bin(im8(i,k),8));
        end
    end
end
fclose(file_1)

% black image 32x32
file_2 = fopen('symbol_black.txt','wt');
for i=1:32
    for k=1:32
        if (i==32 && k==32)
            fprintf(file_2,'%s',dec2bin(0,8));
        else
            fprintf(file_2,'%s\n',dec2bin(0,8));
        end
    end
end
fclose(file_2)
