%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Wt (Phase Lead Filter)                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ----------------------------- setup ----------------------------------%
W=logspace(-2,3,100);
% Calculating a, which is Phut=a*P, where a^-1 is stable
Anum1=[1 1]; Aden1=[1 0];
a1=tf(Anum1,Aden1);
Anum2=conv(Anum1,Anum1); Aden2=conv(Aden1,Aden1);
Anum3=conv(Anum1,Anum2); Aden3=conv(Aden1,Aden2);
Anum4=conv(Anum1,Anum3); Aden4=conv(Aden1,Aden3);
% Calculating which s^0 (P stands for pole)
Pnum1=[1]; Pden1=[1 0];
Pnum2=conv(Pnum1,Pnum1); Pden2=conv(Pden1,Pden1);
Pnum3=conv(Pnum1,Pnum2); Pden3=conv(Pden1,Pden2);
Pnum4=conv(Pnum1,Pnum3); Pden4=conv(Pden1,Pden3);
% -------------------------------- x ------------------------------------%
% gain=0.5; f1=1; f2=3; w1=2*pi*f1;w2=2*pi*f2; gain=gain*(w2/w1);num=[1 w1]; den=[1 w2]; 
gain=2; w=100; ze=0.6; num=[1 0 0]; den=[1 2*ze*w w^2];
    % BODE DIAGRAM
    sys = tf(gain*num,den)
    magt = bode(sys,W); magt = squeeze(magt); magt = 20*log10(magt);
    
    % Wt_hut = Wt/a
%     num=conv(num,Aden4); den=conv(den,Anum4);
    msysTx = nd2sys(num,den,gain);
% -------------------------------- y ------------------------------------%
msysTy=msysTx;
% -------------------------------- z ------------------------------------%
gain=0.5; f1=0.2; f2=0.6; w1=2*pi*f1;w2=2*pi*f2; gain=gain*(w2/w1);num=[1 w1]; den=[1 w2]; 
    % Wt_hut = Wt/a
    num=conv(num,Aden2); den=conv(den,Anum2);
    msysTz = nd2sys(num,den,gain);
% -------------------------------- u ------------------------------------%
gain=0.5; f1=0.2; f2=0.6; w1=2*pi*f1;w2=2*pi*f2; gain=gain*(w2/w1);num=[1 w1]; den=[1 w2]; 
    % Wt_hut = Wt/a
    num=conv(num,Aden3); den=conv(den,Anum3);
    msysTu = nd2sys(num,den,gain);
% -------------------------------- v ------------------------------------%
msysTv=msysTu;
% -------------------------------- w ------------------------------------%
gain=0.5; f1=0.2; f2=0.6; w1=2*pi*f1;w2=2*pi*f2; gain=gain*(w2/w1);num=[1 w1]; den=[1 w2]; 
    % Wt_hut = Wt/a
    num=conv(num,Aden1); den=conv(den,Anum1);
    msysTw = nd2sys(num,den,gain);
% -------------------------------- phi ------------------------------------%
gain=0.5; f1=0.2; f2=0.6; w1=2*pi*f1;w2=2*pi*f2; gain=gain*(w2/w1);num=[1 w1]; den=[1 w2]; 
    % Wt_hut = Wt/a
    num=conv(num,Aden2); den=conv(den,Anum2);
    msysTphi = nd2sys(num,den,gain);
% -------------------------------- theta ------------------------------------%
msysTtheta=msysTphi;
% -------------------------------- psi ------------------------------------%
msysTpsi=msysTphi;
% -------------------------------- p ------------------------------------%
gain=0.5; f1=0.2; f2=0.6; w1=2*pi*f1;w2=2*pi*f2; gain=gain*(w2/w1);num=[1 w1]; den=[1 w2]; 
    % Wt_hut = Wt/a
    num=conv(num,Aden1); den=conv(den,Anum1);
    msysTp = nd2sys(num,den,gain);
