function results = mz_extraction_roimcr_1(sopt,mz_tot,per)
%This function provides information for identification of the chemical
%compounds. The analysis performed has a row-wise augmentation step of the
%ms1 and ms2 positive and negative matrixes in this order
%ms1p-ms2p-ms1n-ms2n

%INPUT
%sopt: the sopt matrix resulting from ROIMCR
%mz_tot:an array with the total mzroi values augmented in the order above
%specified
%per: the percentaje of the max intensity used as a threshold (0-1)

%OUTPUT
%results: a cell array:
    %the mz, int and position in mz_tot with and intensity
        %higher than prefixed by per parameter


results = {};
[row, col] = size(sopt);
mz1 = sopt;

ms1 = {};
for n = 1:row
    [m, pos] = max(sopt(n,:));
    thres = m*per;
    
    s_ms1 = [];

    for p = 1:col
        value = sopt(n,p);
        if value >= thres
            norm = value/max(sopt(n,:))*999;
            arr = [mz_tot(p),value,p];
            s_ms1 = [s_ms1;arr];
        end
    end
    intensities = s_ms1(:,2);
    max_intentity = max(intensities);
    intensities = intensities/max_intentity;
    s_ms1(:,2) = intensities;
    results{n,1}{1,1} = s_ms1;

    s_ms1 = [];
    
end
results = struct('ms1',results(:,1));
end