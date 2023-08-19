function klasa = feature_extraction(x,fs)


win = 20*1e-3*fs;
p = 14;
num = round(length(x)/win);
LPC_kor = zeros(p + 1, num);
LPC_ugr = zeros(p + 1, num);
k = 1;
recon = [];
for i = 1:win:(length(x)-win)

    rxx = autocorrelation(x(i:i+win-1),p);
    [a, s] = estimate_LPC(rxx);
    LPC_kor(:, k) = a';
    [a,s] = aryule(x(i:i+win-1),p);
    LPC_ugr(:, k) = a;
    recon = [recon filter(1,a,randn(1,win)*sqrt(s))];
    k = k+1;

end

write = false;
if write == true 
    figure()
    hold all;
    for i = 2:(p+1)
        plot(LPC_kor(i, :));
    end
    xlabel('odbrici')
    ylabel('LPC koeficijenti')
    title('LPC analiza')
end

f1 = ob1(LPC_ugr);
f2 = ob2(LPC_ugr);
 
klasa = [f1, f2];

end