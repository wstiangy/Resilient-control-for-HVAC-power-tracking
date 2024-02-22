function [c,ceq] = power_track_constraints_res(x)
% x = [msa1;...;msaN;
%      lambda1;...;lambdaN]
% refere to weekly report 01/05/2023
global N A_prime_prime B_prime_prime c_prime_prime

% construct matrics
%{
a0_temp = a0*dist_temp(:,1:end-1);
B = [a0_temp;a0_temp.^2;zeros(3,N-1)];
C = [1 0 0 0 0;
     1 0 0 0 0;
     0 0 1 0 0;
    -1 0 0 0 0;
    -1 0 0 0 0;
     0 0 -1 0 0];
D = [Tub;Tr_nominal+e;Tsa_nominal+r;-Tlb;e-Tr_nominal;r-Tsa_nominal];
% B'
B_prime = [reshape(B,[5*(N-1),1]);repmat(D,[N,1])];
% A'
A_prime = zeros(11*N-5,11*N);
cell_temp = repmat({C}, 1, N);
A_prime(5*(N-1)+1:end,1:5*N) = blkdiag(cell_temp{:});
clear cell_temp
A_prime(5*(N-1)+1:end,5*N+1:end) = eye(6*N);
for i=1:N-1
    A = [a1+a2*x(i), 0, a3*x(i), 0, 0;
         2*a0_temp(i)*(a1+a2*x(i)), (a1+a2*x(i))^2, 2*a0_temp(i)*a3*x(i), a3^2*x(i)^2, 2*(a1+a2*x(i))*a3*x(i);
         0, 0, 1, 0, 0;
         0, 0, 0, 1, 0;
         0, 0, a0_temp(i), a3*x(i), a1+a2*x(i)];
    A_prime((i-1)*5+1:i*5,(i-1)*5+1:i*5) = A;
    A_prime((i-1)*5+1:i*5,i*5+1:(i+1)*5) = -eye(5);
end
% c'
c_prime=[];
for i=1:N
    c = [2*a4*a5*x(i)^2-2*a5*Pref_temp(i)*x(i); a5^2*x(i)^2; 
          2*a4*a6*x(i)^2-2*a6*Pref_temp(i)*x(i); a6^2*x(i)^2; 2*a5*a6*x(i)^2];
    c_prime = [c_prime;c];
end
c_prime = [c_prime;zeros(6*N,1)];
%}

c = [A_prime_prime.'*x(N+1:end)+c_prime_prime];

ceq = [];

end
