function [sqi] = ecg_analysis(ecg, fs)

%% check if the signal is upside down and correct it
    % Calculate the mean and standard deviation of the ECG signal
    mean_val = mean(ecg);
    std_dev = std(ecg);
    
    % Check if the mean is negative and the standard deviation is large
    if mean_val < 0 && std_dev > 0.5
        % The ECG signal is upside down
        disp('The ECG signal is upside down');
        ecg=-ecg;
    else
        % The ECG signal is not upside down
        disp('The ECG signal is not upside down');
    end

%% time vector
    % vettore tempo
    t = [0:length(ecg)-1];
    t=t*(1/fs); % tempo in secondi
    
    % plot
    figure()
    plot(t,ecg)
    
    %% SIGNAL QUALITY INDEX
    
    % Compute the power spectrum of the ECG signal
    [psd, f] = pwelch(ecg, [], [], [], fs);
    
    % Compute the signal-to-noise ratio (SNR)
    snr = 10*log10(mean(psd(f > 0.5 & f < 50)) / mean(psd(f > 50)));
    
    % Compute the SQI
    sqi = (snr - 20) / 30;
    
    % Print the results
    fprintf('Signal quality index: %f\n', sqi);
    
    % Interpret the results
    if sqi > 0.8
        fprintf('The ECG signal is of high quality.\n');
    elseif sqi > 0.5
        fprintf('The ECG signal is of moderate quality.\n');
    else
        fprintf('The ECG signal is of low quality.\n');
    end
    
    %% PRE-PROCESSING
    
    % Filtro passa-banda
    f1=40;
    f2=0.4;
    Wn=[f2 f1]*2/fs; % cutt off based on fs
    N = 3;   % order of 3 less processing
    [a,b] = butter(N,Wn,'bandpass');  % bandpass filtering
    ECG = filtfilt(a,b,ecg);
    
    figure()
    plot(t,ECG)
    title('ECG filtrato')
    xlabel('Time (s)')

    %% Filtro notch per eliminare il rumore di rete (50 Hz)
    % Design a 2nd-order notch filter with a center frequency of 50 Hz and a bandwidth of 2 Hz
    w0=50/(fs/2); %frequenza
    Q=1; %quality factor
    bandwidth=w0/Q; 
    [b,a] = iirnotch(w0,bandwidth); %filtro notch second ordine
    % Apply the filter to the ECG data using zero-phase filtering
    ecg_filtrato=filtfilt(b,a,ECG); %filtro ecg col notch
    
    %%
    % Design a 2nd-order notch filter with a center frequency of 50 Hz and a bandwidth of 2 Hz
    % [b, a] = butter(2, [49 51]/(fs/2), 'stop');
    % 
    % % Apply the filter to the ECG data using zero-phase filtering
    % ecg_filtrato = filtfilt(b, a, ecg);

    %% Plot ecg filtrato
    figure()
    plot(t,ecg_filtrato)
    title('ECG filtrato')
    xlabel('Time (s)')

    % Subplot ecg and filtered ecg
    figure()
    a(1)=subplot(2,1,1)
    plot(t,ecg)
    a(2)=subplot(2,1,2)
    plot(t, ecg_filtrato)
    linkaxes(a,'x')
    
    %% Signal quality index after pre processing
    % Compute the power spectrum of the ECG signal
    [psd, f] = pwelch(ecg_filtrato, [], [], [], fs);
    
    % Compute the signal-to-noise ratio (SNR)
    snr = 10*log10(mean(psd(f > 0.5 & f < 50)) / mean(psd(f > 50)));
    
    % Compute the SQI
    sqi = (snr - 20) / 30;
    
    % Print the results
    fprintf('Signal quality index: %f\n', sqi);
    
    % Interpret the results
    if sqi > 0.8
        fprintf('The ECG filtered signal is of high quality.\n');
    elseif sqi > 0.5
        fprintf('The ECG filtered signal is of moderate quality.\n');
    else
        fprintf('The ECG filtered signal is of low quality.\n');
    end




    %% high pass filter
    % Set the cutoff frequency and filter order
    cutoff_frequency = 5; % Hz
    ecg_filtered=[];

    for ord = 1 : 4
    
         % Design the highpass filter using the butter function
         [b, a] = butter(ord, cutoff_frequency/(fs/2), 'high');
    
        % Apply the filter to the ECG signal using the filter function
        ecg_filtered(ord,:) = filter(b, a, ecg_filtrato);
    end

    figure()
    for i = 1:4
        plot(ecg_filtered(i,:))
        hold on
    end


end

