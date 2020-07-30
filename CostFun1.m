
function [Score,current] = CostFun1(Pars)

%load 'KV1.mat'
%load 'BDSupdated.mat'
%load 'PaTXlongcorrected.mat'

%Choose one of the data sets:
load 'KV2.mat'                      %Load Native Kv2 data
%load 'KCNS2 WT.mat'                %Load wild-type Kv9 data
%load 'KCNS2 c379E.mat'             %Load c379E Kv9 data

HP = V(1:10,1);
Vt = V(1:10,2);
t = T;

m0 = m_0(Pars(1:2), HP);
h0 = h_0(Pars(6:7), HP);

[t,m]  = ode23t(@ODEm,t,m0,[],Pars(1:5), Vt);
[t,n]  = ode23t(@ODEh,t,h0,[],Pars(6:10), Vt);

g   = Pars(11);
p   = Pars(12);
q   = Pars(13);

% HH formalism current (I) equation to calculate current
Ek = -90;
I = g*(m.^p.*n.^q)'.*((Vt-Ek)*ones(1,length(t)));

I_intrp = interp1(T,IK(:,1:10),t,'spline');

% Cost function fitness score
Score = norm(abs((I_intrp)'-(I)),2);     % 2 norm

figure()
plot(t,I,'.-','linewidth',2); hold on;
ax = gca;
ax.ColorOrderIndex = 1;
plot(t(1:20:end),IK(1:20:end,1:10),'-','linewidth',0.1); hold off;
%xlim([-10 200])
%ylim([-20 120])
xlim([-20 200])
ylim([-10 120])
xlabel('Time (ms)'), ylabel('I (pA)')
title(Score)
drawnow;

current = I;
end
