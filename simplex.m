function [x, fval, exitflag] = simplex(c, A, b)
    [m, n] = size(A);
    
    % Add slack variables to convert inequalities to equations
    A = [A, eye(m)];
    c = [c; zeros(m, 1)];
    
    % Construct initial tableau
    tableau = [A, b; c', -c'*zeros(n, 1)];
    
    % Main loop
    while any(tableau(end, 1:end-1) > 0)
        % Find entering variable (column)
        [~, pivotCol] = max(tableau(end, 1:end-1));
        
        % Check if the problem is unbounded
        if all(tableau(1:end-1, pivotCol) <= 0)
            x = [];
            fval = -inf;
            exitflag = -1; % Indicates unbounded
            return;
        end
        
        % Find departing variable (row)
        ratios = tableau(1:end-1, end) ./ tableau(1:end-1, pivotCol);
        ratios(ratios < 0 | isnan(ratios)) = inf; % Exclude negative and NaN ratios
        [~, pivotRow] = min(ratios);
        
        % Pivot
        tableau(pivotRow, :) = tableau(pivotRow, :) / tableau(pivotRow, pivotCol);
        for i = 1:m+1
            if i ~= pivotRow
                tableau(i, :) = tableau(i, :) - tableau(i, pivotCol) * tableau(pivotRow, :);
            end
        end
    end
    
    % Extract solution
    x = zeros(n+m, 1);
    x(1:n) = tableau(:, end);
    fval = tableau(end, end);
    exitflag = 1; % Indicates successful completion
end
