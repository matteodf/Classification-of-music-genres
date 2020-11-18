disp("Setting up...");

%============== SETTINGS FOR FULL SCREEN PLOTS ==============%
set(groot, 'defaultFigureUnits', 'normalized');
set(groot, 'defaultFigurePosition', [0 0 1 1]);

%================= SET NON-VISIBLE FIGURES ==================%
set(groot, 'DefaultFigureVisible', 'off')

%================== EXTRACTION OF THE FEATURES =====================%
addpath(genpath('functions')); %this contains all the functions needed to extract features.

saveJazzSongs;
close all; % this closes all figures. It's useful to avoid the sovrapposition 
           % of subplot titles ("sgtitle" function has this problem).

saveRockSongs;
close all;

saveClassicalSongs;
close all;

%====================== kNN ALGORITHM ========================%
%===================== for each feature ======================% 
addpath(genpath('kNN')); %this contains the different kNN algorithm for each type of feature used.

knnC;
knnE;
knnR;
knnS;
knnZ;
knnCeps;

%plot the results
filename = char("plots/kNN_separate_features.png");
figure
plot (k,rateCeps)
hold on
plot (k,rateC)
hold on
plot (k,rateE)
hold on
plot (k,rateR)
hold on
plot (k,rateS)
hold on
plot (k,rateZ)
hold off;
grid on;
title('Accuracy of kNN algorithm')
xlabel('k parameter')
ylabel('rate')
legend('MFCCs','Spectral Centroid', 'Energy', 'Spectral Rolloff', 'Spectral Spread', 'ZCR')
saveas(gcf,filename);

%====================== kNN ALGORITHM ========================%
%================== using features together ==================% 

knnTime;
knnFreqs;
knnAll;

%plot the results
filename = char("plots/kNN_freq_time_all.png");
figure
plot (k,rateTime)
hold on
plot (k,rateFreqs)
hold on
plot (k,rateAll)
hold off;
grid on;
title('Accuracy of kNN algorithm')
xlabel('k parameter')
ylabel('rate')
legend('Time','Frequency', 'All')
saveas(gcf,filename);