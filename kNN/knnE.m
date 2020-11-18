all_train = [trainJazzE trainRockE trainClassicalE];
all_labels = [labelJazz labelRock labelClassical];
all_test = [testJazzE testRockE testClassicalE];
correct_label = [testlabelJazz testlabelRock testlabelClassical];

k=[1 5 10 15 20];
rateE = zeros(1,5);
for kk=1:length(k)
    disp(['set-up the kNN... number of neighbors: ',mat2str(k(kk))])
    Mdl = fitcknn(all_train',all_labels','NumNeighbors',k(kk));
    
    % test the kNN
    predicted_label = predict(Mdl,all_test');
    
    % measure the performance
    correct = 0;
    for i=1:length(predicted_label)
        if predicted_label(i)==correct_label(i)
            correct=correct+1;            
        end
    end
    %disp('recognition rate:')
    rateE(kk) = (correct/length(predicted_label))*100;
end
[a,b]=max(rateE);
disp('----------results using Energy----------------')
disp(['the maximum recognition rate is ',mat2str(a)])
disp(['and it is achieved with ',mat2str(k(b)),' nearest neighbors'])
disp('---------------------------------------------------------')