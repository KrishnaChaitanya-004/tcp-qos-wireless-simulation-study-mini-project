clc; clear; close all;

%% Defining Network Parameters 
num_nodes = 5;             % 5 wireless sender nodes 
sim_time = 10;             % Simulation time in seconds 
packet_size = 1024;        % Packet size in bytes (1 KB) 
packets_per_second = 100;  % Packet generation rate 
total_packets = packets_per_second * sim_time;

% Distance of each node from Access Point (meters) 
d = [20, 30, 25, 35, 40];   
Pt = 20;                   % Transmit power in dBm 

% Calculate Path Loss (Simple Log Model) 
PL = 10 * log10(d); 
RSSI = Pt - PL;

%% Simulating Wireless TCP Variants 
time = linspace(0, sim_time, total_packets); % Packet timestamps 

% Wireless Throughput Models (with fading & distance effects) 
reno = (log(1 + time) .* (RSSI(1) / max(RSSI))) * packets_per_second * packet_size * 8 / 1e6; % Mbps 
new_reno = (log(1 + time.^1.1) .* (RSSI(2) / max(RSSI))) * packets_per_second * packet_size * 8 / 1e6; 
tahoe = (exp(-0.2 * time) .* (RSSI(3) / max(RSSI))) * packets_per_second * packet_size * 8 / 1e6; 
cubic = ((time.^0.75) .* (RSSI(4) / max(RSSI))) * packets_per_second * packet_size * 8 / 1e6; 
bic = ((log(1 + time).^1.2) .* (RSSI(5) / max(RSSI))) * packets_per_second * packet_size * 8 / 1e6;

%% Plot Wireless TCP Throughput Over Time 
figure;
plot(time, reno, 'r', 'LineWidth', 2); hold on;
plot(time, new_reno, 'g', 'LineWidth', 2);
plot(time, tahoe, 'm', 'LineWidth', 2);
plot(time, cubic, 'b', 'LineWidth', 2);
plot(time, bic, 'k', 'LineWidth', 2);
legend('TCP Reno', 'TCP New Reno', 'TCP Tahoe', 'TCP CUBIC', 'TCP BIC', 'Location', 'best');
xlabel('Time (s)', 'FontWeight', 'bold');
ylabel('Throughput (Mbps)', 'FontWeight', 'bold');
title('Wireless TCP Throughput Over Time', 'FontWeight', 'bold');
grid on;
set(gca, 'FontSize', 12);
hold off;

%% Simulating Wireless Delay and Jitter 
% Delay (ms) influenced by congestion & distance 
delay = 10 + (d / 5) + randn(1, num_nodes) * 3;   
jitter = std(delay) * rand(1, num_nodes);  % Jitter = Standard deviation of delay

%% Print Performance Metrics 
fprintf('Wireless Performance Metrics:\n'); 
fprintf('TCP Variant\t Throughput (Mbps)\t Avg Delay (ms)\t Jitter (ms)\n'); 
fprintf('------------------------------------------------------------\n'); 
fprintf('TCP Reno\t %.4f\t\t %.4f\t\t %.4f\n', mean(reno), delay(1), jitter(1)); 
fprintf('TCP New Reno\t %.4f\t\t %.4f\t\t %.4f\n', mean(new_reno), delay(2), jitter(2)); 
fprintf('TCP Tahoe\t %.4f\t\t %.4f\t\t %.4f\n', mean(tahoe), delay(3), jitter(3)); 
fprintf('TCP CUBIC\t %.4f\t\t %.4f\t\t %.4f\n', mean(cubic), delay(4), jitter(4)); 
fprintf('TCP BIC\t\t %.4f\t\t %.4f\t\t %.4f\n', mean(bic), delay(5), jitter(5)); 

%% Wireless Network Topology  
figure;
theta = linspace(0, 2*pi, num_nodes + 1);  % For circular placement 
layout_radius = 15;  % Visualization radius 
x = layout_radius * cos(theta(1:end-1)); 
y = layout_radius * sin(theta(1:end-1)); 

% Plot Access Point 
plot(0, 0, 'ks', 'MarkerSize', 14, 'MarkerFaceColor', 'y');  
hold on;

% Plot sender nodes and connections to AP 
for i = 1:num_nodes 
    plot(x(i), y(i), 'bo', 'MarkerSize', 12, 'MarkerFaceColor', 'c'); 
    line([0 x(i)], [0 y(i)], 'LineStyle', '--', 'Color', [0.4 0.4 0.4], 'LineWidth', 1.5); 
    text(x(i)*1.15, y(i)*1.15, sprintf('Node %d\n(%dm)', i, d(i)), ...
        'FontSize', 11, 'HorizontalAlignment', 'center', 'FontWeight', 'bold'); 
end

% Style and labels 
title('Wireless Network Topology (Access Point & Sender Nodes)', 'FontWeight', 'bold'); 
xlabel('X-axis (m)', 'FontWeight', 'bold'); 
ylabel('Y-axis (m)', 'FontWeight', 'bold'); 
legend('Access Point', 'Sender Node', 'Location', 'southoutside'); 
axis equal; 
grid on; 
set(gca, 'FontSize', 12); 
hold off;
% %% No Interference Simulation
