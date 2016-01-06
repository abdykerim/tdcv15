classdef WeakClassifier < handle
    
    properties
        data;   % data
        t;      % threshold
        axis;   % classifier axe
        w;      % weights
        labels; % target values for the trainning set
        err;    % classification error
        alpha;  % classifier weight
        miss;   % index of missclassified objects         
    end
    
    methods
        
        function obj = WeakClassifier(dataset, labels, weights)
            
            obj.data = dataset(:,1:2);
            obj.labels = labels;
            obj.err = Inf;
            obj.t = -Inf;
            
            if(isempty(weights))
                right_idx = obj.labels == 1;
                left_idx = obj.labels == -1;
                obj.w(right_idx) = 1 / (2*sum(right_idx));
                obj.w(left_idx) = 1 / (2*sum(left_idx));
            else
                obj.w = weights;
            end
        end
        
        function [prediction] = Test(obj, dataset)
            prediction = dataset;
            left = prediction(:,obj.axis) < obj.t;
            right = prediction(:,obj.axis) >= obj.t;
            prediction(left,3) = -1;
            prediction(right,3) = 1;
        end
        
        function [weights] = Train(obj)
            
            % find a threshhold that minimizes the error function
            
            obj.fit_axis(obj.data, 1);
            obj.fit_axis(obj.data, 2);
            
            % update weights, return next classifier weights
            
            epsilon = obj.err / sum(obj.w);           % normalize the error
            obj.alpha = log((1-epsilon) / epsilon);
            weights = obj.w .* exp(obj.alpha * obj.miss');
            weights = weights ./ sum(weights);        % normalize weights
        end
        
        function [] = fit_axis(obj, data, axis)
                   
            sorted = sort(data(:,axis));
                        
            for i = 1:size(sorted)-1
                tr = (sorted(i+1) + sorted(i)) / 2;
                [e, misses] = obj.error(data(:,axis), tr);
                if(e < obj.err)
                    obj.axis = axis;
                    obj.err = e;
                    obj.t = tr;
                    obj.miss = misses;
                end
            end
        end
        
        function [e, missclassified] = error(obj, data, threshold)                      
            
            miss_left = bsxfun(@and, data < threshold, obj.labels == 1);
            miss_right = bsxfun(@and, data >= threshold, obj.labels == -1);            
            missclassified = bsxfun(@or, miss_left, miss_right);  
            
            e = sum(obj.w(missclassified));
        end
    end
    
end

