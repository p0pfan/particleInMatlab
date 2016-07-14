clear;
clc;
q=10;
V=1000;
Hr=-27000;
p=0.001;
Cp=1;
U=5*10^(-4);
Ar=10;
Tc=3.4;
k0=7.86*10^12;
Ea=14090;
T0=3.5;
C0=7.5;
Cr=10^(-6);
Tr=100;
C(1)=0.1531;
T(1)=4.6091;
dt=1;

Time=100;
ParticleNum=1000;

x_N = 0.00001; % the cov of process noise
x_N_1=0.00001;


x_R = [0.001 0
           0 0.001]; % cov of measurement
x_R_1=0.001;
% covirance of initial distribution
Var=[2 0 
     0  2];

x_P = zeros(2,ParticleNum); % particle
x=zeros(2,Time);
x_out=zeros(2,Time);
x_est=zeros(2,Time);
x_est_out=zeros(2,Time);



x(:,1)=[C(1),T(1)]' ;
%use Gaussian distribution generate initial particle;
for i = 1:ParticleNum
    x_P(:,i) =x(:,1) + sqrt(Var) * [randn,randn]';
end


% 
z_out(:,1) = x(:,1)+sqrt(x_R)*[randn randn]' ; %get actual measurement
x_out(:,1) = x(:,1);  %the actual output vector for measurement values.
x_est(:,1) = x(:,1); % time by time output of the particle filters estimate
x_est_out(:,1) = x_est(:,1); % the vector of particle filter estimates.

test=zeros(2,Time);
test_error=zeros(1,Time);
no_error=zeros(2,Time);
z_error=zeros(2,Time);
x_no=zeros(2,Time);
x_no(:,1)=x(:,1);
no_error(:,1)=x(:,1);
test(:,1)=x(:,1);
z_error(:,1)=x(:,1);
est_error=zeros(2,Time);

for t = 2:Time
    
    k=k0*exp(-Ea/(x(2,t-1)*Tr));
    
    k_no=k0*exp(-Ea/(x_no(2,t-1)*Tr));
    
    process_error1=sqrt(x_N_1)*randn;
    process_error2=sqrt(x_N_1)*randn;
    
    x(1,t)=x(1,t-1)+dt*(  q/V*(C0-x(1,t-1))-k*x(1,t-1)    )+process_error1;
    x(2,t)=x(2,t-1)+dt*(   q/V*(T0-x(2,t-1))-Hr*Cr*k*x(1,t-1) /(p*Cp*Tr)-U*Ar*(x(2,t-1)-Tc)/(p*Cp*V)   )+process_error2;
    
    x_no(1,t)=x_no(1,t-1)+dt*(  q/V*(C0-x_no(1,t-1))-k_no*x_no(1,t-1)    );
    x_no(2,t)=x_no(2,t-1)+dt*(   q/V*(T0-x_no(2,t-1))-Hr*Cr*k_no*x_no(1,t-1) /(p*Cp*Tr)-U*Ar*(x_no(2,t-1)-Tc)/(p*Cp*V)   );
    
%     x(1,1)=x(1,1)+dt*(  q/V*(C0-x(1,1))-k*x(1,1)    )+tt;
%     x(2,1)=x(2,1)+dt*(   q/V*(T0-x(2,1))-Hr*Cr*k*x(1,1) /(p*Cp*Tr)-U*Ar*(x(2,1)-Tc)/(p*Cp*V)   )+sqrt(x_N_1)*randn;
    no_error(1,t)=x_no(1,t);
    no_error(2,t)=x_no(2,t);
    test(1,t)=x(1,t);
    test(2,t)=x(2,t);
    z_out(:,t)=x(:,t)+sqrt(x_R)*[randn randn]';
    z_error(:,t)=z_out(:,t);
    
    
     for i = 1:ParticleNum
        k_particle=k0*exp(-Ea/(x_P(2,i)*Tr));
        x_P_update1(i) = x_P(1,i)+dt*(  q/V*(C0-x_P(1,i))-k*x_P(1,i)    )+sqrt(x_N_1)*randn;
         x_P_update2(i)=x_P(2,i)+dt*(   q/V*(T0-x_P(2,i))-Hr*Cr*k*x_P(1,i) /(p*Cp*Tr)-U*Ar*(x_P(2,i)-Tc)/(p*Cp*V)   )+sqrt(x_N_1)*randn;;
        z_update1(i) = x_P_update1(i);
          z_update2(i) = x_P_update2(i);
        P_w1(i) = (1/sqrt(2*pi*x_R_1)) * exp(-(z_out(1,t) - z_update1(i))^2/(2*x_R_1));
         P_w2(i) = (1/sqrt(2*pi*x_R_1)) * exp(-(z_out(2,t) - z_update2(i))^2/(2*x_R_1));
     end
    P_w1 = P_w1./sum(P_w1);
    P_w2 = P_w2./sum(P_w2);
    for i = 1 : ParticleNum
        x_P(1,i) = x_P_update1(find(rand <= cumsum(P_w1),1));   
         x_P(2,i) = x_P_update2(find(rand <= cumsum(P_w2),1)); 
    end  
    
    x_est1 = mean(x_P(1,:));
    x_est2 = mean(x_P(2,:));
    x_est_out(1,t)=x_est1;
     x_est_out(2,t)=x_est2;
     est_error(:,t)=abs(x_est_out(:,t)-no_error(:,t));
end
t=1:Time;
figure(1)
%  ,t,x_est_out(1,1:Time),'.-g'
plot(t,  test(1,1:Time), '.-b', t, no_error(1,1:Time),'-r',t, z_error(1,1:Time)',t,x_est_out(1,1:Time),'.-g');
figure(2)
plot(t,  test(2,1:Time), '.-b', t, no_error(2,1:Time),'-r',t, z_error(2,1:Time)',t,x_est_out(2,1:Time),'.-g');
figure(3)
plot(t,  est_error(1,1:Time), '.-b');
% , t, x_est_out, '-.r',  t, test(2,1:Time),'-y