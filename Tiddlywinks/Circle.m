classdef Circle < handle
    % Circle class
    % Written by Dang Manh Truong (dangmanhtruong@gmail.com)
    
    properties
        center;
        radius;     
        x_min;
        x_max;
        y_min;
        y_max;
    end
    
    methods
        function obj = Circle(center, radius)
            obj.center = center;
            obj.radius = radius;
            if radius < 0
                error('Circle: Radius cannot be negative');
            end
            
            obj.x_min = obj.center(1) - obj.radius;
            obj.x_max = obj.center(1) + obj.radius;
            obj.y_min = obj.center(2) - obj.radius;
            obj.y_max = obj.center(2) + obj.radius;
        end        
        
        function [result] = is(obj, C1)           
            result = ((obj.center(2) == C1.center(2)) && (obj.center(1) == C1.center(1)) && (obj.radius == C1.radius));           
        end
        
        function [result] = overlaps_with(obj, C1)
            % https://stackoverflow.com/questions/8367512/how-do-i-detect-intersections-between-a-circle-and-any-other-circle-in-the-same
            temp = pdist2(obj.center, C1.center,'euclidean');
            result = (temp <= (obj.radius + C1.radius)); 
        end
        
        function [x_min, x_max, y_min, y_max] = bounding_box(obj)
            x_min = obj.x_min;
            x_max = obj.x_max;
            y_min = obj.y_min;
            y_max = obj.y_max;
        end
        
        function [result] =  is_in_bounding_box(obj, x_min, x_max, y_min, y_max)
            [x_min_circle, x_max_circle, y_min_circle, y_max_circle] = obj.bounding_box();
            result = (...
                (x_min <= x_min_circle) && (x_min_circle <= x_max) && ...
                (x_min <= x_max_circle) && (x_max_circle <= x_max) && ...
                (y_min <= y_min_circle) && (y_min_circle <= y_max) && ...
                (y_min <= y_max_circle) && (y_max_circle <= y_max));
        end
    end
    
end

