function [c,ceq] = power_track_constraints_attack_matrix2(x)
% x=[E[Tr]; E[Tr^2]; E[Tsa]; E[Tsa^2]; E[TrTsa]]  
global A_prime_prime B_prime_prime

% constraints
ceq = [A_prime_prime*x+B_prime_prime];
c = [];


end
