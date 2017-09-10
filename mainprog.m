close all;
clear all;

img = imread('sample.tif');   % apply on .tif image only
I=im2double(img);

%figure,imshow(img);
img11 = histeq(I);        %histogram equalization (standard technique)
%figure,imshow(img11);      % for comparison with proposed method

img1 = dct2(I);              %dct transform (need to be saved for later)
%figure,imshow(img1);

img2=logtransform(img1); %log transform
%figure,imshow(img2);

%img1phase = cos(angle(img1)) + 1i*(sin(angle(img1))); % phase preservation of image 1

grayImage = im2double(img);
sigma = std2(grayImage);   % dynamic range compression

[M,N]=size(grayImage);
%lmeanfunc = grayImage*exp(-(x*x+y*y)/sigma*sigma);
%integral = integral2(@(x,y)exp(-(x.^2+y.^2)/sigma^2),0,M,0,N);
%disp(M);

integral=0.0;
        for p = 1:M
            for q = 1:N
                integral=integral+(exp(-(p^2+q^2)/sigma^2)*double(grayImage(p,q)));
                %img3(p,q) = 2/(1+exp(temp))-1;
            end
        end
        
integral=double(integral);
statistics=zeros(M,N);
lMean = zeros(M,N);
c = 1/integral;
%disp(integral);
        for p = 1:M
            for q = 1:N
                %disp(grayImage(p,q)); 
                %disp(c);
                lMean(p,q) = c*(exp(-(p^2+q^2)/(sigma^2)))*double(grayImage(p,q)); %local mean
                %disp(lMean(p,q));
                statistics(p,q) = ((252/255)*lMean(p,q))+3.0;
                %disp(statistics(p,q));
                temp = -2*(double(grayImage(p,q)))/statistics(p,q);
                %disp(temp);
                img3(p,q) = 2/(1+exp(temp))-1;
                %disp(img3(p,q));
            end
        end
                
%figure,imshow(img3);

img4 = histeq(img3);        %histogram equalization
%figure,imshow(img4);

img5 = dct2(img4);           %dct transform (need to be saved for later)
%figure,imshow(img5);

img6 = logtransform(img5);   %log transform
%figure,imshow(img6);

img7 = imhistmatch(img2,img6); % histogram matching
%figure,imshow(img7);

img8 = ilogtransform(img7);  %inverse log transform
%figure,imshow(img7);

        
img9 = abs(img8).*exp(1i*(angle(img1))); % phase restoration % here calculation of phase is to done.
%figure,imshow(img7);

img10 = idct2(img9);          % inverse orthogonal transform  % idct2 of imaginary is to taken care of.
%figure,imshow((img10));

imshowpair(real(img),real(img10),'montage')
title('original gray scale image(left) and processed image(right)');

%figure,imshow(img10);

%making it square matrix to calculate eme value
        if M>N
            X = I(M-N+1:end,:);
            Y = img11(M-N+1:end,:);
            Z = img10(M-N+1:end,:);
        else
            X = I(:,M-N+1:end);
            Y = img11(:,M-N+1:end);
            Z = img10(:,M-N+1:end);
        end
        
[H,J] = size(X);

disp(eme(X,H,5)); % eme value original image
disp(eme(Y,H,5));  % eme value standard technique
disp(real(eme(Z,H,5))); % eme value proposed technique




