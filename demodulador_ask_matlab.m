% Código para realizar a demodulação em ASK de algum dos sinais obtidos
% pelo filtro FIR de média móvel para comparar com o sinal obtido em VHDL
% Entradas: sinal janelado em 1250 valores
% Saída: sinal de mensagem demodulado
% Autor: João Pedro Cordeiro
% Data: jul/2023
clc; clear all;
close all

N=1250; % tamanho do vetor de teste
EW=8; % tamanho em bits do expoente
FW=18; % tamanho em bits da mantissa

% para trabalhar com binario
% fid = fopen('valor_vetor_entrada_VHDL.txt', 'r');
% x1bin = textread('valor_vetor_entrada_VHDL.txt', '%s');
% fclose(fid);
% 
% for i=1:N
%     cell_string = x1bin(i); % armazena o valor do binario da posicao i
%     string_without_brackets = char(cell_string); % retira os brackets do valor em binario
%     x1float(i)=bin2float(EW,FW,string_without_brackets); % converte a amostra de float para binario e armazena em float
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
format long

x1float = load('out_3_20dB.txt');

k = 1;
med_bit = 14;
j = 1;
maximo = 0;
bits = zeros(1, 50); % Assuming you want an array of size 1x50
tstem = zeros(1, 50); % Assuming you want an array of size 1x50
% threshold = 0;
msn = zeros(1, 50); % Initialize msn with size 1x50

for p=1:1250
    if (j == med_bit)
      bits(k) = x1float(j);
        if (bits(k) > maximo)
          maximo = bits(k);
        end
        tstem(k) = j;
        k = k + 1;
        med_bit = med_bit + 25;  
    else
      j = j + 1;
    end
end
threshold = maximo / 2;
for i=1:50
    if (bits(i) > threshold)
        msn(i) = 1;
    else
        msn(i) = 0;
    end
end
       
sampling_rate = 50;
bit_duration = 25;

threshold_vector = repmat(threshold, 1, 1250);

t = linspace(0, 1250, N);



% 
figure;
hold on
plot(t, x1float)                    % Plot x vs y
plot(t, threshold_vector, 'r--');
grid on
title('Sinal média móvel')        % Set the title of the plot
xlabel('Amostras')                   % Label for the x-axis
ylabel('Tensao[V]')                   % Label for the y-axis
stem(tstem,bits)
% Replicar cada bit para corresponder à duração de 25 bits
x_repeated = repmat(msn, bit_duration, 1);
x_repeated = x_repeated(:)';

% Calcular o tempo total do sinal
% total_time = length(x_repeated) / sampling_rate;
total_time = length(x_repeated);
% Gerar o vetor de tempo
time = linspace(0, total_time, length(x_repeated));

% Plotar o sinal recuperado
figure;
plot(time, x_repeated, 'LineWidth', 2); % Espessura da linha aumentada
grid on
title('Sinal Recuperado');
xlabel('Amostras');
ylabel('Amplitude');

% Aumentar o tamanho das letras
font_size = 12; % Tamanho da fonte aumentado
set(gca, 'FontSize', font_size);

% Estender a amplitude do gráfico
amplitude_extension = 0.2; % Valor de extensão da amplitude
ymin = min(x_repeated) - amplitude_extension;
ymax = max(x_repeated) + amplitude_extension;
ylim([ymin, ymax]);
