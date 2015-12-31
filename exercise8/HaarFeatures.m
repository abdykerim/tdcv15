classdef HaarFeatures
    
    properties
    end
    
    methods
        function obj = HaarFeatures()
        end
        
        function [] = HaarFeaturesCompute(obj);
        end
        
        function response = featureResponse(obj, feat_type, feature)
            
            r = feature(1);
            c = feature(2);
            w = feature(3);
            h = feature(4);
            
            rect_value = @(coords) ...
                 obj.ii(coords(4,:)) + obj.ii(coords(1,:)) - ...
                (obj.ii(coords(2,:)) + obj.ii(coords(3,:)));
            
            switch feat_type
                case 1
                    rect_1 = [r c; r c+w/2-1; r+h-1 c; r+h-1 c+w/2-1];
                    rect_2 = [r c+w/2; r c+w-1; r+h-1 c+w/2; r+h-1 c+w-1];
                    response = rect_value(rect_1) + rect_value(rect_2);
                case 2
                    rect_1 = [r c; r c+w-1; r+h/2-1 c; r+h/2-1 c+w-1];
                    rect_2 = [r+h/2 c; r+h/2 c+w-1; r+h-1 c; r+h-1 c+w-1];
                    response = rect_value(rect_1) + rect_value(rect_2);
                case 3
                    rect_1 = [r c; r c+w/3-1; r+h-1 c; r+h-1 c+w/3-1];
                    rect_2 = [r c+w/3; r c+2*w/3-1; r+h-1 c+w/3; r+h-1 c+2*w/3-1];
                    rect_3 = [r c+2*w/3; r c+w-1; r+h-1 c+2*w/3; r+h-1 c+w-1];
                    response = rect_value(rect_1) - rect_value(rect_2) + rect_value(rect_3);
                case 4
                    rect_1 = [r c; r c+w-1; r+h/3-1 c; r+h/3-1 c+w-1];
                    rect_2 = [r+h/3 c; r+h/3 c+w-1; r+2*h/3 c; r+2*h/3 c+w-1];
                    rect_3 = [r+2*h/3 c; r+2*h/3 c+w-1; r+h-1 c; r+h-1 c+w-1];
                    response = rect_value(rect_1) - rect_value(rect_2) + rect_value(rect_3);
                case 5
                    rect_1 = [r c; r c+w/2-1; r+h/2-1 c; r+h/2-1 c+w/2-1];
                    rect_2 = [r c+w/2; r c+w-1; r+h/2-1 c+w/2; r+h/2-1 c+w-1];
                    rect_3 = [r+h/2 c; r+h/2 c+w/2-1; r+h-1 c; r+h-1 c+w/2-1];
                    rect_4 = [r+h/2 c+w/2; r+h/2 c+w-1; r+h-1 c+w/2; r+h-1 c+w-1];
                    response = rect_value(rect_1) - rect_value(rect_2) + rect_value(rect_3)- rect_value(rect_4);
            end
        end
        
        function [ iImg ] = buildIntegralImage( I )

            iImg = double(I);

            for j = 2:size(I,2)
                iImg(1,j) = iImg(1,j) + iImg(1,j-1);
            end

            for i = 2:size(I,1)
                iImg(i,1) = iImg(i,1) + iImg(i-1,1);
                for j = 2:size(I,2)
                    iImg(i,j) = iImg(i,j) + iImg(i,j-1) + iImg(i-1,j);
                end
            end
        end
    end
    
end

