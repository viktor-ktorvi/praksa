clc;
close all;
clear variables;

set(groot,'defaulttextinterpreter','latex');  
%%
%% Vremenski domen
Fs = 2000; % Hz
t = (0:8191)/Fs; % s

x = 20 + 10*sin(2*pi*500 * t) +17*cos(2*pi*300 * t + 1.3);

% figure;
% plot(t, x)
% title("x(t)")
% xlabel("t [s]")
% ylabel("x [unit]")
% legend("x")

%% Frekvencijski domen
N = 2^11;

[absX1, phaseX1] = my_fft(x, N);

freqs = 5:100;
measured_phases = zeros(length(freqs), 1);

my_phases = 0:360;
inclines = zeros(length(my_phases), 1);
starts = zeros(length(my_phases), 1);
wraps = zeros(length(my_phases), 1);

for j = 1:length(my_phases)
    
    my_phase = my_phases(j);

    for i = 1:length(freqs)
        y = 0 + 1000 * cos(2*pi*freqs(i) * t(1:2048) + my_phase * pi / 180);

        y = y .* flattopwin(length(y))';
        [absY1, phaseY1] = my_fft(y, N);

        [maxval, index] = max(absY1);
        measured_phases(i) = phaseY1(index) / pi * 180;
    end
    differences = diff(measured_phases);
    inclines(j) = median(differences);
    starts(j) = measured_phases(1);
    [val,indexes] = min(differences);
    wraps(j) = differences(indexes(1));
end

figure;
subplot(211)
stem(freqs, measured_phases)
title("Faze")
xlabel("f [Hz]")
ylabel("$arg(X(j2\pi f))$ [rad]")

subplot(212)
stem(freqs, [diff(measured_phases); 0])
title("Nagib")
xlabel("f [Hz]")
ylabel("diff [deg/rad]")



% figure;
% plot(my_phases, inclines);
% title("Nagibi")
% xlabel("$\phi$ [deg]")
% ylabel("Nagib")

figure;
subplot(211)
stem(my_phases, starts)
title("Starts")
xlabel("$\phi$ [deg]")
ylabel("starts")

subplot(212)
stem(my_phases, wraps)
title("Wraps")
xlabel("$\phi$ [deg]")
ylabel("wraps")

%% Jednostrani spektar
n = 0:N/2;
faxis1 = n/(N/2) * Fs / 2;

figure;
sgtitle("Jednostrani spektar");

subplot(211)
plot(faxis1, absY1)
title("$|X(j2\pi f)|$")
xlabel("f [Hz]")
ylabel("$|X(j2\pi f)|$ [unit]")

subplot(212)
plot(faxis1, phaseY1);
title("$arg(X(j2\pi f))$")
xlabel("f [Hz]")
ylabel("$arg(X(j2\pi f))$ [rad]")


function [absX1, phaseX1] = my_fft(x, N)

    X = fft(x, N);
    dc = X(1);
    desno = X(2:N/2 + 1); % jedan odbirak vise na kraju od levo
    levo = X(N/2 + 2:N);
    X = [levo, dc, desno];

    absX1 = abs([dc, desno] / length(x));
    absX1(2:end) = absX1(2:end) * 2;

    phaseX1 = angle([dc, desno]);

end