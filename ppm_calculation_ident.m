function ppm = ppm_calculation_ident(ion1,ion2)
%This function calcules the ppm error between 2 ions

if ion1 >= ion2
    ppm = (1-ion2/ion1)*1000000;
else
    ppm = (1-ion1/ion2)*1000000;
end
end