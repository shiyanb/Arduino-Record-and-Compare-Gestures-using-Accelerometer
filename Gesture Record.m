% configure pins
configurePin(a,'D8','pullup');        % trigger button
configurePin(a,'A0','AnalogInput');   % accelerometer x-axis
configurePin(a,'A1','AnalogInput');   % accelerometer z-axis

% calibrated accelerometer voltages (REPLACE VALUES AS NEEDED)
V_0g = 1.66;          % voltage at 0 g
V_1g = 1.70;           % voltage at 1 g
g = 9.81;               % gravity acceleration (m/s^2)

% parameters
N = 10000;              % maximum number of recording samples
gesture = 0;            % initial gesture number

% initialize recording array
accel_data = zeros(2,N);

% for each gesture
for gesture = 1:3
    
    % print current gesture
    if gesture == 1
        disp(['---------------------------']);
        disp('RECORD CIRCLE GESTURE');
    elseif gesture == 2
        disp(['---------------------------']);
        disp('RECORD VEE GESTURE');
    elseif gesture == 3
        disp(['---------------------------']);
        disp('RECORD DASH GESTURE');
    end

    
    started = 0;            % start flag
    stopped = 0;            % stop flag
    i = 0;                  % initial array index

    
    % keep recording data until stop flag set to 1
    while stopped == 0
        % read button and accelerometer voltages
        button = readDigitalPin(a,'D8');
        V_ax = readVoltage(a,'A0');
        V_az = readVoltage(a,'A1');
        
        % convert voltages to accelerations
        ax = g*(V_ax - V_0g)/(V_1g - V_0g);
        az = g*(V_az - V_0g)/(V_1g - V_0g);
        
        % update start and stop flags
        [started,stopped] = startStopRecording(button,started,stopped);

        
        %------------------------------------------------------------------
        %==================================================================
        % STAGE 2
        % -------
        % record data while button is pressed
        
        if button == 0
            i = i + 1
            accel_data(1,i) = ax;
            accel_data(2,i) = az;
            
        end

        %==================================================================
        %------------------------------------------------------------------
    end

    
    %----------------------------------------------------------------------
    %======================================================================
    % STAGE 2
    % -------
    % trim recorded data
    accel_data = accel_data (1:i)
    %======================================================================
    %----------------------------------------------------------------------
    
    
    % save gesture
    if gesture == 1
        accel_circle = accel_data;
        disp(['---------------------------']);
        disp('SAVING CIRCLE GESTURE TO FILE');
        save('accel_circle.mat','accel_circle');
    elseif gesture == 2
        accel_vee = accel_data;
        disp(['---------------------------']);
        disp('SAVING VEE GESTURE TO FILE');
        save('accel_vee.mat','accel_vee');
    elseif gesture == 3
        accel_dash = accel_data;
        disp(['---------------------------']);
        disp('SAVING DASH GESTURE TO FILE');
        save('accel_dash.mat','accel_dash');
    end
end