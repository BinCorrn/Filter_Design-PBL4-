x = -pi:pi/20:5*pi;
sinc_x = sin(x)./x;
stem(x,sinc_x);
title("Do thi sinx/x trong khoang -pi den 5pi");
xlabel("x");
ylabel("Do lon");