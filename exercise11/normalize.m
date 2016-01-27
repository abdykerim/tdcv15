function [ normImg ] = normalize( Img )
    normImg = (Img - mean (Img(:)) ) / std (Img(:));
end