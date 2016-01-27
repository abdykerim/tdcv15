function [ cor_matrix ] = correlate( T, I )
% straightforward application of formula from pdf, extremely slower that
% fft calculation
cor_matrix=zeros(size(I,1),size(I,2));
I = padarray(I, size(T)-1);
[r1,c1]=size(I);
[r2,c2]=size(T);
%correlate both images
for i=1:(r1-r2+1)
    for j=1:(c1-c2+1)
        img_reg=I(i:i+r2-1,j:j+c2-1);
        corr=sum(sum(img_reg.*T));
        cor_matrix(i,j)=corr;
    end
end
end

