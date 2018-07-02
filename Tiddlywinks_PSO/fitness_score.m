function [score] = fitness_score(candidate, circle_list, x_min, x_max, y_min, y_max)
x = candidate(1);
y = candidate(2);
r = candidate(3);
if r < 0
    score = 0;
    return;
end
circle = Circle([x y], r);
num_of_circles = numel(circle_list);
for i = 1 : num_of_circles
    if circle.overlaps_with(circle_list{i})
        score = 0;
        return;
    end
end
if ~circle.is_in_bounding_box(x_min, x_max, y_min, y_max)
    score = 0;
    return;
end
score = r;

end

