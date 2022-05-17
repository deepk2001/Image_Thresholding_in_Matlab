clear 
close all
clc
%Open file
files = dir('FINAL TEST.jpg'); % List files in a directory
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
%Large Primairly Blue Targets
Blue_Check = imbinarize(Image_Blue, .67);
for i=1:2
 Blue_Check = bwareaopen(Blue_Check,2*10^i);
 [l NUM] = bwlabel(Blue_Check,4); %Get Number of Blobs
 clearvars l;
 if(NUM > 0) %Only apply Wiener2 filter if there are blobs
 Blue_Check = wiener2(Blue_Check,[3 3]);

 end
 Blue_Check = medfilt2(Blue_Check,[4 4]);
 
 subplot(3,3,1+i),imshow(Blue_Check), title("Detection");
end
%Apply Filter to all image slices
Image_Red = Blue_Check.*Image_Red;
Image_Green = Blue_Check.*Image_Green;
Image_Blue = Blue_Check.*Image_Blue;

subplot(3,3,4),imshow(Image_Red);

subplot(3,3,5),imshow(Image_Green);

subplot(3,3,6),imshow(Image_Blue);
Target = cat(3,Image_Red,Image_Green,Image_Blue);

subplot(3,3,7),imshow(Target);