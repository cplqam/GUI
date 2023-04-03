function final_q = spectra_matching_ci(spec1,spec2,ppm)
%This function compares 2 spectra and complete one with the signals of the
%second without repeat signals

%INPUT
%spect1: the spectra to be compared
%spect2: the spectra to be completed
%ppm: the m/z error 

r_c = size(spec1, 1);
ion_cand = spec1(:,1);
int_cand = spec1(:,2);
r_q = size(spec2, 1);
ion_query = spec2(:,1);
int_query = spec2(:,2);


final_q = [];
eli_c = [];
%For each value of query obtain the ppm limits
for n = 1:r_q
    t = 0;
    i_q = ion_query(n);
    sup = -i_q/((ppm/1000000)-1);
    inf = -i_q*((ppm/1000000)-1);
    uni = 0; %Para que solo puedas atribuirle 1 ion y no elimines 2
    %For each value of candidate
    for n2 = 1:r_c
        i_c = ion_cand(n2);
        %If is the same value as the query i add it to the list with its
        %intensity
        if (i_c > inf) & (i_c < sup) & (uni == 0)
            final_q = [final_q;i_q,int_query(n)];
            eli_c = [eli_c,i_c];
            t = 1;
            uni = 1;
        %If not, I add the candidate value with the minimum intensity
        else
            final_q = [final_q;i_c,1];
        end
    %If the value did not match with the candidate signals, I add the query 
    % signal with its intensity 
    if t == 0
        final_q = [final_q;i_q,int_query(n)];
    end
    end
end
%I remove the duplicate values
[u,ia] = unique(final_q(:,1));
final_q = final_q(ia,:);
% final_q = unique(final_q(:,1),'rows');

eli = [];

for e = eli_c
    eli = [eli;find(final_q(:,1) == e)];
end
final_q(eli,:) = [];
end
