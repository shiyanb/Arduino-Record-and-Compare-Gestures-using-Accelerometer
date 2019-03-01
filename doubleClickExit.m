function [exitFlag,wasClicked,tClick] = doubleClickExit(button,wasClicked,tClick,dt_click)

exitFlag = 0;

if button == 0 && wasClicked == 0
    if etime(clock,tClick) < dt_click
        exitFlag = 1;
    end
end

if button == 0
    wasClicked = 1;
    tClick = clock;
else
    wasClicked = 0;
end