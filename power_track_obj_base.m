function f = power_track_obj_base(x)
% x=[msa;P;Tr]
global N Pref_temp
f = (x(N+1:2*N)'-Pref_temp)*(x(N+1:2*N)-Pref_temp');
end

