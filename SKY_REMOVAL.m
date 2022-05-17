clear 
close all
clc
%Open file
files = dir('test2.jpg'); % List files in a directory
if( ~isempty(files) > 0 )
 [cdata,map] = imread(files(1).name);
 if ~isempty( map )
 cdata = ind2rgb( cdata, map);
 end
 figure();
 subplot(3,3,1),imshow(cdata); %Display Image
end 
%Convert to RGB Images
inputImg = cdata;
doubleImg = im2double(inputImg);
Image_Red = im2double(inputImg(:,:,1)); %Red frame to Double
Image_Green = im2double(inputImg(:,:,2)); %Green frame to Double
Image_Blue = im2double(inputImg(:,:,3)); %Blue frame to Double
subplot(3,3,2),imshow(Image_Blue),title("Blue Image Matrix");
%Sky and Horizon Elimination
Sky_Check = imbinarize(Image_Blue, .33); %Threshold at a suitable value to get sky
subplot(3,3,3),imshow(Sky_Check),title("Image to Black and White");
Sky_Check = bwareaopen(Sky_Check,10); %Remove groups under 10 pixels
[l NUM] = bwlabel(Sky_Check,4);
subplot(3,3,4),imshow(Sky_Check),title("10PX LARGE NOISE REMOVAL");
Sky_Check = wiener2(Sky_Check,[3 3]); %Wiener filter image over 3x3 areas
subplot(3,3,5),imshow(Sky_Check),title("Wiener filter over 3x3 area");
Sky_Check = medfilt2(Sky_Check,[4 4]); %Median filter at 4x4 areas
subplot(3,3,6),imshow(Sky_Check),title('Median Filter over 4x4 area');
Sky_Check = bwareaopen(Sky_Check,1000); %Find groups larger than 1000 pixels
subplot(3,3,7),imshow(Sky_Check),title("remove blobs under 1000 pixels");
Sky_Check = im2double(Sky_Check); %Convert to a double
Sky_Check = Sky_Check - imclearborder(Sky_Check);
subplot(3,3,8),imshow(Sky_Check), title('Subtrack Large Blobs that touch the Border');
%Remove Sky from all RGB Component Images
 %Only apply Wiener2 filter if there are blobs
if (NUM > 0)
Image_Red = Image_Red.*~Sky_Check;
Image_Green = Image_Green.*~Sky_Check;
Image_Blue = Image_Blue.*~Sky_Check;
end

subplot(3,3,9),imshow(cat(3,Image_Red,Image_Green,Image_Blue)),title('Sky Free Image');
imwrite(cat(3,Image_Red,Image_Green,Image_Blue),'Sky Free Image.jpg')
