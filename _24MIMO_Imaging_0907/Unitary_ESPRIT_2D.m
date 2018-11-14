function [f1,f2,S] = Unitary_ESPRIT_2D(X,M,N,K)
[P,L] = size(X);
m = P/2;
X1 = X(1:m,:);
X2 = X(m+1:end,:);
T1 = real(X1+IEM(m)*X2);
T2 = -imag(X1+IEM(m)*X2);
T3 = imag(X1-IEM(m)*X2);
T4 = real(X1-IEM(m)*X2);
Z = [T1 T2
    T3 T4];
[U,D,V] = svd(Z);
Uz = U(:,1:K);
Es = UniMat(P)*Uz;
Mat1 = SampMat(M,N-1,1,1);
Mat2 = SampMat(M,N-1,1,2);
E1 = Mat1*Es(1:end-M,:);
E2 = Mat2*Es(M+1:end,:);
Psi = pinv(E1)*E2;
[T,D] = eig(Psi);
f12 = angle(diag(D))/2/pi;
Te = rowPermutateMat(M,N);
Es2 = Te*Es;
B = Es2*T;
B1 = B(1:end-N,:);
B2 = B(N+1:end,:);
Phi = B1\B2;
f1 = angle(diag(Phi))/2/pi;
f2 = f12 - f1;
A = kr(exp(1i*2*pi*(0:M-1).'*f2.'),exp(1i*2*pi*(0:N-1).'*f1.'));
S = sqrt(abs(diag((A'*A)\A'*(X*X')*A/(A'*A)))/L);