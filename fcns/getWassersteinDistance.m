function W = getWassersteinDistance(mu_0, mu_1)

p = 1;

mu_0 = sort(mu_0(:));
mu_1 = sort(mu_1(:));
 
x = unique([(0:numel(mu_0)) / numel(mu_0), ...
    (0:numel(mu_1)) / numel(mu_1)], 'sorted').';
Finv = mu_0(fix(x(1:end-1)*numel(mu_0)) + 1);
Ginv = mu_1(fix(x(1:end-1)*numel(mu_1)) + 1);

W = sum((abs(Finv-Ginv).^p .* diff(x)))^(1/p);

end