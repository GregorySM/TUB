
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
%% Delta 1


folder  = './Delta1/';

if read_and_convert_tdms == 1
    file_type = '*.tdms';
else
    file_type = '*.mat';    
end
nameFiles = dir(strcat(folder,file_type));
files_delta1 = {nameFiles.name}; 




for i=1:size(files_delta1,2)
    
    file{i} = strcat(folder,files_delta1{:,i});   
    if read_and_convert_tdms == 1
        matFileName=simpleConvertTDMS(file{i});  
        DATA_d1(i) = load(cell2mat(matFileName));
    else
        %A = load(file{i});
        DATA_d1(i) = load(file{i}); %check_channelnaming(A);
    end
    p1{i} = files_delta1{:,i}(13:end-4);
      
end
p1 =cellstr(p1);


clc
%% Delta 2


folder  = './Delta2/';

if read_and_convert_tdms == 1
    file_type = '*.tdms';
else
    file_type = '*.mat';    
end
nameFiles = dir(strcat(folder,file_type));
files_delta2 = {nameFiles.name}; 




for i=1:size(files_delta2,2)
    
    file{i} = strcat(folder,files_delta2{:,i});   
    if read_and_convert_tdms == 1
        matFileName=simpleConvertTDMS(file{i});  
        DATA_d2(i) = load(cell2mat(matFileName));
    else
        A = load(file{i});
        DATA_d2(i) = check_channelnaming(A);
    end
    p2{i} = files_delta2{:,i}(13:end-4);
      
end
p2 =cellstr(p2);


clc
%% Sinus


folder  = './Sinus/';

if read_and_convert_tdms == 1
    file_type = '*.tdms';
else
    file_type = '*.mat';    
end
nameFiles = dir(strcat(folder,file_type));
files_Sinus = {nameFiles.name}; 




for i=1:size(files_Sinus,2)
    
    file{i} = strcat(folder,files_Sinus{:,i});   
    if read_and_convert_tdms == 1
        matFileName=simpleConvertTDMS(file{i});  
        DATA_Sinus(i) = load(cell2mat(matFileName));
    else
        
        DATA_Sinus(i) = load(file{i});
    end
    pSinus{i} = files_Sinus{:,i}(13:end-4);
      
end
pSinus =cellstr(pSinus);


clc
%% Constants

Fs = 10^4;      % Sampling frequency 10 KHz

Ts = 1/Fs;      % Sampling period

r_speed = 3;    % Rotational speed of the turbine in Hz

flag_BRBM_Beta_Curve = 1;

%%

BM_beta_curves(DATA_d1,Fs,files_delta1,flag_BRBM_Beta_Curve)
 


%% Filtering Data & Preparing Data


  [Data_d5] = greg_filter(DATA_d5, Fs, r_speed,p5,1,2);

  [Data_d2] = greg_filter(DATA_d2, Fs, r_speed,p2,3,4);

  [Data_d1] = greg_filter(DATA_d1, Fs, r_speed,p1,5,6);


%% Delay estimation


% Experiments for estimation

d1_plus = merge(Data_d1(21).iddata,Data_d1(3).iddata,Data_d1(5).iddata,Data_d1(7).iddata,Data_d1(9).iddata,...
    Data_d1(11).iddata,Data_d1(13).iddata,Data_d1(15).iddata,Data_d1(17).iddata,Data_d1(19).iddata,...
    Data_d1(22).iddata,Data_d1(24).iddata,Data_d1(26).iddata,Data_d1(28).iddata,Data_d1(30).iddata,...
     Data_d1(32).iddata,Data_d1(34).iddata,Data_d1(36).iddata,Data_d1(38).iddata,Data_d1(40).iddata);

%   d1 = merge(Data_d1(:).iddata);
  d2 = merge(Data_d2(:).iddata);
  d5 = merge(Data_d5(:).iddata); 
%   dminus = merge(Data_d5(4).iddata,Data_d5(2).iddata,Data_d5(5).iddata,Data_d5(7).iddata); 
  

  
  
%% System identification

%------------------------- Raw Validation Data -------------------------%


% % Negative change Validation
% z_m = iddata(DATA_d5(2).crio_databendflapblade3DMS02.Data *   -8.212171639296294e+05 ...
% + -1.973389124055448e+02,DATA_d5(2).crio_dataservo1setpointAI313.Data * -0.068965517241379 ...
% + 98.965517241379300, Ts);
% 
% % Negative change Validation
% z_p = iddata(DATA_d5(1).crio_databendflapblade3DMS02.Data *   -8.212171639296294e+05 ...
% + -1.973389124055448e+02,DATA_d5(1).crio_dataservo1setpointAI313.Data * -0.068965517241379 ...
% + 98.965517241379300, Ts);
% 
% % Detrending Data
% z_m = detrend(z_m);
% z_p = detrend(z_p);





%------------------------- Model Estimation -------------------------%

% Tranfer Function models
% 

model_plus = tfest(d1_plus,1,0); % 1st order transfer function estimation (1pole, no zeros)
model2_plus = tfest(d1_plus,2,1);% 2nd order transfer function estimation (2pole, 1 zero)
% model3 = tfest(d,3,2);% 2nd order transfer function estimation (2pole, 1 zero)
% 
% 
% % ARMAX MODELS
% 
% Armax model estimation with default settings
% opt = armaxOptions;
% opt.Regularization.Lambda = 1;
% opt.Display = 'off';
% m_poly = armax(d,[2 2 2 1],opt);
% % ml_minus = armax(dminus,[2 2 2 1],opt);
% % 
% % Armax model estimation with focus on simulation and auto method selection
% opt1 = armaxOptions('Focus','simulation');
% opt1.Display = 'off';
% m_polys = armax(d,[2 2 2 1],opt1);
% % m_minus_sim = armax(d,[2 2 2 1],opt1);
% % 
% 
% Armax model estimation with focus on simulation and method Levenberg-Marquardt
opt2 = armaxOptions;
opt2.Focus = 'simulation';
opt2.SearchMethod = 'lm';
opt2.SearchOption.MaxIter = 10;
opt2.Display = 'off';
sys_plus = armax(d1_plus,[2 2 2 1],opt2);
% sys_minus = armax(dminus,[2 2 2 1],opt2);
% 
% 
% 
% 
% 
% %------------------------- Comparison -------------------------%
% 
% 
% compare(z_m,ml_plus,ml_minus,m_plus_sim,m_minus_sim,sys_plus,sys_minus)
% figure
% compare(z_p,ml_plus,ml_minus,m_plus_sim,m_minus_sim,sys_plus,sys_minus)
for i=1:size(Data_d5,2)
figure
compare(Data_d2(i).iddata,model_plus,model2_plus,sys_plus)


end


%%

% mo = tfest(Data_d5(4).iddata,2,1);
% figure
% plot(Data_d2(i).iddata)
% 
% 
% compare(Data_d2(4).iddata,mo)

