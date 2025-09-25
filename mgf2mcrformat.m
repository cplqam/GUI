function [st, mzroi, limit] = mgf2mcrformat(mgf, thresh, mz_val, mslevel)
%This function transforms the spectra in mgf format to MSident input (st
%matrix, mzroi and limit of MS1 spectra before starting MS2).
%Import mgf as a numeric matrix, separator '=' + space and complete the
%unimportable cells with 0

%Input
%mgf: the imported mgf file as it is specify above
%thresh: the intensity threshold to filter the MS2 spectra depending on
%their intensity signal. (0-1)
%mz_val: 2 if the RT is before mz value and 1 if mz value is before in mgf
%file
%msLevel: 1 if mgf file includes in each spectrum a row starting by
%"msLevel" and 0 if it does not

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
if mslevel == 1
    filter2 = find(mzroi_ms1_tot(:, 2) == 2);
    filter3 = filter2-1;
    filter4 = sort([filter2;filter3]);
    filter4 = unique(filter4);
    mzroi_ms1_tot(filter4, :) = [];
end

if mz_val == 1
    mzroi_ms1_tot = transpose(mzroi_ms1_tot(1:2:end,2));
elseif mz_val == 2
    mzroi_ms1_tot = transpose(mzroi_ms1_tot(2:2:end,2));
else
    error('select a correct value for mz_val parameter')
end
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
    if mod(n,10000) == 0
        progress = strcat(num2str(n/size(mgf,1)*100), '%')                             
    end
    ms2 = mgf(n,1);
    if ms2 ~= 0
        pos = find(mzroi_ms2 == round(ms2,4));
        int  = mgf(n,2);
        st_2(contador,pos) = int;
        if n ~= size(mgf, 1)
            if mgf(n+1,1) == 0
                max_int = max(st_2(contador,:));
                st_2(contador,:) = st_2(contador,:)/max_int;
                contador = contador + 1;
            end
        end
    end
end
st_1
St_2
st = [st_1,st_2];
limit = size(mzroi_ms1, 2);
end