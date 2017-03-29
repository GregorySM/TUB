function response_time(Data_d2,Data_d5,Data_d10,Fs,callib,r_speed)
one_rotation = 1/r_speed; % one rotation in seconds
Ts = 1/Fs;

if callib == 1
    servos = get_servo_calib;
end

% Filters

Fc1 = 2.5;
Wn1 = (2/Fs)*Fc1;
[b1,a1]=butter(3,Wn1);

Fc2 = 1;
Wn2 = (2/Fs)*Fc2;
[b2,a2]=butter(3,Wn2);



%% Change  of delta 2°
    
Change_d2.setpoint = Data_d2(2).crio_dataservo1setpointAI313.Data * -0.068965517241379 + 98.965517241379300;
    
g = gradient(Change_d2.setpoint);
      
triggerp = find(g>=max(g));
Change_d2.setpoint = Change_d2.setpoint(triggerp(1):end); 
    
N = length(Change_d2.setpoint);
t = (0:N-1)/Fs;

Change_d2.beta.servo1 = filtfilt(b1,a1,Data_d2(2).crio_dataservopos1AI30.Data(triggerp(1):end) * servos.acp1.m + servos.acp1.n);
Change_d2.beta.servo2 = filtfilt(b1,a1,Data_d2(2).crio_dataservopos2AI31.Data(triggerp(1):end) * servos.acp2.m + servos.acp2.n);
Change_d2.beta.servo3 = filtfilt(b1,a1,Data_d2(2).crio_dataservopos3AI32.Data(triggerp(1):end) * servos.acp3.m + servos.acp3.n);
Change_d2.moment = filtfilt(b2,a2,Data_d2(2).crio_databendflapblade3DMS02.Data(triggerp(1):end)) *   -8.212171639296294e+05 + -1.973389124055448e+02;




figure

subplot(5,1,1)
hold on
plot(t,Change_d2.setpoint)
plot([one_rotation one_rotation],[0 3],'k--')
xlim([0 2])
ylabel('Setpoint [°]')
hold off

subplot(5,1,2)
hold on
plot(t,Change_d2.beta.servo1)
plot([one_rotation one_rotation],[0 3],'k--')
plot([0 3],[2 2],'k--')
xlim([0 2])
ylabel('Servo 1 Response [°]')
hold off

subplot(5,1,3)
hold on
plot(t,Change_d2.beta.servo2)
plot([0.33 0.33],[0 2],'k--')
plot([0 3],[2 2],'k--')
xlim([0 2])
ylabel('Servo 2 Response [°]')
hold off

subplot(5,1,4)
hold on
plot(t,Change_d2.beta.servo3)
plot([0.33 0.33],[0 3],'k--')
plot([0 3],[2 2],'k--')
xlim([0 2])
ylabel('Servo 3 Response [°]')
hold off

subplot(5,1,5)
hold on
plot(t,Change_d2.moment)
plot([0.33 0.33],[0 50],'k--')
xlim([0 2])
ylim([35 45])
ylabel('BRBM [Nm]')
xlabel('time [s]')
hold off


%% Change of delta 5°
    
Change_d5.setpoint = Data_d5(1).crio_dataservo1setpointAI313.Data * -0.068965517241379 + 98.965517241379300;
    
g = gradient(Change_d5.setpoint);
      
triggerp = find(g>=max(g));
Change_d5.setpoint = Change_d5.setpoint(triggerp(1):end); 
    
N = length(Change_d5.setpoint);
t = (0:N-1)/Fs;

Change_d5.beta.servo1 = filtfilt(b1,a1,Data_d5(1).crio_dataservopos1AI30.Data(triggerp(1):end) * servos.acp1.m + servos.acp1.n);
Change_d5.beta.servo2 = filtfilt(b1,a1,Data_d5(1).crio_dataservopos2AI31.Data(triggerp(1):end) * servos.acp2.m + servos.acp2.n);
Change_d5.beta.servo3 = filtfilt(b1,a1,Data_d5(1).crio_dataservopos3AI32.Data(triggerp(1):end) * servos.acp3.m + servos.acp3.n);
Change_d5.moment = filtfilt(b2,a2,Data_d5(1).crio_databendflapblade3DMS02.Data(triggerp(1):end)) *   -8.212171639296294e+05 + -1.973389124055448e+02;

