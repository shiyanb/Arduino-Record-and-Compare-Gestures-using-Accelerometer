% load training gestures
load('accel_vee.mat');
load('accel_circle.mat');
load('accel_dash.mat');

% configure pins
configurePin(a,'D8','pullup');        % trigger button
configurePin(a,'A0','AnalogInput');   % accelerometer x-axis
configurePin(a,'A1','AnalogInput');   % accelerometer z-axis

% calibrated accelerometer voltages
V_0g = 1.6862;          % voltage at 0 g
V_1g = 2.0283;           % voltage at 1 g
g = 9.81;               % gravity acceleration (m/s^2)

% parameters
N = 10000;              % maximum number of recording samples
dt_click = 0.25;        % double-click time (time between clicks) (s)
wasClicked = 1;         % click flag
tClick = clock;         % initial click time

%--------------------------------------------------------------------------
%==========================================================================
% STAGE 5
% -------
% add a threshold variable to differentiate between a gesture being
% recognized or not

                            % threshold distance metric
                            
threshold = 2000;
%==========================================================================
%--------------------------------------------------------------------------


% infinite loop to keep recognizing gestures
while true
    
    % initialization
    accel_data = zeros(2,N);    % acceleration data array
    started = 0;                % start flag
    stopped = 0;                % stop flag
    i = 0;                      % array index

    disp(['---------------------------']);
    disp('WAITING (DOUBLE-CLICK TO EXIT)');
    % loop to keep collecting data until recording stops
    while stopped == 0
        % read button and accelerometer voltages
        button = readDigitalPin(a,'D8');
        V_ax = readVoltage(a,'A0');
        V_az = readVoltage(a,'A1');
        
        % convert voltages to accelerations
        ax = g*(V_ax - V_0g)/(V_1g - V_0g);
        az = g*(V_az - V_0g)/(V_1g - V_0g);
        
        % update start and stop conditions
        [started,stopped] = startStopRecording(button,started,stopped);

        % check for double-click and set exit flag
        [exitFlag,wasClicked,tClick] = doubleClickExit(button,wasClicked,tClick,dt_click);
        
        % exit recording loop if exit flag is 1
        if exitFlag == 1
            disp(['---------------------------']);
            disp('EXITING');
            break;
        end
        
        %------------------------------------------------------------------
        %==================================================================
        % STAGE 2
        % -------
        % record data if button is pressed
        
        if button == 0
            i = i + 1;
            accel_data(1,i) = ax;
            accel_data(2,i) = az;
            
        end 
            
        
        
        
     
        %==================================================================
        %------------------------------------------------------------------
    end
    
    % exit infinite loop if exit flag is 1
    if exitFlag == 1
        break;
    end
    
    %----------------------------------------------------------------------
    %======================================================================
    % STAGE 2
    % -------
    % trim recorded data (only keep i samples)
    
    accel_data = accel_data (1:i)

    %======================================================================
    %----------------------------------------------------------------------
    
    
    %----------------------------------------------------------------------
    %======================================================================
    % STAGE 4
    % -------
    % get distance metric for DTW applied to each training gesture
    
    dist_circle = dtw(accel_data, accel_circle);
    dist_vee = dtw(accel_data, accel_vee);
    dist_dash = dtw(accel_data, accel_dash);
    
    
    
  
    
    
    
    % find minimum distance metric
    
    [dist_min, idx_min] = min([dist_circle dist_vee dist_dash]);

    %======================================================================
    %----------------------------------------------------------------------
    
    
    % print distance metrics
    disp(['---------------------------']);
    disp(['    DISTANCE SCORES:']);
    disp(['    Circle: ' num2str(dist_circle)]);
    disp(['    Vee:    ' num2str(dist_vee)]);
    disp(['    Dash:   ' num2str(dist_dash)]);
    disp(['---------------------------']);
    
    %----------------------------------------------------------------------
    %======================================================================
    % STAGE 5
    % -------
    % print recognized gesture if distance metric less than threshold
    % (modify the if-else chain below)
    if idx_min == 1 && dist_circle < threshold
        disp(['    CIRCLE GESTURE RECOGNIZED']);
    elseif idx_min == 2 && dist_vee < threshold
        disp(['    VEE GESTURE RECOGNIZED']);
    elseif idx_min == 3 && dist_dash < threshold
        disp(['    DASH GESTURE RECOGNIZED']);
    end
    %======================================================================
    %----------------------------------------------------------------------
    
    % show bar graph of distance metrics
    clf
    bar([dist_circle dist_vee dist_dash]);
    set(gca,'XTickLabel',{'Circle','Vee','Dash'});
    ylabel('Distance Metric');
    getframe;
end
