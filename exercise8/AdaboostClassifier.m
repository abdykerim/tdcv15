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
        
        function [] = Test(obj, testingSet)
            
            prediction = zeros(size(testingSet,1),1);

            % compute the weighted sum of each classifier response
            
            for i = 1:size(obj.classifiers,2)
                pred_data = obj.classifiers{i}.Test(testingSet);
                prediction = prediction + obj.classifiers{i}.alpha * pred_data(:,3);
            end
            prediction = sign(prediction);
            
            % plot results
            
            plot_left = testingSet(prediction == -1,:);
            plot_right = testingSet(prediction == 1,:);

            figure;
            hold on;
            scatter(plot_left(:,1), plot_left(:,2), 10, 'r', 'o');
            scatter(plot_right(:,1), plot_right(:,2), 10, 'b', 'x');
            hold off;
        end
    end
    
end

