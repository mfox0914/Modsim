function R_eff = estimate_Reff(R0, x_t, efficiency)
% Estimate R_eff for the SSE-targeted intervention
%
% Estimates the effective reproductive number (R_eff) under given disease
% and intervention parameters. While the dispersion parameter for the
% disease is fixed (k=0.16), the basic reproductive number can be varied.
% The aggressiveness (x_t) and efficiency of the intervention can also be
% varied.
%
% Inputs
%   R0 (float): Basic reproductive number of disease
%   x_t (integer): Secondary case threshold (for SSE-targeted intervention)
%   efficiency (float): Efficiency parameter (for SSE-targeted intervention)
%
% Returns
%   R_eff (float): Estimated effective reproductive number
%
% References
%   Althouse et al. (2020) "Stochasticity and heterogeneity in the
%   transmission dynamics of SARS-CoV-2" ArXiv

% Given parameterization
k = 0.16;
% Convert parameterization to matlab format
r = k;
p = 1 / (1 + R0 / k);
% Define the distributions
pd_sse = makedist('NegativeBinomial', 'r', r, 'p', p);
% Set intervention parameters
T = 5;
I0 = 1;
n_pop = 1e6; % Huge population; to study R_eff
n_realizations = 400;

% Reserve space for simulation
I_all = zeros(T, n_realizations);

% Run realizations
rng(101); % Use common random numbers to stabilize the comparisons
for i = 1:n_realizations
    I_all(:, i) = simulate_intervention(I0, pd_sse, n_pop, T, x_t, efficiency);
end

I_mean = mean(I_all, 2);

% Estimate R_eff
R_eff = mean(I_mean(2:end) ./ I_mean(1:end-1));

end