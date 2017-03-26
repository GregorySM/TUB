function BM_beta_curves(DATA,Fs,files_delta1,flag)

% Fc = 3;
% Wn = Fc/(Fs/2);
% [b,a] = butter(10,Wn,'low');
c = 0;  
%beta = [0 1 2 3 4 5 6 7 8 9 10 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10];
beta = -10:10;
if flag == 1
for i=1:size(DATA,2)
      Data(i).output = DATA(i).cRIObendflapblade3.Data *   -8.212171639296294e+05 + -1.973389124055448e+02;
%       Data(i).input = DATA(i).cRIOservo1setpoint.Data * -0.068965517241379 + 98.965517241379300;
%     %     Data(i).filtered = filter(b,a,Data(i).output);
    if mod(i,2) == 1 || i == 40
        c = c + 1;
        BRBM(c) = mean(Data(i).output(1:3333));
        
    end   
end

BRBM(1) = mean(Data(2).output(1:3333));
BRBM = sort(BRBM);

plot(beta,BRBM,'*')
line(beta,BRBM)
grid minor
title('Flap-wise Blade Root Bending Moment Against Flap Position')
ylabel('BRBM_f (Nm)')
xlabel('Flap angle \beta(°)')



end

