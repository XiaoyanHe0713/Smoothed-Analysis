% Define a linear programming problem
f = [-1; -2];  
A = [1, 1; -1, 2; 2, 1];  
b = [2; 2; 3];  

% Parameters for analysis
numTrials = 10000;  
sigma = 0.3;  

% Initialize variables to store total runtime for each case
totalTimeWorst = 0;
totalTimeAverage = 0;
totalTimeSmoothed = 0;

% Perform analyses
for i = 1:numTrials
    % Worst-case analysis
    tic;
    options = optimoptions('linprog', 'Display', 'none');  
    linprog(f, -A, -b, [], [], [], [], options);
    elapsedTimeWorst = toc;
    totalTimeWorst = totalTimeWorst + elapsedTimeWorst;
    
    % Average-case analysis - Randomly generate new A matrix for each trial
    A_random = rand(size(A));
    tic;
    linprog(f, -A_random, -b, [], [], [], [], options);
    elapsedTimeAverage = toc;
    totalTimeAverage = totalTimeAverage + elapsedTimeAverage;
    
    % Smoothed analysis - Add Gaussian noise to original A matrix
    A_perturbed = A + sigma * randn(size(A));
    tic;
    linprog(f, -A_perturbed, -b, [], [], [], [], options);
    elapsedTimeSmoothed = toc;
    totalTimeSmoothed = totalTimeSmoothed + elapsedTimeSmoothed;
end

% Compute the average runtime for each case
averageRuntimeWorst = totalTimeWorst / numTrials;
averageRuntimeAverage = totalTimeAverage / numTrials;
averageRuntimeSmoothed = totalTimeSmoothed / numTrials;

% Display the results
fprintf('Worst-case average runtime over %d trials: %.4f seconds\n', numTrials, averageRuntimeWorst);
fprintf('Average-case average runtime over %d trials: %.4f seconds\n', numTrials, averageRuntimeAverage);
fprintf('Smoothed analysis average runtime over %d trials: %.4f seconds\n', numTrials, averageRuntimeSmoothed);

