function J = nlCostFcn(X,U,e,data)

p = data.PredictionHorizon;
U1 = sum(U(1:p,data.MVIndex(1)));
U2 = sum(U(1:p,data.MVIndex(2)));
U3 = sum(U(1:p,data.MVIndex(3)));
U4 = sum(U(1:p,data.MVIndex(4)));
X7 = sum(X(2:p+1,7));
X8 = sum(X(2:p+1,8));
X9 = sum(X(2:p+1,9));
J = .1* (U1 + U2 + U3 + U4) + X7 + X8 + X9;

end