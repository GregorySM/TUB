function FFT_plot(Data,Fs)

BRBM = Data;
m1 = mean(BRBM);
BRBM = BRBM - m1;
L1    = size(BRBM,1); 
NFFT1 = 2^nextpow2(L1);                   
Y1    = 2*fft(BRBM,NFFT1)/L1;          
f1    = Fs/2*linspace(0,1,NFFT1/2+1);
freq1 = transpose(f1);
amplitude_freq1 = abs(Y1(1:NFFT1/2+1));

figure
plot(f1,abs(Y1(1:NFFT1/2+1)),'b')
title('Smart Blade - Flapwise Blade Root Bending Moment FFT (Low-Pass 10Hz)')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
old_limits = axis;
grid minor
axis([10^-1, 10*3, old_limits(3), old_limits(4)]);

end