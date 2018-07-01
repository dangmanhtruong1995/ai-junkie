function [yes] = is_operator(input)
switch input
    case '+'
        yes = true;
    case '-'
        yes = true;
    case '*'
        yes = true;
    case '/'
        yes = true;
    otherwise
        yes = false;
end

end

