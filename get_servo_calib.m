function servos = get_servo_calib(force_new_calibration,return_folder)
%% function returns linear functions for Servo Setpoint and Actual Servo Position


return_invers = 1;
plot_beta     = 0;
% data estimated from sin functions
% beta        = [-10;10];
% setpoint1   = [1233;1526]; 
% actu_pos1   = [-2.02;-1.6];
% 
% setpoint2   = [1805;1536]; 
% actu_pos2   = [-2.036;-1.791];
% 
% setpoint3   = [1348;1564]; 
% actu_pos3   = [-1.91;-1.52];

%% Following Data from Adrianos Stepchanges:

% beta1       = [-10;10];
% setpoint1   = [1508;1215]; 
% actu_pos1   = [-1.627977708;-2.074079878];
% 
% beta2       = [-10;7];
% setpoint2   = [1566;1796]; 
% actu_pos2   = [-1.77745981;-2.121961023];
% 
% beta3       = beta1;
% setpoint3   = [1553;1444]; 
% actu_pos3   = [-1.532506564;-1.958969116];

%% Campaign 8

beta1       = [-10;10];
setpoint1   = [1580;1290]; 
actu_pos1   = [1.523;1.962];

beta2       = [-10;8];
setpoint2   = [1518;1253]; 
actu_pos2   = [1.64;2.06];

beta3       = beta1;
setpoint3   = [1599;1290]; 
actu_pos3   = [1.52;1.87];
poti_pos3   = [4.787;5.2245];







%% Setpoints:

[servos.sp1.m,servos.sp1.n] = linear_fit(beta1,setpoint1,return_invers,plot_beta);
[servos.sp2.m,servos.sp2.n] = linear_fit(beta2,setpoint2,return_invers,plot_beta);
[servos.sp3.m,servos.sp3.n] = linear_fit(beta3,setpoint3,return_invers,plot_beta);


%% Beta
[servos.acp1.m,servos.acp1.n] = linear_fit(beta1,actu_pos1,return_invers,plot_beta);
[servos.acp2.m,servos.acp2.n] = linear_fit(beta2,actu_pos2,return_invers,plot_beta);
[servos.acp3.m,servos.acp3.n] = linear_fit(beta3,actu_pos3,return_invers,plot_beta);
[servos.poti3.m,servos.poti3.n] = linear_fit(beta3,poti_pos3,return_invers,plot_beta);



return
end