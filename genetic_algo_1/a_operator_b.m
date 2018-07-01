function [output] = a_operator_b(a, operator, b)
switch operator
    case '+'
        output = a + b;
    case '-'
        output = a - b;
    case '*'
        output = a * b;
    case '/'
        output = a / b;
    otherwise  
        error('Invalid operator!');
end

end

