function I = simulate_branching(I0, pd, n_pop, T)
% Simulate infection history with a branching process. Assumes an finite,
% identical, homogeneously-connected population. Individuals are assumed to
% be infected for exactly one timestep (aka "generation").
%
% Inputs
%   I0 (integer): Initial number of infected persons
%   pd (probability distribution): Distribution of new infected persons,
%     per current infection
%   n_pop (integer): Total population
%   T (integer): Number of timesteps to simulate
%
% Returns
%   I (vector): History of current-infected count

% Setup
I = zeros(T, 1);
I(1) = I0;
s = n_pop - I0; % Total susceptible persons

% Simulate
for i = 2:T
    % New infected persons
    delta_I = min(sum(random(pd, I(i-1), 1), 'all'), s);
    % Increment model
    I(i) = delta_I;  % Infected recover each round
    s = s - delta_I; % Decrement the total susceptibles
end

end