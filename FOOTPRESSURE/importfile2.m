function trialnames = importfile2(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   P001 = IMPORTFILE(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   P001 = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   P001 = importfile('P001.lst', 20, 22);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2020/01/07 18:14:17

%% Initialize variables.
delimiter = '\t';
if nargin<=2
    startRow = 20;
    endRow = 22;
end

%% Format for each line of text:
%   column1: categorical (%C)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%C%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'WhiteSpace', '', 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'WhiteSpace', '', 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
    dataArray{1} = [dataArray{1};dataArrayBlock{1}];
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
trialnames  = table(dataArray{1:end-1}, 'VariableNames', {'DAT'});

