clc;
close all;
clear variables;


set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
%%
N = 64;
R = 17;
theta = (0:N - 1) * 2*pi/N;
rho = rand(1, N) * R + eps;

x = rho .* cos(theta);
y = rho .* sin(theta);

figure;
axis equal
plot(x, y, 'x')
title("Nasumicni primeri")
xlabel("x")
ylabel("y")
grid on

fileID = fopen('Signali/x.txt','w');
save_to_file_vhdl_float(x, fileID)
fclose('all');

fileID = fopen('Signali/y.txt','w');
save_to_file_vhdl_float(y, fileID)
fclose('all');

function save_to_file_vhdl_float(array, fileID)
    fprintf(fileID, 'constant ADC_test_vector3: test_arr := (\n');
    for i = 1:length(array)
        if i ~=length(array)
            fprintf(fileID, '\tx"%s",\n', num2hex(single(array(i))));
        else
            fprintf(fileID, '\tx"%s"\n);', num2hex(single(array(i))));
        end
    end
end
