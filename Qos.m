clc; clear;

%% Simulation Setup
sim_time = 100;       % seconds 
dt = 0.01;            % time step 
time = 0:dt:sim_time; 

% Traffic characteristics (average Mbps) 
video_rate = 2.5;     % High bandwidth, variable rate 
audio_rate = 0.5;     % Medium stability, low bandwidth 
cbr_rate   = 1.0;     % Constant Bit Rate 

% Traffic generation 
video_traffic = video_rate + 0.5*randn(size(time));  % bursty 
audio_traffic = audio_rate + 0.1*randn(size(time));  % fairly stable 
cbr_traffic   = cbr_rate * ones(size(time));         % constant 

% Avoid division by zero 
video_traffic(video_traffic <= 0) = 0.01; 
audio_traffic(audio_traffic <= 0) = 0.01; 

% Delay models (simulated inversely proportional to traffic) 
video_delay = 100 ./ video_traffic; 
audio_delay = 100 ./ audio_traffic; 
cbr_delay   = 100 ./ cbr_traffic; 

% Jitter (variation in delay) 
video_jitter = [0, abs(diff(video_delay))]; 
audio_jitter = [0, abs(diff(audio_delay))]; 
cbr_jitter   = [0, abs(diff(cbr_delay))]; 

%% Plot Throughput
figure; 
plot(time, video_traffic, 'r', time, audio_traffic, 'g', time, cbr_traffic, 'b'); 
title('Traffic Throughput'); 
legend('Video', 'Audio', 'CBR'); 
xlabel('Time (s)'); 
ylabel('Mbps'); 

%% Plot Delay
figure; 
plot(time, video_delay, 'r', time, audio_delay, 'g', time, cbr_delay, 'b'); 
title('Simulated Delay'); 
legend('Video', 'Audio', 'CBR'); 
xlabel('Time (s)'); 
ylabel('Delay (ms)'); 

%% Plot Jitter
figure; 
plot(time, video_jitter, 'r', time, audio_jitter, 'g', time, cbr_jitter, 'b'); 
title('Simulated Jitter'); 
legend('Video', 'Audio', 'CBR'); 
xlabel('Time (s)'); 
ylabel('Jitter (ms)'); 

%% QoS Summary Output
fprintf('--- QoS Summary ---\n'); 
fprintf('Video: Avg Delay = %.2f ms, Avg Jitter = %.2f ms, Avg Throughput = %.2f Mbps\n', ...
    mean(video_delay), mean(video_jitter), mean(video_traffic)); 
fprintf('Audio: Avg Delay = %.2f ms, Avg Jitter = %.2f ms, Avg Throughput = %.2f Mbps\n', ...
    mean(audio_delay), mean(audio_jitter), mean(audio_traffic)); 
fprintf('CBR  : Avg Delay = %.2f ms, Avg Jitter = %.2f ms, Avg Throughput = %.2f Mbps\n', ...
    mean(cbr_delay), mean(cbr_jitter), mean(cbr_traffic)); 

%% Network Topology Visualization for Video/Audio/CBR Nodes
num_apps = 3; 
theta = linspace(0, 2*pi, num_apps + 1); 
x = cos(theta) * 50; 
y = sin(theta) * 50; 

figure; hold on;
% Plot Access Point
plot(0, 0, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10); 
text(0, 0, 'Access Point', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 12);

% Application Nodes
node_labels = {'Video', 'Audio', 'CBR'}; 
colors = {'r', 'g', 'b'}; 

for i = 1:num_apps 
    plot(x(i), y(i), 'o', 'MarkerEdgeColor', 'k', 'MarkerSize', 8, 'MarkerFaceColor', colors{i});
    text(x(i), y(i), node_labels{i}, 'FontSize', 10, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top'); 
    plot([0 x(i)], [0 y(i)], 'k-', 'LineWidth', 1); 
end

axis equal; 
xlim([-60 60]); 
ylim([-60 60]); 
xlabel('X (m)'); 
ylabel('Y (m)'); 
title('Network Topology for Video, Audio, and CBR Nodes'); 
grid on; 
hold off;
