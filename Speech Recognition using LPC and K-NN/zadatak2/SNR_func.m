function y = SNR_func(ni,odnos_max,num_bits)

    y = 4.77 + 6*num_bits - 20*log10(log(1+ni)) - 10*log10(1+(odnos_max./ni).^2 + sqrt(2).*odnos_max./ni);

end