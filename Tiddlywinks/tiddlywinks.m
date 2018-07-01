clear 
clc
rng('default');

%% Configurable parameters
num_of_circles = 20;
min_radius = 10;
max_radius = 30;
window_height = 400;
window_width = 400;

num_of_chromosomes = 100;
crossover_rate = 0.8;
mutation_rate = 0.05;
gene_length = 10;
chromosome_length = gene_length * 3;
num_of_elites = 4;

%% Initialize circles
x_min = 0;
x_max = window_width;
y_min = 0;
y_max = window_height;

circle_list = cell(1, num_of_circles);
first_time = 1;
for i = 1 : num_of_circles   
    radius = randi([min_radius max_radius],1,1);
    ok = 0;
    while ok == 0
        new_circle = Circle(...
            [randi([radius, x_max - radius], 1, 1) randi([radius, y_max - radius], 1, 1)], ...
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

%% Initialize the population
population = cell(1, num_of_chromosomes);
for i = 1 : num_of_chromosomes   
    new_member = randi([0 1], 1, chromosome_length);
    population{i} = new_member;
end

%% Begin
fitness_scores = zeros(1, num_of_chromosomes);
iter_num = 1;
while 1
    % Test each chromosome to see how good it is at solving the problem 
    % at hand and assign a fitness score accordingly. The fitness score 
    % is a measure of how good that chromosome is at solving the problem 
    new_population = cell(1, num_of_chromosomes);
    current_best = [];
    best_fitness_score = -1;
    for i = 1 : num_of_chromosomes 
        fitness_score_of_chromosome = fitness_score(circle_list, population{i}, ...
            gene_length, chromosome_length, ...
            x_max, y_max);
        fitness_scores(i) = fitness_score_of_chromosome;        
        if best_fitness_score < fitness_score_of_chromosome
            current_best = population{i};
            current_best_idx = i;
            best_fitness_score = fitness_score_of_chromosome;
        end        
    end
    figure('Name', sprintf('Iteration %d',iter_num));
    set(gcf,'MenuBar','none')
    set(gca,'DataAspectRatioMode','auto')
    set(gca,'Position',[0 0 1 1])
    for i = 1 : num_of_circles
        viscircles(circle_list{i}.center, circle_list{i}.radius, 'EdgeColor', 'red');   
    end    
    for i = 1 : num_of_chromosomes
        if (i ~= current_best_idx) && (fitness_scores(i) > 0)
            [x, y, r] = decode(population{i}, gene_length, chromosome_length, x_max);
            viscircles([x y], r, 'EdgeColor', 'green');   
        end
    end
    [x, y, r] = decode(current_best, gene_length, chromosome_length, x_max);
    viscircles([x y], r, 'EdgeColor', 'blue');
    rectangle('Position',[x_min y_min x_max-x_min y_max-y_min], ...
        'EdgeColor','b', 'LineStyle','--')
    pause(0.5)
   
    new_idx = 1;
    % Elitism
%     new_population{new_idx} = current_best;
%     new_idx = new_idx + 1;
    [~, fitness_scores_sorted_idx] =sort(fitness_scores, 'descend');
    for m = 1 : num_of_elites
        new_population{new_idx} = population{fitness_scores_sorted_idx(m)};
        new_idx = new_idx + 1;
    end
    
    while 1        
        % Select two members from the current population        
        if sum(fitness_scores)==0
            prob_vector = ones(1, num_of_chromosomes) * (1 / num_of_chromosomes);
        else
            prob_vector = fitness_scores ./ sum(fitness_scores);
        end  
        [member_1_index, member_2_index ] = select_2_members_using_roulette_wheel(num_of_chromosomes, prob_vector);
        member_1 = population{member_1_index};
        member_2 = population{member_2_index};

        % Depending on the crossover rate crossover the bits from each chosen 
        % chromosome at a randomly chosen point
        [new_member_1, new_member_2] = crossover(member_1, member_2, crossover_rate);

        % Step through the chosen chromosomes bits and flip depending on the
        % mutation rate.
        [new_member_1, new_member_2, num_of_mutated] = mutation(new_member_1, new_member_2, mutation_rate);
        
        new_population{new_idx} = new_member_1;
        new_idx = new_idx + 1;
        new_population{new_idx} = new_member_2;
        new_idx = new_idx + 1;        
        if new_idx > num_of_chromosomes
            iter_num = iter_num + 1;      
            population = new_population;
            break;
        end
    end
    close    
end