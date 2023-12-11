I = imread('captured_image.bmp');   % image read
BW = im2bw(I,0.5);                  % thresholding
BW2=bwareaopen(BW, 300);            % noise removal
BW3=imfill(BW2,'holes');            % hole filling
BW4=bwareaopen(BW3, 1.0e+05);       % noise removal

BWs = im2bw(I,0.15);                % thresholding
BW2s=imcomplement(BWs);
BW3s=bwareaopen(BW2s, 500);         % noise removal
SED=strel('disk',5);    
SEE=strel('disk',5);
BW4s =imdilate(BW3s,SED);           % dilation
BW5s=imerode(BW4s,SEE);             % erosion

BW6=imadd(BW4,BW5s);                % summing
SED=strel('disk',8);    
SEE=strel('disk',8);
BW7 =imdilate(BW6,SED);             % dilation
BW8=imerode(BW7,SEE);               % erosion

% --- Optimization

c=0.032251;                         % in mm/px

B = bwboundaries(BW8,'noholes');
XY=B{1};
X=XY(:,2);
Y=XY(:,1);

Y=-(Y-1200)*c;
X=X*c;

[xc,yc,R,a] = circfit(X,Y);

Rmin=min(sqrt((X-xc).^2+(Y-yc).^2));
Rmax=max(sqrt((X-xc).^2+(Y-yc).^2));
okrP=(Rmax-Rmin);

% --- Visualisation

XLIM=[xc-Rmax-1 xc+Rmax+1];
YLIM=[yc-Rmax-1 yc+Rmax+1];
figure
subplot(1,2,1)
image(I)
hold on
imcontour(BW8,1,'-r');
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
axis equal
xlim(XLIM/c)
ylim(1200-fliplr(YLIM)/c)
subplot(1,2,2)
plot(X,Y,'-r','LineWidth',1)
t=0:0.01:2*pi;
hold on
plot(Rmin*cos(t)+xc,Rmin*sin(t)+yc,'-k')
hold on
plot(R*cos(t)+xc,R*sin(t)+yc,'-.k')
hold on
plot(Rmax*cos(t)+xc,Rmax*sin(t)+yc,'-k')
grid on
xlim(XLIM)
ylim(YLIM)
xlabel('x, mm')
ylabel('y, mm')
