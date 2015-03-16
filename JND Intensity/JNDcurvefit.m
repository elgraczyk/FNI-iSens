%Script to do curve fitting and calculate JND for intensity perception
%experiments
%Need to have already run the JNDIntensityAnalysis.m script

%Created by: Graczyk
%12/30/14

clear all

%Select the file - should be in format SXXXAnalysis-Date-Time.mat
[filename,PathName]=uigetfile('*.mat','Select the analysis file you wish to load');
load([PathName '/' filename]);

elec=cell2mat(inputdlg(['Please enter electrode contact']));
pattern=cell2mat(inputdlg('Please enter stimulation pattern type (Constant or Sinusoidal)'));

%Gompertz curve
%y(t)=a*exp(-b*exp(-ct))

%depends on variables loaded
xdata=((testlist-ref)/ref)*100; %need to offset the frequencies by the reference frequency
ydata=teststrongperc; %the percetage data

%try 10 curve fits
MSE=inf;
ub=[110 200 inf 10 inf];
lb=[80 0 -inf -1 -inf];
        for k=1:10       
        
        %for gompertz
        %th1 can vary between 0 and 20
        th1=rand()*20; %coefficient A
        %th2 can vary between 0 and 30
        th2=rand()*30; %tau
        %th3 can vary between -20 and 20
        th3=rand()*40-20; %t0, freq offset
        %th4 can vary between 0 and 30
        th4=rand()*30; %y offset
        %th5 can vary between 0 and 20
        th5=rand()*20; %coefficient B
        %gompertz
        thIN=[th1 th2 th3 th4 th5]; %vector of theta estimates, to put in lsqcurvefit

        %Optimal estimates of thetas are in thOUT
        [thOUT, resnorm, residual]=lsqcurvefit(@gompertzfit,thIN,xdata,ydata,lb,ub);
        
        if mean(residual.^2) < MSE
            MSE=mean(residual.^2);
            A=thOUT(1); %a
            B=thOUT(5); %b
            tau=thOUT(2);
            t0=thOUT(3);
            offset=thOUT(4);
            end
        end
    %For plotting
    thOUT=[A tau t0 offset B];
    xfit=[-100:0.1:100];
    yfit=(A*exp(-B*exp(-(1/tau)*(xfit-t0)))).*heaviside(xfit-t0)+offset;
    
    type=str2num(cell2mat(inputdlg(['Please enter parameter of discrimination (1=freq, 2=PW)'])));
    
    %plot
    figure
    hold on
    plot(xfit,yfit,'LineWidth',3,'Color','blue')
    scatter(xdata,ydata,'r','LineWidth',3)
    hold off
    
    if type==1
    xlabel('Relative Frequency (Test-reference) Percentage (%)','FontSize',14);
    ylabel('Percentage of "test frequency stronger" responses (%)','FontSize', 14);
    axis([-100 100 0 100])
    title([elec '  ' pattern '  ' num2str(ref) ' Hz'],'FontSize',14)
    elseif type==2
        xlabel('Relative PW (Test-reference) Percentage (%)','FontSize',14);
    ylabel('Percentage of "test PW stronger" responses (%)','FontSize', 14);
    axis([-100 100 0 100])
    title([elec '  ' pattern '  ' num2str(ref) ' us'],'FontSize',14)
    end
    
    
    
    %formatting output - for Excel table
    metrics(1)=ref;
    metrics(2)=thOUT(1);
    metrics(3)=thOUT(5);
    metrics(4)=thOUT(2);
    metrics(5)=thOUT(3);
    metrics(6)=thOUT(4);
    metrics(7)=gompfxn(50,thOUT)-gompfxn(25,thOUT);
    metrics(8)=gompfxn(75,thOUT)-gompfxn(50,thOUT);
    metrics(9)=(metrics(7)+metrics(8))/2;
    metrics(10)=gompfxn(50,thOUT);
    
       