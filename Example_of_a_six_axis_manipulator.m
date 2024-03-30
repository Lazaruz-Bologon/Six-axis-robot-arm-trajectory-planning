waypoints = [
    -58.357, -29.707, 118.144, -5.048, -89.808, 54.281;
    31.179, -29.710, 118.141, -5.048, -89.811, 54.281;
    49.351, 33.242, 70.961, -10.471, -91.574, 72.351;
    49.35, 35.65, 73.72, -19.21, -91.57, 72.33;
    49.351, 33.242, 48.961, 6.471, -91.574, 72.351;
    51.2306, 33.7971, 76.9225, -20.5073, -91.5659, 74.2124;
    51.2306, 31.2959, 70.2167, -11.3003, -91.5659, 74.2124;
    31.179, -29.710, 118.141, -5.048, -89.811, 54.281; 
];
n_joints = 6;
n_points = size(waypoints, 1);
t = linspace(0, 1, n_points);
t = cumsum(t);
A = zeros(6, 6, n_joints);
b = zeros(6, n_joints);
for joint = 1:n_joints
    for i = 1:(n_points-1)
        T = t(i+1) - t(i);
        A(:,:,joint) = [
            1 0 0 0 0 0;
            0 1 0 0 0 0;
            0 0 2 0 0 0;
            1 T^1 T^2 T^3 T^4 T^5;
            0 1 2*T 3*T^2 4*T^3 5*T^4;
            0 0 2 6*T 12*T^2 20*T^3;
        ];        
        b(:,joint) = [
            waypoints(i,joint);
            0;
            0;
            waypoints(i+1,joint);
            0;
            0;
        ];
    end
    coefficients(joint,:) = A(:,:,joint) \ b(:,joint);
end
disp('每个关节的五次多项式系数:');
disp(coefficients);
t_plot = linspace(0, t(end), 100);
q_plot = zeros(size(t_plot, 1), n_joints);
for joint = 1:n_joints
    for i = 1:length(t_plot)
        q_plot(i,joint) = coefficients(joint,1) + ...
                          coefficients(joint,2) * t_plot(i) + ...
                          coefficients(joint,3) * t_plot(i)^2 + ...
                          coefficients(joint,4) * t_plot(i)^3 + ...
                          coefficients(joint,5) * t_plot(i)^4 + ...
                          coefficients(joint,6) * t_plot(i)^5;
    end
end
figure;
for joint = 1:n_joints
    subplot(3, 2, joint);
    plot(t_plot, q_plot(:,joint));
    title(['关节 ' num2str(joint) ' 角度随时间变化']);
    xlabel('时间');
    ylabel('角度 (度)');
end