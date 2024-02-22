function lambda = MPC_attack_fmincon_matrix2_dual(lambda)
% x=lambda 
global N 

options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
problem.options = options;
problem.solver = 'fmincon';

problem.x0 = lambda;
% problem.lb = -Inf(7*(N-1)+6,1);
% problem.ub = Inf(7*(N-1)+6,1);

problem.objective = @power_track_obj_attack_matrix2_dual;
problem.nonlcon = @power_track_constraints_attack_matrix2_dual;

lambda = fmincon(problem);
end

