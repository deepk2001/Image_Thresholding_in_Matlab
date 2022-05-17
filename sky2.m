%Open file
files = dir('TEST.jpg'); % List files in a directory
if( ~isempty(files) > 0 )
 [cdata,map] = imread(files(1).name);
 if ~isempty( map )
 cdata = ind2rgb( cdata, map);
 end
 figure('NumberTitle', 'off', 'Name', 'Original Image'); %label figure components
 imshow(cdata); %Display Image
%Convert to RGB Images
end
inputImg = cdata;
doubleImg = im2double(inputImg);
Image_Red = im2double(inputImg(:,:,1)); %Red frame to Double
Image_Green = im2double(inputImg(:,:,2)); %Green frame to Double
Image_Blue = im2double(inputImg(:,:,3)); %Blue frame to Double
figure('NumberTitle', 'off', 'Name', 'Blue Image Matrix'); %label figure components
imshow(Image_Blue);
%Sky and Horizon Elimination
Sky_Check = imbinarize(Image_Blue, .50); %Threshold at a high value to get sky
figure('NumberTitle', 'off', 'Name', 'Image to Black and White'); %label figure components
imshow(Sky_Check);
Sky_Check = bwareaopen(Sky_Check,10); %Remove groups under 10 pixels
figure('NumberTitle', 'off', 'Name', 'Remove Noise under 10 Pixels Large'); %label figure components
imshow(Sky_Check);
Sky_Check = wiener2(Sky_Check,[3 3]); %Wiener filter image over 3x3 areas
figure('NumberTitle', 'off', 'Name', 'Wiener filter over 3x3 area'); %label figure components
imshow(Sky_Check);
Sky_Check = medfilt2(Sky_Check,[4 4]); %Median filter at 4x4 areas
figure('NumberTitle', 'off', 'Name', 'Median Filter over 4x4 area'); %label figure components
imshow(Sky_Check);
Sky_Check = bwareaopen(Sky_Check,10000); %Find groups larger than 10,000 pixels
figure('NumberTitle', 'off', 'Name', 'remove blobs under 10,000 pixels'); %label figure components
imshow(Sky_Check);
Sky_Check = im2double(Sky_Check); %Convert to a double
Sky_Check = Sky_Check - imclearborder(Sky_Check);
figure('NumberTitle', 'off', 'Name', 'Subtrack Large Blobs that touch the Border'); %label figure components
imshow(Sky_Check);
%Remove Sky from all RGB Component Images
if(NUM > 0) %Only apply Wiener2 filter if there are blobs
Image_Red = Image_Red.*~Sky_Check;
Image_Green = Image_Green.*~Sky_Check;
Image_Blue = Image_Blue.*~Sky_Check;
end
figure('NumberTitle', 'off', 'Name', 'Sky Free Image'); %label figure components
imshow(cat(3,Image_Red,Image_Green,Image_Blue));