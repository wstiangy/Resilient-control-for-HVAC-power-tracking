
load('result_PI_24C.mat')
load('Reference_power.mat')


t_serise = 0.5/60:0.5/60:19;
figure
subplot(2,1,1)
hold on
plot(t_serise,Tr(1:120*19),'LineWidth',2)
% plot(t_serise,Tr_att(1:120*19),'LineWidth',2)
xlim([8 19])
% legend('True value','Falsified value')
ylabel('Zone Temperature (^oC)')
xlabel('Time (h)')
ylim([21 25])
grid
subplot(2,1,2)
hold on
% plot(t_serise,P(1:120*19)/1000*1.1,'LineWidth',2)
% plot(t_serise,P(1:120*19)/1000*0.9,'LineWidth',2)
x2 = [t_serise, fliplr(t_serise)];
inBetween = [P(1:120*19)/1000*1.15, fliplr(P(1:120*19)/1000*0.85)];
fill(x2, inBetween, 'g','FaceAlpha',0.3,'EdgeColor','none');
plot(t_serise,Pref_regulated3(1:120*19)/1000,'--k','LineWidth',2)
plot(t_serise,P(1:120*19)/1000,'LineWidth',2)
xlim([8 19])
ylim([20 60])
legend('Flexibility region','Target power','HVAC power-PI control')
ylabel('HVAC Power (kW)')
xlabel('Time (h)')
grid