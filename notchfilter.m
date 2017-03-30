function Data = notchfilter(DATA,P,Fs)
Ts = 1/Fs;


    for i = 1:size(DATA,2)
        Data(i).input = DATA(i).crio_dataservo1setpointAI313.Data * -0.068965517241379 + 98.965517241379300;
        Data(i).output = DATA(i).crio_databendflapblade3DMS02.Data *   -8.212171639296294e+05 + -1.973389124055448e+02;
        Data(i).filtered = Data(i).output; 
        for j = 1:3
            wo = P(j)/(Fs/2); bw = wo/20;
            [b,a] = iirnotch(wo,bw,20); 
            
            D = round(mean(grpdelay(b,a))); % filter delay in samples
            
            Data(i).filtered= filtfilt(b,a,Data(i).filtered); % zero-phase filtering
         %
            Blade_1 = Data(i).filtered;

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
            axis([10^-1, 10*3, old_limits(3), old_limits(4)]);
%          
            Data(i).iddata = iddata(Data(i).filtered(10000:end),Data(i).input(10000:end),Ts);
            Data(i).iddata = detrend(Data(i).iddata);



        end

    end


end