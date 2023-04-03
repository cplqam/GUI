function results = mz_extraction_roimcr_3(sopt,mz_tot,limits,per, per_2)
%This function provides information for identification of the chemical
%compounds. The analysis performed has a row-wise augmentation step of the
%ms1 and ms2 positive and negative matrixes in this order
%ms1p-ms2p-ms1n-ms2n

%INPUT
%sopt: the sopt matrix resulting from ROIMCR
%mz_tot:an array with the total mzroi values augmented in the order above
%specified
%limits: an array with the value position of the mz_tot matrix transition
%(e.g. from ms1 positive to ms2 positive)
%per: the percentaje of the max intensity used as a threshold (0-1)
%per2: the percentaje of the max intensity used as a threshold individually 
% for each matrix

%OUTPUT
%results: a cell array:
    %1st column:in which ionization and ms leves is the max intensity
    %2nd column:ms1 positive results
        %1st column:the mz, int and position in mz_tot with and intensity
            %higher than prefixed by per parameter
        %2nd column: the same information, but an intensity normalization is 
            %performed for pattern of fragmentation
        %3rd column:the same information as the 1st column, but this time
            %the intenstity theshold is inside the individual matrix (per2)
        %4rd column:the same information than 3r column, but an intensity 
            %normalization is performed for pattern of fragmentation
    %3rd column: ms2 positive
        %same info than in ms1 results
    %4th column: ms1 negative results
        %same info than in ms1 results
    %5th column: ms2 negative results
        %same info than in ms1 results


results = {};
[row, col] = size(sopt);
mz1_p = sopt(:, 1:limits(1));
mz2_p = sopt(:, limits(1)+1:limits(2));
mz1_n = sopt(:, limits(2)+1:limits(3));
mz2_n = sopt(:, limits(3)+1:end);

ms1_p = {};
ms2_p = {};
ms1_n = {};
ms2_p = {};
for n = 1:row
    [m, pos] = max(sopt(n,:));
    max_int = m*per;
    if pos <= limits(1)
        results{n,1} = 'Positive ms1';
    elseif (limits(1) < pos) &  (pos <= limits(2))
        results{n,1} = 'Positive ms2';
    elseif (limits(2) < pos) & (pos <= limits(3))
        results{n,1} = 'Negative ms1';
    elseif limits(3) < pos
        results{n,1} = 'Negative ms2';
    end
    
    s_ms1_p = [];
    s_ms2_p = [];
    s_ms1_n = [];
    s_ms2_n = [];

    s_ms1_p2 = [];
    s_ms2_p2 = [];
    s_ms1_n2 = [];
    s_ms2_n2 = [];

    for p = 1:col
        value = sopt(n,p);
        if value >= max_int
            if p <= limits(1)
                norm = value/max(sopt(n,1:limits(1)))*999;
                arr = [mz_tot(p),value,p];
                s_ms1_p = [s_ms1_p;arr];
                s_ms1_p2 = [s_ms1_p2; mz_tot(p), norm, p];
            elseif (limits(1) < p) & (p <= limits(2))
                norm = value/max(sopt(n,limits(1)+1:limits(2)))*999;
                arr = [mz_tot(p),value,p];
                s_ms2_p = [s_ms2_p;arr];
                s_ms2_p2 = [s_ms2_p2; mz_tot(p), norm, p];
            elseif (limits(2) < p) & (p <= limits(3))
                norm = value/max(sopt(n,limits(2)+1:limits(3)))*999;
                arr = [mz_tot(p),value,p];
                s_ms1_n = [s_ms1_n;arr];
                s_ms1_n2 = [s_ms1_n2; mz_tot(p), norm, p];
            elseif limits(3) < p
                norm = value/max(sopt(n,limits(3)+1:end))*999;
                arr = [mz_tot(p),value,p];
                s_ms2_n = [s_ms2_n;arr];
                s_ms2_n2 = [s_ms2_n2; mz_tot(p), norm, p];
            end
        end
    end
    results{n,2}{1,1} = s_ms1_p;
    results{n,3}{1,1} = s_ms2_p;
    results{n,4}{1,1} = s_ms1_n;
    results{n,5}{1,1} = s_ms2_n;
    
    results{n,2}{1,2} = s_ms1_p2;
    results{n,3}{1,2} = s_ms2_p2;
    results{n,4}{1,2} = s_ms1_n2;
    results{n,5}{1,2} = s_ms2_n2;

    s_ms1_p = [];
    s_ms2_p = [];
    s_ms1_n = [];
    s_ms2_n = [];

    s_ms1_p2 = [];
    s_ms2_p2 = [];
    s_ms1_n2 = [];
    s_ms2_n2 = [];

    max_ms1_p = max(mz1_p(n,:));
    value_ms1p = max_ms1_p*per_2;

    max_ms2_p = max(mz2_p(n,:));
    value_ms2p = max_ms2_p*per_2;

    max_ms1_n = max(mz1_n(n,:));
    value_ms1n = max_ms1_n*per_2;

    max_ms2_n = max(mz2_n(n,:));
    value_ms2n = max_ms2_n*per_2;

    for p = 1:size(mz1_p,2)
        value = mz1_p(n,p);
        if value >= value_ms1p
            norm = value/max_ms1_p*999;
            v = value/max_ms1_p;
            s_ms1_p = [s_ms1_p;mz_tot(p),norm,p];
            s_ms1_p2 = [s_ms1_p2;mz_tot(p),v,p];
        end
    end
    
    for p = 1:size(mz2_p,2)
        value = mz2_p(n,p);
        if value >= value_ms2p
            norm = value/max_ms2_p*999;
            v = value/max_ms2_p;
            s_ms2_p = [s_ms2_p;mz_tot(p+limits(1)),norm,p+limits(1)];
            s_ms2_p2 = [s_ms2_p2;mz_tot(p+limits(1)),v,p+limits(1)];
        end
    end

    for p = 1:size(mz1_n,2)
        value = mz1_n(n,p);
        if value >= value_ms1n
            norm = value/max_ms1_n*999;
            v = value/max_ms1_n;
            s_ms1_n = [s_ms1_n;mz_tot(p+limits(2)),norm,p+limits(2)];
            s_ms1_n2 = [s_ms1_n2;mz_tot(p+limits(2)),v,p+limits(2)];
        end
    end

    for p = 1:size(mz2_n,2)
        value = mz2_n(n,p);
        if value >= value_ms2n
            norm = value/max_ms2_n*999;
            v = value/max_ms2_n;
            s_ms2_n = [s_ms2_n;mz_tot(p+limits(3)),norm,p+limits(3)];
            s_ms2_n2 = [s_ms2_n2;mz_tot(p+limits(3)),v,p+limits(3)];
        end
    end
    
    results{n,2}{1,3} = s_ms1_p2;
    results{n,3}{1,3} = s_ms2_p2;
    results{n,4}{1,3} = s_ms1_n2;
    results{n,5}{1,3} = s_ms2_n2;

    results{n,2}{1,4} = s_ms1_p;
    results{n,3}{1,4} = s_ms2_p;
    results{n,4}{1,4} = s_ms1_n;
    results{n,5}{1,4} = s_ms2_n;
end
results = struct('Max_signal',results(:,1),'ms1_pos',results(:,2),'ms2_pos',results(:,3), 'ms1_neg', results(:,4), 'ms2_neg', results(:,5));
end