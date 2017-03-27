function [Data] = filtpass (DATA, Fs, Fc)
Ts = 1/Fs;
Wn = (2/Fs)*Fc;
[b,a]=butter(3,Wn);

for i=1:size(DATA,2)
 
  Data(i).input = DATA(i).crio_dataservo1setpointAI313.Data * -0.068965517241379 + 98.965517241379300;
  Data(i).output = DATA(i).crio_databendflapblade3DMS02.Data *   -8.212171639296294e+05 + -1.973389124055448e+02;
%   N = length(Data(i).output);
%   t = (0:N-1)/Fs;  
  

   %% Filtering Data

%------------ Electronic Noise Filtering ------------%


% Compansation for this delay by adding zeros to the end of the signal. The amount of zeros is equal to the number of delayed 
% samples 
D = round(mean(grpdelay(b,a))); % filter delay in samples

Data(i).filtered= filtfilt(b,a,Data(i).output); % zero-phase filtering
Data(i).iddata = iddata(Data(i).filtered(10000:end),Data(i).input(10000:end),Ts);
Data(i).iddata = detrend(Data(i).iddata);

% figure
% plot(Data(i).iddata)

end

end
