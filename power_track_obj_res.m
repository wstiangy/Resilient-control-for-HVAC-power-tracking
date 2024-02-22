function f = power_track_obj_res(x)
% x = [msa1;...;msaN;
%      lambda1;...;lambdaN]
% refere to weekly report 01/05/2023
global N Pref_temp dist_temp msa_temp
global a0 a1 a2 a3 a4 a5 a6
global  Tub Tlb e r sigma Tr_nominal Tsa_nominal msa_lb msa_ub
global A_prime_prime B_prime_prime c_prime_prime

% construct matrics
a0_temp = a0*dist_temp(:,1:end-1);
B = [a0_temp;a0_temp.^2;zeros(3,N-1)];
C = [1 0 0 0 0;
    -1 0 0 0 0];
D = [-Tub;Tlb];
% B'
B_prime = reshape(B,[5*(N-1),1]);
% D'
D0 = [-Tr_nominal-e;
      Tr_nominal-e;
      -Tsa_nominal-r;
      Tsa_nominal-r;
      -(Tr_nominal-e)^2-sigma^2;
      -(Tsa_nominal-r)^2-sigma^2;];
D_prime = [D0; repmat(D,[N-1,1])];
% A'
A_prime = [zeros(5*(N-1),5) -eye(5*(N-1))];
for i=1:N-1
    A = [a1+a2*x(i), 0, a3*x(i), 0, 0;
         2*a0_temp(i)*(a1+a2*x(i)), (a1+a2*x(i))^2, 2*a0_temp(i)*a3*x(i), a3^2*x(i)^2, 2*(a1+a2*x(i))*a3*x(i);
         0, 0, 1, 0, 0;
         0, 0, 0, 1, 0;
         0, 0, a0_temp(i), a3*x(i), a1+a2*x(i)];
    A_prime((i-1)*5+1:i*5,(i-1)*5+1:i*5) = A;
end
% C'
C_prime_temp1 = [1 0 0 0 0;
                -1 0 0 0 0;
                 0 0 1 0 0;
                 0 0 -1 0 0;
                 0 1 0 0 0;
                 0 0 0 1 0];
cell_temp = repmat({C}, 1, N-1);
C_prime_temp2 = blkdiag(cell_temp{:});
clear cell_temp
C_prime = [C_prime_temp1 zeros(size(C_prime_temp1,1),size(C_prime_temp2,2));
           zeros(size(C_prime_temp2,1),size(C_prime_temp1,2)) C_prime_temp2];
% c'
c_prime=[];
for i=1:N
    c = [2*a4*a5*x(i)^2-2*a5*Pref_temp(i)*x(i); a5^2*x(i)^2; 
         2*a4*a6*x(i)^2-2*a6*Pref_temp(i)*x(i); a6^2*x(i)^2; 2*a5*a6*x(i)^2];
    c_prime = [c_prime;c];
end
c_prime_prime = [c_prime;zeros(2*(N-1)+6,1)];
% double prime matrics
A_prime_prime = [A_prime zeros(5*(N-1),2*(N-1)+6);
                 C_prime eye(2*(N-1)+6)];
B_prime_prime = [B_prime;D_prime];

f = B_prime_prime.'*x(N+1:end) + repmat(a4^2,[1,N])*x(1:N).^2  - 2*a4*Pref_temp*x(1:N) + Pref_temp*Pref_temp.';
end

