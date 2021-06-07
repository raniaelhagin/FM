clc
clear

%% 
%{
read audio file and find the spectrum
%}

fileName = 'eric.wav';
[y, Fs] = audioread(fileName);  %% read audio file y >> sampled data
% sound(y, Fs); % play the samples 

% find the spectrum 
Y = fftshift(fft(y));
Ymag = abs(Y);     % magnitude spectrum
Yphase = angle(Y); % phase spectrum

Fvec = linspace(-Fs/2, Fs/2, length(Y)); % frquency vector

% plot the spectrum
figure;
subplot(2, 1, 1); plot(Fvec, Ymag); title('Magnitude Spectrum');
subplot(2, 1, 2); plot(Fvec, Yphase); title('Phase Spectrum');

%% 
%{
 apply an ideal low pass filter with f = 4kHz
%}
SPHz = length(Y)/Fs;  % sample per Hz 
lp_edge1 = round(20000*SPHz); % 20kHz = 24kHz - 4kHz 
lp_edge2 = round(length(Y)-(20000*SPHz)+1);

Y([1:lp_edge1 lp_edge2:411248]) = 0;
Ymag_filtered = abs(Y);     % magnitude spectrum
Yphase_filtered = angle(Y); % phase spectrum
figure;
subplot(2, 1, 1); plot(Fvec, Ymag_filtered); title('Magnitude Spectrum after LPF');
subplot(2, 1, 2); plot(Fvec, Yphase_filtered); title('Phase Spectrum after LPF');
%% 
%{
obtain the filtered signal in time domain with BW = 4kHz 

%}

Y_filtered = Y(lp_edge1:lp_edge2);
Y_filtered_mag = abs(Y_filtered);
Y_filtered_phase = angle(Y_filtered);

Fs_filter = 8000;   % from -4kHz to 4kHz 
Fvec_filter = linspace(-Fs_filter/2, Fs_filter/2, length(Y_filtered));

figure;
subplot(2, 1, 1); plot(Fvec_filter, Y_filtered_mag); 
title('Magnitude Spectrum after LPF with BW = 4kHz');
subplot(2, 1, 2); plot(Fvec_filter, Y_filtered_phase); 
title('Phase Spectrum after LPF with BW = 4kHz');

y_filtered = real(ifft(ifftshift(Y_filtered)));
% audiowrite('eric_filtered.wav', y_filtered, Fs_filter);
sound(y_filtered, Fs_filter);

%% 
%{
Generate NBFM signal 
fc = 100kHz
Fs_NBFM = 5 * fc
plot the resulting spectrum 
%}










