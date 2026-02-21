function [A, Y, E, R2] = fit_linear(Z,y)
    Z_T = Z';
    Z_multiplier = (inv(Z_T*Z)) * Z_T;
    A = Z_multiplier * y; % Calculate the coefficients
    Y = Z * A;
    E = y - Z * A; % Compute the residuals
    R2 = 1 - (sum(E.^2) / sum((y - mean(y)).^2)); % 1 - Sr / St
end

