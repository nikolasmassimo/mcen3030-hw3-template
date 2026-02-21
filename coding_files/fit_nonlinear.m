function A = fit_nonlinear(x,y,model,seed)

    x = x(:); 
    y = y(:);
    A = seed(:);

    max_iter = 100;
    lambda = 1e-1;   % damping

    for j = 1:max_iter

        y0 = model(x, A);
        D  = y - y0;

        % Build Z
        Z = zeros(length(x), length(A));
        for i = 1:length(A)
            Z(:,i) = partial_function(model, x, A, i, y0);
        end

        % AI HELP -- Lines 23 - 39
        % Remove NaNs/Infs from Jacobian
        if any(isnan(Z(:))) || any(isinf(Z(:)))
            warning('NaN/Inf in Jacobian, stopping iteration');
            break;
        end

        % Regularized normal equation
        M = Z'*Z + lambda*eye(length(A));

        % Use pseudoinverse if singular
        if rcond(M) < 1e-12
            Ad = pinv(M) * (Z'*D);
        else
            Ad = M \ (Z'*D);
        end

        % Damped step update
        A = A + 0.3*Ad;

        % Convergence
        if norm(Ad) < 1e-6
            break;
        end
    end
end


function partial = partial_function(model, x, A, i, y0)

    h = 1e-6*(abs(A(i)) + 1);
    A1 = A;
    A1(i) = A1(i) + h;

    partial = (model(x,A1) - y0) / h;
end