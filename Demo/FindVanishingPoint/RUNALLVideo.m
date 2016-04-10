% This is the main file, it will run findVanishingPoint() function on all
% the images in 'dname' folder and save the results to the avi file 
% in the working folder.
clear all; close all;
dname = '../../images/frames/asphalt';
% dname = '../../images/frames/indiana';
files = dir(dname); files(1) = []; files(1) = [];
aviobj = avifile('vanishing point.avi');
S = 2;
figure('DoubleBuffer','on');

for i=1:size(files, 1)
    original = imread(fullfile(dname, files(i).name));
%     original = imresize(original,0.7);    
    im = im2double(rgb2gray(original));	
%     [row, col] = findVanishingPoint(im);
%     row = findHorizon(im);
      row = findHorizonEdge(im);
    original(row,1:end,2) = 255;
    aviobj = addframe(aviobj, original);
     imshow(original);pause(0.01)
i
end    

        
aviobj = close(aviobj);