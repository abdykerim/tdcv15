classdef AdaboostClassifier < handle
    
    properties
        classifiers;     % array  of weak classifiers
    end
    
    methods
        function obj = AdaboostClassifier(numberOfClassifiers)
            obj.classifiers = cell(1,numberOfClassifiers);
        end
        
        function [] = Train(obj, trainingSet, labels)
            
            weights = [];
            
            % initialize each weak classifier forwarding weights
            
            for i = 1:size(obj.classifiers, 2)
                wc = WeakClassifier(trainingSet, labels, weights);
                obj.classifiers{i} = wc;
                weights = wc.Train;
            end
        end
        
        function [prediction] = Test(obj, testingSet)
            
            prediction = zeros(size(testingSet,1),1);
            
            % compute the weighted sum of each classifier response
                        
            for i = 1:size(obj.classifiers,2)
                pred_data = obj.classifiers{i}.Test(testingSet);
                prediction = prediction + obj.classifiers{i}.alpha * (pred_data(:,3));
            end
            prediction = sign(prediction);
        end
        
        function [] = Plot(obj, dataset, labels)
            figure;
            hold on;
            
            max_x = max(dataset(:,1));
            min_x = min(dataset(:,1));
            max_y = max(dataset(:,2));
            min_y = min(dataset(:,2));
            
            % Plot Thresholds
            
            for i = 1:size(obj.classifiers,2)
                wc = obj.classifiers{i};
                if(wc.axis == 1)
                    line([wc.t, wc.t], [min_x, max_x]);
                else
                    line([min_y, max_y], [wc.t, wc.t]);
                end
            end            
            
            % Plot predictions
            
            weights = wc.w;
            
            plot_left = dataset(labels < 0,:);
            weights_left = weights(labels < 0);
            plot_right = dataset(labels >= 0,:);
            weights_right = weights(labels >= 0);
            scatter(plot_left(:,1), plot_left(:,2), 8000*weights_left, 'r', 'o');
            scatter(plot_right(:,1), plot_right(:,2), 8000*weights_right, 'b', 'x');            
            
            hold off;
        end
    end
    
end

