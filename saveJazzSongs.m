%========================= SAVE SONGS INTO A MATRIX ==============================%

addpath(genpath('songs/jazz/'));
paths = ["deltaCityBlues.wav", "humanNature.wav", "lingus.wav", "manFacingNorth.wav", "spain.wav", "sugar.wav"];
fsJazz = zeros(1,6);

%save audio file into a matrix
disp("Saving jazz songs...");
[y,fs] = audioread(paths(1));
y = sum(y,2);
y = nonzeros(y);
y = normalize(y);
len = length(y);
jazz = y;
fsJazz(1) = fs;

for i=2:6
    [y,fs] = audioread(paths(i));
    y = sum(y,2);
    y = nonzeros(y);
    y = normalize(y);
    if length(y)<len
        len = length(y);
        jazz = [jazz(1:len,:) y];
    else
        jazz = [jazz y(1:len,1)];
    end
    fsJazz(i) = fs;

end

%====================== TIME-DOMAIN FEATURES =========================%

trainJazzE = [];
testJazzE = [];
trainJazzZ = [];
testJazzZ = [];

disp('Extracting time-domain features from jazz songs');

for i=1:6
    [E,Z] = timeDomainFeatures(jazz(:,i),fsJazz(i),i,paths);
    if i < 4
        trainJazzE = [trainJazzE E];
        trainJazzZ = [trainJazzZ Z];
    else
        testJazzE = [testJazzE E];
        testJazzZ = [testJazzZ Z];
    end
end

%====================== FREQ-DOMAIN FEATURES ==========================%

trainJazzCeps = [];
testJazzCeps = [];
trainJazzC = [];
testJazzC = [];
trainJazzS = [];
testJazzS = [];
trainJazzR = [];
testJazzR = [];

disp('Extracting frequency-domain features from jazz songs');

for i=1:6
    [C,S,R,ceps] = frequencyDomainFeatures(jazz(:,i),fsJazz(i),paths(i));
    if i < 4
        trainJazzCeps = [trainJazzCeps ceps];
        trainJazzC = [trainJazzC C];
        trainJazzS = [trainJazzS S];
        trainJazzR = [trainJazzR R];
    else
        testJazzCeps = [testJazzCeps ceps];
        testJazzC = [testJazzC C];
        testJazzS = [testJazzS S];
        testJazzR = [testJazzR R];
    end
end

%====================== CREATE LABELS FOR KNN ===========================%

labelJazz = repmat("jazz",1,length(trainJazzCeps));
testlabelJazz = repmat("jazz",1,length(testJazzCeps));