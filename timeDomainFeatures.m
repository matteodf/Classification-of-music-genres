%TIME DOMAIN FEATURES
%this also plots the features

function [E,Z] = timeDomainFeatures(y,fs,i,paths)

    [~,name,~] = fileparts(paths(i));
    filename = char(strcat('plots/timefeatures/',name,'.png'));
    
    windowLength = fs*0.02;
    [M,nf] = windowize(y,windowLength,floor(windowLength/2)); 
    Z=zeros(1,nf);
    E=zeros(1,nf);
    
    for j=1:nf % for each frame compute ZCR and Energy
        Z(j) = feature_zcr(M(:,j));
        E(j) = feature_energy(M(:,j));
    end
    
    %plot the features
    figure
    sgtitle(name)
    subplot(5,1,1); plot(y);
    xlabel('Time (samples)')
    title('Audio signal')
    axis tight
    subplot(5,1,2); plot(Z);
    xlabel('Time (frames)')
    title('Zero crossing rate')
    axis tight
    subplot(5,1,3); plot(E);
    xlabel('Time (frames)')
    title('Energy')
    axis tight
    subplot(5,1,4); histogram(Z);
    title('Histogram of ZCR')
    subplot(5,1,5); histogram(E);
    title('Histogram of Energy')
    saveas(gcf,filename);

end
