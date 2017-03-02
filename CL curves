clear
close all
clc

%%

Data = importfile2('Delta One.csv', 4, 64);


%%
beta = [1 7 -9 -10 -5 3 -3 9 10 5 -7 -4 4 -8 0 -1 -6 8 2 -2 6];
betal = {'-10°' '-9°' '-8°' '-7°' '-6°' '-5°' '-4°' '-3°' '-2°' '-1°' '0°' '1°' '2°'...
     '3°' '4°' '5°' '6°' '7°' '8°' '9°' '10°'};



l = ones(61,21);
h = 0;
for i= 1:size(Data,1)
    B(i,:) = l(i,:).* beta;
end
h = 0;

for i=1:2:size(Data,2)-1
    h = 1 + h;
    Alpha(:,h) = Data(:,i);
    CL(:,h) = Data(:,i+1);
end
h = 0;



Alpha = Alpha(:);        
CL = CL(:);        
B = B(:);        

D = [Alpha B CL];
        
[values, order] = sort(D(:,2));
D_sorted = D(order,:);
c = 0;
figure
hold on
grid on
xlabel('AOA')
ylabel('CL')
for i=1:61:size(D_sorted,1)-61
   plot(D_sorted(i:i+60,1),D_sorted(i:i+60,3),'color',rand(1,3))
c = c+1;
end
legend(betal,'location','southeast')
hold off



a = Data(1:end,1);
c = 0;
for i=1:61:size(D,1)-61
    c = c+1;
    Da(:,c) = D_sorted(i:i+60,3) - D_sorted(611:671,3);
    
end


figure
hold on
grid on
xlabel('beta')
ylabel('\Delta CL')

l = -10:9;
b_cell = {'-10°' '-9°' '-8°' '-7°' '-6°' '-5°' '-4°' '-3°' '-2°' '-1°' '0°' '1°' '2°'...
     '3°' '4°' '5°' '6°' '7°' '8°' '9°'};
for i=1:size(Da,1)
    b(i,:) = l;
    plot(b(i,:), Da(i,:),'color',rand(1,3))
end
legend(b_cell,'location','southeast')







