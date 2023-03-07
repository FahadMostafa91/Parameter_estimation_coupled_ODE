% Define the coupled differential equations
f = @(t, y, p) [y(2); -y(1) - p(1)*y(2)];

% Define the true parameter values
params_true = [1; 2];

% Generate synthetic data
t = linspace(0, 10, 101);
y_true = ode45(@(t, y) f(t, y, params_true), t, [0; 0]);
y_obs = y_true.y + 0.1*randn(size(y_true.y));

% Define the objective function (sum of squared errors)
obj_fun = @(params) sum(sum((ode45(@(t, y) f(t, y, params), t, [0; 0]).y - y_obs).^2));

% Define the initial parameter values
params_init = [0.5; 1.5];

% Use the Nelder-Mead simplex algorithm to minimize the objective function
options = optimset('Display', 'iter', 'MaxIter', 10000, 'MaxFunEvals', 10000);
params_est = fminsearch(obj_fun, params_init, options);

% Generate plots of the true and estimated solutions
y_true_est = ode45(@(t, y) f(t, y, params_est), t, [0; 0]);
figure;
plot(t, y_true(1,:), 'b-', t, y_obs(1,:), 'ro', t, y_true_est(1,:), 'g--');
legend('True', 'Observed', 'Estimated');
xlabel('t');
ylabel('y_1');
title('Estimation of Coupled Differential Equations');

figure;
plot(t, y_true(2,:), 'b-', t, y_obs(2,:), 'ro', t, y_true_est(2,:), 'g--');
legend('True', 'Observed', 'Estimated');
xlabel('t');
ylabel('y_2');
title('Estimation of Coupled Differential Equations');
