function result = intensity_normalization_spect(db)

r = size(db,1);
for n = r:-1:1
    try
        ms2 = db(n).MS2;
        val = max(ms2(:,2));

        sig = size(ms2,1);
        for spe = 1:sig
            ms2(spe,2) = ms2(spe,2)/val * 1000;
        end
        db(n).MS2 = ms2;
    catch MEexception
        if strcmp(MEexception.identifier, 'MATLAB:badsubscript')
            db(n) = [];
        else
            error('Something went wrong')
        end
    end
end
result = db;
end