function [fitness_score, is_target, expr_string] = evaluate_fitness_score(chromosome, target_value, decoder)
% Dang Manh Truong (dangmanhtruong@gmail.com)
% This function evaluates the fitness score for a given chromosome
% It also returns the corresponding expression in string form
num_of_genes = numel(chromosome) / 4;
expr_string = '';
is_operator_turn = false;
% Decode into valid expression
for i = 1 : num_of_genes
    relevant_bits = chromosome((i-1)*4+1 :(i-1)*4+4);
    switch relevant_bits
        case '0000'
            decoded_value = '0';
        case '0001'
            decoded_value = '1';
        case '0010'
            decoded_value = '2';
        case '0011'
            decoded_value = '3';
        case '0100'
            decoded_value = '4';
        case '0101'
            decoded_value = '5';
        case '0110'
            decoded_value = '6';
        case '0111'
            decoded_value = '7';
        case '1000'
            decoded_value = '8';
        case '1001'
            decoded_value = '9';
        case '1010'
            decoded_value = '+';
        case '1011'
            decoded_value = '-';
        case '1100'
            decoded_value = '*';
        case '1101'
            decoded_value = '/';
        otherwise
            continue;
    end
    % Number -> Operator -> Number -> .....
    if xor(is_operator_turn, is_operator(decoded_value))
        continue;
    end
    expr_string = [expr_string decoded_value];
    is_operator_turn = ~is_operator_turn;        
end
% Evaluate expression 
try
    % expr_value = str2double(expr_string(1));
    expr_value = expr_string(1) - '0';
    expr_string_cleaned = expr_string(1);
    numel_expr_string = numel(expr_string); % For lack of a better term ...
    for i = 2 : numel_expr_string
        expr_char = expr_string(i);
        if ~is_operator(expr_char)
            continue;
        end
        if i == numel_expr_string
            continue;
        end
        if (strcmp(expr_char,'/') == 1) && (strcmp(expr_string(i+1),'0')==1)
            continue;
        end
        if is_operator(expr_string(i+1))
            continue;
        end       
        expr_value = a_operator_b(expr_value, expr_char, expr_string(i+1) - '0');  
        expr_string_cleaned = [expr_string_cleaned expr_char expr_string(i+1)];        
    end
    expr_string = expr_string_cleaned;
    % Calculate fitness score
    fitness_score = 1 / (abs(expr_value - target_value) + 1e-9);    
    is_target = abs(expr_value - target_value) < 1e-10;
catch
    fitness_score = 0;
    is_target = false;
    expr_string = '';
end
end

