%% Analysis to determine the eignefrequencies of the blades 1 & 2

%% Data location on server :

%\\giga\wind\BeRT\16-11 Campaign 8\BeRT\16-15-15 BladeEigenfreq

%\\giga\wind\BeRT\16-11 Campaign 8\BeRT\16-12-14 Vibration - Hammertest



%% Initialization

close all
clear
clc

%% Import Data
read_and_convert_tdms = 0;  % 1 = Yes, 0 = No
    
    
if read_and_convert_tdms == 1
    file_type = '*.tdms';
else
    file_type = '*.mat';    
end

folder = './Data/';

nameFiles = dir(strcat(folder,file_type));
files = {nameFiles.name}; 

file = strcat(folder,files{:,1});   



for i = 1:size(files,2)
    clc
    
    file = strcat(folder,files{:,i});
    if read_and_convert_tdms == 1;
        matFileName=simpleConvertTDMS(file);  
        DATA(i) = load(cell2mat(matFileName));
    else
        DATA(i) = load(file);   
    end
end

%% Manual insert of data
Fs = 10^4; % Hz
Ts = 1/Fs;

blade1_flap_1 = 12.82;
blade1_flap_2 = 16.33;
blade3_flap_1 = 15.06;
blade3_flap_2 = 18;
blade3_edge_1 = 49.75;
Tower_acc = 8.14;
Tower_thrust = 7.98;

max_speed = 300;
minexp_op_speed = 2.5 *60;
op_speed = 3 * 60;
maxexp_op_speed = 3.3 * 60;
max_op_speed = 250;
f_rot = 3;


%% FFTs
%-------------- Blade 1 -------------%
Blade_1 = DATA(1).crio_databendflapblade1DMS11.Data(88140:121600);
m1 = mean(Blade_1);
Blade_1 = Blade_1 - m1;

L1    = size(Blade_1,1); 

NFFT1 = 2^nextpow2(L1);                   
Y1    = 2*fft(Blade_1,NFFT1)/L1;          
f1    = Fs/2*linspace(0,1,NFFT1/2+1);

freq1 = transpose(f1);
amplitude_freq1 = abs(Y1(1:NFFT1/2+1));

figure
plot(f1,abs(Y1(1:NFFT1/2+1)),'b')
title('Blade 1 FFT')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
old_limits = axis;
grid minor
axis([10^-1, 10*f_rot, old_limits(3), old_limits(4)]);

%-------------- Blade 3 -------------%

Blade_3 = DATA(7).crio_databendflapblade3DMS02.Data(119500:157500);
m2 = mean(Blade_3);
Blade_3 = Blade_3 - m2;
L2    = size(Blade_3,1); 

NFFT2 = 2^nextpow2(L2);                 
Y2    = 2*fft(Blade_3,NFFT2)/L2;       
f2    = Fs/2*linspace(0,1,NFFT2/2+1);
freq2 = transpose(f2);
amplitude_freq2 = abs(Y2(1:NFFT2/2+1));

figure
plot(f2,abs(Y2(1:NFFT2/2+1)),'b')
title('Smart Blade FFT')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
old_limits = axis;
grid minor
axis([10^-1,  100, old_limits(3), old_limits(4)]);


  
%% Campell Diagram

main_shaft_speed = 0:max_speed;

figure
grid on
hold on
xlim([0 300])
ylim([0 50])
xlabel('main shaft speed [l/min]')
ylabel('frequecny [Hz]')
title('Campbell Diagram for BeRT')
legend('hide')
% Plot 1p up to 6p
plot(main_shaft_speed./60,'k','DisplayName','p1','LineWidth',2)
plot(2*main_shaft_speed./60,'k:','DisplayName','p2','LineWidth',2)
plot(3*main_shaft_speed./60,'k--','DisplayName','p3','LineWidth',2)
plot(4*main_shaft_speed./60,'k','DisplayName','p4','LineWidth',2)
plot(5*main_shaft_speed./60,'k:','DisplayName','p5','LineWidth',2)
plot(6*main_shaft_speed./60,'k--','DisplayName','p6','LineWidth',2)
% Plot eigen freq
plot([0 max_speed],[blade1_flap_1 blade1_flap_1],'b','DisplayName','Blade1 flap 1','LineWidth',2)
plot([0 max_speed],[blade1_flap_2 blade1_flap_2],'Color',[0 0 0.75],'DisplayName','Blade1 flap 2','LineWidth',2)
plot([0 max_speed],[blade3_flap_1 blade3_flap_1],'r','DisplayName','Blade3 flap 1','LineWidth',2)
plot([0 max_speed],[blade3_flap_2 blade3_flap_2],'Color',[0.75 0 0],'DisplayName','Blade3 flap 2','LineWidth',2)
%plot([0 max_speed],[blade3_edge_1 blade3_edge_1],'k','DisplayName','Blade3 Edge1','LineWidth',2)
plot([0 max_speed],[Tower_acc Tower_acc],'c','DisplayName','Tower acc','LineWidth',2)
plot([0 max_speed],[Tower_thrust Tower_thrust],'Color',[0 0.75 0.75],'DisplayName','Tower thrust','LineWidth',2)

legend('show')
legend('Location','northwest')
% Plot speeds
plot([minexp_op_speed minexp_op_speed],[0 50],'k--')
plot([op_speed op_speed],[0 50],'r--')
plot([maxexp_op_speed maxexp_op_speed],[0 50],'k--')
plot([max_op_speed max_op_speed],[0 50],'r--')
text(op_speed-22,45,'n_o_p_a_r_a_t_i_o_n \rightarrow ')
text(max_op_speed,45,'\leftarrow n_m_a_x ')
text(maxexp_op_speed,45,'\leftarrow 3.3 Hz ')
text(minexp_op_speed-15,45,'2.5 Hz \rightarrow')
