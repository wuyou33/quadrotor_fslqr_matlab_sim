%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Reference:  Quadrotor control: modeling, nonlinearcontrol design, and simulation
%               by FRANCESCO SABATINO
%   MODEL:
%               xdot = A*x + B*u + Dd*d
%               y    = C*x + D*u
%   where:      x = state;          % [x,y,z,u,v,w,phi,th,psi,p,q,r]
%               u = input;          % [f,tx,ty,tz]
%               d = disturbance;    % [fwx,fwy,fwz,twx,twy,tw]
%               y = output;         % Leave it for now. Depends on sensors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W=logspace(-2,3,100);
%% States
%    x,  y,  z,  u,  v,  w, phi, th, psi, p, q,  r;
%{%
A = [0   0   0   1   0   0   0   0   0   0   0   0;
     0   0   0   0   1   0   0   0   0   0   0   0;
     0   0   0   0   0   1   0   0   0   0   0   0;
     0   0   0   0   0   0   0   -g  0   0   0   0;
     0   0   0   0   0   0   g   0   0   0   0   0;
     0   0   0   0   0   0   0   0   0   0   0   0;
     0   0   0   0   0   0   0   0   0   1   0   0;
     0   0   0   0   0   0   0   0   0   0   1   0;
     0   0   0   0   0   0   0   0   0   0   0   1;
     0   0   0   0   0   0   0   0   0   0   0   0;
     0   0   0   0   0   0   0   0   0   0   0   0;
     0   0   0   0   0   0   0   0   0   0   0   0];
 %}
ep=10^(-9);
%{
%    x,  y,  z,  u,     v,      w,      phi,    th,     psi,    p,      q,      r;
A = [0   0   0   1      -ep      ep      0       ep      -ep     0       0       0;
     0   0   0   ep     1       -ep     -ep     0       ep      0       0       0;
     0   0   0   -ep    ep      1       ep      -ep     0       0       0       0;
     0   0   0   0      ep      -ep     0       -g      0       0       -ep     ep;
     0   0   0   -ep    0       ep      g       0       0       ep      0       -ep;
     0   0   0   ep     -ep     0        0       0       0       -ep     ep      0;
     0   0   0   0      0       0       0       ep      0       1       0       ep;
     0   0   0   0      0       0       -ep     0       0       0       1       -ep;
     0   0   0   0      0       0       ep      0       0       0       ep      1;
     0   0   0   0      0       0       0       0       0       0       ep      ep;
     0   0   0   0      0       0       0       0       0       ep      0       ep;
     0   0   0   0      0       0       0       0       0       ep      ep      0];
%}
%{
 A = [-ep   0   0   1   0   0   0   0   0   0   0   0;
     0   -ep   0   0   1   0   0   0   0   0   0   0;
     0   0   -ep   0   0   1   0   0   0   0   0   0;
     0   0   0   -ep   0   0   0   -g  0   0   0   0;
     0   0   0   0   -ep   0   g   0   0   0   0   0;
     0   0   0   0   0   -ep   0   0   0   0   0   0;
     0   0   0   0   0   0   -ep   0   0   1   0   0;
     0   0   0   0   0   0   0   -ep   0   0   1   0;
     0   0   0   0   0   0   0   0   -ep   0   0   1;
     0   0   0   0   0   0   0   0   0   -ep   0   0;
     0   0   0   0   0   0   0   0   0   0   -ep   0;
     0   0   0   0   0   0   0   0   0   0   0   -ep];
 %}

%    f     tx      ty      tz
B = [0     0       0       0;
     0     0       0       0;
     0     0       0       0;
     0     0       0       0;
     0     0       0       0;
     -1/m  0       0       0;
     0     0       0       0;
     0     0       0       0;
     0     0       0       0;
     0     1/Ixx   0       0;
     0     0       1/Iyy   0;
     0     0       0       1/Izz];
C = eye(12); 
% D = 0.001*ones(size(C,1), size(B,2));
D = zeros(size(C,1), size(B,2));

gain=10; f=0.1; ze=0.7; w=2*pi*f; num=[0 0 w^2]; den=[1 2*ze*w w^2]; 
    q = nd2sys(num,den,gain);
    q_g = frsp(q, W); 
    xq=daug(q,q,q);
    xq0=daug(1,1,1);
    Xq=daug(xq,xq0,xq0,xq0);
    [Aq,Bq,Cq,Dq]=unpck(Xq);
    
gain=30; f=0.1; ze=0.7; w=2*pi*f; num=[0 0 w^2]; den=[1 2*ze*w w^2]; 
    r = nd2sys(num, den, gain);
    Xr=daug(r,r,r,r);
    [Ar,Br,Cr,Dr]=unpck(Xr);
    r_g = frsp(r, W); r_g=minv(r_g); figure; vplot('liv,lm', q_g, r_g);
    xlabel('Frequency [rad/s]'); ylabel('Gain [dB]'); legend('{\itW_q}', '{\itW_r}');
    
