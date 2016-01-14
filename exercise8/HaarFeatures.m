classdef HaarFeatures
    
    properties
        featuresPositions;
        featuresType;
        featuresAttributes;
        ii; % integral image
        n;
        winSize = 19;
    end
    
    methods
        function obj = HaarFeatures(classifiers)
            
            %positions            
            obj.n = size(classifiers,2);
            obj.featuresPositions.r = zeros(obj.n, 1);
            obj.featuresPositions.c = zeros(obj.n, 1);
            obj.featuresPositions.winWidth = zeros(obj.n, 1);
            obj.featuresPositions.winHeight = zeros(obj.n, 1);            
            
            % type 
            obj.featuresType = zeros(obj.n, 1);            
            
            % other attributes
            obj.featuresAttributes.mean = zeros(obj.n, 1);
            obj.featuresAttributes.std_deviation = zeros(obj.n, 1);
            obj.featuresAttributes.maxPos = zeros(obj.n, 1);
            obj.featuresAttributes.minPos = zeros(obj.n, 1);
            obj.featuresAttributes.R = zeros(obj.n, 1);
            obj.featuresAttributes.alpha = zeros(obj.n, 1);
            obj.featuresAttributes.error = zeros(obj.n, 1);
            obj.featuresAttributes.false_negative_error = zeros(obj.n, 1);
            obj.featuresAttributes.false_positive_error = zeros(obj.n, 1);
            obj.featuresAttributes.min_t = zeros(obj.n, 1);
            obj.featuresAttributes.max_t = zeros(obj.n, 1);
            
            for i = 1:obj.n
                obj.featuresPositions.r(i) = classifiers(1, i);
                obj.featuresPositions.c(i) = classifiers(2, i);
                obj.featuresPositions.winWidth(i) = classifiers(3, i);
                obj.featuresPositions.winHeight(i) = classifiers(4, i);   
                
                obj.featuresType(i) = classifiers(5, i);        
                
                obj.featuresAttributes.mean(i) = classifiers(6, i);
                obj.featuresAttributes.std_deviation(i) = classifiers(7, i);
                obj.featuresAttributes.maxPos(i) = classifiers(8, i);
                obj.featuresAttributes.minPos(i) = classifiers(9, i);
                obj.featuresAttributes.R(i) = classifiers(10, i);
                obj.featuresAttributes.alpha(i) = classifiers(11, i);
                obj.featuresAttributes.error(i) = classifiers(12, i);
                obj.featuresAttributes.false_negative_error(i) = classifiers(13, i);
                obj.featuresAttributes.false_positive_error(i) = classifiers(14, i);
                
                mean = obj.featuresAttributes.mean(i);
                minPos = obj.featuresAttributes.minPos(i);
                maxPos = obj.featuresAttributes.maxPos(i);
                R = obj.featuresAttributes.R(i);
                obj.featuresAttributes.min_t(i) = mean - (abs(mean - minPos) * (R - 5) / 50.0);
                obj.featuresAttributes.max_t(i) = mean + (abs(maxPos - mean) * (R - 5) / 50.0);
            end
            
        end
        
        function detected = HaarFeaturesCompute(obj, gray_img)
            
            scaleFactor = 0.8;
            scaledImg = gray_img;
            i = 1;
            
            while(size(scaledImg,1) >= obj.winSize && size(scaledImg,2) >= obj.winSize)                
                det_scales{i} = obj.HaarFeaturesComputeScale(scaledImg);
                scaledImg = imresize(scaledImg, scaleFactor);
                i = i+1;
            end            
        end
        
        function detected = HaarFeaturesComputeScale(obj, gray_img)
            
            % padded with zeros on left and top            
            obj.ii = integralImage(double(gray_img));
            obj.ii = obj.ii(2:end,2:end);
                        
            wm = size(obj.ii, 1) - obj.winSize;
            wn = size(obj.ii, 2) - obj.winSize;
            
            response_matrix = zeros(obj.n, wm*wn);
                        
            for f = 1:obj.n
                
                r = obj.featuresPositions.r(f);
                c = obj.featuresPositions.c(f);
                w = obj.featuresPositions.winWidth(f);
                h = obj.featuresPositions.winHeight(f);
                
                feat_type = obj.featuresType(f);
            
                for i=1:wm
                    for j=1:wn
                        feature_pos = [r+i-1 c+j-1 w h];
                        response = FeatureResponse(obj, feat_type, feature_pos);
                        if response == 0
                            resp(i,j) = 0;
                        elseif (response <= obj.featuresAttributes.max_t(f) && ...
                            response >= obj.featuresAttributes.min_t(f))
                            resp(i,j) = obj.featuresAttributes.alpha(f);
                        else
                            resp(i,j) = -obj.featuresAttributes.alpha(f);
                        end
                    end
                end
                response_matrix(f, 1:wm*wn) = reshape(resp, 1, wm*wn);
            end
            detected = find(sum(response_matrix)>0);
        end
        
        function response = FeatureResponse(obj, feat_type, feature_pos)
            
            r = feature_pos(1);
            c = feature_pos(2);
            w = feature_pos(3);
            h = feature_pos(4);
            
            % D + A - B - C
            rect_value = @(coords) ...
                obj.ii(coords(4,1), coords(4,2)) + ...  % D
                obj.ii(coords(1,1), coords(1,2)) - ...  % A
                obj.ii(coords(2,1), coords(2,2)) - ...  % B
                obj.ii(coords(3,1), coords(3,2));       % C      

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
        
        function [ iImg ] = buildIntegralImage(obj, I)
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
