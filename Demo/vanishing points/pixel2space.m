function [ x,y ] = pixel2space(i,j)
%PIXEL2SPACE Summary of this function goes here
%   Detailed explanation goes here
global rate;
x = (i-352) *rate;
y = (j-288)*rate;

end

