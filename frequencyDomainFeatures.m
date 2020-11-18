%FREQUENCY DOMAIN FEATURES
%this also plots the features

function [C,S,R,ceps]=frequencyDomainFeatures(y,fs,path)

    [~,name,~] = fileparts(path);
    filename = char(strcat('plots/freqfeatures/',name,'.png'));
    filenameMFCC = char(strcat('plots/mfcc/',name,'.png'));

    windowLength = fs*0.02;
    Ham = window(@hamming, windowLength); % smooths the data in the window
    [M,nf] = windowize(y,windowLength,floor(windowLength/2));
    mfccParams = feature_mfccs_init(windowLength, fs); % initialization of MFCCs

    % initialization of the feature vectors
    C=zeros(1,nf);
    S=zeros(1,nf);
    R=zeros(1,nf);
    ceps=zeros(13,nf);

    for i=1:nf
        frame = M(:,i);
        frame  = frame .* Ham;
        frameFFT = getDFT(frame, fs);
        [C(i),S(i)] = feature_spectral_centroid(frameFFT, fs);
        R(i) = feature_spectral_rolloff(frameFFT, 0.9);
        ceps(1:13,i) = feature_mfccs(frameFFT, mfccParams);
    end

    %save plots
    figure
    sgtitle(name)
    subplot(3,2,1)
    plot(C)
    title('spectral centroid - plot')
    subplot(3,2,3)
    plot(S)
    title('spectral spread - plot')
    subplot(3,2,5)
    plot(R)
    title('spectral roll-off - plot')
    subplot(3,2,2)
    histogram(C)
    title('spectral centroid - histogram')
    subplot(3,2,4)
    histogram(S)
    title('spectral spread - histogram')
    subplot(3,2,6)
    histogram(R)
    title('spectral roll-off - histogram')
    saveas(gcf,filename);

    figure
    imagesc(ceps)
    title(['MFCC of ', name])
    saveas(gcf,filenameMFCC);

end