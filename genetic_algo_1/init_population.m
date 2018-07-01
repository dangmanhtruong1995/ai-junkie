function [population] = init_population(num_of_chromosomes)
% Dang Manh Truong (dangmanhtruong@gmail.com)
% Initial routine for the genetic algorithm
population = cell(1, num_of_chromosomes);
num_of_genes = 75; % From http://www.ai-junkie.com/ga/intro/gat3.html
for i = 1 : num_of_chromosomes        
    new_member = randi([0,1],1, 4 * num_of_genes);
    new_member = char(new_member + '0');
    population{i} = new_member;
end

end

