function [finalsolns, globals, solns1, solns2, solns3, solns4, solns5] = particleswarm(parts)

tic;

%Upper and lower bounds

%                    Activation                                   Inactivation
%      Vh_m  k_m   Amp_m   Vmax_m   sigma_m       Vh_n  k_n   amp_n   Vmax_n   sigma_n    Gmax_Kv7    p_m  p_n
UB = [  -35.2 8.9     10    -166      190          -55    7.5     10     -16.6       9.1         90        3    1];
LB = [  -35.2 6.9    0.1    -306       30          -53    3.5    0.1     -36.6       5.1         30        3    1];

Parsna = [-35.2 7.9 1 -286 160 -62 5.5 1 -26.6 7.1 3 1 60];

%Load in experimental data

load('mockna.mat');
%IK = IK(:,1:10);

%Initialise matrices

iters = 5;                                 %iterations
solns = zeros(parts,14);
solns(:,1:13) = rand(parts,13);
v = zeros(parts,13);
omega = 0.2;                                %Inertia
psi1 = 0.3;                                 %global weighting
psi2 = 0.2;                                 %personal weighting
globals = zeros(1,iters);

%Generate initial solution particles

solns(:,1) = solns(:,1).*(UB(1)-LB(1))+LB(1);
solns(:,2) = solns(:,2).*(UB(2)-LB(2))+LB(2);
solns(:,3) = solns(:,3).*(UB(3)-LB(3))+LB(3);
solns(:,4) = solns(:,4).*(UB(4)-LB(4))+LB(4);
solns(:,5) = solns(:,5).*(UB(5)-LB(5))+LB(5);
solns(:,6) = solns(:,6).*(UB(6)-LB(6))+LB(6);
solns(:,7) = solns(:,7).*(UB(7)-LB(7))+LB(7);
solns(:,8) = solns(:,8).*(UB(8)-LB(8))+LB(8);
solns(:,9) = solns(:,9).*(UB(9)-LB(9))+LB(9);
solns(:,10) = solns(:,10).*(UB(10)-LB(10))+LB(10);
solns(:,11) = solns(:,11).*(UB(11)-LB(11))+LB(11);
solns(:,12) = solns(:,12).*(UB(12)-LB(12))+LB(12);
solns(:,13) = solns(:,13).*(UB(13)-LB(13))+LB(13);

%Calculate fitness of initial particles
HP = V(1:10,1);
Vt = V(1:10,2);
t = T;
Ek = 52;
for i=1:parts
    m0 = m_0(solns(i,1:2), HP);
    h0 = h_0(solns(i,6:7), HP);
    [t,m]  = ode23t(@ODEm,t,m0,[],solns(i,1:5), Vt);
    [t,n]  = ode23t(@ODEh,t,h0,[],solns(i,6:10), Vt);
    g   = solns(i,11);
    p   = solns(i,12);
    q   = solns(i,13);
    I = g*(m.^p.*n.^q)'.*((Vt-Ek)*ones(1,length(t)));
    I_intrp = interp1(T,IK(:,1:10),t,'spline');
    Score = norm(abs((I_intrp)'-(I)),2);
    solns(i,14) = Score;
end

%Update global best and personals

best = min(solns(:,14));
bestrow = solns(:,14)==best;
globalbest = solns(bestrow,:);

personals = solns;

%%Particle Swarm Optimisation

for j=1:iters
    
    %calculate velocities
    U1 = rand(parts,13);
    U2 = rand(parts,13);
    
    for n=1:parts
        for m=1:13
            
            v(n,m) = omega*v(n,m) + psi1*U1(n,m)*(globalbest(m)-solns(n,m)) + psi2*U2(n,m)*(personals(n,m)-solns(n,m));
            
        end
    end
     
    %Update particles
    
    solns(:,1:13) = solns(:,1:13) + v(:,1:13);
    
    %Re-calculate fitness
    
    for i=1:parts
            try
                m0 = m_0(solns(i,1:2), HP);
                h0 = h_0(solns(i,6:7), HP);
                [t,m]  = ode23t(@ODEm,t,m0,[],solns(i,1:5), Vt);
                [t,n]  = ode23t(@ODEh,t,h0,[],solns(i,6:10), Vt);
                g   = solns(i,11);
                p   = solns(i,12);
                q   = solns(i,13);
                I = g*(m.^p.*n.^q)'.*((Vt-Ek)*ones(1,length(t)));
                I_intrp = interp1(T,IK(:,1:10),t,'spline');
                Score = norm(abs((I_intrp)'-(I)),2);
                solns(i,14) = Score;
            catch
                %If ODE fails, particle is randomised to create new
                %particle
                solns(i,1) = solns(i,1).*(UB(1)-LB(1))+LB(1);
                solns(i,2) = solns(i,2).*(UB(2)-LB(2))+LB(2);
                solns(i,3) = solns(i,3).*(UB(3)-LB(3))+LB(3);
                solns(i,4) = solns(i,4).*(UB(4)-LB(4))+LB(4);
                solns(i,5) = solns(i,5).*(UB(5)-LB(5))+LB(5);
                solns(i,6) = solns(i,6).*(UB(6)-LB(6))+LB(6);
                solns(i,7) = solns(i,7).*(UB(7)-LB(7))+LB(7);
                solns(i,8) = solns(i,8).*(UB(8)-LB(8))+LB(8);
                solns(i,9) = solns(i,9).*(UB(9)-LB(9))+LB(9);
                solns(i,10) = solns(i,10).*(UB(10)-LB(10))+LB(10);
                solns(i,11) = solns(i,11).*(UB(11)-LB(11))+LB(11);
                solns(i,12) = solns(i,12).*(UB(12)-LB(12))+LB(12);
                solns(i,13) = solns(i,13).*(UB(13)-LB(13))+LB(13);
            end
    end
    
    %Update personal bests and global best
    
    if min(solns(:,14))<globalbest(14)
        best = min(solns(:,14));
        bestrow = solns(:,14)==best;
        globalbest = solns(bestrow,:);
    end
    
    for p=1:parts
        if solns(p,14)<personals(p,14)
            personals(p,:) = solns(p,:);
        end
    end
    globals(j) = globalbest(14);
    disp(num2str(j))
    if j==1
        solns1 = solns;
    elseif j==2
        solns2 = solns;
    elseif j==3
        solns3 = solns;
    elseif j==4
        solns4 = solns;
    elseif j==5
        solns5 = solns;
    end
end

finalsolns = solns;
disp(['Best solution is:' num2str(globalbest)])
load('MODEL.mat');
disp(['Solutions should be:' num2str(Parsna) ' '])
plot(globals)

toc