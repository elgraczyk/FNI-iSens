function F=gompertzfit(x,tdata)
F=(x(1)*exp(-x(5)*exp(-(1/x(2)*(tdata-x(3)))))).*heaviside(tdata-x(3))+x(4);
end
