function hd3 = draw_3d_animation(T, X_data, Xlqr_data, l, dt, t_end, limit, legendPos)
%%  3D
slow = false;
record = false;
camera_turn=false;
if record==true
%     vidObj = VideoWriter(sprintf('Motion_f=%i.avi', freq));
    vidObj = VideoWriter('Servo');
    open(vidObj)
end

figure
set(gcf, 'Name', '3D Position');
az = 55; el = 25;
legend('expd','lqr'); 
same_xy_lim = true;
if same_xy_lim == true
    x_min = min([X_data(1,:) Xlqr_data(1,:) X_data(2,:) Xlqr_data(2,:)])-2*l;
    x_max = max([X_data(1,:) Xlqr_data(1,:) X_data(2,:) Xlqr_data(2,:)])+2*l;
    y_min = x_min;
    y_max = x_max;
else
    x_min=min([X_data(1,:) Xlqr_data(1,:)])-2*l;
    x_max=max([X_data(1,:) Xlqr_data(1,:)])+2*l;
    y_min=min([X_data(2,:) Xlqr_data(2,:)])-2*l;
    y_max=max([X_data(2,:) Xlqr_data(2,:)])+2*l;
end
z_min=min([X_data(3,:) Xlqr_data(3,:)])-2*l;
z_max=max([X_data(3,:) Xlqr_data(3,:)])+2*l;


proposedColor = [0.85 0.325 0.098];
conventionColor = [0.0 0.447 0.741];
thinPColor = [0.95 0.425 0.198];
thinCColor = [0.1 0.547 0.84];

fastforward=5;
for i=1:length(T)/fastforward
    t=fastforward*i;
    x = X_data(1,t);
    y = X_data(2,t);
    z = X_data(3,t); 
    phi = X_data(7,t);
    th = X_data(8,t);
    psi = X_data(9,t);
    x_lqr = Xlqr_data(1,t);
    y_lqr = Xlqr_data(2,t);
    z_lqr = Xlqr_data(3,t);
    phi_lqr = Xlqr_data(7,t);
    th_lqr = Xlqr_data(8,t);
    psi_lqr = Xlqr_data(9,t);    
    hd3 = plot3(X_data(1,1:t),X_data(2,1:t),X_data(3,1:t), Xlqr_data(1,1:t), Xlqr_data(2,1:t), Xlqr_data(3,1:t)); grid on; 
    set(hd3(1), 'Color', thinPColor,     'LineStyle', ':', 'LineWidth', 1); 
    set(hd3(2), 'Color', thinCColor,   'LineStyle', ':', 'LineWidth', 1); 
    if slow==true
%         xlim([-2 2]); ylim([-2 2]); zlim([-2 2]);
        xlim([x_min x_max]); ylim([y_min y_max]); zlim([z_min z_max]);
    else
        xlim([x_min x_max]); ylim([y_min y_max]); zlim([z_min z_max]);
    end
    if limit~=0
        xlim([-limit limit]); ylim([-limit limit]); zlim([-limit limit]);
    end
    R_lqr = getRotationalMatrix(phi_lqr, th_lqr, psi_lqr);
    linex_lqr = R_lqr*[1; 0; 0];
    liney_lqr = R_lqr*[0; 1; 0];
    line([x_lqr+l*linex_lqr(1) x_lqr-l*linex_lqr(1)], [y_lqr+l*linex_lqr(2) y_lqr-l*linex_lqr(2)], [z_lqr+l*linex_lqr(3) z_lqr-l*linex_lqr(3)], 'Color', conventionColor);
    line([x_lqr+l*liney_lqr(1) x_lqr-l*liney_lqr(1)], [y_lqr+l*liney_lqr(2) y_lqr-l*liney_lqr(2)], [z_lqr+l*liney_lqr(3) z_lqr-l*liney_lqr(3)], 'Color', conventionColor);
    ar1_lqr = [x_lqr; y_lqr; z_lqr];
    ar2_lqr = [x_lqr; y_lqr; z_lqr] + l*R_lqr*[0; 0; 5];
    arrow(ar1_lqr, ar2_lqr, 'Length', 8);
    R = getRotationalMatrix(phi, th, psi);
    linex = R*[1; 0; 0];
    liney = R*[0; 1; 0];
    line([x+l*linex(1) x-l*linex(1)], [y+l*linex(2) y-l*linex(2)], [z+l*linex(3) z-l*linex(3)], 'Color', proposedColor);
    line([x+l*liney(1) x-l*liney(1)], [y+l*liney(2) y-l*liney(2)], [z+l*liney(3) z-l*liney(3)], 'Color', proposedColor);
    ar1 = [x; y; z];
    ar2 = [x; y; z] + l*R*[0; 0; 5];
    arrow(ar1, ar2, 'Length', 8);
    
    arrow([x_min+0.1 y_min+0.1 z_min+0.1], [x_min+0.3 y_min+0.1 z_min+0.1], 'Length', 8); text(x_min+0.4,y_min+0.1,z_min+0.1,'\itx', 'FontSize',10);
    arrow([x_min+0.1 y_min+0.1 z_min+0.1], [x_min+0.1 y_min+0.3 z_min+0.1], 'Length', 8); text(x_min+0.1,y_min+0.4,z_min+0.1,'\ity', 'FontSize',10);
    arrow([x_min+0.1 y_min+0.1 z_min+0.1], [x_min+0.1 y_min+0.1 z_min+0.3], 'Length', 8); text(x_min+0.1,y_min+0.1,z_min+0.4,'\itz', 'FontSize',10);

    
    if(camera_turn==true) 
        if(az>360)
            az=0;
        end
        az=az+1;
    end
    view(az, el);
    xlabel('{\itx}, m'); ylabel('{\ity}, m'); zlabel('{\itz}, m');
%     legend('LQR','Proposed', 'Location','northeast','Orientation','horizontal');
%    title(sprintf('%0.1f/%i[s], CameraAngle: %i[deg]',t*dt,t_end, az));
    title(sprintf('%0.1f/%i [s]',t*dt,t_end));
    drawnow;
    if slow==true
        pause(0.2);
    end
    if T(t) > 30
        pause;
    end

    if record==true
        currFrame = getframe(gcf);
        writeVideo( vidObj, currFrame );
    end
end

if record==true
    close( vidObj );
end
success = true;