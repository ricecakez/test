clear;clc;close all;

load('data/RxSignal_plane_1106.mat');
% SNR = 0;
Echo = RxSig/sqrt(N);
% Echo = awgn(RxSig/sqrt(N),SNR,'measured');
for k = 1:K
    t = T_min + (k-1)*T + (tc:1/fs:(T-1/fs));
    t = t(:);
    for nr = 1:Nr
        y = exp(-1i*2*pi*Fc*t).*Echo((k-1)*N_T+((N_c+1):N_T),nr);
        tmp = fft(y)./ank(:,k)/sqrt(N);
        for nt = 1:Nt
            nv = (nr-1)*Nt+nt;
            Phi0 = exp(1i*2*pi*((nt:Nt:N)-1).'*df*(2*VP(nv)/c-T_min));
            Psi0 = exp(1i*2*pi*2*VP(nv)/lambda);
            Y((nv-1)*N0+(1:N0),k) = tmp(nt:Nt:N).*Phi0*Psi0;
        end
    end
end

NFFT = 256;
% X111 = zeros(NFFT);

% for k = 1:K
    Y1 = reshape(Y(:,1),[N0,Nv]);
    tic
for nv = 1:Nv
    X11(:,nv) = NFFT*fftshift(ifft(Y1(:,nv),NFFT))/N0;
end
for nf = 1:NFFT
    X111(nf,:) = NFFT*fftshift(ifft(X11(nf,:),NFFT))/Nv;
end
toc
% clear X11;
% end
u = (-(NFFT/2-1):NFFT/2)/NFFT*N0*d0;
% theta0 = A0(1)*pi/180;
% phi0 = A0(2)*pi/180;
v = (-(NFFT/2-1):NFFT/2)/NFFT*lambda*R0/2/d;
% x = v - u*u0(1);
% y =  (- x*u0(1)-u)/u0(2);
% x0 = u0*cos(theta0)-v0*sin(theta0);
% y0 = u0*sin(theta0)+v0*cos(theta0);
imagesc(u,v,abs(X111))
axis xy
xlabel('$u/{\mathrm{m}}$','Interpreter','latex')
ylabel('$v/{\mathrm{m}}$','Interpreter','latex')
colormap('hot')

[m,n,S_1] = find_peak_2D(abs(X111),I);
u_1 = -u(m);
v_1 = -v(n);
x_1 = P(1) + v_1 - u_1*u0(1);
y_1 =  P(2) + (- (x_1-P(1))*u0(1)-u_1)/u0(2);
figure
scatter(x_1,y_1,S_1,'k','s');
xlabel('$x/{\mathrm{m}}$','Interpreter','latex')
ylabel('$y/{\mathrm{m}}$','Interpreter','latex')
grid on
hold on
% xlim([-10,15])
% ylim([-15,10])
% figure
% scatter(u,v)
[phi,psi] = sort2D(phi,psi,1);
%  
u1 = phi*N0*d0;
v1 = psi*lambda/2*R0/d;
figure(3)
scatter(u1,v1,12,'r')
hold on
load('data\selMat6464.mat')
% hold on
tic
[phi_est,psi_est] = StepUESPRIT(Y,Nv,N0,Nt,I);
% [phi_est,psi_est,s_est] = Unitary_ESPRIT_2D1(Y,N0,Nv,I);
toc
ms = sort_matrix([phi_est psi_est],'ascend',1);
p1 = ms(:,1);
s1 = ms(:,2);
% S1 = ms(:,3);

tic
[phi_est1,psi_est1,s_est1] = Unitary_ESPRIT_2D1115(Y,N0,Nv,I);
toc
ms = sort_matrix([phi_est1 psi_est1 s_est1],'ascend',1);
p2 = ms(:,1);
s2 = ms(:,2);
S2 = ms(:,3);
u_est = p1*N0*d0;
v_est = s1*lambda/2*R0/d;
figure(3)
scatter(u_est,v_est,12,'b+');
hold on
x_est = v_est - u_est*u0(1);
y_est =  (- x_est*u0(1)-u_est)/u0(2);
figure(4)
scatter(x_est+P(1),y_est+P(2),12,'b+');
hold on
u_est1 = p2*N0*d0;
v_est1 = s2*lambda/2*R0/d;
figure(3)
scatter(u_est1,v_est1,S2,'ks');
x_est1 = v_est1 - u_est1*u0(1);
y_est1 =  (- x_est1*u0(1)-u_est1)/u0(2);
figure(4)
scatter(x_est1+P(1),y_est1+P(2),S2,'ks');
scatter(a(1,:)+P(1),a(2,:)+P(2),12,'r')



% tic
%
% toc

    