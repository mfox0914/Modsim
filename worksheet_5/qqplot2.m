function qqplot2(X, pd, varargin)
% Construct a quantile-quantile (QQ) plot
% 
% Inputs
%   X (vector): Data sample
%   pd (probability distribution object): Theoretical distribution
%
% Returns
%   plot object

% Handle optional arguments
p = inputParser;
defaultJitter = 0;
defaultAlpha = 1;
addParameter(p, 'jitter', defaultJitter, @(x) isnumeric(x) && isscalar(x) && (0 <= x));
addParameter(p, 'alpha', defaultAlpha, @(x) isnumeric(x) && (0 <= x) && (x <= 1));
parse(p, varargin{:});
jitter = p.Results.jitter;
alp = p.Results.alpha;

% Compute
n = length(X);
X_s = sort(X);
% Filliben order statistic medians
I = 1:n;
p = (I - 0.3175) / (n + 0.365);
p(end) = 0.5^(1/n);
p(1) = 1 - 0.5^(1/n);
% Convert to quantiles
q = icdf(pd, p);

% Apply jitter
X_s = X_s + normrnd(0, 1, size(X_s)) * jitter;
q = q + normrnd(0, 1, size(q)) * jitter;

% Visualize
figure(); clf; hold on;
plot([min(q), max(q)], [min(q), max(q)], ':k');
scatter(q, X_s, '.b', 'MarkerEdgeAlpha', alp);
xlabel('Theoretical Quantiles')
ylabel('Observed Quantiles')

end