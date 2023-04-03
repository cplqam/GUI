function results = mz_extraction_roimcr_2(sopt,mz_tot,limits,per, per_2)
%This function provides information for identification of the chemical
%compounds. The analysis performed has a row-wise augmentation step of the
%ms1 and ms2 positive and negative matrixes in this order
%ms1p-ms2p-ms1n-ms2n

%INPUT
%sopt: the sopt matrix resulting from ROIMCR
%mz_tot:an array with the total mzroi values augmented in the order above
%specified
%limits: an array with the value position of the mz_tot matrix transition
%(from ms1 to ms2 )
%per: the percentaje of the max intensity used as a threshold (0-1)
%per2: the percentaje of the max intensity used as a threshold individually 
% for each matrix

%OUTPUT
%results: a cell array:
    %1st column:in which ionization and ms leves is the max intensity
    %2nd column:ms1 results
        %1st column:the mz, int and position in mz_tot with and intensity
            %higher than prefixed by per parameter
        %2nd column: the same information, but an intensity normalization is 
            %performed for pattern of fragmentation
        %3rd column:the same information as the 1st column, but this time
            %the intenstity theshold is inside the individual matrix (per2)
        %4rd column:the same information than 3r column, but an intensity 
            %normalization is performed for pattern of fragmentation
    %3rd column: ms2 results
        %same info than in ms1 results


results = {};
[row, col] = size(sopt);
mz1 = sopt(:, 1:limits(1));
mz2 = sopt(:, limits(1)+1:end);

ms1 = {};
ms2 = {};
for n = 1:row
    [m, pos] = max(sopt(n,:));
    max_int = m*per;
    if pos <= limits(1)
        results{n,1} = 'ms1';
    elseif (limits(1) < pos)
        results{n,1} = 'ms2';
    end
    
    s_ms1 = [];
    s_ms2 = [];

    s_ms1_2 = [];
    s_ms2_2 = [];

    for p = 1:col
        value = sopt(n,p);
        if value >= max_int
            if p <= limits(1)
                norm = value/max(sopt(n,1:limits(1)))*999;
                arr = [mz_tot(p),value,p];
                s_ms1 = [s_ms1;arr];
                s_ms1_2 = [s_ms1_2; mz_tot(p), norm, p];
            elseif (limits(1) < p)
                norm = value/max(sopt(n,limits(1)+1:end))*999;
                arr = [mz_tot(p),value,p];
                s_ms2 = [s_ms2;arr];
                s_ms2_2 = [s_ms2_2; mz_tot(p), norm, p];
            end
        end
    end
    results{n,2}{1,1} = s_ms1;
    results{n,3}{1,1} = s_ms2;
    
    results{n,2}{1,2} = s_ms1_2;
    results{n,3}{1,2} = s_ms2_2;

    s_ms1 = [];
    s_ms2 = [];

    s_ms1_2 = [];
    s_ms2_2 = [];

    max_ms1 = max(mz1(n,:));
    value_ms1 = max_ms1*per_2;

    max_ms2 = max(mz2(n,:));
    value_ms2 = max_ms2*per_2;

    for p = 1:size(mz1,2)
        value = mz1(n,p);
        if value >= value_ms1
            norm = value/max_ms1*999;
            v = value/max_ms1;
            s_ms1 = [s_ms1;mz_tot(p),norm,p];
            s_ms1_2 = [s_ms1_2;mz_tot(p),v,p];
        end
    end
    
    for p = 1:size(mz2,2)
        value = mz2(n,p);
        if value >= value_ms2
            norm = value/max_ms2*999;
            v = value/max_ms2;
            s_ms2 = [s_ms2;mz_tot(p+limits(1)),norm,p+limits(1)];
            s_ms2_2 = [s_ms2_2;mz_tot(p+limits(1)),v,p+limits(1)];
        end
    end
    
    results{n,2}{1,3} = s_ms1_2;
    results{n,3}{1,3} = s_ms2_2;

    results{n,2}{1,4} = s_ms1;
    results{n,3}{1,4} = s_ms2;
end
results = struct('Max_signal',results(:,1),'ms1',results(:,2),'ms2',results(:,3));
end