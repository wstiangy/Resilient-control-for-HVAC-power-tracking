function msa = MPC_res_fmincon(lambda)
% x = [x1;x2;...;xN]
% x_t=[E[Tr]; E[Tr^2]; E[Tsa]; E[Tsa^2]; E[TrTsa]]  
global N 

options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
problem.options = options;
problem.solver = 'fmincon';

problem.x0 = [ones(N,1)*16;lambda];
% problem.lb = [ones(N,1);ones(7*(N-1)+6,1)*0];
% problem.ub = [ones(N,1)*40;ones(7*(N-1)+6,1)*9e9];

problem.objective = @power_track_obj_res;
problem.nonlcon = @power_track_constraints_res;

x = fmincon(problem);

msa = x(1);

end

