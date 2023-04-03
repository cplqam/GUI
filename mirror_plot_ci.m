function [nouX1,XF,nouY1,YF]=mirror_plot_ci(X,Y,norm);

X1=X(:,1);
X2=X(:,2);

Y1=Y(:,1);
Y2=Y(:,2);

% X BINNING
% ***************************************
% binning
nouX1=[min(X1)-1:0.1:max(X1)+1];
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
nouY1=[min(Y1)-1:0.1:max(Y1)+1];
YbinEdges = nouY1;
[Yh,YwhichBin] = histc(Y1, YbinEdges);

for Yj = 1:(length(nouY1));
    YflagBinMembers = (YwhichBin == Yj);
    YbinMembers     = Y2(YflagBinMembers);
    YbinSum(Yj)      = sum(YbinMembers);
end

YF=YbinSum;
% ***********************

if norm=='y'
    XFmax=max(XF);
    YFmax=max(abs(YF));
    XF=XF/XFmax*1000;
    YF=YF/YFmax*1000;   
    bar(nouX1,XF,8); hold on;
bar(nouY1,YF,8)
else
    bar(nouX1,XF,8); hold on;
bar(nouY1,YF,8)
end