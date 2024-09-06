function I = simulate_intervention(I0, pd, n_pop, T, x_t, eff)
% Simulate infection history with a branching process. Assumes an finite,
% identical, homogeneously-connected population. Individuals are assumed to
% be infected for exactly one timestep (aka "generation").
%
% Additional parameters x_t, p (cf. simulate_branching) represent a public 
% health intervention that seeks to stop super-spreading events.
%
% Inputs
%   I0 (integer): Initial number of infected persons
%   pd (probability distribution): Distribution of new infected persons,
%     per current infection
%   n_pop (integer): Total population
%   T (integer): Number of timesteps to simulate
%
%   x_t (integer): Threshold for super-spreading events
%   eff (float): Efficiency parameters: success probability for SSE threshold
%
% Returns
%   I (vector): History of current-infected count

% Setup
I = zeros(T, 1);
I(1) = I0;
s = n_pop - I0; % Total susceptible persons
pd_trun = truncate(pd, 0, x_t);

% Simulate
for i = 2:T
    % Draw secondary case values
    X_base = random(pd, I(i-1), 1);      % Base distribution
    X_trun = random(pd_trun, I(i-1), 1); % Truncated distribution
    % Simulate efficiency
    ind_eff = rand(size(X_base)) <= eff;
    X = X_base .* ( (X_base <= x_t) | (~ind_eff)) ...
      + X_trun .* ( (X_base > x_t)  & (ind_eff));

    % New infected persons
    delta_I = min(sum(X, 'all'), s);
    % Increment model
    I(i) = delta_I;  % Infected recover each round
    s = s - delta_I; % Decrement the total susceptibles
end

end