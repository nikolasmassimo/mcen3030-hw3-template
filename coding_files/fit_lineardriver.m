% Import data
data = readmatrix('yacht_hydrodynamics.csv');

X = data(:,1:6);    % inputs x1...x6
y = data(:,7);      % residuary resistance per unit weight

% Add intercept column
Z = [ones(size(x,1),1), x];

% Fit model
[A, Y, E, R2] = fit_linear(Z, y);

% x1 = x2 = ... = x6 = 1
x_cube = ones(1,6);
Z_cube = [1, x_cube];      % include intercept
y_cube = Z_cube * A;       % predicted resistance

% Display results
disp('Fit coefficients A:')
disp(A) % Positive A: increase in resistence
        % Negative N: decrease in resistence

fprintf('R^2 = %.5f\n', R2);
fprintf('Cube boat residuary resistance = %.5f\n', y_cube);