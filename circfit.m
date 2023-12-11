function   [xc,yc,R,a] = circfit(x,y)
   % Two solutions may be used
   % Analytical  by Izhak Bucher 25/oct /1991: 
   x=x(:); y=y(:);
   a=[x y ones(size(x))]\[-(x.^2+y.^2)];
   xc = -.5*a(1);
   yc = -.5*a(2);
   R  =  sqrt((a(1)^2+a(2)^2)/4-a(3));
   
   % or MATLAB least squares:
   % f = @(a) (x-a(1)).^2 + (y-a(2)).^2 - a(3).^2;
   % a0 = [mean(x),mean(y),max(x)-mean(x)]; 
   % circFit = lsqnonlin(f,a0);
   % R=circFit(3);
   % xc=circFit(1);
   % yc=circFit(2);
end
