function [c,ceq] = power_track_constraints_attack_matrix2_dual(x)
% x=lambda 
global c_prime_prime A_prime_prime B_prime_prime

% constraints
ceq = [];
c = [A_prime_prime.'*x+c_prime_prime];


end
