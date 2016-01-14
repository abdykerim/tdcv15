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
        
        function [prediction] = Test(obj, testingSet, iterations)
            
            if(iterations > size(obj.classifiers,2))
               iterations = size(obj.classifiers,2);
            end
            
            prediction = zeros(size(testingSet,1),1);
            
            % compute the weighted sum of each classifier response
                        
            for i = 1:iterations
                pred_data = obj.classifiers{i}.Test(testingSet);
                prediction = prediction + obj.classifiers{i}.alpha * (pred_data(:,3));
            end
            prediction = sign(prediction);
        end
        
        function [] = Plot(obj, dataset, labels, show_weights, show_thresholds)
            
            hold on;
            
            max_x = max(dataset(:,1));
            min_x = min(dataset(:,1));
            max_y = max(dataset(:,2));
            min_y = min(dataset(:,2));
            
            % Plot Thresholds
            
            if(show_thresholds)
                for i = 1:size(obj.classifiers,2)
                    wc = obj.classifiers{i};
                    if(wc.axis == 1)
                        line([wc.t, wc.t], [min_x, max_x]);
                    else
                        line([min_y, max_y], [wc.t, wc.t]);
                    end
                end
            end
            
            % Plot predictions
            
            weights = obj.classifiers{end}.w;
            
            plot_left = dataset(labels < 0,:);
            weights_left = weights(labels < 0);
            plot_right = dataset(labels >= 0,:);
            weights_right = weights(labels >= 0);
            
            if(show_weights)
                scatter(plot_left(:,1), plot_left(:,2), 20000*weights_left, 'b', '+');
                scatter(plot_right(:,1), plot_right(:,2), 20000*weights_right, 'r', 'o');
            else
                scatter(plot_left(:,1), plot_left(:,2), 10, 'b', '+');
                scatter(plot_right(:,1), plot_right(:,2), 10, 'r', 'o');
            end
            
            hold off;
        end
    end
    
end

