function [started,stopped] = startStopRecording(button,started,stopped)

if button == 1 && started == 1
    stopped = 1;
    disp(['---------------------------']);
    disp('STOPPING');
elseif button == 0 && started == 0
    started = 1;
    disp(['---------------------------']);
    disp('STARTING');
end