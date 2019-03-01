
% create two signals stretched over different number of samples
N1 = 100;
N2 = 150;
t1 = linspace(0,1,N1);
t2 = linspace(0,1,N2);
xNoise = 0;
x1 = cos(6*pi*t1) + xNoise*randn(1,N1);
x2 = cos(6*pi*(t2).^2) + xNoise*randn(1,N2);

% plot signals
figure
subplot(1,2,1)
plot(1:N1,x1,'r','linewidth',2)
grid on
xlim([1 N2]);
title('Signal 1');
subplot(1,2,2)
plot(1:N2,x2,'b','linewidth',2);
grid on
xlim([1 N2]);
title('Signal 2');

% APPLY DYNAMIC TIME WARPING
%=========================================================================
% use appropriate function to match signals x1 and x2

%=========================================================================