% Plotting
figure

subplot(5,1,1)
hold on
plot(t,Change_d5.setpoint)
plot([0.33 0.33],[0 10],'k--')
plot([0 3],[5 5],'k--')
xlim([0 2])
ylabel('Setpoint [°]')
hold off

subplot(5,1,2)
hold on
plot(t,Change_d5.beta.servo1)
plot([0.33 0.33],[0 10],'k--')
plot([0 3],[5 5],'k--')
xlim([0 2])
ylabel('Servo 1 Response [°]')
hold off

subplot(5,1,3)
hold on
plot(t,Change_d5.beta.servo2)
plot([0.33 0.33],[0 10],'k--')
plot([0 3],[5 5],'k--')
xlim([0 2])
ylabel('Servo 2 Response [°]')
hold off

subplot(5,1,4)
hold on
plot(t,Change_d5.beta.servo3)
plot([0.33 0.33],[0 10],'k--')
plot([0 3],[5 5],'k--')
xlim([0 2])
ylabel('Servo 3 Response [°]')
hold off

subplot(5,1,5)
hold on
plot(t,Change_d5.moment)
plot([0.33 0.33],[0 50],'k--')
xlim([0 2])
ylim([35 45])
ylabel('BRBM [Nm]')
xlabel('time [s]')
hold off

%% Change of delta 10°
    
Change_d10.setpoint = Data_d10(1).crio_dataservo1setpointAI313.Data * -0.068965517241379 + 98.965517241379300;
    
g = gradient(Change_d10.setpoint);
      
triggerp = find(g>=max(g));
Change_d10.setpoint = Change_d10.setpoint(triggerp(1):end); 
    
N = length(Change_d10.setpoint);
t = (0:N-1)/Fs;

Change_d10.beta.servo1 = filtfilt(b1,a1,Data_d10(1).crio_dataservopos1AI30.Data(triggerp(1):end) * servos.acp1.m + servos.acp1.n);
Change_d10.beta.servo2 = filtfilt(b1,a1,Data_d10(1).crio_dataservopos2AI31.Data(triggerp(1):end) * servos.acp2.m + servos.acp2.n);
Change_d10.beta.servo3 = filtfilt(b1,a1,Data_d10(1).crio_dataservopos3AI32.Data(triggerp(1):end) * servos.acp3.m + servos.acp3.n);
Change_d10.moment = filtfilt(b2,a2,Data_d10(1).crio_databendflapblade3DMS02.Data(triggerp(1):end)) *   -8.212171639296294e+05 + -1.973389124055448e+02;

% Plotting
figure

subplot(5,1,1)
hold on
plot(t,Change_d10.setpoint)
plot([0.33 0.33],[0 15],'k--')
plot([0 3],[10 10],'k--')
xlim([0 2])
ylabel('Setpoint [°]')
hold off

subplot(5,1,2)
hold on
plot(t,Change_d10.beta.servo1)
plot([0.33 0.33],[0 15],'k--')
plot([0 3],[10 10],'k--')
xlim([0 2])
ylabel('Servo 1 Response [°]')
hold off

subplot(5,1,3)
hold on
plot(t,Change_d10.beta.servo2)
plot([0.33 0.33],[0 15],'k--')
plot([0 3],[10 10],'k--')
xlim([0 2])
ylabel('Servo 2 Response [°]')
hold off

subplot(5,1,4)
hold on
plot(t,Change_d10.beta.servo3)
plot([0.33 0.33],[0 15],'k--')
plot([0 3],[10 10],'k--')
xlim([0 2])
ylabel('Servo 3 Response [°]')
hold off

subplot(5,1,5)
hold on
plot(t,Change_d10.moment)
plot([0.33 0.33],[0 50],'k--')
xlim([0 2])
ylim([40 50])
ylabel('BRBM [Nm]')
xlabel('time [s]')
hold off







end