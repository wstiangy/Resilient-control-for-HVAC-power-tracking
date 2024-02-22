% this script aims to validate the altered distribution of Tr and Tsa can
% compromize the power tracking in a stealthy way
clear all
% close all
clc

% initialization
global a0 a1 a2 a3 a4 a5 a6
global N Tr_init Tsa_temp dist_temp Pref_temp msa_temp
global Tub Tlb e r sigma Tr_nominal Tsa_nominal msa_lb msa_ub 
for i=1:1
    a0 = [0.0018 2.0611e-07 2.4255e-07];
    a1 = 0.9982;
    a2 = -2.4608e-04;
    a3 = 2.4608e-04;
    c_air=1014.54;
    COP = 4.17;
    beta = 0.3;
end
load('Two_Day_inputs_30s.mat')
dist = disturbance_all;
N = 10;
T = size(dist,2);
Tr = ones(1,T)*24;
Tub = 25;
Tlb = 23;
P = zeros(1,T);
msa = ones(1,T)*17.815;
Tsa = ones(1,T)*14;
err_i = 0;
Tr_att = Tr;
Tsa_att = Tsa;
e = 0.3;
r = 0.2;
sigma = r;
Tr_nominal = 24;
Tr_set = 24;
Tsa_nominal = 14;
msa_lb = 1;
msa_ub = 40;
% time-domain simualtion
rng(999)
load('result_MPC_base.mat')
Tr_att_static = Tr_att;
Tsa_att_static = Tsa_att;
% con_type = 'PI';
con_type = 'MPC_base'; 
% con_type = 'MPC_res';
% T=100;

%Pref = ones(1,T)*5.5e4;
load('Reference_power.mat')
% Pref = Pref_nominal;
% Pref = Pref_regulated;
Pref = Pref_regulated3;% step function profile
for t = 120*7:120*20-9
    % evaluate HVAC power
    a4 = beta*c_air*dist(1,t)/COP;
    a5 = (1-beta)*c_air/COP;
    a6 = -c_air/COP;
    P(t) = a4*msa(t) + a5*Tr(t)*msa(t) + a6*Tsa(t)*msa(t);
    
    %% HVAC control
    Tr_init = Tr(t);
    Tsa_temp = Tsa(t:t+9);
    dist_temp = dist(:,t:t+9);
    Pref_temp = Pref(t:t+9);
    Tr_nominal = Tr(t);
    Tsa_nominal = Tsa(t);
    Tr_att(t) = Tr(t);
    Tsa_att(t) = Tsa(t);
    % Sensor attack
    msa_temp = MPC_base_fmincon;
    [E_Tr0,Var_Tr0,E_Tsa,Var_Tsa,lambda_temp] = MPC_attack_fmincon_matrix2;
    lambda1(:,t) = lambda_temp;
    Tr_att(t) = normrnd(E_Tr0,sigma^2,[1,1]);
    Tsa_att(t) = normrnd(E_Tsa,sigma^2,[1,1]);

        
    % PI control
    if t>1
        err_i = err_i + Tr(t-1) - Tr_set;
    end
    if strcmp(con_type,'PI')
        msa(t+1) = 1*(Tr(t) - Tr_set) + 0.3*err_i;
    end
    
    % MPC control
    Tr_init = Tr_att(t);
    Tsa_temp = Tsa_att(t)*ones(1,N);
%     Tr_init = Tr(t);
%     Tsa_temp = Tsa(t:t+9);

    % Base MPC control
    if strcmp(con_type,'MPC_base')
        sol_temp = MPC_base_fmincon;
        msa(t+1) = sol_temp(1);
    end
    
    % Resilient Control
    t_start = tic;
    if strcmp(con_type,'MPC_res')
        lambda2 = MPC_attack_fmincon_matrix2_dual(lambda1(:,t));% initialize dual variables
        msa(t+1) = MPC_res_fmincon(lambda2);
    end
    t_record(:,t) = toc(t_start);
    %% update zone temperature
    Tr(t+1) = a1*Tr(t) + a2*msa(t)*Tr(t) + a3*msa(t)*Tsa(t) + a0*dist(:,t);
end
RMSE = sqrt(mean((P(120*8:120*19)/1000-Pref(120*8:120*19)/1000).^2))
save(['result_' con_type '_regulated3_edot3_rdot2'])
% save(['result_' con_type '_regulated3_no_att'])

t_serise = (0.5:0.5:0.5*(t-1))/60;
t_serise = 0.5/60:0.5/60:19;
figure
subplot(3,1,1)
hold on
plot(t_serise,Tr(1:120*19),'LineWidth',2)
plot(t_serise,Tr_att(1:120*19),'LineWidth',2)
xlim([8 19])
% legend('True value','Falsified value')
ylabel('Zone Temperature (^oC)')
xlabel('Time (h)')
ylim([21 25])
grid
subplot(3,1,2)
hold on
plot(t_serise,Tsa(1:120*19),'--r','LineWidth',2)
plot(t_serise,Tsa_att(1:120*19),'LineWidth',2)
xlim([8 19])
legend('True value','Falsified value')
ylabel('Supply Air Temperature (^oC)')
ylim([14-3*0.3 14+3*0.3])
grid
subplot(3,1,3)
hold on
plot(t_serise,P(1:120*19)/1000,'LineWidth',2)
plot(t_serise,Pref_regulated3(1:120*19)/1000,'--r','LineWidth',2)
xlim([8 19])
ylim([20 60])
legend('HVAC Power','Target Power')
ylabel('HVAC Power (kW)')
xlabel('Time (h)')
grid

t_serise = 0.5/60:0.5/60:24;
figure
subplot(2,1,1)
hold on
plot(t_serise,dist(1,1:120*24),'LineWidth',2)
xlim([0 24])
xlabel('Time (h)')
ylabel('Outside Air Temperature (^oC)')
subplot(2,1,2)
hold on
plot(t_serise,dist(2,1:size(t_serise,2)),'LineWidth',2)
xlim([0 24])
xlabel('Time (h)')
ylabel('Solar Irradiance (J/m^2)')


Pref_regulated3 = Pref_nominal;
for i = 1:length(Pref_regulated3)/30
    Pref_regulated3(30*(i-1)+1:30*i) = ones(1,30)*Pref_nominal(30*(i-1)+15);
end

Pref_regulated3(1:1000) = 30000;
Pref_regulated3(1001:1200) = 30000:5000/(200-1):35000;
Pref_regulated3(1201:1400) = 35000:7000/(200-1):42000;
Pref_regulated3(1401:1600) = 42000:-2000/(200-1):40000;
Pref_regulated3(1601:1800) = 40000:14000/(200-1):54000;
Pref_regulated3(1801:2000) = 54000:1000/(200-1):55000;
Pref_regulated3(2001:2200) = 55000:-10000/(200-1):45000;
Pref_regulated3(2201:2400) = 45000:-10000/(200-1):35000;

x = [800:2700];
y = Pref_regulated3(800:2700);
p = polyfit(x,y,20);
xx = 800:2400;
yy = polyval(p,xx);

for i = 1:length(Pref_regulated3)/30
    Pref_regulated3(30*(i-1)+1:30*i) = ones(1,30)*Pref_regulated3(30*(i-1)+15);
end