% AG=[Aq                              Bq*C                            zeros(length(Aq),length(Ar));
%     zeros(length(A),length(Aq))     A                               B*Cr
%     zeros(length(Ar),length(Aq))    zeros(length(Ar),length(A))     Ar];
% BG=[zeros(length(Aq), size(Br,2));
%     B*Dr;
%     Br];
% AG=[A                               zeros(length(A),length(Aq))     zeros(length(A),length(Ar));
%     Bq                              Aq                              zeros(length(Aq),length(Ar));
%     zeros(length(Ar),length(A))     zeros(length(Ar),length(Aq))    Ar];
% BG=[B;
%     zeros(size(Bq,1), size(B,2));
%     Br];
% CG=[C zeros(size(C,1),length(Aq)) zeros(size(C,1),length(Ar))];
% DG=zeros(size(CG,1),size(BG,2));
% QG=[[Dq';Cq']*[Dq Cq] zeros(length(A)+length(Aq),length(Ar)); zeros(length(Ar), length(A)+length(Aq)) Cr'*Cr];
% RG=Dr'*Dr;
Aag=[A                               zeros(length(A),length(Aq))     B*Cr;
    Bq                              Aq                              zeros(length(Aq),length(Ar));
    zeros(length(Ar),length(A))     zeros(length(Ar),length(Aq))    Ar];
Bag=[B*Dr;
    zeros(length(Aq), size(Br,2));
    Br];
Cag=[Dq Cq zeros(size(Cq,1), length(Ar))]; Dag=zeros(size(Cag,1), size(Bag,2));
[K_lqr, Pg, e] = lqr(Aag, Bag, eye(size(Aag)), eye(size(Bag,2)));
Kx=K_lqr(:,1:length(A));     Kq=K_lqr(:,length(A)+1:length(A)+length(Aq));     Kr=K_lqr(:,length(A)+length(Aq)+1:length(A)+length(Aq)+length(Ar));

Ak=[ Aq         zeros(length(Aq), size(Ar-Br*Kr,2));
     -Br*Kq     Ar-Br*Kr];
Bk=[ Bq; -Br*Kx];
Ck=[ Dr*Kq  -(Cr-Dr*Kr)];
Dk= -Dr*Kx;

lqg=pck(Aag-Bag*K_lqr,Bag,Cag,Dag);
LQG=sel(lqg, 1:12, 1:4);
LQG_g=frsp(LQG,W);
figure
vplot('liv,lm',vsvd(LQG_g));
legend('{\it f}','{\tau_x}','{\tau_y}','{\tau_z}');

% Disturbances (This matrix will be needed for Hinfinity Controller)
%{
%   fwx,    fwy,    fwz,    twx,    twy,    twz
Dd = [0        0       0       0       0       0;
      0        0       0       0       0       0;
      0        0       0       0       0       0;
      1/m      0       0       0       0       0;
      0        1/m     0       0       0       0;
      0        0       1/m     0       0       0;
      0        0       0       0       0       0;
      0        0       0       0       0       0;
      0        0       0       0       0       0;
      0        0       0       1/Ixx   0       0;
      0        0       0       0       1/Iyy   0;
      0        0       0       0       0       1/Izz];
% this all should be 1. as disturbances applied will be the dryden wind
% model
% https://jp.mathworks.com/help/aeroblks/drydenwindturbulencemodeldiscrete.html
% a lot to think of
%}

P = pck(A,B,C,D);
% Bode Diagram of Plant P

P_g = frsp(P,W);
%{
for i=1:length(A)
   Psel_g = sel(P_g, i, 1:size(B,2));
   figure
   vplot('bode', Psel_g); title(sprintf('%i',i));
   legend('u','tx','ty','tz');
end
%}

% poles and pole diagram of Plant P
Pss = ss(A,B,C,D);
%{
for i=1:size(B,2)
    for j=1:size(A,1)
        bode(Pss(j,i),w); 
        hold on
    end
end
%}
% figure
% pzmap(Pss);

% Transfer Function of P (from 4inputs to 12 outputs)
% tf(Pss)
% spoles(P)

%{
tf1=tf([1],[1 1]);
tf2=tf([1],[1 2 1]);
tf3=tf([1],[1 3 3 1]);
tf4=tf([1], [1 4 6 4 1]);
systf=[ 0   0   tf4     0;
        0   tf4 0       0;
        tf2 0   0       0;
        0   0   tf3     0;
        0   tf3 0       0;
        tf1 0   0       0;
        0   tf2 0       0;
        0   0   tf2     0;
        0   0   0       tf2;
        0   tf1 0       0;
        0   0   tf1     0;
        0   0   0       tf1];
Pss = ss(systf);
P = pck(Pss.A,Pss.B,Pss.C,Pss.D);
%}
%% Checking for Controllability & Observability
co=ctrb(A,B);
if rank(co)==size(A)
   disp('This system is controllable.')
else
   if rank(co)==0
      disp('This system is uncontrollable.')
   else
      disp('This system is stabilizable.')
   end
end
Controllability = rank(co)
obs=obsv(A,C);
if rank(obs)==size(A)
   disp('This system is observable.')
else
   if rank(obs)==0
      disp('This system is unobservable.')
   else
      disp('This system is detectable.')
   end
end
Observability = rank(obs)
