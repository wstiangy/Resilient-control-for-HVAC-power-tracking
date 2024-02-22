function [c,ceq] = power_track_constraints_base(x)
% x=[msa;P;Tr]
global a0 a1 a2 a3 a4 a5 a6
global N Tr_init Tsa_temp dist_temp

c = [];
for t=1:N
    c = [c; x(2*N+t+1) - 24.5];
    c = [c; 23.5 - x(2*N+t+1)];
end

ceq = [x(2*N+1) - Tr_init];
for t = 1:N
    ceq = [ceq; a4*x(t) + a5*x(t)*x(2*N+t) + a6*x(t)*Tsa_temp(t) - x(N+t)];
    ceq = [ceq; a1*x(2*N+t) + a2*x(t)*x(2*N+t) + a3*x(t)*Tsa_temp(t) + a0*dist_temp(:,t) - x(2*N+t+1)];
end

end
