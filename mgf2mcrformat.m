function [st,mzroi, limit] = mgf2mcrformat(mgf, thresh)
%This function transforms the spectra in mgf format to MSident input (st
%matrix, mzroi and limit of MS1 spectra before starting MS2).
%Import mgf as a numeric matrix, separator '=' and complete the
%unimportable cels as 0

%Input
%mgf: the imported mgf file as it is specify above
%thresh: the intensity threshold to filter the MS2 spectra depending on
%their intensity signal. (0-1)

%Output
%st: the intensities normalized to 1 of the signals in the format of St
%matrix from MCR
%mzroi: an array with the m/z values of the signals
%limit: the limit of MS1 spectra before starting MS2

filter_1 = find(mgf(:,2) < thresh);
filter_2 = find(mgf(:,2) == 0);
filter = [filter_1;filter_2];
filter = sort(filter);
mgf(filter,:) = [];

mzroi_ms2 = transpose(mgf(:,1));
filter = find(mzroi_ms2 == 0);
mzroi_ms2(filter) = [];
mzroi_ms2 = sort(round(mzroi_ms2, 4));
mzroi_ms2 = unique(mzroi_ms2);

filter = find(mgf(:,1) == 0);
mzroi_ms1_tot = mgf(filter,:);
mzroi_ms1_tot = transpose(mzroi_ms1_tot(3:4:end,2));
mzroi_ms1 = sort(round(mzroi_ms1_tot, 4));
n_spec = size(mzroi_ms1, 2);
mzroi_ms1 = unique(mzroi_ms1);

mzroi = [mzroi_ms1,mzroi_ms2];

for n = 1:n_spec
    ms1 = mzroi_ms1_tot(n);
    pos = find(mzroi_ms1 == round(ms1,4));
    st_1(n,pos) = 1;
end
contador = 1;
for n = 1:size(mgf,1)
    ms2 = mgf(n,1);
    if ms2 ~= 0
        pos = find(mzroi_ms2 == round(ms2,4));
        int  = mgf(n,2);
        st_2(contador,pos) = int;
        if n ~= size(mgf, 1)
            if mgf(n+1,1) == 0
                contador = contador + 1;
            end
        end
    end
end
st = [st_1,st_2];
limit = size(mzroi_ms1, 2);
end