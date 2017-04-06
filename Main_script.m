%% Initialization

close all
clear
clc

%% Inputing and converting the Data to .mat
cd '\\changeit\public\Sirko\Greg\SysID\00_Script'

read_and_convert_tdms = 0; 
BRBM_callib = load('dms_calib.mat');
format long


if read_and_convert_tdms == 1
    file_type = '*.tdms';
else
    file_type = '*.mat';    
end
%% Constants

Fs = 10^4;      % Sampling frequency 10 KHz

Ts = 1/Fs;      % Sampling period [s]

r_speed = 3;    % Motor Rotational speed [Hz]

P = [3 6 8 12]; % 1p 2p 3p 4p
% Curves

flag_BRBM_Beta_Curve = 0;   % Blade Root Bending Moment Against Flap angle
flag_response_time_curves = 0;  % Servos and BRBM Step Response

% Import Data 
Import_data_Wind = 1;
Import_data_d1 = 0;
Import_data_d2 = 0;
Import_data_d5 = 1;
Import_data_d10 = 0;
Import_data_sinus = 0;

%
Model_estimation = 0;


%% Delta 1
if Import_data_d1 == 1
folder  = './Delta1/';
nameFiles = dir(strcat(folder,file_type));
files_delta1 = {nameFiles.name}; 

for i=1:size(files_delta1,2)
    
        file{i} = strcat(folder,files_delta1{:,i});   
        if read_and_convert_tdms == 1
            matFileName=simpleConvertTDMS(file{i});  
            DATA_d1(i) = load(cell2mat(matFileName));
        else
            DATA_d1(i) = check_channelnaming(load(file{i}));
        end
        p1{i} = files_delta1{:,i}(13:end-4);
      
    end
    p1 =cellstr(p1);


    clc
end
%% Delta 2
if Import_data_d2 == 1
    folder  = './Delta2/';

    nameFiles = dir(strcat(folder,file_type));
    files_delta2 = {nameFiles.name}; 

    for i=1:size(files_delta2,2)
    
        file{i} = strcat(folder,files_delta2{:,i});   
        if read_and_convert_tdms == 1
            matFileName=simpleConvertTDMS(file{i});  
            DATA_d2(i) = load(cell2mat(matFileName));
        else
            DATA_d2(i) = check_channelnaming(load(file{i}));
        end
        p2{i} = files_delta2{:,i}(13:end-4);
      
    end
    p2 =cellstr(p2);


    clc
end
%% Delta 5
if Import_data_d5 == 1
    folder  = './Delta5/';
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
end
%% Delta 10
if Import_data_d10 == 1
    folder  = './Delta10/';
    nameFiles = dir(strcat(folder,file_type));
    files_delta10 = {nameFiles.name}; 


    for i=1:size(files_delta10,2)
    
        file{i} = strcat(folder,files_delta10{:,i});   
        if read_and_convert_tdms == 1
            matFileName=simpleConvertTDMS(file{i});  
            DATA_d10(i) = load(cell2mat(matFileName));
        else
            DATA_d10(i) = load(file{i});
        end
        p10{i} = files_delta2{:,i}(13:end-4);
      
    end
    p10 =cellstr(p10);


    clc
end
%% Sinus
if Import_data_sinus == 1
    folder  = './Sinus/';

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
end
%% Wind_Velocity_Step
if Import_data_Wind == 1
    folder  = './Wind_Velocity_Step/';

    nameFiles = dir(strcat(folder,file_type));
    files_Wind = {nameFiles.name}; 


    for i=1:size(files_Wind,2)
    
        file{i} = strcat(folder,files_Wind{:,i});   
        if read_and_convert_tdms == 1
            matFileName=simpleConvertTDMS(file{i});  
            DATA_Wind(i) = load(cell2mat(matFileName));
        else
        
            DATA_Wind(i) = check_channelnaming(load(file{i}));
        end
%         pWind{i} = files_Wind{:,i}(13:end-4);
      end
%     pWind =cellstr(pWind);


    clc
end





%% Blade Root Bending againts Flap position curve

if flag_BRBM_Beta_Curve == 1
    
    BM_beta_curves(DATA_d1)
    
end

%% Servo-motors and Blade Root Bending Moment Step responses

if flag_response_time_curves == 1
    
    response_time(DATA_d2,DATA_d5,DATA_d10,Fs,1,r_speed)

end


%% Filtering Data & Preparing Data for 


[Data_d1] = notchfilter(DATA_d1,P,Fs,10);

[Data_d2] = notchfilter(DATA_d2,P,Fs,10);

[Data_d5] = notchfilter(DATA_d5,P,Fs,10);

%% Delay estimation


% Experiments for estimation


  d1 = merge(Data_d1(:).iddata);

  
  

%% System identification

if Model_estimation == 1


%------------------------- Model Estimation -------------------------%

% Tranfer Function models
% 

model = tfest(d1,1,0); % 1st order transfer function estimation (1pole, no zeros)


% model2 = tfest(d1,2,1);% 2nd order transfer function estimation (2pole, 1 zero)


% ARMAX MODELS

% Armax model estimation with focus on simulation and method Levenberg-Marquardt
opt2 = armaxOptions;
opt2.Focus = 'simulation';
opt2.SearchMethod = 'lm';
opt2.SearchOption.MaxIter = 10;
opt2.Display = 'off';
m_polylm = armax(d1,[2 2 2 1],opt2);
 
%------------------------- Comparison -------------------------%

for i=1:size(Data_d2,2)
    figure
    compare(Data_d2(i).iddata,model,polys)
end

%------------------------- Control Design -------------------------%
[C2,info] = pidtune(model,'PI',opt);
opt = pidtuneOptions('DesignFocus','disturbance-rejection');

Cp = pidtune(m_polylm,'PI');

pidtune(m_polylm,C)

end