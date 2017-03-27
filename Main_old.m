%% Initialization

close all
clear
clc

%% Inputing and converting the Data to .mat
read_and_convert_tdms = 0; 
load('dms_calib.mat')
format long

%% Delta 5
folder  = './Delta5/';

if read_and_convert_tdms == 1
    file_type = '*.tdms';
else
    file_type = '*.mat';    
end

nameFiles = dir(strcat(folder,file_type));
files_delta5 = {nameFiles.name}; 


for i=1:size(files_delta5,2)
    
    file{i} = strcat(folder,files_delta5{:,i});   
    if read_and_convert_tdms == 1;
        matFileName=simpleConvertTDMS(file{i});  
        DATA_d5(i) = load(cell2mat(matFileName));
    else
        DATA_d5(i) = load(file{i});   
    end
    p5{i} = files_delta5{:,i}(13:end-4);
end
p5 =cellstr(p5);  


clc
%% Delta 10 


folder  = './Delta10/';

if read_and_convert_tdms == 1
    file_type = '*.tdms';
else
    file_type = '*.mat';    
end
nameFiles = dir(strcat(folder,file_type));
files_delta10 = {nameFiles.name}; 




for i=1:size(files_delta10,2)
    
    file{i} = strcat(folder,files_delta10{:,i});   
    if read_and_convert_tdms == 1;
        matFileName=simpleConvertTDMS(file{i});  
        DATA_d10(i) = load(cell2mat(matFileName));
    else
        DATA_d10(i) = load(file{i});   
    end
    p10{i} = files_delta10{:,i}(13:end-4);
      
end
p10 =cellstr(p10);


clc
%% Constants

Fs = 10^4;      % Sampling frequency 10 KHz
Ts = 1/Fs;      % Sampling period

r_speed = 3;    % Rotational speed of the turbine in Hz


 
 
%% Filtering Data & Preparing Data


  [Data_d5] = greg_filter(DATA_d5, Fs, r_speed,p5);

  [Data_d10] = greg_filter(DATA_d10, Fs, r_speed,p10);




%% Delay estimation


% Experiments for estimation


  dplus = merge(Data_d5(8).iddata,Data_d5(6).iddata,Data_d5(1).iddata,Data_d5(3).iddata);
  
  dminus = merge(Data_d5(4).iddata,Data_d5(2).iddata,Data_d5(5).iddata,Data_d5(7).iddata); 
  

  
  
%% System identification

%------------------------- Raw Validation Data -------------------------%


% Negative change Validation
z_m = iddata(DATA_d10(2).crio_databendflapblade3DMS02.Data *   -8.212171639296294e+05 ...
+ -1.973389124055448e+02,DATA_d10(2).crio_dataservo1setpointAI313.Data * -0.068965517241379 ...
+ 98.965517241379300, Ts);

% Negative change Validation
z_p = iddata(DATA_d10(1).crio_databendflapblade3DMS02.Data *   -8.212171639296294e+05 ...
+ -1.973389124055448e+02,DATA_d10(1).crio_dataservo1setpointAI313.Data * -0.068965517241379 ...
+ 98.965517241379300, Ts);

% Detrending Data
z_m = detrend(z_m);
z_p = detrend(z_p);





%------------------------- Model Estimation -------------------------%

% Tranfer Function models
% 
model = tfest(dminus,1,0); % 1st order transfer function estimation (1pole, no zeros)
model2 = tfest(dminus,2,1);% 2nd order transfer function estimation (2pole, 1 zero)
model3 = tfest(dminus,3,2);% 2nd order transfer function estimation (2pole, 1 zero)


% ARMAX MODELS

% Armax model estimation with default settings
opt = armaxOptions;
opt.Regularization.Lambda = 1;
opt.Display = 'off';
ml_plus = armax(dplus,[2 2 2 1],opt);
ml_minus = armax(dminus,[2 2 2 1],opt);

% Armax model estimation with focus on simulation and auto method selection
opt1 = armaxOptions('Focus','simulation');
opt1.Display = 'off';
m_plus_sim = armax(dplus,[2 2 2 1],opt1);
m_minus_sim = armax(dminus,[2 2 2 1],opt1);


% Armax model estimation with focus on simulation and method Levenberg-Marquardt
opt2 = armaxOptions;
opt2.Focus = 'simulation';
opt2.SearchMethod = 'lm';
opt2.SearchOption.MaxIter = 10;
opt2.Display = 'off';
sys_plus = armax(dplus,[2 2 2 1],opt2);
sys_minus = armax(dminus,[2 2 2 1],opt2);





%------------------------- Comparison -------------------------%


compare(z_m,ml_plus,ml_minus,m_plus_sim,m_minus_sim,sys_plus,sys_minus)
figure
compare(z_p,ml_plus,ml_minus,m_plus_sim,m_minus_sim,sys_plus,sys_minus)
figure
compare(Data_d10(2).iddata,sys_plus,model3)
