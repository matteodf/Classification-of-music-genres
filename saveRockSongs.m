%========================= SAVE SONGS INTO A MATRIX ==============================%

addpath(genpath('songs/rock/'));
paths = ["bestOfYou.wav", "demoni.wav", "ifTheFireGoesOut.wav", "nucleare.wav", "radioNowhere.wav", "theWolf.wav"];
fsRock = zeros(1,6);

%save audio file into a matrix
disp("Saving rock songs...");
[y,fs] = audioread(paths(1));
y = sum(y,2);
y = nonzeros(y);
y = normalize(y);
len = length(y);
rock = y;
fsRock(1) = fs;

for i=2:6
    [y,fs] = audioread(paths(i));
    y=sum(y,2);
    y = nonzeros(y);
    y = normalize(y);

    if length(y)<len
        len = length(y);
        rock = [rock(1:len,:) y];
    else
        rock = [rock y(1:len,1)];
    end
    fsRock(i) = fs;

end

%====================== TIME-DOMAIN FEATURES =========================%

trainRockE = [];
testRockE = [];
trainRockZ = [];
testRockZ = [];

disp('Extracting time-domain features from rock songs');

for i=1:6
    [E,Z] = timeDomainFeatures(rock(:,i),fsRock(i),i,paths);
    if i < 4
        trainRockE = [trainRockE E];
        trainRockZ = [trainRockZ Z];
    else
        testRockE = [testRockE E];
        testRockZ = [testRockZ Z];
    end
end

%====================== FREQ-DOMAIN FEATURES =========================%

trainRockCeps = [];
testRockCeps = [];
trainRockC = [];
testRockC = [];
trainRockS = [];
testRockS = [];
trainRockR = [];
testRockR = [];

disp('Extracting frequency-domain features from rock songs');

for i=1:6
    [C,S,R,ceps] = frequencyDomainFeatures(rock(:,i),fsRock(i),paths(i));
    if i < 4
        trainRockCeps = [trainRockCeps ceps];
        trainRockC = [trainRockC C];
        trainRockS = [trainRockS S];
        trainRockR = [trainRockR R];
    else
        testRockCeps = [testRockCeps ceps];
        testRockC = [testRockC C];
        testRockS = [testRockS S];
        testRockR = [testRockR R];
    end
end

%====================== CREATE LABELS FOR KNN ===========================%

labelRock = repmat("rock",1,length(trainRockCeps));
testlabelRock = repmat("rock",1,length(testRockCeps));