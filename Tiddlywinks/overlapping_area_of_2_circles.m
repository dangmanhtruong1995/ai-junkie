function [area] = overlapping_area_of_2_circles(C1, C2)
% https://www.mathworks.com/matlabcentral/answers/273066-overlapping-area-between-two-circles
a = @(d,r,R) (1/d).*sqrt(4*(d.^2)*(R.^2) - ((d.^2)-(r.^2)+(R.^2)).^2);
d = pdist2(C1.center, C2.center, 'euclidean');
r = C1.radius;
R = C2.radius;
if (4*(d.^2)*(R.^2) - ((d.^2)-(r.^2)+(R.^2)).^2) < 0
    area = 0;
else
    area = a(d, C1.radius, C2.radius);
end
end

