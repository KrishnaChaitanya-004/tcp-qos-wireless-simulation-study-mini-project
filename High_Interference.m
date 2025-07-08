clc; clear; close all;

%% Defining Network Parameters 
num_tcp_nodes = 5;               
num_cbr_nodes = 5;               
sim_time = 10;                  
packet_size = 1024;          
packets_per_second = 100;    
total_packets = packets_per_second * sim_time;

% Distance of each node from Access Point (meters) 
d = [20, 30, 25, 35, 40, 50, 55, 60, 65, 70];    
Pt = 20; % Transmit power in dBm 

% Calculate Path Loss (Simple Log Model) 
PL = 10 * log10(d);  
RSSI = Pt - PL;

%% Adjusting Wireless Channel Contention (Higher CBR Interference) 
cof = 0.7;  % Increased interference

%% TCP Throughput Models 
time = linspace(0, sim_time, total_packets);

bic = ((log(1 + time.^1.7) .* (RSSI(5) / max(RSSI))) * packets_per_second * packet_size * 8 / 1e6) * (1 - cof);  
new_reno = ((log(1 + time.^1.5) .* (RSSI(2) / max(RSSI))) * packets_per_second * packet_size * 8 / 1e6) * (1 - cof);  
cubic = ((time.^0.45) .* (RSSI(4) / max(RSSI))) * packets_per_second * packet_size * 8 / 1e6 * (1 - cof);  
tahoe = ((exp(-0.15 * time) .* (RSSI(3) / max(RSSI))) * packets_per_second * packet_size * 8 / 1e6) * (1 - cof);  
reno = ((log(1 + time).^0.85 .* (RSSI(1) / max(RSSI))) * packets_per_second * packet_size * 8 / 1e6) * (1 - cof);

%% Adding Five CBR Nodes (Constant Bit Rate) 
cbr_rate = 2.5;   
cbr1 = cbr_rate * ones(1, total_packets);  
cbr2 = (cbr_rate - 0.2) * ones(1, total_packets);  
cbr3 = (cbr_rate - 0.4) * ones(1, total_packets);  
cbr4 = (cbr_rate - 0.6) * ones(1, total_packets);  
cbr5 = (cbr_rate - 0.8) * ones(1, total_packets);

%% Plot Wireless TCP & CBR Throughput Over Time 
figure;  
plot(time, bic, 'k', 'LineWidth', 2); hold on; 
plot(time, new_reno, 'g', 'LineWidth', 2);  
plot(time, cubic, 'b', 'LineWidth', 2);  
plot(time, tahoe, 'm', 'LineWidth', 2);  
plot(time, reno, 'r', 'LineWidth', 2);  
plot(time, cbr1, '--c', 'LineWidth', 2);  
plot(time, cbr2, '--y', 'LineWidth', 2);  
plot(time, cbr3, '--r', 'LineWidth', 2);  
plot(time, cbr4, '--g', 'LineWidth', 2);  
plot(time, cbr5, '--b', 'LineWidth', 2);  
legend('TCP BIC', 'TCP New Reno', 'TCP CUBIC', 'TCP Tahoe', 'TCP Reno', ...
       'CBR 1', 'CBR 2', 'CBR 3', 'CBR 4', 'CBR 5');
xlabel('Time (s)');  
ylabel('Throughput (Mbps)');  
title('Wireless TCP + CBR Throughput (Matching NetSim Order)');  
grid on;  
hold off;

%% Simulating Wireless Delay and Jitter 
delay = (10 + (d / 5) + randn(1, num_tcp_nodes + num_cbr_nodes) * 3) .* (1 + cof);    
jitter = std(delay) * rand(1, num_tcp_nodes + num_cbr_nodes);

%% Print Performance Metrics 
fprintf('Wireless Performance Metrics (TCP + 5 CBR Interference, Adjusted Order):\n'); 
fprintf('Variant\t\t Throughput (Mbps)\t Avg Delay (ms)\t Jitter (ms)\n'); 
fprintf('------------------------------------------------------------\n'); 
fprintf('TCP BIC\t\t %.4f\t\t %.4f\t\t %.4f\n', mean(bic), delay(5), jitter(5));  
fprintf('TCP New Reno\t %.4f\t\t %.4f\t\t %.4f\n', mean(new_reno), delay(2), jitter(2));  
fprintf('TCP CUBIC\t %.4f\t\t %.4f\t\t %.4f\n', mean(cubic), delay(4), jitter(4));  
fprintf('TCP Tahoe\t %.4f\t\t %.4f\t\t %.4f\n', mean(tahoe), delay(3), jitter(3));  
fprintf('TCP Reno\t %.4f\t\t %.4f\t\t %.4f\n', mean(reno), delay(1), jitter(1));  
fprintf('CBR 1\t\t %.4f\t\t %.4f\t\t %.4f\n', mean(cbr1), delay(6), jitter(6));  
fprintf('CBR 2\t\t %.4f\t\t %.4f\t\t %.4f\n', mean(cbr2), delay(7), jitter(7));  
fprintf('CBR 3\t\t %.4f\t\t %.4f\t\t %.4f\n', mean(cbr3), delay(8), jitter(8));  
fprintf('CBR 4\t\t %.4f\t\t %.4f\t\t %.4f\n', mean(cbr4), delay(9), jitter(9));  
fprintf('CBR 5\t\t %.4f\t\t %.4f\t\t %.4f\n', mean(cbr5), delay(10), jitter(10));

%% Wireless Network Topology Visualization (TCP + CBR) 
figure;

% Layout nodes in circular topology 
total_nodes = num_tcp_nodes + num_cbr_nodes; 
theta = linspace(0, 2*pi, total_nodes + 1); 
layout_radius = 20; 
x = layout_radius * cos(theta(1:end-1)); 
y = layout_radius * sin(theta(1:end-1)); 

% Access Point at the center 
plot(0, 0, 'ks', 'MarkerSize', 14, 'MarkerFaceColor', 'y');  
hold on;

% Plot TCP and CBR nodes with labels and connections 
for i = 1:total_nodes 
    if i <= num_tcp_nodes
        % TCP Nodes 
        plot(x(i), y(i), 'bo', 'MarkerSize', 12, 'MarkerFaceColor', 'c'); 
        label = sprintf('TCP Node %d\n(%dm)', i, d(i)); 
    else 
        % CBR Nodes 
        plot(x(i), y(i), 'rd', 'MarkerSize', 12, 'MarkerFaceColor', 'm'); 
        label = sprintf('CBR Node %d\n(%dm)', i - num_tcp_nodes, d(i)); 
    end
    line([0 x(i)], [0 y(i)], 'LineStyle', '--', 'Color', [0.4 0.4 0.4], 'LineWidth', 1.5); 
    text(x(i)*1.15, y(i)*1.15, label, ...
        'HorizontalAlignment', 'center', 'FontSize', 11, 'FontWeight', 'bold');
end

title('Wireless Topology: TCP + CBR Nodes around Access Point', 'FontWeight', 'bold'); 
xlabel('X-axis (m)', 'FontWeight', 'bold'); 
ylabel('Y-axis (m)', 'FontWeight', 'bold'); 
legend('Access Point', 'TCP Nodes', 'CBR Nodes', ...
    'Location', 'southoutside', 'Orientation', 'horizontal'); 
axis equal; 
grid on; 
set(gca, 'FontSize', 12); 
hold off;
