
x1 = All_d10.input;
x2 = Data_d2(2).input(10000:end);
x3 = normalize(Data_d5(7).input(10000:end));
xn = normalize(x1);
yn = normalize(y1);

y1 = All_d10.output;
y2 = normalize(Data_d2(2).filtered(10000:end));
y3 = normalize(Data_d5(7).filtered(10000:end));

inputs = num2cell(xn');
targets = num2cell(yn');

inputs2 = num2cell(x3');
targets2 = num2cell(y3');

numberHidden = {16};
net = narxnet(1:2,1:2,16);
[Xs,Xi,Ai,Ts] = preparets(net,inputs,{},targets);
TF = {'tansig','purelin'};
net.divideFcn = 'divideblock';


[net,tr] = train(net,Xs,Ts,Xi,Ai);
view(net)

net2 = closeloop(net);
view(net2)
[Xs,Xi,Ai,Ts] = preparets(net,inputs2,{},targets2);

Y = net(Xs,Xi,Ai);
plotresponse(Ts,Y)

