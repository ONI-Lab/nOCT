clearvars; close all; 

strDir = 'D:\Codes\nOCT USC OCE\TestData\'; 
strSave = strDir; 

listFolder = dir(fullfile(strDir, '*.dat')); 

strFile = sprintf('%s%s', strDir, listFolder(2).name); 
cellArrays = readHeader(strFile); 
nNumberLines = cellArrays{2,3};
nLineLength = cellArrays{2,4};

for nFile = 1 : numel(listFolder)
    strFile = sprintf('%s%s', strDir, listFolder(nFile).name); 
    disp(strFile);
    [~, strName, ~] = fileparts(strFile); 

    [pdIMAQ, ~] = readDataFile(strFile, cellArrays); 
    
    fid = fopen(sprintf('%sTestOCE_%s.bin', strSave, strName), 'w'); 
    fwrite(fid, pdIMAQ, 'int16'); 
    fclose(fid); 


end







%% FUNCTION: read header
function cellArrays = readHeader(strFile)

fp = fopen(strFile, 'r', 'n', 'US-ASCII');
% read filename
nLength = fread(fp, 1, 'int');  strTest = transpose(char(fread(fp, nLength+1, 'char')));  strTest(1) = [];
strFilename = strTest;
clear nLength strTest;
% read frame number
nLength = fread(fp, 1, 'int');  strTest = transpose(char(fread(fp, nLength+1, 'char')));  strTest(1) = [];  eval(strTest);
clear nLength strTest;
% read number of data arrays

nLength = fread(fp, 1, 'int');  strTest = transpose(char(fread(fp, nLength+1, 'char')));  strTest(1) = [];  eval(strTest);
clear nLength strTest;
cellArrays{nNumberDataArrays+1, 5} = 0;
cellArrays{1,1} = strFilename;
cellArrays{1,2} = nFrameNumber;
clear strFilename nFrameNumber;
for nArrayNumber = 1 : nNumberDataArrays
    % read variable name, offset, number of lines, number of points, data type
    nLength = fread(fp, 1, 'int');  strTest = transpose(char(fread(fp, nLength+1, 'char')));  strTest(1) = [];  eval(strTest);  clear nLength strTest;
    nLength = fread(fp, 1, 'int');  strTest = transpose(char(fread(fp, nLength+1, 'char')));  strTest(1) = [];  eval(strTest);  clear nLength strTest;
    nLength = fread(fp, 1, 'int');  strTest = transpose(char(fread(fp, nLength+1, 'char')));  strTest(1) = [];  eval(strTest);  clear nLength strTest;
    nLength = fread(fp, 1, 'int');  strTest = transpose(char(fread(fp, nLength+1, 'char')));  strTest(1) = [];  eval(strTest);  clear nLength strTest;
    nLength = fread(fp, 1, 'int');  strTest = transpose(char(fread(fp, nLength+1, 'char')));  strTest(1) = [];  eval(strTest);  clear nLength strTest;
    cellArrays{nArrayNumber+1, 1} = strVar;
    cellArrays{nArrayNumber+1, 2} = nOffset;
    cellArrays{nArrayNumber+1, 3} = nNumberLines;
    cellArrays{nArrayNumber+1, 4} = nNumberPoints;
    cellArrays{nArrayNumber+1, 5} = strDataType;
    clear strVar nOffset nNumberLines nNumberPoints strDataType;
end % for nArrayNumber
clear nArrayNumber nNumberDataArrays;
fclose(fp);
clear fp ans; 

end

%% FUNCTION: read data file
function [pdIMAQ, pdDAQ] = readDataFile(strFile, cellArrays)

fp = fopen(strFile, 'r', 'l');
for nArrayNumber = 2 : size(cellArrays, 1)
    strVar        = cellArrays{nArrayNumber, 1};
    nOffset       = cellArrays{nArrayNumber, 2};
    nNumberLines  = cellArrays{nArrayNumber, 3};
    nNumberPoints = cellArrays{nArrayNumber, 4};
    strDataType   = cellArrays{nArrayNumber, 5};
    fseek(fp, nOffset, 'bof');
    strTest = sprintf('%s = fread(fp, [%d, %d], ''%s'');', strVar, nNumberPoints, nNumberLines, strDataType);
    eval(strTest);
    clear strVar nOffset nNumberLines nNumberPoints strDataType;
    clear strTest;
end
fclose(fp);
clear ans fp nArrayNumber;

end
