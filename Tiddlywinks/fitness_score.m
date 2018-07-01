function [score] = fitness_score(circle_list, chromosome, gene_length, chromosome_length, m_cxClient, m_cyClient)
[x, y, r] = decode(chromosome, gene_length, chromosome_length, m_cxClient);
new_circle = Circle([x y], r);
num_of_circles = numel(circle_list);
for i = 1 : num_of_circles    
    if new_circle.overlaps_with(circle_list{i})
        score = 0;
        return;
    end   
    if ~new_circle.is_in_bounding_box(0, m_cxClient, 0, m_cyClient)
        score = 0;
        return;
    end
    score = r;
end

end

