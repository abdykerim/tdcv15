classdef WeakClassifier < handle
    
    properties
        data;   % data
        t;      % threshold
        axis;   % classifier axe
        w;      % weights
        labels; % target values for the trainning set
        err;    % classification error
        alpha;  % classifier weight
    end
    
    methods
        function obj = WeakClassifier(dataset, labels, weights)
            
            obj.axis = randi(2); % ramdomly select the one of the two axis as the stump classifier
            obj.data = dataset(:,obj.axis);
            obj.t = min(obj.data);
            obj.labels = labels;
            obj.err = Inf;
            
            if(isempty(weights))
                obj.w = ones(1,size(obj.data,1)) / size(obj.data,1);
            else
                obj.w = weights;
            end
        end
        
        function prediction = Test(obj, dataset)
            prediction = dataset;
            left = prediction(:,obj.axis) < obj.t;
            right = prediction(:,obj.axis) >= obj.t;
            prediction(left,3) = -1;
            prediction(right,3) = 1;
        end
        
        function weights = Train(obj)
            
            sorted = sort(obj.data);            
            miss = [];
            
            % find a threshhold that minimizes the error function
            
            for i = 1:size(obj.data)-1;
                threshold = (sorted(i+1) + sorted(i)) / 2;
                [e, missclassified] = obj.error(threshold);
                if(e < obj.err)
                    obj.err = e;
                    obj.t = threshold;
                    miss = missclassified;
                end
            end
            
            % update weights, return next classifier weights
            
            epsilon = obj.err / sum(obj.w);
            obj.alpha = log((1-epsilon) / epsilon);
            weights = obj.w;
            weights(miss) = obj.w(miss) .* exp(obj.alpha);
        end
        
        function [e,missclassified] = error(obj, threshold)
            left = obj.data < threshold;
            right = obj.data >= threshold;        
            missclassified = [find(obj.labels(left) ~= -1)' find(obj.labels(right) ~= 1)'];
            e = sum(obj.w(missclassified));
        end
    end
    
end

