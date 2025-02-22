function [Data] = greg_filter (DATA, Fs, r_speed)
Ts = 1/Fs;




for i=1:size(DATA,2)
   
    
  Data(i).input = DATA(i).crio_dataservo1setpointAI313.Data * -0.068965517241379 + 98.965517241379300;
  Data(i).output = DATA(i).crio_databendflapblade3DMS02.Data *   -8.212171639296294e+05 + -1.973389124055448e+02;
  
  

   %% Filtering Data

%------------ Electronic Noise Filtering ------------%


N = length(Data(i).output);
t = (0:N-1)/Fs;  



Fnorm = 75/(Fs/2);  % Normalization of the cut-off frequency

df = designfilt('lowpassfir','FilterOrder',40,'CutoffFrequency',Fnorm); % Filter Design 

% Calculation of the Delay the Filter is introducing
D = mean(grpdelay(df)); % filter delay in samples

% Compansation for this delay by adding zeros to the end of the signal. The amount of zeros is equal to the number of delayed 
% samples 

Channel_filt= filter(df,[Data(i).output; zeros(D,1)]);
Data(i).Filtered = Channel_filt(D+1:end);  


% plotting the results and comparing raw and filtered


% 
% figure
% plot(t, Data(i).output,t,Data(i).Filtered,'r','linewidth',1.5);
% xlabel('Time (s)')
% legend('Original Noisy Signal','Filtered Signal');
% grid on
% axis tight
% title(['Filtered Waveforms Beta Change: ',p{i}]);

%------------ Smoothing Data over One Rotation ------------%

One_rotation = floor(Fs/r_speed);  % We use a window equal to how many samples we have for one full
                                   % rotation of the turbine

coeffOneRotation = ones(1, One_rotation)/One_rotation;

Data(i).avgOneRotation = filter(coeffOneRotation, 1, Data(i).Filtered);

fDelay = (length(coeffOneRotation )-1)/2;   % Any symmetric filter of length N will have a delay of (N-1)/2 samples.



%%
% 

%  Data(i).avgOneRotation = medfilt1(Data(i).avgOneRotation,300);



%%
% 
% figure
% plot(t,Data(i).Filtered,t-Ts*fDelay,Data(i).avgOneRotation,'linewidth',1.5);
% xlabel('Time (s)')
% legend('Input Channel','Smoothed Signal');
% grid on
% axis tight
% title(['Smoothed Waveforms Over One Rotation Beta Change: ',p{i}]);


Data(i).iddata = iddata( Data(i).avgOneRotation(4050:end),Data(i).input(4050:end),Ts);
Data(i).iddata = detrend(Data(i).iddata);


end

end
