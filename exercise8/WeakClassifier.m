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
            
            % how do you come up with this value?
            
            % We are trying to minimize the error with the simple method of 
            % a "less than" comparison of the current value over iterations.
            % So Inf looks like a fair value to ensure that we are not passing
            % by any error as big as it might be.
            obj.err = Inf;
            
            % how do you come up with this value?
            
            % We are minimizing the error by swaping a threshold across the
            % data that is parallel to one of the axis. It goes in
            % assendending order and is allways updated since there is
            % allways one that minimizes the error function. This is just
            % the least possible one. If you see an -Inf valued threshold
            % in the trained classifier then there's bug, but it hasn't
            % happend to me so far. 
            obj.t = -Inf;
            
            % TODO: but it says weights = 1/N in the beginning, why do you give
            % them different weights based on the label (sign)?
            
            % If take a look at the algorithm in the paper you will see this
            % initialization. If you notice also that in the test data the
            % amount of 1 and -1 labeled data are equal you will see that 
            % this end up precisely with weight values of 1/N so this is not 
            % affecting the results.
            % I began directly assigning 1/N values and then tried this to
            % see whether it improves the classification.
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

