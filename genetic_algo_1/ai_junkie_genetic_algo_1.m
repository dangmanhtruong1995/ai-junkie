clear
clc
target_number = 360;

num_of_chromosomes = 100;
crossover_rate = 0.3;
mutation_rate = 0.05;
value_list =   {'0000', '0001', '0010', '0011', '0100','0101','0110','0111','1000','1001','1010','1011','1100','1101'};
key_list   =   {'0'   , '1'   , '2'   , '3'   , '4'   ,'5'   ,'6'   ,'7'   ,'8'   ,'9'   ,'+'   ,'-'   ,'*'   ,'/'   };
encoder = containers.Map(key_list, value_list);
decoder = containers.Map(value_list, key_list);
fitness_scores = zeros(1, num_of_chromosomes);
population = init_population(num_of_chromosomes);
iter_num = 1;
num_of_total_crossovers = 0;
num_of_total_mutations = 0;
while 1
    % fprintf('Iteration number %d \n', iter_num);
    new_population = cell(1, num_of_chromosomes);
    found_the_right_expression = 0;
    
    % Test each chromosome to see how good it is at solving the problem 
    % at hand and assign a fitness score accordingly. The fitness score 
    % is a measure of how good that chromosome is at solving the problem 
    current_best = [];
    best_val = -1;
    for i = 1 : num_of_chromosomes        
        [fitness_scores(i), is_target, expr_string] = evaluate_fitness_score(population{i},...
            target_number, decoder);        
        if best_val < fitness_scores(i)
            best_val = fitness_scores(i);
            current_best = expr_string;
        end
        if is_target == true
            found_the_right_expression = 1;
            break;
        end
    end
    
    if found_the_right_expression
        fprintf('Solution: %s at iteration %d \n', expr_string, iter_num);
        fprintf('Number of total crossovers: %d \n', num_of_total_crossovers);
        fprintf('Number of total mutations: %d \n', num_of_total_mutations);
        break;
    end    
    new_idx = 1;
    while 1
        % Select two members from the current population. The chance of 
        % being selected is proportional to the chromosomes fitness
        % Here we use roulette wheel selection
        if sum(fitness_scores)==0
            prob_vector = ones(1, num_of_chromosomes) * (1 / num_of_chromosomes);
        else
            prob_vector = fitness_scores ./ sum(fitness_scores);
        end  
        member_1_index = randsample(1:num_of_chromosomes, 1, true, prob_vector); % Requires Statistic toolbox
        while 1
            member_2_index = randsample(1:num_of_chromosomes, 1, true, prob_vector);
            if member_2_index ~= member_1_index                
                break;
            end
        end
        member_1 = population{member_1_index};
        member_2 = population{member_2_index};
        % Depending on the crossover rate crossover the bits from each chosen 
        % chromosome at a randomly chosen point
        do_a_crossover = randsample([false true], 1, true, [(1-crossover_rate) crossover_rate]);
        if do_a_crossover
            num_of_total_crossovers = num_of_total_crossovers + 1;            
            [new_member_1, new_member_2] = crossover(member_1, member_2);
        end

        % Step through the chosen chromosomes bits and flip depending on the
        % mutation rate.
        if do_a_crossover
            [new_member_1, new_member_2, num_of_mutated] = mutation(...
                new_member_1, new_member_2, mutation_rate);
        else
            [new_member_1, new_member_2, num_of_mutated] = mutation(...
                member_1, member_2, mutation_rate);
        end
        num_of_total_mutations = num_of_total_mutations + num_of_mutated;
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
end

    