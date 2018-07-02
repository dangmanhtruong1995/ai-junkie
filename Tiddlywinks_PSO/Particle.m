classdef Particle < handle
    % Particle class
    % Used for Particle Swarm Optimization
    % Written by Dang Manh Truong (dangmanhtruong@gmail.com)
    
    properties
        pos;
        score;
        i_best_pos;
        i_best_score;
        fitness_func;
        velocity;
        v_max;
    end
    
    methods
        function obj = Particle(pos, fitness_func, v_max)
            obj.pos = pos;
            obj.fitness_func = fitness_func;
            obj.score = obj.fitness_func(pos);
            obj.i_best_pos = pos;
            obj.i_best_score = obj.score;
            obj.velocity =  (-v_max) + 2*v_max .* rand(size(pos));
            obj.v_max = v_max;
        end         
        
        function score = fitness_score(obj)
            score = obj.score;
        end
        
        function circle_obj = as_circle(obj)
            circle_obj = Circle([obj.pos(1) obj.pos(2)], obj.pos(3));
        end
        
        function update(obj, g_best_pos, w, c1, c2)
            try
                r1 = rand;
                r2 = rand;            
                velocity_new = w*obj.velocity + c1*r1*(obj.i_best_pos - obj.pos) + ...
                    c2*r2*(g_best_pos - obj.pos); 
                for i = 1 : numel(velocity_new)
                    if velocity_new(i) > obj.v_max(i)
                        velocity_new(i) = obj.v_max(i);
                    end
                    if velocity_new(i) < -obj.v_max(i)
                        velocity_new(i) = -obj.v_max(i);
                    end
                end
                pos_new = obj.pos + velocity_new;            
                obj.score = obj.fitness_func(pos_new);
                obj.pos = pos_new;
                obj.velocity = velocity_new;
                if obj.score > obj.i_best_score
                    obj.i_best_score = obj.score;
                    obj.i_best_pos = obj.pos;
                end
            catch
                disp('');
            end
        end        
    end
    
end

