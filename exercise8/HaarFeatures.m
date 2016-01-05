classdef HaarFeatures
    
    properties
        featuresPositions;
        featuresType;
        featuresAttributes;
        ii; %integral image
        n;
    end
    
    methods
        function obj = HaarFeatures(classifiers)
            %positions
            obj.n = size(classifiers,2);
            obj.featuresPositions.r = zeros(obj.n, 1);
            obj.featuresPositions.c = zeros(obj.n, 1);
            obj.featuresPositions.winWidth = zeros(obj.n, 1);
            obj.featuresPositions.winHeight = zeros(obj.n, 1);
            
            obj.featuresType = zeros(obj.n, 1);
            
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
        function response = HaarFeaturesCompute(obj, gray_img)
            %padded with zeros on left and top
            obj.ii = integralImage(double(gray_img));
            
            response = cell(1, obj.n);
            for i = 1:obj.n
                r = obj.featuresPositions.r(i);
                c = obj.featuresPositions.c(i);
                w = obj.featuresPositions.winWidth(i);
                h = obj.featuresPositions.winHeight(i);
                feature_pos = [r c w h];
                feat_type = obj.featuresType(i);
                response{i} = FeatureResponse(obj, feat_type, feature_pos);
            end
            
            % rest in progress
            % TODO: need to slide the window and update feature_pos
        end
        
        function response = FeatureResponse(obj, feat_type, feature_pos)
            
            r = feature_pos(1);
            c = feature_pos(2);
            w = feature_pos(3);
            h = feature_pos(4);
            
            % TODO: I am not sure if rect_value calculation is correct,
            % shouldn't response give 1 value, not vector?
            
            % The coordinate pair must be passed explicitly and not as a
            % vector. This is a minor adjustment in a well known formula
            % that shouldn't be stopping us. It is returning a scalar now. 
            rect_value = @(coords) ...
                obj.ii(coords(4,1), coords(4,2)) + ...
                obj.ii(coords(1,1), coords(1,2)) - ...
               (obj.ii(coords(2,1), coords(2,2)) + ...
                obj.ii(coords(3,1), coords(3,2)));
            

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
        
    end
    
end
