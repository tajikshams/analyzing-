clear;
clc;

load Lat23_1Long59_2
load Thrust
load Power

global Thrust_i;
global V_i;
global Vdot_i;

disp('Please wait ...');

for i=1:length(Data)
    Data(i,5)=sqrt(Data(i,3)^2+Data(i,4)^2);
end

for i=length(Data):-1:1
    if (Data(i,5)<2) || (Data(i,5)>21.6)
        Data(i,:)=[];
    else
        for j=1:length(Power)
            if abs(Data(i,5)-Power(j,1))<=0.05
                Data(i,6)=Power(j,2);
                Data(i,7)=Thrust(j,2);
                break;
            end
        end
    end
end

for i=1:length(Data)
  Za(i)=Data(i,1)/2;
  W(i)=2*pi/Data(i,2);
  Landa(i)=61.6/(W(i)^2);
  k(i)=2*pi/Landa(i);
  V(i)=Za(i)*W(i)*exp(k(i)*Za(i));
  Vdot(i)=Za(i)*W(i)^2*exp(k(i)*Za(i));
  
  Data(i,8)=V(i);
  Data(i,9)=Vdot(i);  
end

for i=1:length(Data)
        
    Thrust_i=Data(i,7);
    V_i=Data(i,8);
    Vdot_i=Data(i,9);

    t=[0:0.01:10];
    [t,Disp]=ode45(@Base,t,[0 0 0 0]);
    U=abs(Disp(:,3));
    u(i)=max(U);
end

Data(:,10)=u;

plot(Data(:,10),Data(:,6),'bo');
xlabel('Displacement');
ylabel('Power');
hold on;

Max_Power=max(Data(:,6));
Min_Disp=min(Data(:,10));

for i=length(Data):-1:1
    if (Data(i,6)>0.50*Max_Power)&&(Data(i,10)<2*Min_Disp)
        plot(Data(i,10),Data(i,6),'ro');
    end
end

clearvars -except Data

save Lat23_1Long59_2
clc;