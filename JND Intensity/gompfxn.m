function x=gompfxn(y,thOUT)
%returns the inverse of the gompertz function (gives you x given y)
%             A=thOUT(1); %a
%             B=thOUT(5); %b
%             tau=thOUT(2);
%             t0=thOUT(3);
%             offset=thOUT(4);
x=thOUT(3)-thOUT(2)*log(log((y-thOUT(4))/thOUT(1))/-thOUT(5));
end
