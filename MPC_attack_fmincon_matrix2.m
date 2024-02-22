function [E_Tr0,std_Tr0,E_Tsa,std_Tsa,lambda] = MPC_attack_fmincon_matrix2()
% x=[E[Tr0]; E[Tr0^2]; E[Tsa0]; E[Tsa0^2]; E[Tr0Tsa0];
%    E[Tr1]; E[Tr1^2]; E[Tsa1]; E[Tsa1^2]; E[Tr1Tsa1];
%    ...;
%    E[TrN]; E[TrN^2]; E[TsaN]; E[TsaN^2]; E[TrNTsaN];
%    u]  
global N 
global c_prime_prime A_prime_prime B_prime_prime

options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
problem.options = options;
problem.solver = 'fmincon';

problem.x0 = [repmat([24;24^2;14;14^2;24*14],[N,1]);zeros(2*(N-1)+6,1)];
problem.lb = zeros(N*5 + 2*(N-1)+6,1);
problem.ub = ones(N*5 + 2*(N-1)+6,1)*9e9;

problem.objective = @power_track_obj_attack_matrix2;
problem.nonlcon = @power_track_constraints_attack_matrix2;

x = fmincon(problem);

E_Tr0 = x(1);
std_Tr0 = x(2)-x(1)^2;
E_Tsa = x(3);
std_Tsa = x(4)-x(3)^2;

lambda = -pinv(A_prime_prime.')*c_prime_prime;
obj_dual = B_prime_prime.'*lambda

end

