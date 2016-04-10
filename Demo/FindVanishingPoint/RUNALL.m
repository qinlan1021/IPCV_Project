% This is the main file, it will run findVanishingPoint() function on all
% the images in 'dname' folder and save the results to the images
% 'resultNNN.jpg' in the working folder.

clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%% read the image
% original = imread('../images/Image155.jpg');
% original = imread('../images/indiana.jpg');
original = imread('picture2.jpg');
% original = imread('../frames/fakeroad.bmp');
% original = imread('../frames/verticalbar.bmp');
% original = imread('../frames/cross.bmp');

dname = '../images';
files = dir(dname);
files(1) = [];
files(1) = [];
for i=1:size(files, 1)
    original = imread(fullfile(dname, files(i).name));
    original = imresize(original,0.35);    
    im = im2double(rgb2gray(original));	
    [row, col] = findVanishingPoint(im);
    imshow(original);hold;plot(col,row,'rx');
    saveas(gcf,strcat('result',num2str(i)),'jpg');
    close
end    

        
