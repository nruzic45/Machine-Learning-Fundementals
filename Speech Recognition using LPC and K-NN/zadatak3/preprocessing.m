function y = preprocessing(x,fs)


% filtracija
N = 2048;
Wn = [60 3500]/(fs/2); % fs/2 normalizacija zbog digitalnog filtra
[B,A] = butter(6,Wn,'bandpass');

xf = filter(B,A,x); % filtrirani signal


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% segmentacija 

wl = 20e-3*fs;

E = zeros(size(xf)); % KVE - kratkovremenska energija
Z = zeros(size(xf)); % ZCR - zero crossing rate
for i = wl:length(xf)
    rng = (i - wl + 1):i-1;
    E(i) = sum(xf(rng).^2);
    Z(i) = sum(abs(sign(xf(rng + 1)) - sign(xf(rng))));
end

Z = Z/wl/2;
time = 1/fs:1/fs:length(E)/fs;

% Segmentacija

ITU = 0.1*max(E);
ITL = 0.0001*max(E);

% pravimo niz pocetaka i kraja reci

pocetak = [];
kraj = [];

% poredjenje sa vecim pragom ITU
for i = 2:length(E)
    if E(i) > ITU && E(i-1) < ITU
        pocetak = [pocetak i];
    end
    if E(i) < ITU && E(i-1) > ITU
        kraj = [kraj i];
    end
end

rec = zeros(1,length(E));

for i = 1:length(pocetak)
    rec(pocetak(i):kraj(i)) = max(E);
end


for i = 1:length(pocetak)
    pomeraj = pocetak(i);
    while E(pomeraj)>ITL
        pomeraj = pomeraj - 1;
    end
    pocetak(i) = pomeraj; % azuriramo pocetak reci
end

for i = 1:length(kraj)
    pomeraj = kraj(i);
    while E(pomeraj)>ITL
        pomeraj = pomeraj + 1;
    end
    kraj(i) = pomeraj; % azuriramo pocetak reci
end

% uklanjanje duplikata (sada smo spojili dve reci tako sto one imaju isti
% pocetak i kraj, ali oni su duplikati)

pocetak = unique(pocetak);
kraj = unique(kraj);


y = x(pocetak:kraj);

end