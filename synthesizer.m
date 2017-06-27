time=2;

target = [0.9;0.25;0];
gain = [0.0010;0.0010;0.00075];
duration = [100;200;100];
adsr = adsr_gen(target,gain,duration,time);

%  plot(adsr);

octave=30;
note_freq=27.50;
f0 = octave*note_freq;
fs = 16384;
x = singen(f0,fs,time-1/fs,1,0.4,0.2);
y = adsr .* x;  % Modulate
sound(y,fs);

% plot(y)
N=length(y);
dt=1/fs;
Xc=fft(y);
df=1/(N*dt);
f=df*(0:N-1);
% plot(f(1:N/2+1),abs(Xc(1:N/2+1))/(N/2));
% title 'Chirp from time domain'
spectrogram(y)