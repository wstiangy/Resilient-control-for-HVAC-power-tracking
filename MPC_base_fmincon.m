function msa = MPC_base_fmincon()
% x=[msa;P;Tr]
global N Tr_init

options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
problem.options = options;
problem.solver = 'fmincon';

problem.x0 = [ones(N,1)*16;zeros(N,1);ones(N+1,1)*Tr_init];
problem.lb = [ones(N,1);ones(2*N+1,1)*-9e9];
problem.ub = [ones(N,1)*40;ones(2*N+1,1)*9e9];

problem.objective = @power_track_obj_base;
problem.nonlcon = @power_track_constraints_base;

x = fmincon(problem);

msa = x(1:N);

end

