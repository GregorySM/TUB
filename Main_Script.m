%% Initialization

close all
clear
clc

%% Inputing and converting the Data to .mat
%cd 'C:\Users\Greg\Documents\TU Berlin\System Identification'

read_and_convert_tdms = 0; 
BRBM_callib = load('dms_calib.mat'); % strain gauge calib
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

P = [3 6 9 12]; % 1p 2p 3p 4p
% Curves

flag_BRBM_Beta_Curve = 0;       % Blade Root Bending Moment Against Flap angle
flag_response_time_curves = 0;  % Servos and BRBM Step Response

% Import Data 
Import_data_Wind       = 0;
Import_data_d1         = 0; % one single discrete step changes beta- 1� deltas
Import_data_d2         = 0; % one single discrete step changes beta- 2� deltas
Import_data_d5         = 0; % one single discrete step changes beta- 5� deltas
Import_data_d10        = 0; % one single discrete step changes beta- 10� deltas
Import_data_sinus      = 0; % sin inputs with different frequencies
Import_data_continuous = 1; % random step changes within one file!

% Flags
Model_estimation       = 0; % finds TF beta flap to BRB
Wind_Model_estimation  = 0; % finds TF for GROWIKA FAN (WIND VEL) to BRB

%% Delta 1
if Import_data_d1 == 1
    folder  = './Data/Delta1/';
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
    folder  = './Data/Delta2/';

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
    folder  = './Data/Delta5/';
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
    folder  = './Data/Delta10/';
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
        p10{i} = files_delta10{:,i}(13:end-4);
      
    end
    p10 =cellstr(p10);


    clc
end
%% Sinus
if Import_data_sinus == 1
    folder  = './Data/Sinus/';

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
    folder  = './Data/Wind_Velocity_Step/';

    nameFiles = dir(strcat(folder,file_type));
    files_Wind = {nameFiles.name}; 


    for i=1:size(files_Wind,2)
    
        file{i} = strcat(folder,files_Wind{:,i});   
        if read_and_convert_tdms == 1
            matFileName=simpleConvertTDMS(file{i});  
            DATA_Wind(i) = check_channelnaming(load(file{i}));
        else
        
            DATA_Wind(i) = check_channelnaming(load(file{i}));
        end
%         pWind{i} = files_Wind{:,i}(13:end-4);
     end
%     pWind =cellstr(pWind);


    clc
end


%% Continuous Step
if Import_data_continuous == 1
    folder  = './Data/Continuous/';

    nameFiles = dir(strcat(folder,file_type));
    files_Continuous = {nameFiles.name}; 


    for i=1:size(files_Continuous,2)
     % imports all continous measurements and puts them into one row (each
     % expiremt corresponds to one line!)
        file{i} = strcat(folder,files_Continuous{:,i});   
        if read_and_convert_tdms == 1
            matFileName=simpleConvertTDMS(file{i});
            A = load(cell2mat(matFileName)); 
            DATA_Continuous(i) = check_channelnaming(A);
        else
        
            DATA_Continuous(i) = check_channelnaming(load(file{i}));
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


%% Filtering Data & Preparing Data for System Identification
if Import_data_sinus == 1
    [Data_Sinus] = notchfilter(DATA_Sinus,P,Fs,10,0);
end

if Import_data_d1 == 1
    [Data_d1] = notchfilter(DATA_d1,P,Fs,10,0);
end

if Import_data_d2 == 1
    [Data_d2] = notchfilter(DATA_d2,P,Fs,10,0);
end

if Import_data_d5 == 1
    [Data_d5] = notchfilter(DATA_d5,P,Fs,10,0);
end

if Import_data_d10 == 1
    [Data_d10] = notchfilter(DATA_d10,P,Fs,10,0);
end

if Import_data_Wind == 1
    [Data_Wind] = notchfilter(DATA_Wind,P,Fs,10,0);
end

if Import_data_continuous == 1
    [Data_C] = notchfilter(DATA_Continuous,P,Fs,10,0);
end
%% Delay estimation
% Experiments for estimation
d_Es = Data_C(2).iddata; % Estimation data - used to find Model (+/- 5� max flap angle)
  
d_Vs = Data_C(4).iddata; % Validation data - used to valid found model (+/- 5� max flap angle)

d_E = Data_C(1).iddata;  
  
d_V = Data_C(3).iddata;

%% System identification

% Wind Model
% change of inflow velocity by GroWika Fan adjustment
% graphical system identifaction (Ziegler - Nichols)
if Wind_Model_estimation == 1
    N = length(Data_Wind(2).filtered);
    t = (0:N-1)/Fs;
    plot(t,Data_Wind(1).filtered - 36.4)
    %
    t1 = 15.7; % time, manually determined
    t2 = 19;   % time, manually determined
    tau = 3/2 * (t2 - t1);
    theta = t2 - tau;

    s = tf('s');
    Gp = exp(-15*s)/(1 + tau*s)

    hold on; step(2*Gp,'r'),hold off;
end
% Smart blade Model
%------------------------- Model Estimation -------------------------%
if Model_estimation == 1
    ident % opens graphical tool for identification (shall be replaced by code)
    % State space (state space estimation using subspace method)
    opt = n4sidOptions('Focus','simulation','Display','on','N4weight','CVA');
    SS_model = n4sid(d_Es,4,opt);
    
    
    %------------ Tranfer Function models ------------%

    TF_model = tfest(d_Es,2,1);   % 2nd order Transfer Function 

    %------------ ARMAX MODELS ------------%
    % Armax model estimation with focus on simulation and method Levenberg-Marquardt
    % not used right now
    opt2 = armaxOptions;
    opt2.Focus = 'simulation';
    opt2.SearchMethod = 'lm';
    opt2.SearchOption.MaxIter = 10;
    opt2.Display = 'off';
    Poly_model = armax(d_Es,[2 2 2 1],opt2);
    
    %------------------------- Neural Network ---------------------%

    % x = Data_d5(1).input(10000:end);
    % xd = detrend(x);
    % xtest = Data_d5(2).input(10000:end);
    % 
    % y = Data_d5(1).filtered(10000:end);
    % yd = detrend(y);
    % ytest = Data_d5(2).filtered(10000:end);

    %------------------------- Comparison -------------------------%
    % compares input (Experiment), compares 
    % experimental output and estimated output 
    compare(d_E,TF_model,SS_model,Poly_model)

    compare(d_Vs,TF_model,SS_model,Poly_model)
    
    %------------------------- Control Design -------------------------%
    opt = pidtuneOptions('DesignFocus','balanced');
    opt1 = pidtuneOptions('DesignFocus','reference-tracking');
    opt2 = pidtuneOptions('DesignFocus','disturbance-rejection');
% this stuff works, but graphical pid tuning (pidTuner) works better, as 
% slightly faster response for example can be set easy (not possible in
% coded stuff)
    [C_balanced,info1] = pidtune(SS_model,'PID',opt);
    [C_following,info2] = pidtune(SS_model,'PID',opt1);
    [C_reacting,info3] = pidtune(SS_model,'PID',opt2);
    % pidtune returns parallel pid controller form: Kp, Ki, Kd,
    % labview needs Kp, Ti, Td
    % convert using: Ti =   #
    % Greg did this using the graphical pid tuner changing from parallel to
    % standard form! technically, convertion should work as well!
end