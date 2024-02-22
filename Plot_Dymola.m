clear all
close all
clc

load('OneAHU_standardMPC.mat')
data_MPCbase = data;
load('OneAHU_resilientMPC.mat')
data_MPCres = data;


figure
subplot(2,1,1)
hold on
plot((data_MPCbase(:,1)-data_MPCbase(1,1))/(60*60),data_MPCbase(:,4)-0.25,'LineWidth',2)
plot((data_MPCres(:,1)-data_MPCres(1,1))/(60*60),data_MPCres(:,4)-0.25,'LineWidth',2)
% plot((T_ref(:,1)-T_ref(1,1))/(60*60),T_ref(:,2)-273.15,'LineWidth',2)
xlim([8 19])
ylim([21 25])
xlabel('Time (h)')
ylabel('Zone Temperature (^oC)')
legend('Standard MPC under attack','Resilient MPC under attack')
grid
subplot(2,1,2)
hold on
plot((data_MPCbase(:,1)-data_MPCbase(1,1))/(60*60),data_MPCbase(:,3)/1000*1.1,'LineWidth',2)
plot((data_MPCres(:,1)-data_MPCres(1,1))/(60*60),data_MPCres(:,3)/1000*1.1,'LineWidth',2)
plot((data_MPCres(:,1)-data_MPCres(1,1))/(60*60),data_MPCres(:,2)/1000,'LineWidth',2)
xlim([8 19])
ylim([20 60])
xlabel('Time (h)')
ylabel('HVAC Power (kW)')
legend('Regular MPC under attack','Resilient MPC under attack','Target power')
grid

index = (data_MPCres(:,1)-data_MPCres(1,1))/(60*60);
% index = unique(index);
index_start = find(index==8);
index_end = find(index==19);

P_ref_daytime = data_MPCres(index_start(1):index_end(1),2)/1000;
P_MPCbase_daytime = data_MPCbase(index_start(1):index_end(1),3)/1000;
P_MPCres_daytime = data_MPCres(index_start(1):index_end(1),3)/1000;
RMSE1 = sqrt(mean((P_ref_daytime-P_MPCbase_daytime*1.1).^2))
RMSE2 = sqrt(mean((P_ref_daytime-P_MPCres_daytime*1.1).^2))


figure
hold on
plot((T_PI_daytime(:,1)-P_MPC(1,1))/(60*60),T_PI_daytime(:,2)/1000,'LineWidth',2)
plot((T_MPC_daytime(:,1)-P_MPCres(1,1))/(60*60),T_MPC_daytime(:,2)/1000,'LineWidth',2)
plot((P_PI(:,1)-P_PI(1,1))/(60*60),P_PI(:,2)/1000,'LineWidth',2)
xlim([8 19])
ylim([0 100])
xlabel('Time (h)')
ylabel('HVAC Power (kW)')
legend('Regular MPC under attack','Resilient MPC under attack','Target power')
grid




