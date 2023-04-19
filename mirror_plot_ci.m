function mirror_plot_ci(X,Y);

X1=X(:,1);
X2=X(:,2);

Y1=Y(:,1);
Y2=Y(:,2);

% X BINNING
% ***************************************
% binning
if size(X1,1) == 1
    nouX1=[min(X1)-50:0.1:max(X1)+50];
else
    nouX1=[min(X1)-1:0.1:max(X1)+1];
end
XbinEdges = nouX1;
[Xh,XwhichBin] = histc(X1, XbinEdges);

for Xj = 1:(length(nouX1));
    XflagBinMembers = (XwhichBin == Xj);
    XbinMembers     = X2(XflagBinMembers);
    XbinSum(Xj)      = sum(XbinMembers);
end

XF=XbinSum;
% ***********************



% Y BINNING
% ***************************************
% binning
if size(Y1,1) == 0
    nouY1=[min(Y1)-50:0.1:max(Y1)+50];
else
    nouY1=[min(Y1)-1:0.1:max(Y1)+1];
end
YbinEdges = nouY1;
[Yh,YwhichBin] = histc(Y1, YbinEdges);

for Yj = 1:(length(nouY1));
    YflagBinMembers = (YwhichBin == Yj);
    YbinMembers     = Y2(YflagBinMembers);
    YbinSum(Yj)      = sum(YbinMembers);
end

YF=YbinSum;
% ***********************

bar(nouX1,XF,8); 
hold on;
bar(nouY1,YF,8)
hold off
end