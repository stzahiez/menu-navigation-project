% compare=1 when the images are equal
function compare = Image_Compare(img_num)

output = imread(strcat('H:\Project\SG_Project\test_files\test_random_4\output\out_img_',num2str(img_num),'.bmp'));
output = double(output(:,:,1));
expected = imread(strcat('H:\Project\SG_Project\test_files\test_random_4\expected\out_img_',num2str(img_num),'.bmp'));
expected = double(expected(:,:,1));

% check if dimensions match
if ( size(output,1)~=size(expected,1) )
    compare = 0;
    return
else if ( size(output,2)~=size(expected,2) )
    compare = 0;
    return
    end
end

% if dimensions match, check the diff of the images
if (output==expected)
    compare = 1; % 1 when the images are equal
else
    compare = 0;
end
