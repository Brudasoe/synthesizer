function x = singen(f,fs,duration,amp_1,amp_2,amp_3,amp_4,amp_5,typeofWave)
% Input
%   f        - frequency of sinusoid
%   fs       - sampling frequency
%   duration - duration of signal in seconds
% Output
%   x        - vector of sinusoid samples
n = [0:fs*duration]';
switch typeofWave
    case 'sine'
        x = amp_1*sin(2*pi*f/fs*n);
        

    case 'sawtooth'
        x1 = amp_1*sin(2*pi*f/fs*n);
        x2= amp_2*sin(2*pi*f/fs*n*2);
        x3= amp_3*sin(2*pi*f/fs*n*4);
        x4= amp_4*sin(2*pi*f/fs*n*8);
        x5= amp_5*sin(2*pi*f/fs*n*16);
        x=x1+x2+x3+x4+x5;
    case 'square'
        x1 = amp_1*sin(2*pi*f/fs*n);
        x2= amp_2*sin(2*pi*f/fs*n*3);
        x3= amp_3*sin(2*pi*f/fs*n*5);
        x4= amp_4*sin(2*pi*f/fs*n*7);
        x5= amp_5*sin(2*pi*f/fs*n*9);
        x=x1+x2+x3+x4+x5;
end