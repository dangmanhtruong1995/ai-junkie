clear 
clc
% rng('default');

%% Configurable parameters
num_of_circles = 20;
min_radius = 10;
max_radius = 30;
window_height = 400;
window_width = 400;

num_of_particles = 100;
w = 1.2; % Inertia coefficient 
c1 = 1.8; % Cognitive coefficient
c2 = 1.8; % Social coefficient
v_max = zeros(1, 3); % Velocity clamping
k = 0.2; % Velocity clamping factor
v_max(1) = k * window_width;
v_max(2) = k * window_height;
v_max(3) = k * (max_radius - min_radius) / 2;

%% Initialize circles
x_min = 0;
x_max = window_width;
y_min = 0;
y_max = window_height;

circle_list = cell(1, num_of_circles);
first_time = 1;
for i = 1 : num_of_circles   
    radius = min_radius + (max_radius - min_radius)*rand;
    ok = 0;
    while ok == 0
        new_circle = Circle(...
            [(radius+(x_max-radius)*rand)  (radius+(y_max-radius)*rand)], ...
            radius);
        ok = 1;         
        for i1 = 1 : (i-1)
            current_circle = circle_list{i1};
            if current_circle.overlaps_with(new_circle)
                ok = 0;
                break;
            end
        end         
    end
    circle_list{i} = new_circle;     
end

%% Initialize the particles
fitness_func = @(candidate) fitness_score(candidate, circle_list, x_min, x_max, y_min, y_max);
particle_list = cell(1, num_of_particles);
for i = 1 : num_of_particles   
    r = min_radius + (max_radius - min_radius)*rand;
    x = radius+(x_max-radius)*rand;
    y = radius+(y_max-radius)*rand;
    new_member = Particle([x y r], fitness_func, v_max);
    particle_list{i} = new_member;
end

%% Begin
iter_num = 1;
while 1
    % Find best particle      
    g_best_score = -1;
    g_best_pos = [];
    g_best_idx = -1;
    for i = 1 : num_of_particles 
        if g_best_score < particle_list{i}.score
            g_best_score = particle_list{i}.score;
            g_best_pos = particle_list{i}.pos;
            g_best_idx = i;
        end
    end
    
    % Display
    figure('Name', sprintf('Iteration %d (Ctrl-C to quit)',iter_num));
    set(gcf,'MenuBar','none')
    set(gca,'DataAspectRatioMode','auto')
    set(gca,'Position',[0 0 1 1])
       
    for i = 1 : num_of_particles
        % if (i ~= g_best_idx) && (particle_list{i}.score > 0)            
            circle = particle_list{i}.as_circle();
            x = circle.center(1);
            y = circle.center(2);
            r = circle.radius;            
            viscircles([x y], r, 'EdgeColor', 'green');   
        % end
    end
    for i = 1 : num_of_circles
        viscircles(circle_list{i}.center, circle_list{i}.radius, 'EdgeColor', 'red');   
    end 
    circle = particle_list{g_best_idx}.as_circle();
    x = circle.center(1);
    y = circle.center(2);
    r = circle.radius;  
    viscircles([x y], r, 'EdgeColor', 'blue');
    rectangle('Position',[x_min y_min x_max-x_min y_max-y_min], ...
        'EdgeColor','b', 'LineStyle','--')
    pause(0.5)   
    close
    
    % Update velocity and position
    for i = 1 : num_of_particles
        particle_list{i}.update(g_best_pos, w, c1, c2);
    end    
    
    iter_num = iter_num + 1;
end