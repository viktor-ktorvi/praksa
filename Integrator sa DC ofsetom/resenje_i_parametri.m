clc;
close all;
clear variables;

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
%% Parametri
Fs = 2000; % Hz
f = 50; % Hz
A = 328;
DC = 10;
epsilon = 30;
w = 2*pi*f;
% N = 512;

%% Realni podaci

sim_duration = 10; % s
time = 1/Fs * (0:(Fs * sim_duration));
real_input = dlmread('signal_txt.txt');
save('real_input.mat', 'real_input');

real_input_tt = timetable(seconds(time)', real_input(1:length(time)));
%% Modifikovani integrator
s = tf('s');
G = 1/(s + epsilon);
W = 1/s;

Gz = c2d(G, 1/Fs, 'tustin');
zpk(Gz)
[num,den] = tfdata(Gz);
Gz = filt(num, den ,1/Fs);
zpk(Gz)

%% Bodeovi dijagrami
figure;
margin(W)
title("Idealni integrator")

figure;
margin(G)
title("Modifikovani integrator")

figure;
margin(Gz)
title("Diskretni modifikovani integrator")

figure;
bode(W, Gz)
%% Signal

t = time;
x = real_input(1:length(time));

figure;
sgtitle("Vremenski domen")

subplot(211)
plot(t, x)
title("Ulazni signal")
ylabel("$x(t)$ [unit]")
xlabel("t [s]")

subplot(212)
ind1 = round(0.5 * length(t));
ind2 = round(0.55 * length(t));
plot(t(ind1:ind2), x(ind1:ind2))
title("Uvelicano")
xlabel("t [s]")
ylabel("$x(t)$ [unit]")


%% Simulacija
sim_file_name = "model";
open_system(sim_file_name)
out = sim(sim_file_name);
%%
fileID = fopen('input.txt','w');
save_to_file_vhdl(out.input(1:2048), fileID)
fclose('all');



