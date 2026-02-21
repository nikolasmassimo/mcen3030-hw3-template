% 0. Data Loading and Preparation
data = readmatrix('rheo_data.csv'); 
x = data(:,1); 
y = data(:,2);

Z = [ones(size(x,1),1), x]; % For linear fit model

%Seeds
seed2 = [1,1,0.5];
seed3 = [1,1,0.5,0.5];

% --- THEORY SECTION ---
% Define the model using a function handle: f(x, parameters)

bingham = @(x, p) p(1) + p(2)*x; 

hershel = @(x, p) p(1) + p(2)*x.^p(3);

hershel_plus = @(x, p) p(1) + p(2)*x + p(3)*x.^p(4);

% Call functions
[p, Y, E, R2] = fit_linear(Z,y);
[p_2] = fit_nonlinear(x, y, hershel, seed2);
[p_3] = fit_nonlinear(x, y, hershel_plus, seed3);

% Generate theoretical curve using the function handle
x_fine = linspace(0, max(x), 200); 
y_bingham = bingham(x_fine, p);
y_hershel = hershel(x_fine, p_2);
y_hershel_plus = hershel_plus(x_fine, p_3);

% 1. Figure Number and Initial Setup
fig1 = figure(1); 
clf; 

% 2. Plotting the Data
hold on;

p_theobingham = plot(x_fine, y_bingham, 'r-', 'LineWidth', 2.5);
p_theoHershel = plot(x_fine, y_hershel, 'b-', 'LineWidth', 2.5);
p_theoHershelPlus = plot(x_fine, y_hershel_plus, 'g-', 'LineWidth', 2.5);
p_exp = plot(x, y, 'ko', ...
    'MarkerFaceColor', 'none', ... 
    'MarkerEdgeColor', 'k', ...
    'MarkerSize', 4, ...
    'LineWidth', 1.5); % Adjust thickness of the diamond outline

% 3. Grid and Scaling
grid off;            
axis tight; % Sets axis 'tightly' along edges of plot

% 4. Fine-Tuning the Axes
ax = gca; 
ax.FontName = 'Times New Roman';
%ax.FontWeight = "bold";
ax.XLim = [0, max(x) * 1.05]; % Sets origin to 0, and padding around the rest of the plot
ax.YLim = [0, max(y) * 1.1];
ax.LineWidth = 2; 
ax.TickDir = 'in'; 
ax.TickLength = [0.01, 0.01]; 
ax.Box = 'off'; % DONT have ticks along ALL borders

% ADDED THESE LINES FOR SMALLER TICKS:
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';

% Custom edges around border (WITHOUT TICKS)
xl = xlim; yl = ylim;
line(xl, [yl(2) yl(2)], 'Color', 'k', 'LineWidth', ax.LineWidth); % Top line
line([xl(2) xl(2)], yl, 'Color', 'k', 'LineWidth', ax.LineWidth); % Right line

% Labels and Appearance
text(-0.15, 1.05, '\textbf{(a)}', 'Units', 'normalized', ...
     'Interpreter', 'latex', 'FontSize', 16);
xlabel('Shear Rate, $\dot{\gamma}\ \mathrm{[s^{-1}]}$', 'Interpreter','latex');
ylabel('Shear Stress, $\tau\ \mathrm{[Pa]}$', 'Interpreter','latex');
legend( ...
[p_exp, p_theobingham, p_theoHershel, p_theoHershelPlus], ...
{ ...
'Experiment', ...
sprintf('$\\hat{y}_B = %.3f + %.3f x$', p(1), p(2)), ...
sprintf('$\\hat{y}_H = %.3f + %.3f x^{%.3f}$', p_2(1), p_2(2), p_2(3)), ...
sprintf('$\\hat{y}_P = %.3f + %.3f x + %.3f x^{%.3f}$', p_3(1), p_3(2), p_3(3), p_3(4)) ...
}, ...
'Interpreter','latex', ...
'Location','southeast');
set(gca, 'FontSize', 18); % LATEX for math
hold off;