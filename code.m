
y=imread('3.jpg');
x=rgb2gray(y);
z=double(x);
for i=1:size(z,1)-2
    for j=1:size(z,2)-2
        Gx=((2*z(i+2,j+1)+z(i+2,j)+z(i+2,j+2))-(2*z(i,j+1)+z(i,j)+z(i,j+2)));
        Gy=((2*z(i+1,j+2)+z(i,j+2)+z(i+2,j+2))-(2*z(i+1,j)+z(i,j)+z(i+2,j)));
        x(i,j)=sqrt(Gx.^2+Gy.^2);
    end
end
%   1   Edge detection
figure,imshow(x);
j=histeq(x);
%   2   Histogram equalization
figure,imshow(j);

y=imread('3.jpg');
x=rgb2gray(y);
PSF=fspecial('motion',13,45);
INITPSF=ones(size(PSF));
se1 = strel('disk',2);
se2 = strel('line',13,45);
weight=x;
w=double(weight);
for i=1:size(w,1)-2
    for j=1:size(w,2)-2
        Gx=((2*w(i+2,j+1)+w(i+2,j)+w(i+2,j+2))-(2*w(i,j+1)+w(i,j)+w(i,j+2)));
        Gy=((2*w(i+1,j+2)+w(i,j+2)+w(i+2,j+2))-(2*w(i+1,j)+w(i,j)+w(i+2,j)));
        weight(i,j)=sqrt(Gx.^2+Gy.^2);
    end
end
weight=1-double(imdilate(weight,[se1 se2]))/256;
%weight=padarray(weight([1:2 end-[0:1]],[1:2 end-[0:1]]),[2 2]);
%weight([1:3 end-[0:2]],:) = 0;
%weight(:,[1:3 end-[0:2]]) = 0;

%   3   Weight
figure,imshow(weight);
[J P]=deconvblind(x,INITPSF,30,[],weight);
P1=P;
P1(find(P1<0.01))=0.000001;
[J2 P2]=deconvblind(x,P1,30,[],weight);
FUN = @(P2) padarray(P2(3:end-2,3:end-2),[2 2]);
[JF PF] = deconvblind(x,P2,30,[],weight,FUN);
%   4   Deblurring
figure,imshow(JF);
bit7=bitget(x,7);
%   5   Bit 7
figure,imshow(bit7,[]);

y=imread('3.jpg');
x=rgb2gray(y);
%   6   Addition
figure,imshow(x+100);
%   7   Subtraction
figure,imshow(x-100);
%   8   Multiplication
figure,imshow(x*2);
%   9   Division
figure,imshow(x/5);
%   10  Reversal
figure,imshow(255-x);
%   11  Bitmap
figure,imshow(im2bw(x,0.5));
%   12  Gaussian noise
g=imnoise(x,'gaussian',0,0.01);
figure,imshow(g);
%   13  Salt and pepper noise
g=imnoise(x,'salt & pepper',0.05);
figure,imshow(g);
%   14  Speckle noise
g=imnoise(x,'speckle',0.04);
figure,imshow(g);
%   15  Blurring
h=fspecial('gaussian',size(x),1.0);
g=imfilter(x,h);
figure,imshow(g);
