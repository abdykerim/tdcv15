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
        inv;    % whether to use inverted labels
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
            
            if(obj.inv)
                left = prediction(:,obj.axis) >= obj.t;
                right = prediction(:,obj.axis) < obj.t;
            else
                left = prediction(:,obj.axis) < obj.t;
                right = prediction(:,obj.axis) >= obj.t;
            end
            
            prediction(left,3) = -1;
            prediction(right,3) = 1;
        end
        
        function [weights] = Train(obj)
            
            % find a threshhold that minimizes the error function
            
            obj.fit_axis(obj.data, 1, 0);
            obj.fit_axis(obj.data, 2, 0);
            obj.fit_axis(obj.data, 1, 1);
            obj.fit_axis(obj.data, 2, 1);
            
            % update weights, return next classifier weights
            
            epsilon = obj.err / sum(obj.w);           % normalize the error
            obj.alpha = log((1-epsilon) / epsilon);
            weights = obj.w .* exp(obj.alpha * obj.miss');
            weights = weights ./ sum(weights);        % normalize weights
        end
        
        function [] = fit_axis(obj, data, axis, inverted)
                   
            sorted = sort(data(:,axis));
            tr = sorted(1) - 1;
                        
            for i = 1:size(sorted)-1
                [e, misses] = obj.error(data(:,axis), tr, inverted);
                if(e < obj.err)
                    obj.axis = axis;
                    obj.err = e;
                    obj.t = tr;
                    obj.miss = misses;
                    obj.inv = inverted;
                end
                tr = (sorted(i+1) + sorted(i)) / 2;
            end
        end
        
        function [e, missclassified] = error(obj, data, threshold, inverted)                      
            
            if(inverted)
                miss_left = bsxfun(@and, data >= threshold, obj.labels == 1);
                miss_right = bsxfun(@and, data < threshold, obj.labels == -1);
            else
                miss_left = bsxfun(@and, data < threshold, obj.labels == 1);
                miss_right = bsxfun(@and, data >= threshold, obj.labels == -1);            
            end
            
            missclassified = bsxfun(@or, miss_left, miss_right);           
            e = sum(obj.w(missclassified));
        end
    end
    
end

