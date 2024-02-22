clear all
close all
clc

load('result_MPC_base_regulated3.mat')
T_sa = Tsa_att(1:120*19);
T_oa = dist(1,1:120*19);
T_ra = Tr_att(1:120*19);
T_ma = 0.7*T_ra + 0.3*T_oa;
t_serise = 0.5/60:0.5/60:19;

figure
hold on
plot(t_serise(1),T_oa(1) - T_sa(1),'bo','MarkerSize',10,'LineWidth',2)
plot(t_serise(1),T_oa(1) - T_ma(1),'rx','MarkerSize',10,'LineWidth',2)
plot(t_serise(1),T_ma(1) - T_sa(1),'msquare','MarkerSize',10,'LineWidth',2)
plot(t_serise(1),T_ra(1) - T_sa(1),'kdiamond','MarkerSize',10,'LineWidth',2)
plot(t_serise(1),T_oa(1) - T_ra(1),'g^','MarkerSize',10,'LineWidth',2)
legend('Rule 8','Rule 10','Rule 11&16','Rule 12&17','Rule 18')
plot(t_serise,T_oa - T_sa,'b','LineWidth',2)
plot(t_serise,T_oa - T_ma,'r','LineWidth',2)
plot(t_serise,T_ma - T_sa,'m','LineWidth',2)
plot(t_serise,T_ra - T_sa,'k','LineWidth',2)
plot(t_serise,T_oa - T_ra,'g','LineWidth',2)
xlim([8 19])
ylabel('APAR Safe Margins')
xlabel('Time (h)')
grid
for i = 8:19
    plot(t_serise(120*i),T_oa(120*i) - T_sa(120*i),'bo','MarkerSize',10,'LineWidth',2)    
    plot(t_serise(120*i),T_oa(120*i) - T_ma(120*i),'rx','MarkerSize',10,'LineWidth',2)
    plot(t_serise(120*i),T_ma(120*i) - T_sa(120*i),'msquare','MarkerSize',10,'LineWidth',2)
    plot(t_serise(120*i),T_ra(120*i) - T_sa(120*i),'kdiamond','MarkerSize',10,'LineWidth',2)
    plot(t_serise(120*i),T_oa(120*i) - T_ra(120*i),'g^','MarkerSize',10,'LineWidth',2)
end
