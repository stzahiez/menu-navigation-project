 % text file for frame 480*640
filename = 'frame_00.txt';
file = fopen( filename ,'wt');
for sym_row=1:15
    for row=1:32
        for sym_col=1:20
            for col=1:32
                fprintf(file,'%s\n',dec2bin(4*(row+col),8));
            end
        end
    end
end
fclose(file);

txtfile = 'frame_00';
R=480;
C=640;
txt2bmp( txtfile , R , C );