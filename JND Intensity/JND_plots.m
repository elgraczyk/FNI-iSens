clear all

load('Dec2014JNDExperimentsSummary.mat');

%For S104 - plot by contact

xfit=[-100:0.1:100];

%M2
[m,n]=size(data);
figure
hold on
col=[1 0 0; 0 0 1; 0 1 0; 0 0 0];
j=1;
for i=1:m
    if strcmp('M2',data(i,3))==1 && strcmp('Constant',data(i,4))==1
        A=cell2mat(data(i,9));
        B=cell2mat(data(i,10));
        tau=cell2mat(data(i,11));
        t0=cell2mat(data(i,12));
        offset=cell2mat(data(i,13));
        yfit=(A*exp(-B*exp(-(1/tau)*(xfit-t0)))).*heaviside(xfit-t0)+offset;
        
        plot(xfit,yfit,'Color', col(j,:),'LineWidth',3)
        j=j+1;
    end

end
%     legend('50 Hz, PW: 230us','100 Hz, PW: 170-175 us (Sinusoidal)','100 Hz, PW: 170 us')
legend('50 Hz, PW: 230us','100 Hz, PW: 170 us')
    title('S104 Intensity Discrimination, Contact M2','FontSize',14)
    xlabel('Relative Frequency (Test-reference) Percentage (%)','FontSize',14);
    ylabel('Percentage of "test frequency stronger" responses (%)','FontSize', 14);
    axis([-100 100 0 100])
    hold off
    
    %M7
figure
hold on
col=[1 0 0; 0 0 1; 0 1 0; 0 0 0];
j=1;
for i=1:m
    if strcmp('M7',data(i,3))==1 && strcmp('Constant',data(i,4))==1
        A=cell2mat(data(i,9));
        B=cell2mat(data(i,10));
        tau=cell2mat(data(i,11));
        t0=cell2mat(data(i,12));
        offset=cell2mat(data(i,13));
        yfit=(A*exp(-B*exp(-(1/tau)*(xfit-t0)))).*heaviside(xfit-t0)+offset;
        
        plot(xfit,yfit,'Color', col(j,:),'LineWidth',3)
        j=j+1;
    end

end
%     legend('50 Hz, PW: 255us','50 Hz, PW: 250-255 us (Sinusoidal)','100 Hz, PW: 160us')
legend('50 Hz, PW: 255us','100 Hz, PW: 160us')
    title('S104 Intensity Discrimination, Contact M7','FontSize',14)
    xlabel('Relative Frequency (Test-reference) Percentage (%)','FontSize',14);
    ylabel('Percentage of "test frequency stronger" responses (%)','FontSize', 14);
    axis([-100 100 0 100])
    hold off

 %M4
figure
hold on
col=[1 0 0; 0 0 1; 0 1 0; 0 0 0];
j=1;
for i=1:m
    xfit=[-100:0.1:100];
    if strcmp('M4',data(i,3))==1 && strcmp('S104',data(i,2))==1
        A=cell2mat(data(i,9));
        B=cell2mat(data(i,10));
        tau=cell2mat(data(i,11));
        t0=cell2mat(data(i,12));
        offset=cell2mat(data(i,13));
        %Attempt to put it back into absolute frequency rather than freq
        %percentage
%         if cell2mat(data(i,8))==50
%         xfit=xfit./2;
%         end
        yfit=((A*exp(-B*exp(-(1/tau)*(xfit-t0)))).*heaviside(xfit-t0)+offset);
        plot(xfit,yfit,'Color', col(j,:),'LineWidth',3)
        j=j+1;
    end

end
    legend('50 Hz, PW: 230us','100 Hz, PW: 220us')
    title('S104 Intensity Discrimination, Contact M4','FontSize',14)
    xlabel('Relative Frequency (Test-reference) Percentage (%)','FontSize',14);
    ylabel('Percentage of "test frequency stronger" responses (%)','FontSize', 14);
    axis([-100 100 0 100])
    hold off

    
%R4
figure
hold on
col=[1 0 0; 0 0 1; 0 1 0; 0 0 0];
j=1;
for i=1:m
    xfit=[-100:0.1:100];
    if strcmp('R4',data(i,3))==1 && strcmp('S104',data(i,2))==1
        A=cell2mat(data(i,9));
        B=cell2mat(data(i,10));
        tau=cell2mat(data(i,11));
        t0=cell2mat(data(i,12));
        offset=cell2mat(data(i,13));
        yfit=((A*exp(-B*exp(-(1/tau)*(xfit-t0)))).*heaviside(xfit-t0)+offset);
        plot(xfit,yfit,'Color', col(j,:),'LineWidth',3)
        j=j+1;
    end

end
    legend('50 Hz, PW: 210us','100 Hz, PW: 210us')
    title('S104 Intensity Discrimination, Contact R4','FontSize',14)
    xlabel('Relative Frequency (Test-reference) Percentage (%)','FontSize',14);
    ylabel('Percentage of "test frequency stronger" responses (%)','FontSize', 14);
    axis([-100 100 0 100])
    hold off

%% ---------------------
%S102
%M4
figure
hold on
col=[1 0 0; 0 0 1; 0 1 0; 0 0 0];
j=1;
for i=1:m
    xfit=[-100:0.1:100];
    if strcmp('M4',data(i,3))==1 && strcmp('S102',data(i,2))==1
        A=cell2mat(data(i,9));
        B=cell2mat(data(i,10));
        tau=cell2mat(data(i,11));
        t0=cell2mat(data(i,12));
        offset=cell2mat(data(i,13));
        yfit=((A*exp(-B*exp(-(1/tau)*(xfit-t0)))).*heaviside(xfit-t0)+offset);
        plot(xfit,yfit,'Color', col(j,:),'LineWidth',3)
        j=j+1;
    end

end
load('S102_summary_20150123.mat')
A=cell2mat(data(1,9));
        B=cell2mat(data(1,10));
        tau=cell2mat(data(1,11));
        t0=cell2mat(data(1,12));
        offset=cell2mat(data(1,13));
        yfit=((A*exp(-B*exp(-(1/tau)*(xfit-t0)))).*heaviside(xfit-t0)+offset);
        plot(xfit,yfit,'Color', col(4,:),'LineWidth',3)

    legend('12/12/14 100 Hz, PW: 80us','12/12/14 100 Hz, PW: 120us','12/12/14 50 Hz, PW: 120us','1/23/15 100 Hz, PW: 130us')
    title('S102 Intensity Discrimination, Contact M4','FontSize',14)
    xlabel('Relative Frequency (Test-reference) Percentage (%)','FontSize',14);
    ylabel('Percentage of "test frequency stronger" responses (%)','FontSize', 14);
    axis([-100 100 0 100])
    hold off
    