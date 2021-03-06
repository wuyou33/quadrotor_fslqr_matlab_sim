% Look for the minimum rms out of all combinations
% Only interested in Position y, which is stored in X(2);
% 0.5Hz is stored in Freq(4)
countComb=1;
xyuv=zeros(1,1);
% for comb=1:length(combinations)
%     if(~ismember(0,ismember([1 2 4 5], combinations(comb,:))))
%         xyuv(countComb,:)=combinations(comb,:);
%         countComb=countComb+1;
%     end
% end
% checks if the combination include 1,2,4,5 -> x,y,u,v
for comb=1:length(combinations)
    if(~ismember(0,ismember([1 2 4 5], combinations(comb,:))))
        xyuv(countComb,1)=comb;
        countComb=countComb+1;
    end
end
for comb=1:length(xyuv)
    saveXYUVSinState(:,:,comb,:)=saveSinState(:,:,xyuv(comb),:);
    saveXYUVSinRms(:,:,comb,:)=saveSinRms(:,:,xyuv(comb),:);
end
%%
gyaku=length(xyuv);
for comb=1:length(xyuv)
    if (max(saveXYUVSinState(:,1,gyaku,4))<0.05) || (max(saveXYUVSinState(:,2,gyaku,4))<0.05)
        saveXYUVSinState(:,:,gyaku,:)=[];
        saveXYUVSinRms(:,:,gyaku)=[];
        xyuv(gyaku)=[];
    end
    gyaku=gyaku-1;
end
[Min,Indx]=min(saveXYUVSinRms(1,4,:)+saveXYUVSinRms(2,4,:)); 
% [sortRms,sortIndx]=sort(saveXYUVSinRms(2,4,:));
Indx=xyuv(Indx);
%%
% --------------------------- Time Response -----------------------------%
% sin input for different frequency (THE BEST COMBINATION)
numSubplot=4;
numData=3;
% for f=1:length(Freq)
for f=3:5
    indexSubplot=rem(f,numSubplot);
    if indexSubplot==1;       figure
    elseif indexSubplot==0;   indexSubplot=numSubplot;
    end
    subplot(2,2,indexSubplot)
    plot(T,saveSinState(:,1,Indx,f));
    xlabel(XLabels(1)); ylabel('Position [m]'); title(FreqLabels(f));
    legend('\itx');
end
%{
for f=1:4
    indexSubplot=rem(f,numSubplot);
    if indexSubplot==1;       figure
    elseif indexSubplot==0;   indexSubplot=numSubplot;
    end
    subplot(2,2,indexSubplot)
    for indx=1:length(combinations)
        plot(T,saveSinState(:,1,sortIndx(indx),f));
        legendInfo{indx}=sprintf('%i',sortIndx(indx));
        hold on
    end
    xlabel(XLabels(1)); ylabel('Position [m]'); title(FreqLabels(f));
    legend(legendInfo);
end
for f=1:4
    indexSubplot=rem(f,numSubplot);
    if indexSubplot==1;       figure
    elseif indexSubplot==0;   indexSubplot=numSubplot;
    end
    subplot(2,2,indexSubplot)
    for indx=1:length(combinations)
        plot(T,saveSinState(:,2,sortIndx(indx),f));
        legendInfo{indx}=sprintf('%i',sortIndx(indx));
        hold on
    end
    xlabel(XLabels(1)); ylabel('Position [m]'); title(FreqLabels(f));
    legend(legendInfo);
end
%}
%%
for f=1:length(Freq)
    indexSubplot=rem(f,numSubplot);
    if indexSubplot==1;       figure
    elseif indexSubplot==0;   indexSubplot=numSubplot;
    end
    subplot(2,2,indexSubplot)
    plot(T,saveSinState(:,2,Indx,f));
    xlabel(XLabels(1)); ylabel('Position [m]'); title(FreqLabels(f));
    legend('\ity');
end