% -------------------------------- q ------------------------------------%
msysTq=msysTp;
% -------------------------------- r ------------------------------------%
msysTr=msysTp;
% ------------------------------ total ----------------------------------%
% Wt=daug(daug(msysx,msysy,msysz), daug(msysu,msysv,msysw), daug(msysphi,msystheta,msyspsi), daug(msysp,msysq,msysr));
wt=daug(msysTx,msysTx,msysTx,msysTx);
Wt=daug(wt,wt,wt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Ws (MOST IMPORTANT)                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -------------------------------- x ------------------------------------%
% gain=0.1; f1=0.1; f2=1;  w1=2*pi*f1; w2=2*pi*f2; num=[1 w2]; den=[1 w1];
gain=3; ze=0.7; w=10; num=[0 0 w^2]; den=[1 2*ze*w w^2];
    % BODE DIAGRAM
    sys = tf(gain*num,den)
    magX = bode(sys,W); magX = squeeze(magX); magX = 20*log10(magX); wsX = nd2sys(num,den,gain);
   
    % Ws_hut = Ws/a^0
%     num=conv(num,Pnum4); den=conv(den,Pden4);
    msysSx = nd2sys(num,den,gain);
% -------------------------------- y ------------------------------------%
msysSy=msysSx;
% -------------------------------- z ------------------------------------%
gain=0.4; f1=0.04; f2=0.15;  w1=2*pi*f1; w2=2*pi*f2; num=[1 w2]; den=[1 w1];
    num=conv(num,Pnum2); den=conv(den,Pden2);
    msysSz = nd2sys(num,den,gain);
% -------------------------------- u ------------------------------------%
gain=0.4; f1=0.04; f2=0.15;  w1=2*pi*f1; w2=2*pi*f2; num=[1 w2]; den=[1 w1];
    num=conv(num,Pnum3); den=conv(den,Pden3);
    msysSu = nd2sys(num,den,gain);
% -------------------------------- v ------------------------------------%
msysSv=msysSu;
% -------------------------------- w ------------------------------------%
gain=0.4; f1=0.04; f2=0.15;  w1=2*pi*f1; w2=2*pi*f2; num=[1 w2]; den=[1 w1];
    num=conv(num,Pnum1); den=conv(den,Pden1);
    msysSw = nd2sys(num,den,gain);
% -------------------------------- phi ------------------------------------%
gain=0.4; f1=0.04; f2=0.15;  w1=2*pi*f1; w2=2*pi*f2; num=[1 w2]; den=[1 w1];
    num=conv(num,Pnum2); den=conv(den,Pden2);
    msysSphi = nd2sys(num,den,gain);
% -------------------------------- theta ------------------------------------%
msysStheta=msysSphi;
% -------------------------------- psi ------------------------------------%
msysSpsi=msysSphi;
% -------------------------------- p ------------------------------------%
gain=0.4; f1=0.04; f2=0.15;  w1=2*pi*f1; w2=2*pi*f2; num=[1 w2]; den=[1 w1];
    num=conv(num,Pnum1); den=conv(den,Pden1);
    msysSp = nd2sys(num,den,gain);
% -------------------------------- q ------------------------------------%
msysSq=msysSp;
% -------------------------------- r ------------------------------------%
msysSr=msysSp;
% ------------------------------ total ----------------------------------%
% Ws=daug(daug(msysx,msysy,msysz), daug(msysu,msysv,msysw), daug(msysphi,msystheta,msyspsi), daug(msysp,msysq,msysr));
Ws=daug(msysSx,msysSx,msysSx);
% Ws=daug(ws,ws,ws,ws);


% Wn = daug(0.01, 0.01, 0.01, 0.01, 0.01, 0.01);
% Wn = daug(Wn,Wn);

% Wn = daug(0.01,0.01,0.01,0.01);
% Wd = daug(daug(0.15, 0.15, 0.15, 0.01, 0.01, 0.01), daug(0.01, 0.01, 0.01, 0.01, 0.01, 0.01));
% Wd = daug(daug(0.01, 0.01, 0.01, 0.01, 0.01, 0.01), daug(0.01, 0.01, 0.01, 0.01, 0.01, 0.01));
% Wd = daug(0.15, 0.15, 0.15);

% Wn = daug(daug(0.01, 0.01, 0.01, 0.1, 0.1, 0.1), daug(0.01, 0.01, 0.01, 0.1, 0.1, 0.1));


figure; semilogx(W,magX, W, magt); grid on;
xlabel('Frequency [rad/s]'); ylabel('Gain [dB]'); legend('{\itW_x}', '{\itW_t}');xlim([10^(-2) 10^(3)]);ylim([-30 50]);
    
