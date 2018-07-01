function [new_member_1, new_member_2, num_of_mutated] = mutation(member_1, member_2, mutation_rate)
% Dang Manh Truong (dangmanhtruong@gmail.com)
% Iterate down the length of each chromosome mutating the bits according 
% to the mutation rate

length_1 = numel(member_1);
length_2 = numel(member_2);
new_member_1 = member_1;
new_member_2 = member_2;
num_of_mutated = 0;
mutated = 0;
mutation_decisions = randsample([false true], length_1, true,[(1-mutation_rate) mutation_rate]);
for i = 1 : length_1    
    do_a_mutation = mutation_decisions(i);
    if do_a_mutation
        mutated = 1;
        switch new_member_1(i)
            case 1
                new_member_1(i) = 0;
            case 0
                new_member_1(i) = 1;
        end
    end
end
num_of_mutated = num_of_mutated + mutated;
mutated = 0;
mutation_decisions = randsample([false true], length_2, true,[(1-mutation_rate) mutation_rate]);
for i = 1 : length_2    
    do_a_mutation = mutation_decisions(i);
    if do_a_mutation
        mutated = 1;
        switch new_member_2(i)
            case 1
                new_member_2(i) = 0;
            case 0
                new_member_2(i) = 1;
        end
    end
end
num_of_mutated = num_of_mutated + mutated;

end

