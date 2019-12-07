%{
    Basics of Signals and Systems (Fall 2019-2020)
    Computer Assignment 1
  
    @author: Fuad Aghazada
    @id: 21503691
    @date: 27.10.2019
%}

% Loading the data matrix X
load('data.mat', 'X');

% Sampling parameters
sampling_rate = 1000;

% Selecting 3 signals: 6, 9, 1
signal1 = X(6,:);
signal2 = X(9,:);
signal3 = X(1,:);

% Plotting the signals seperately
plot(signal1)
title("Signal 1 (6th signal in X)")
xlabel("t (sec)")

figure

plot(signal2)
title("Signal 2 (9th signal in X)")
xlabel("t (sec)")

figure

plot(signal3)
title("Signal 3 (1st signal in X)")
xlabel("t (sec)");

% Estimating the parameters of the signals
[C1, A1, f1, phi1] = parameters_of_sin(sampling_rate, signal1);
[C2, A2, f2, phi2] = parameters_of_sin(sampling_rate, signal2);
[C3, A3, f3, phi3] = parameters_of_sin(sampling_rate, signal3);

% Displaying the signal in the given format
display_format = 'x_%d(t) = %+.2f %+.2f cos(%.2f t %+.2f)\n';
fprintf(display_format, 1, C1, A1, 2 * pi * f1, phi1 * (pi / 180));
fprintf(display_format, 2, C2, A2, 2 * pi * f2, phi2 * (pi / 180));
fprintf(display_format, 3, C3, A3, 2 * pi * f3, phi3 * (pi / 180));

% Function for estimating the parameters of the signals
function [C, A, f, phi] = parameters_of_sin(fs, x)

min_value = min(x);                                     % Minimum value of signal x
max_value = max(x);                                     % Maximum value of signal x

% Calculating Amplitude and DC value
A = round(abs(max_value - min_value) / 2, 2);           % Amplitude of signal x
C = round((max_value - A), 2);                          % DC value of the signal x

% Calculating Cyclic frequency and phase shift
max_compare_value = C + A - A / 1000;                   % Compare value for finding first max peak
min_compare_value = C - A + A / 1000;                   % Compare value for finding first min peak

max_peak_idxs = find(x > max_compare_value);            % Vector of indices in which signal values is greater than max compare value
min_peak_idxs = find(x < min_compare_value);            % Vector of indices in which signal values is less than min compare value

first_max_idx = max_peak_idxs(1);                       % First max index among the indices
first_min_idx = min_peak_idxs(1);                       % First min index among the indices

number_of_samples = abs(first_max_idx - first_min_idx); % Number of samples in a period

fprintf("Max peak index: %d\n", first_max_idx);
fprintf("Min peak index: %d\n", first_min_idx);
fprintf("Number of samples: %d\n", number_of_samples);

f = round(fs / (2 * number_of_samples), 2);             % Cyclic frequency

t_shift = (first_max_idx - 0) / fs;                     % Time shift of signal

phi = -2*pi*f*t_shift;                                  % Phase shift
phi = round(phi * (180 / pi), 2);                       % Converting to degrees

end

