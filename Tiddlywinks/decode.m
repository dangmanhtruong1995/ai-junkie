function [x, y, r] = decode(chromosome, gene_length, chromosome_length, m_cxClient)
decoded = zeros(1, chromosome_length / gene_length);
counter = 0;
for i = 1 : gene_length : chromosome_length
    counter = counter + 1;
    genome = chromosome(i : i+gene_length-1);
    multiplier = 1;
    for j = gene_length : -1 : 1
        decoded(counter) = decoded(counter) + genome(j) * multiplier;
        multiplier = multiplier * 2;
    end
end
bit_multiplier = pow2(gene_length);
conversion_multiplier = m_cxClient /  bit_multiplier;
r = decoded(3) * conversion_multiplier;
conversion_multiplier = (m_cxClient - 2*r) / bit_multiplier;
x = decoded(1) * conversion_multiplier + r;
y = decoded(2) * conversion_multiplier + r;
disp('');
end

