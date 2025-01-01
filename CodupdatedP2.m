% Load pre-trained GoogLeNet
net = googlenet;

% Data augmentation
rootFolder = 'C:\Users\alexb\Desktop\Facultate\RestPoze';
imds = imageDatastore(rootFolder, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[trainImgs, valImgs, testImgs] = splitEachLabel(imds, 0.6, 0.2, 0.2, 'randomized');

targetSize = net.Layers(1).InputSize;

pixelRange = [-30 30];
scaleRange = [0.9 1.1];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection', true, ...
    'RandXTranslation', pixelRange, ...
    'RandYTranslation', pixelRange, ...
    'RandXScale', scaleRange, ...
    'RandYScale', scaleRange);

augTrain = augmentedImageDatastore(targetSize(1:2), trainImgs, 'DataAugmentation', imageAugmenter);
augVal = augmentedImageDatastore(targetSize(1:2), valImgs, 'DataAugmentation', imageAugmenter);
augTest = augmentedImageDatastore(targetSize(1:2), testImgs, 'DataAugmentation', imageAugmenter);

% Remove last layers and add new ones
lgraph = layerGraph(net);
lgraph = removeLayers(lgraph, {'loss3-classifier', 'prob', 'output'});

numClasses = numel(categories(imds.Labels));
newLayers = [
    fullyConnectedLayer(numClasses, 'Name', 'fc', 'WeightLearnRateFactor', 10, 'BiasLearnRateFactor', 10)
    softmaxLayer('Name', 'softmax')
    classificationLayer('Name', 'classoutput')];

lgraph = addLayers(lgraph, newLayers);
lgraph = connectLayers(lgraph, 'pool5-drop_7x7_s1', 'fc');

% Training options
opts = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.001, ...
    'MaxEpochs', 6, ...
    'MiniBatchSize', 32, ...
    'ValidationData', augVal, ...
    'ValidationFrequency', 10, ...
    'Plots', 'training-progress');

% Train the network
convnetP2 = trainNetwork(augTrain, lgraph, opts);

% Save the trained model
save('plant_disease_modelP2.mat', 'convnetP2');

% Classify test images
preds = classify(convnetP2, augTest);
actual = testImgs.Labels;
numCorrect = nnz(preds == actual);

% Display confusion chart
confusionchart(actual, preds);