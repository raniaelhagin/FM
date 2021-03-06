clc
clear

%% 
%{ 
read audio file and find the spectrum
%}

fileName = 'eric.wav';
[y, Fs] = audioread(fileName);  % read audio file y >> sampled data
sound(y, Fs); % play sound signal 


% find the spectrum 
Y = fftshift(fft(y));
Ymag = abs(Y);     % magnitude spectrum
Yphase = angle(Y); % phase spectrum

Fvec = linspace(-Fs/2, Fs/2, length(Y)); % frquency vector

% plot the signal in time domain
figure;
subplot(4, 2, [1 2]); plot(y); 
title('The message signal in time domain');

% plot the spectrum
subplot(4, 2, 3); plot(Fvec, Ymag); 
title('Magnitude Spectrum of the message signal');
subplot(4, 2, 4); plot(Fvec, Yphase); 
title('Phase Spectrum of the message signal');

%% 
%{
 apply an ideal low pass filter with BW = 4kHz
%}

SPHz = length(Y)/Fs;  % sample per Hz 

% low pass filter edges
lp_edge1 = round(20000*SPHz); % 20kHz = 24kHz - 4kHz  
lp_edge2 = round(length(Y)-(20000*SPHz)+1);

Y([1:lp_edge1 lp_edge2:length(Y)]) = 0;  % apply the low pass filter 

Ymag_filtered = abs(Y);     % magnitude spectrum after LPF
Yphase_filtered = angle(Y); % phase spectrum after LPF

% Plot spectrum after LPF
subplot(4, 2, 5); plot(Fvec, Ymag_filtered); 
title('Magnitude Spectrum of the message signal after LPF');
subplot(4, 2, 6); plot(Fvec, Yphase_filtered); 
title('Phase Spectrum of the message signal after LPF');

% obtain the filtered signal in time domain 
y_filtered = real(ifft(ifftshift(Y)));

% plot the signal in time domain after LPF
subplot(4, 2, [7 8]); plot(y_filtered); 
title('The message signal in time domain after LPF');

pause(length(y)/Fs);    % wait until the sound stops
sound(y_filtered, Fs);


%% 
%{
Generate NBFM signal 
fc = 100kHz
Fs_NBFM = 5 * fc
plot the resulting spectrum 
%}
a = 10;
fc = 100000;
Fs_NBFM = 5*fc;
kf = 0.5;  % use it small enough to get NBFM signal 

wc = 2*pi*fc;
Ns = length(Y)*Fs_NBFM/Fs;
duration = Ns/Fs_NBFM;
t = transpose(linspace(0, duration, Ns));

% resampling the filtered signal
y_resampled = resample(y_filtered, Fs_NBFM, Fs);

% using general FM eqn: a * cos((wc*t) + (kf*cumsum(y_filtered)))
% using NBFM eqn:(a*cos(wc*t)) - (a * kf * sin(wc.*t) .* cumsum(y_filtered))
% got the same output 
s_NBFM = a*cos(wc*t)-a*kf*sin(wc*t).*cumsum(y_resampled(1:end-1));

% plot the modulated signal in time domain 
figure; 
subplot(2, 2, [1 2]);plot(s_NBFM); 
title('S_N_B_F_M(t): Modulated signal');

% find the spectrum of the modulated signal 
S_NBFM = fftshift(fft(s_NBFM)); 
S_NBFM_mag = abs(S_NBFM);      % magnitude spectrum of the modulated signal
S_NBFM_phase = angle(S_NBFM);  % phase spectrum of the modulated signal

F_NBFM_vec = linspace(-Fs_NBFM/2, Fs_NBFM/2, length(S_NBFM)); 

%plot the spectrum of the modulated signal 
subplot(2, 2, 3); plot(F_NBFM_vec, S_NBFM_mag);
title('Magnitude Spectrum of S_N_B_F_M(f)');
subplot(2, 2, 4); plot(F_NBFM_vec, S_NBFM_phase); 
title('Phase Spectrum of S_N_B_F_M(f)');

%% 
%{
 Demodulation 
%}


figure;
subplot(3, 2, 1); plot(y);
title('Message Signal');
subplot(3, 2, 2); plot(s_NBFM);
title('Modulated Signal');

% apply envelope detecttion 
env_det_s = sqrt(a^2 + (a*kf*cumsum(y_resampled(1:end-1)).^2)); 
subplot(3, 2, 3); plot(env_det_s);
title('Demodulated Signal after envelope detector');

diff_s = diff(env_det_s);             % differentiation of env_det_s 
subplot(3, 2, 4); plot(diff_s);
title('Diff of the Demodulated Signal after envelope detector');

signal = resample(diff_s, Fs, Fs_NBFM);


subplot(3, 2, 5); plot(signal);
title('Demodulated Signal');
% 
% amplification 
signal = signal*kf;
subplot(3, 2, 6); plot(signal);
title('Demodulated Signal after amplification');

pause(length(y)/Fs);
sound(signal, Fs);








