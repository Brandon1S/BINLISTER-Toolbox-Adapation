offset = 50;
pxPerChar = 10;
numRegions = 4;
regionNames = {'Beginning', 'PreTarget', 'Target_word', 'Ending'};
conditionColName = 'trigcondition';
itemColName = 'trigitem';
txtFilePath = 'C:\Users\ItsBr\Documents\MATLAB\eeglab_current\eeglab2024.2\plugins\eyesort\datasets\WTS Datasource_Final_with_IAs_102824_.txt';

EEG = compute_text_based_ia(EEG, txtFilePath, offset, pxPerChar, ...
                            numRegions, regionNames, conditionColName, itemColName);