figure
subplot(3,1,1)
plot(T,saveSinState(:,2,Indx,3));
xlabel(XLabels(1)); ylabel('Position [m]'); title(FreqLabels(3));
legend('\ity');
subplot(3,1,2)
plot(T,saveSinState(:,2,Indx,4));
xlabel(XLabels(1)); ylabel('Position [m]'); title(FreqLabels(4));
legend('\ity');
subplot(3,1,3)
plot(T,saveSinState(:,2,Indx,5));
xlabel(XLabels(1)); ylabel('Position [m]'); title(FreqLabels(5));
legend('\ity');
%%
for f=1:length(Freq)
    indexSubplot=rem(f,numSubplot);
    if indexSubplot==1;       figure
    elseif indexSubplot==0;   indexSubplot=numSubplot;
    end
    subplot(2,2,indexSubplot)
    plot(T,saveSinState(:,3,Indx,f));
    xlabel(XLabels(1)); ylabel('Position [m]'); title(FreqLabels(f));
    legend('\itz');
end
%% In 1 Plot for Yohshi
figure
plot(T,saveSinState(:,2,Indx,2),'--',T,saveSinState(:,2,Indx,3),'--',T,saveSinState(:,2,Indx,4), T,saveSinState(:,2,Indx,5),':');
xlabel(XLabels(1)); ylabel('Position [m]'); ylim([-2 2]);
legend('{\itf}=0.05','{\itf}=0.10','{\itf}=0.50','{\itf}=1.00');

% step input for different frequency (THE BEST COMBINATION)
figure
for i=0:3
    subplot(2,2,i+1);
    plot(T,saveStepState(:,3*i+1,Indx),T,saveStepState(:,3*i+2,Indx),T,saveStepState(:,3*i+3,Indx));
    xlabel(XLabels(1)); ylabel(AllStateLabels(i+1));
    legendInfo{1}=YLabels{3*i+1}; legendInfo{2}=YLabels{3*i+2};  legendInfo{3}=YLabels{3*i+3};
    legend(legendInfo);
end
%% 3D Trajectory Animation
%{%
figure
h = animatedline;
xlim([min(saveStepState(:,1,Indx)) max(saveStepState(:,1,Indx))]);
ylim([min(saveStepState(:,2,Indx)) max(saveStepState(:,2,Indx))]);
zlim([min(saveStepState(:,3,Indx)) max(saveStepState(:,3,Indx))]);
xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');
grid on;view(3)
for t=1:length(T)-1
    addpoints(h,saveStepState(t,1,Indx), saveStepState(t,2,Indx), saveStepState(t,3,Indx));
    title(sprintf('%0.3f/%i [s]',t*dt,t_end));
    pause(0.01)
    drawnow limitrate
end
drawnow
%}
%%
% ------------------------- Frequency Response --------------------------%
% --- Plotting All States for 1 combo
%{%
numSubplot=3;
for x=1:length(X)
    indexSubplot=rem(x,numSubplot);
    if indexSubplot==1;     figure
    elseif indexSubplot==0; indexSubplot=numSubplot;
    end
    subplot(3,1,indexSubplot)
    semilogx(W, Sense(:,x,Indx), W,-Mag(:,x));
    xlabel(XLabels(3)); ylabel('Gain [dB]'); grid on;
    legendInfo{1}=YLabels{x}; legendInfo{2}=['Weight'];
    legend(legendInfo);
end
% x,y Sensitivity & Weight
figure
semilogx(W, Sense(:,1,Indx), W,-Mag(:,1),W, Sense(:,2,Indx), W,-Mag(:,2));
xlabel(XLabels(2)); ylabel('Gain [dB]'); legend('Sensitivity \itx',' Weight x','Sensitivity \ity',' Weight y');
%{
subplot(1,2,1)
semilogx(W, Sense(:,1,Indx), W,-Mag(:,1));xlabel(XLabels(2));legend('Sensitivity \itx',' Weight');
subplot(1,2,2)
semilogx(W, Sense(:,2,Indx), W,-Mag(:,2));xlabel(XLabels(2));legend('Sensitivity \ity',' Weight');
%}
%}
%%
% --- Plot all Y sensitivity for all combos
%{%
figure
for indx=1:length(combinations)
    semilogx(W,Sense(:,2,sortIndx(indx)));
    legendInfo{indx}=sprintf('%i',sortIndx(indx));
    hold on
end
semilogx(W,-Mag(:,2));
legend(legendInfo)
%}