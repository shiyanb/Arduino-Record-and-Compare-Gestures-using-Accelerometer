% configure pins
configurePin(a,'D8','pullup');        % trigger button
configurePin(a,'A0','AnalogInput');   % accelerometer x-axis
configurePin(a,'A1','AnalogInput');   % accelerometer z-axis

% calibrated accelerometer voltages
V_0g = 1.7107;        % voltage at 0 g
V_1g = 2.043;         % voltage at 1 g
g = 9.81;             % gravity acceleration (m/s^2)

while true
    button = readDigitalPin(a,'D8');
    V_ax = readVoltage(a,'A0');
    V_az = readVoltage(a,'A1');

    % convert voltages to accelerations
    ax = g*(V_ax - V_0g)/(V_1g - V_0g);
    az = g*(V_az - V_0g)/(V_1g - V_0g);
    
    % display output
    fprintf('V_ax = %7.4f V | V_az = %7.4f V | ax = %8.4f m/s^2 | az = %8.4f m/s^2\n',V_ax,V_az,ax,az);
    
    if button == 0
        break;
    end
end