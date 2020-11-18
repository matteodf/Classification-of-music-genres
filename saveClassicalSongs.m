%========================= SAVE SONGS INTO A MATRIX ==============================%

addpath(genpath('songs/classical/')); 
paths = ["concertinoDaCamera.wav", "dansesExotiques.wav", "fantaisieImpromptu.wav", "fantasia.wav", "rapsodie.wav", "scaramouche.wav"];
fsClassical = zeros(1,6);

%save audio file into a matrix
disp("Saving classical songs...");
[y,fs] = audioread(paths(1));
y = sum(y,2);
y = nonzeros(y);
y = normalize(y);
len = length(y);
classical = y;
fsClassical(1) = fs;

for i=2:6
    [y,fs] = audioread(paths(i));
    y=sum(y,2);
    y = nonzeros(y);
    y = normalize(y);
    if length(y)<len
        len = length(y);
        classical = [classical(1:len,:) y];
    else
        classical = [classical y(1:len,1)];
    end
    fsClassical(i) = fs;

end

%====================== TIME-DOMAIN FEATURES =========================%

trainClassicalE = [];
testClassicalE = [];
trainClassicalZ = [];
testClassicalZ = [];

disp('Extracting time-domain features from classical songs');

for i=1:6
    [E,Z] = timeDomainFeatures(classical(:,i),fsClassical(i),i,paths);
    if i < 4
        trainClassicalE = [trainClassicalE E];
        trainClassicalZ = [trainClassicalZ Z];
    else
        testClassicalE = [testClassicalE E];
        testClassicalZ = [testClassicalZ Z];
    end
end

%====================== FREQ-DOMAIN FEATURES ==========================%

trainClassicalCeps = [];
testClassicalCeps = [];
trainClassicalC = [];
testClassicalC = [];
trainClassicalS = [];
testClassicalS = [];
trainClassicalR = [];
testClassicalR = [];

disp('Extracting frequency-domain features from classical songs');

for i=1:6
    [C,S,R,ceps] = frequencyDomainFeatures(classical(:,i),fsClassical(i),paths(i));
    if i < 4
        trainClassicalCeps = [trainClassicalCeps ceps];
        trainClassicalC = [trainClassicalC C];
        trainClassicalS = [trainClassicalS S];
        trainClassicalR = [trainClassicalR R];
    else
        testClassicalCeps = [testClassicalCeps ceps];
        testClassicalC = [testClassicalC C];
        testClassicalS = [testClassicalS S];
        testClassicalR = [testClassicalR R];
    end
end

%====================== CREATE LABELS FOR KNN ===========================%

labelClassical = repmat("classical",1,length(trainClassicalCeps));
testlabelClassical = repmat("classical",1,length(testClassicalCeps));