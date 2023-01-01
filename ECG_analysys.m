clear all
clc
close all

% Open file 

% Set the directory containing the data files
data_directory = 'C:\Users\vitto\Desktop\BIOMEDICAL SIGNAL PROCESSING LAB\assignment\training2017';
basePath = 'C:\Users\vitto\Desktop\BIOMEDICAL SIGNAL PROCESSING LAB\assignment\results';

fs=300; % Sampling frequency

% Get a list of all the files in the data directory
data_files = dir(data_directory);
data_files = dir(fullfile(data_directory, '*.mat'));

% Loop through each file
for i = 1:length(data_files)
   % Get the file name
   file_name = data_files(i).name;
    
    % visualizzo nome file 
    fprintf(file_name);
    fprintf('\n');

   % Check if the file is a MATLAB data file
   if strcmp(file_name(end-3:end), '.mat')
       % Load the data file
       data = load(fullfile(data_directory, file_name));
   end

   ecg=data.val;

   %% Funzione con analisi ecg (pre processing etc.)
    [sqi]=ecg_analysis(ecg, fs);
    
    %% Salvataggio workspace
    mkdir(basePath, file_name);

    filename = string(strcat(basePath, '\', file_name, '\', 'workspace','.mat'));
    save(filename); 


    %% Salvataggio figure

    filename_ecg = string(strcat(basePath, '\', file_name, '\', 'ecg_raw', '.fig')); 
    filename_ecg_filtered =string(strcat(basePath, '\', file_name, '\', 'ecg_filtered', '.fig'));
    filename_subplot =string(strcat(basePath, '\', file_name, '\', 'ecg_subplot', '.fig'));

    savefig(1, filename_ecg); 
    savefig(3, filename_ecg_filtered); 
    savefig(4, filename_subplot); 

    close all

end




