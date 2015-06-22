%Batch processing of raw JND intensity data files

close all
clear all
%% Open the experiment data file(s)

datafiles={};
defaultpath=pwd;
cd('C:\Users\Emily\Documents\MATLAB\JND Intensity');
[datafiles,PathName]=uigetfile('*.mat','Select the experiment data file you wish to analyze','Multiselect','on');
cd(PathName);

%Initialize structure to store all analyzed data in
alldata=[];
summary_head={'SID','contact','date','discrim_type','ref','p1','p2','p3','p4','p5','MSE','Rsquared','JND','PSS','subj_bias'};
summary_data=[];

%% Initialize figures and axes for group plots - for discrimination data
col=[0, 0, 1; 0.13, 0.54, 0.13; 0.55, 0.21, 0.55; 1, 0, 0; 1, 0.54, 0; 1, 0.4, 0.7; 0, 0.6, 0.8; 0, 0, 0; 1, 1, 0; 0, 1, 0; 0.6, 0.4, 1; 0, 1, 0.8; 1, 0.2, 0.6; 0.6, 0, 0; 0, 0, 0.6];
f1=figure; %figure for S102, freq
h1=axes('Parent',f1);
xlabel('Relative Frequency (Test-reference) Percentage (%)','FontSize',14);
ylabel('Percentage of "test stimulus stronger" responses (%)','FontSize', 14);
axis([-100 100 0 100])
title('S102 Frequency Discrimination','FontSize',16)
c1=1;

f2=figure; %figure for S102, PW
h2=axes('Parent',f2);
xlabel('Relative PW (Test-reference) Percentage (%)','FontSize',14);
ylabel('Percentage of "test stimulus stronger" responses (%)','FontSize', 14);
axis([-100 100 0 100])
title('S102 Pulse Width Discrimination','FontSize',16)
c2=1;

f3=figure; %figure for S104, freq
h3=axes('Parent',f3);
xlabel('Relative Frequency (Test-reference) Percentage (%)','FontSize',14);
ylabel('Percentage of "test stimulus stronger" responses (%)','FontSize', 14);
axis([-100 100 0 100])
title('S104 Frequency Discrimination','FontSize',16)
c3=1;

f4=figure; %figure for S104, PW
h4=axes('Parent',f4);
xlabel('Relative PW (Test-reference) Percentage (%)','FontSize',14);
ylabel('Percentage of "test stimulus stronger" responses (%)','FontSize', 14);
axis([-100 100 0 100])
title('S104 Pulse Width Discrimination','FontSize',16)
c4=1;

f5=figure;
h5=axes('Parent', f5);
xlabel('Relative Frequency (Test-reference) Percentage (%)','FontSize',14);
ylabel('Percentage of "test stimulus stronger" responses (%)','FontSize', 14);
axis([-100 100 0 100])
title('Frequency Discrimination, All Subjects','FontSize',16)
c5=1;

f6=figure;
h6=axes('Parent', f6);
xlabel('Relative Frequency (Test-reference) Percentage (%)','FontSize',14);
ylabel('Percentage of "test stimulus stronger" responses (%)','FontSize', 14);
axis([-100 100 0 100])
title('Frequency Discrimination, 50 Hz reference, All Subjects','FontSize',16)
c6=1;

f7=figure;
h7=axes('Parent', f7);
xlabel('Relative Frequency (Test-reference) Percentage (%)','FontSize',14);
ylabel('Percentage of "test stimulus stronger" responses (%)','FontSize', 14);
axis([-100 100 0 100])
title('Frequency Discrimination, 100 Hz reference, All Subjects','FontSize',16)
c7=1;

f8=figure; %figure for all subjects, PW
h8=axes('Parent',f8);
xlabel('Relative PW (Test-reference) Percentage (%)','FontSize',14);
ylabel('Percentage of "test stimulus stronger" responses (%)','FontSize', 14);
axis([-100 100 0 100])
title('Pulse Width Discrimination, All Subjects','FontSize',16)
c8=1;

leg1={};
leg2={};
leg3={};
leg4={};
leg5={};
leg6={};
leg7={};
leg8={};
%% Iterate through each discrimination file containing data
for k=1:length(datafiles)
    load(datafiles{k});
    expname=['Exp' datestr(datevec(datafiles{k}(11:end-4),'yyyy-mm-dd T HH.MM.SSPM'),'yyyymmddHHMMSS')];
    
    %Set subject ID, electrode contact
    SID=MyData.PatientID;
    elec=cell2mat(MyData.Contact);
    teststr=[]; %initialize
    prop=[]; %initialize
    teststrongperc=[]; %initialize
    testlist=[]; %initialize
    temp=[]; %make sure it's empty
    expdate=datestr(datevec(MyData.DateVal),'yyyymmdd');
    
    %store in summary matrix
    summary_data(k,1)=str2num(SID);
    summary_data(k,2)=str2num(elec);
    summary_data(k,3)=str2num(expdate);
    
    %Determine whether it was a frequency discrimination or a PW
    %discrimination
    if isfield(MyData,'StimFreq1')==1 %then this is a freq discrimination
        
        testfreq=[]; %initialize
        summary_data(k,4)=1;
        
        %Determine what the reference frequency is
        if max(MyData.StimFreq1)==166
            ref=100;
            testlist=[25 50 83 90 100 111 125 145 166];
        else
            ref=50;
            testlist=[12 25 40 45 50 55 62 76 90];
        end
        
        %initialize structures
        for i=1:length(testlist)
            prop.(['test' num2str(testlist(i))])=[];
        end
        
        
        %% Loop through trials - for freq discrim
        for j=1:MyData.Trial(end)
            %Determine if the test freq was the same as the ref
            if MyData.StimFreq1(j)==MyData.StimFreq2(j)
                %The determination of true or false will just be which button
                %was pressed - 0 for 1, 1 for 2 - to get idea of biasing toward
                %1st stimulus or not
                if MyData.Response(j)==1
                    teststr(j)=0;
                else
                    teststr(j)=1;
                end
                %Store the test frequency (which in this case is also the
                %reference)
                testfreq(j)=MyData.StimFreq1(j);
                prop.(['test' num2str(floor(testfreq(j)))])=cat(1, prop.(['test' num2str(floor(testfreq(j)))]), teststr(j));
                
            else %MyData.StimFreq1(j)~=MyData.StimFreq2(j) - or test was not the ref
                %Determine which stim was the test frequency and store the freq
                if MyData.StimFreq1(j)==ref
                    testfreq(j)=MyData.StimFreq2(j);
                else
                    testfreq(j)=MyData.StimFreq1(j);
                end
                %Determine whether the response was test or reference
                temp=MyData.(['StimFreq' num2str(MyData.Response(j))])(j);
                if temp==ref
                    teststr(j)=0;
                else
                    teststr(j)=1;
                end
                %Store the answer in the appropriate test frequency field
                prop.(['test' num2str(floor(testfreq(j)))])=cat(1, prop.(['test' num2str(floor(testfreq(j)))]), teststr(j));
            end
            
        end
        
        %Fill in teststrongperc - by summing across prop fields
        
        for i=1:length(testlist)
            teststrongperc(i)=5*sum(prop.(['test' num2str(testlist(i))]));
        end
        
        %Save data
        alldata.(expname).trialresults=cat(1,testfreq,teststr);
        alldata.(expname).type=1; %1=freq discrim, 2=PW discrim
        summary_data(k,4)=1;
        
    else %then this is a PW discrimination
        %determine the testlist for this experiment
        sortstim=sort(MyData.Stim1PW);
        dpw=sortstim(2:end)-sortstim(1:end-1);
        testlist=[sortstim(find(dpw>0)) sortstim(end)];
        ref=testlist(5);
        %initialize structures
        for i=1:length(testlist)
            prop.(['test' num2str(testlist(i))])=[];
        end
        
        testPW=[]; %initialize
        
        for j=1:MyData.Trial(end)
            %Determine if the test PW was the same as the reference
            if MyData.Stim1PW(j)==MyData.Stim2PW(j) %then the test = reference
                %The determination of true or false will just be which button
                %was pressed - 0 for 1, 1 for 2 - to get idea of biasing toward
                %1st stimulus or not
                if MyData.Response(j)==1 %button 1 was pressed
                    teststr(j)=0;
                else %button 2 was pressed
                    teststr(j)=1;
                end
                %Store the test PW (which in this case is also the
                %reference)
                testPW(j)=MyData.Stim1PW(j);
                prop.(['test' num2str(floor(testPW(j)))])=cat(1, prop.(['test' num2str(floor(testPW(j)))]), teststr(j));
                
            else % test does not = ref (MyData.Stim1PW(j)~=MyData.Stim2PW(j))
                %Determine which stim was the test PW and store the PW
                if MyData.Stim1PW(j)==ref
                    testPW(j)=MyData.Stim2PW(j);
                else
                    testPW(j)=MyData.Stim1PW(j);
                end
                %Determine whether the response was test or reference
                temp=MyData.(['Stim' num2str(MyData.Response(j)) 'PW'])(j);
                if temp==ref
                    teststr(j)=0;
                else
                    teststr(j)=1;
                end
                prop.(['test' num2str(floor(testPW(j)))])=cat(1, prop.(['test' num2str(floor(testPW(j)))]), teststr(j));
            end
            
        end
        
        %Fill in teststrongperc - by summing across prop fields
        for i=1:length(testlist)
            teststrongperc(i)=5*sum(prop.(['test' num2str(testlist(i))]));
        end
        
        %Save data
        alldata.(expname).trialresults=cat(1,testPW,teststr);
        alldata.(expname).type=2; %1=freq discrim, 2=PW discrim
        summary_data(k,4)=2;
    end
    %Save data
    alldata.(expname).prop=prop;
    alldata.(expname).percentage=teststrongperc;
    alldata.(expname).testlist=testlist;
    alldata.(expname).ref=ref;
    alldata.(expname).SID=SID;
    alldata.(expname).date=expdate;
    alldata.(expname).elec=elec;
    summary_data(k,5)=ref;
    
    save('formatted_data_intensityJND.mat','alldata')
    
    %% Curve fitting - discrimination data
    
    % Cumulative distribution function
    
    %depends on variables loaded
    xdata=((testlist-ref)/ref)*100; %need to offset the frequencies (or PWs) by the reference frequency
    ydata=teststrongperc; %the percetage data
    ydata(5)=50; %just for purposes of curve fitting - will put in actual value later
    
    %try 10 curve fits
    MSE=inf; %initialize to infinity
    p=[]; %initialize
    temp=[];
    
    %Specify upper and lower bounds - only useful for lsqcurvefit
    ub=[110 200 inf 10 inf];
    lb=[80 0 -inf -1 -inf];
    
    for q=1:10 %try to fit 10 times, with 10 new guesses
        %randomly create guesses between these bounds
      
        th1=rand()*20+40; %coefficient A
        th2=rand()*30-15; %mu
        th3=rand()*50-50; %sigma
       
        
        %cumulative distriution function
        thIN=[th1 th2 th3]; %vector of theta estimates, to put in lsqcurvefit
        
       %
        %Use nonlinearmodel.fit from statistics toolbox - will give more
        %data about the fit
        %Function to fit = cumulative normal distribution
        try
            F=@(p,xdata) (p(1)*(1-erf((xdata-p(2))./(p(3)*sqrt(2)))));
            alldata.(expname).mdl=NonLinearModel.fit(xdata,ydata,F, thIN);
            
            
            if alldata.(expname).mdl.MSE < MSE
                temp=dataset2cell(alldata.(expname).mdl.Coefficients(:,1));
                p=cell2mat(temp(2:end,2));
                MSE=alldata.(expname).mdl.MSE;
                R2=alldata.(expname).mdl.Rsquared.Adjusted;
            end
        catch
        end
        
    end
    %Save fit data to summary structure
    summary_data(k,6:8)=p';
    summary_data(k,11)=MSE;
    summary_data(k,12)=R2;
    
    %create and store summary metrics - jnd and pss
    try %in case it fails because complex
        jnd=abs(((CDFinv(50,p')-CDFinv(25,p'))+(CDFinv(75,p')-CDFinv(50,p')))/2);
        if isreal(jnd)==0 || jnd>100
            summary_data(k,13)=NaN;
        else
            summary_data(k,13)=jnd;
        end
       
    catch
        summary_data(k,13)=NaN;
    end
    summary_data(k,14)=CDFinv(50,p');
    summary_data(k,15)=teststrongperc(5);
    
    %% Plotting
    xfit=[-100:0.1:100];
    yfit=(p(1)*(1-erf((xfit-p(2))./(p(3)*sqrt(2)))));
    %     yfit=(100./(1 + p(1).*exp(-p(2).*(xfit-p(3))))+p(4));
    
    %plot individual blocks
    figs.(['F' num2str(k)])=figure;
    figs.(['H' num2str(k)])=axes('Parent',figs.(['F' num2str(k)]));
    hold on
    scatter(figs.(['H' num2str(k)]),[xdata(1:4) xdata(6:9)],[ydata(1:4) ydata(6:9)],40,[0 0 1]);
    scatter(figs.(['H' num2str(k)]),xdata(5),teststrongperc(5),40,[1 0 0]);
    plot(figs.(['H' num2str(k)]),xfit,yfit,'LineWidth',3)
    textline=['R-squared=' num2str(R2)];
    text(figs.(['H' num2str(k)]),-80,80,textline,'FontSize',12);
    hold off
    ylabel(figs.(['H' num2str(k)]),'Percentage of "test stimulus stronger" responses (%)','FontSize', 14);
    axis(figs.(['H' num2str(k)]),[-100 100 0 100])
    
    %plot summary figures - for subject, discrimination type sets
    if summary_data(k,4)==1 %freq discrim
        title(figs.(['H' num2str(k)]),['S' SID ' M' elec ' Frequency discrimination, ref=' num2str(ref) ' Date:' expdate],'FontSize',16)
        xlabel(figs.(['H' num2str(k)]),'Relative Frequency (Test-reference) Percentage (%)','FontSize',14);
        
        %plot summary figs - freq discrim
        axes(h5)
        hold on
        plot(h5, xfit,yfit,'LineWidth',2,'Color',col(c5,:))
        leg5=cat(2,leg5,['S' SID ' M' elec ', ref=' num2str(ref) ', Rsq=' num2str(R2)]);
        hold off
        c5=c5+1;
        if ref==50
            axes(h6)
            hold on
            plot(h6,xfit,yfit,'LineWidth',2,'Color',col(c6,:))
            hold off
            leg6=cat(2,leg6,['S' SID ' M' elec  ', Rsq=' num2str(R2)]);
            hold off
            c6=c6+1;
        elseif ref==100
            axes(h7)
            hold on
            plot(h7,xfit,yfit,'LineWidth',2','Color',col(c7,:))
            hold off
            leg7=cat(2,leg7,['S' SID ' M' elec ', Rsq=' num2str(R2)]);
            hold off
            c7=c7+1;
        end
        if str2num(SID)==102
            axes(h1)
            hold on
            scatter(h1,[xdata(1:4) xdata(6:9)],[ydata(1:4) ydata(6:9)],20,col(c1,:));
            plot(h1,xfit,yfit,'LineWidth',2,'Color',col(c1,:))
            hold off
            leg1=cat(2,leg1,['Raw, M' elec ', ref=' num2str(ref) ', Date:' expdate]);
            leg1=cat(2,leg1,['Fit, M' elec ', ref=' num2str(ref) ', Rsq=' num2str(R2)]);
            c1=c1+1;
        elseif str2num(SID)==104
            axes(h3)
            hold on
            scatter(h3,[xdata(1:4) xdata(6:9)],[ydata(1:4) ydata(6:9)],20,col(c3,:));
            plot(h3,xfit,yfit,'LineWidth',2,'Color',col(c3,:))
            hold off
            leg3=cat(2,leg3,['Raw, M' elec ', ref=' num2str(ref) ', Date:' expdate]);
            leg3=cat(2,leg3,['Fit, M' elec ', ref=' num2str(ref) ', Rsq=' num2str(R2)]);
            c3=c3+1;
        end
    else %then it's a PW discrimination
        title(figs.(['H' num2str(k)]),['S' SID ' M' elec ' PW discrimination, ref=' num2str(ref) ' Date:' expdate],'FontSize',16)
        xlabel(figs.(['H' num2str(k)]),'Relative PW (Test-reference) Percentage (%)','FontSize',14);
        %plot summary figs - PW discrim
            axes(h8) %plot for PW discrim for all subjects
            hold on
            plot(h8,xfit,yfit,'LineWidth',2','Color',col(c8,:))
            hold off
            leg8=cat(2,leg8,['S' SID ' M' elec ', Rsq=' num2str(R2)]);
            hold off
            c8=c8+1;
        if str2num(SID)==102
            axes(h2)
            hold on
            scatter(h2,[xdata(1:4) xdata(6:9)],[ydata(1:4) ydata(6:9)],20,col(c2,:));
            plot(h2,xfit,yfit,'LineWidth',2,'Color',col(c2,:))
            hold off
            leg2=cat(2,leg2,['Raw, M' elec ', ref=' num2str(ref) ', Date:' expdate]);
            leg2=cat(2,leg2,['Fit, M' elec ', ref=' num2str(ref) ', Rsq=' num2str(R2)]);
            c2=c2+1;
        elseif str2num(SID)==104
            axes(h4)
            hold on
            scatter(h4,[xdata(1:4) xdata(6:9)],[ydata(1:4) ydata(6:9)],20,col(c4,:));
            plot(h4,xfit,yfit,'LineWidth',2,'Color',col(c4,:))
            hold off
            leg4=cat(2,leg4,['Raw, M' elec ', ref=' num2str(ref) ', Date:' expdate]);
            leg4=cat(2,leg4,['Fit, M' elec ', ref=' num2str(ref) ', Rsq=' num2str(R2)]);
            c4=c4+1;
        end
    end
end
% set(get(get(p1,'Annotation'),'LegendInformation'),'IconDisplayStyle',tmp)
legend(h1,leg1,'Location','NorthWest')
legend(h2,leg2,'Location','SouthEast')
legend(h3,leg3,'Location','SouthEast')
legend(h4,leg4,'Location','SouthEast')
legend(h5,leg5,'Location','EastOutside','FontSize',14)
legend(h6,leg6,'Location','EastOutside','FontSize',14)
legend(h7,leg7,'Location','EastOutside','FontSize',14)
legend(h8,leg8,'Location','EastOutside','FontSize',14)

%% Plot metrics - JND in bar plot
% f50grp=find(and(summary_data(:,4)==1,summary_data(:,5)==50));
% f100grp=find(and(summary_data(:,4)==1,summary_data(:,5)==100))
% pwgrp=find(summary_data(:,4)==2);

%need to restructure data in order to feed into bar()
sort_data=sortrows(summary_data,[3 2 4 5]);
ddate=cat(1,sort_data(2:end,3)-sort_data(1:(end-1),3),0);
delec=cat(1,abs(sort_data(2:end,2)-sort_data(1:(end-1),2)),0);

c1=1;
barticks={['S' num2str(sort_data(1,1)) ' M' num2str(sort_data(1,2)) ' ' num2str(sort_data(1,3))]};

for k=1:size(sort_data,1)
    if sort_data(k,4)==1 %freq
        if sort_data(k,5)==50 %col 1
            f50grp(c1,1)=sort_data(k,13);
        elseif sort_data(k,5)==100
            f100grp(c1,1)=sort_data(k,13);
        end
    elseif sort_data(k,4)==2 %pw
        pwgrp(c1,1)=sort_data(k,13);
    end
    if (ddate(k)>0 || delec(k)>0)
        c1=c1+1;
        barticks=cat(2,barticks,['S' num2str(sort_data(k,1)) ' M' num2str(sort_data(k,2)) ' ' num2str(sort_data(k,3))]);
        %         barticks=cat(2,barticks,sprintf('S%d M%d\n%d',sort_data(k,1),sort_data(k,1),sort_data(k,3)));
    end
end
%make sure all 3 groups are the same length
f50grp(length(f50grp)+1:c1)=0;
f100grp(length(f100grp)+1:c1)=0;
pwgrp(length(pwgrp)+1:c1)=0;
bar_data=cat(2,f50grp, f100grp, pwgrp);

%plot bar graph of jnd
figure
bar(bar_data,'grouped')
set(gca,'XTickLabel',barticks)
ylabel('Weber Fraction', 'FontSize', 14)
legend('Freq discrimination, 50 Hz reference','Freq discrimination, 100 Hz reference','PW discrimination')

%summary stats
avgjnd(1)=mean(f50grp(f50grp>0));
stdjnd(1)=std(f50grp(f50grp>0));
avgjnd(2)=mean(f100grp(f100grp>0));
stdjnd(2)=std(f100grp(f100grp>0));
avgjnd(3)=mean(pwgrp(pwgrp>0));
stdjnd(3)=std(pwgrp(pwgrp>0));

%plot jnd bar plot to compare across conditions
%includes error bars for the std dev
figure
hold on
bar(avgjnd, 'FaceColor',[0.12 0.56 1])
barlab={'','Freq, 50Hz ref','','Freq, 100Hz ref','','PW'};
set(gca,'XTickLabel',barlab,'FontSize',14);
errorbar(avgjnd, stdjnd,'.','Color','k','LineWidth',2);
xlabel('Discrimination Condition')
ylabel('Weber Fraction (%)', 'FontSize', 14)
title('Sensation Intensity JND','FontSize',14)
hold off

%Plot reference stimulus average value
sblen=length(summary_data(:,15));
avgsubjbias=mean(summary_data(:,15));
figure
hold on
bar(summary_data(:,15),'FaceColor',[0.12 0.56 1])
bar(sblen+1,avgsubjbias,'r')
hold off
legend('Individual experiments','Average','FontSize',14,'Location','EastOutside','FontSize',14)
title('Subject responses when the two stimuli were the same','FontSize',14)
ylabel('Percentage of subject responses that were #2','FontSize',14)


%Save everything
cd('C:\Users\Emily\Documents\MATLAB\JND Intensity');
save('all_data_intensityJND_erf.mat','alldata','summary_head','summary_data','bar_data','sort_data')
cd(defaultpath);

%% Analyze indentation matching data
clear all
defaultpath=pwd;
cd('C:\Users\Emily\Documents\MATLAB\JND Intensity');

datafiles={};
[datafiles, pathname]=uigetfile('*.mat','Pick the indentation analysis files','MultiSelect','on');
cd(pathname)

%initialize figures and axes
q1=1;
q2=1;
f1=figure; %S102
f2=figure; %S104
h1=axes('Parent',f1);
h2=axes('Parent',f2);

allmdls=[];
ind_match_data=[];

col=[0 0 1; 0 1 0; 1 0 0; 0.7 0 1; 0 0 0; 1 0 1];
leg1txt={};
leg2txt={};

for i=1:length(datafiles)
    clear avg_data data sort_data std_data
    load(datafiles{i});
    SID=datafiles{i}(4:6);
    elec=datafiles{i}(8);
    type=datafiles{i}(9);
    
    %find std dev
    sort_data=sortrows(data,1);
    q=1;
    for i=1:5:size(data,1)
        std_data(q,1)=sort_data(i,1);
        std_data(q,2)=std(sort_data(i:(i+4),2));
        q=q+1;
    end
    
    %save
    ind_match_data.(['S' SID]).(['M' elec]).data=avg_data;
    ind_match_data.(['S' SID]).(['M' elec]).std=std_data;
    
    if strcmp(type,'F')==1
        yrange=max(data(:,2));
        normdata=100*avg_data(:,2)/yrange;
        ind_match_data.(['S' SID]).(['M' elec]).scaled=cat(2,avg_data(:,1),normdata);
        axes(h1)
        
        allmdls.(['s' SID]).(['M' elec])=LinearModel.fit(avg_data(:,1),avg_data(:,2));
        t=dataset2cell(allmdls.(['s' SID]).(['M' elec]).Coefficients(:,1));
        p=cell2mat(t(2:end,2));
        xfit=[0:0.1:180];
        yfit=p(1)+p(2).*xfit;
        
        hold on
        scatter(h1,avg_data(:,1), avg_data(:,2),40,col(q1,:));
%         scatter(h1,avg_data(:,1), normdata,40,col(q1,:));
        plot(h1,xfit,yfit,'Color',col(q1,:));
        errorbar(std_data(:,1),avg_data(:,2),std_data(:,2),'Marker','none','LineStyle','none','LineWidth',2,'Color',col(q1,:))
        hold off
        leg1txt=cat(2,leg1txt,[SID ' M' elec]);
        leg1txt=cat(2,leg1txt,['Rsq=' num2str(allmdls.(['s' SID]).(['M' elec]).Rsquared.Adjusted)]);
        leg1txt=cat(2,leg1txt,' ');
        q1=q1+1;
    elseif strcmp(type,'P')==1
        pwrange=max(avg_data(:,1))-min(avg_data(:,1));
%         temp=100*(avg_data(:,1)-min(avg_data(:,1)))/pwrange;
        temp=avg_data(:,1)-min(avg_data(:,1));
        yrange=max(data(:,2));
        normdata=100*avg_data(:,2)/yrange;
        ind_match_data.(['S' SID]).(['M' elec]).scaled=cat(2,temp,normdata);
        axes(h2)
        
        allmdls.(['s' SID]).(['M' elec])=LinearModel.fit(temp,avg_data(:,2));
        t=dataset2cell(allmdls.(['s' SID]).(['M' elec]).Coefficients(:,1));
        p=cell2mat(t(2:end,2));
        xfit=[0:0.1:200];
        yfit=p(1)+p(2).*xfit;
        
        hold on
        scatter(h2,temp, avg_data(:,2),40,col(q2,:));
        plot(h2,xfit,yfit,'Color',col(q2,:));
         errorbar(temp,avg_data(:,2),std_data(:,2),'LineWidth',2,'Color',col(q2,:),'Marker','none','LineStyle','none')
        hold off
        leg2txt=cat(2,leg2txt,[SID ' M' elec]);
        leg2txt=cat(2,leg2txt,['Rsq=' num2str(allmdls.(['s' SID]).(['M' elec]).Rsquared.Adjusted)]);
        leg2txt=cat(2,leg2txt,' ');
        q2=q2+1;
    end
    xlabel(h1,'Frequency (Hz)','FontSize',14)
    ylabel(h1,'Indentation Depth (um)','FontSize',14)
    axis(h1,[0 180 0 9000])
   
    xlabel(h2,'PW, Relative to sensory threshold (us))','FontSize',14)
    ylabel(h2,'Indentation Depth (um)','FontSize',14)
    axis(h2,[0 200 0 9000]);
    
end
    
 legend(h1,leg1txt,'Location','EastOutside','FontSize',14);   
 legend(h2,leg2txt,'Location','EastOutside','FontSize',14);
 title(h1,'Matching indentation depth to stimulation frequency','FontSize',16)
 title(h2,'Matching indentation depth to stimulation PW','FontSize',16)
 

%save everything
cd('C:\Users\Emily\Documents\MATLAB\JND Intensity');
save('all_indmatch_data.mat','allmdls','ind_match_data')

clear all

%% Transform JND curves into indentation depth space

load('all_indmatch_data.mat')

load('all_data_intensityJND.mat')
clear summary_head summary_data bar_data sort_data

%in order to iterate, must know the field names of alldata
fname=fieldnames(alldata);


for i=1:length(fname)
    p=[];
    SID=alldata.(fname{i}).SID;
    elec=['M' alldata.(fname{i}).elec];
    type= alldata.(fname{i}).type;
    if type==1 %freq discrim
        %make sure that there is a mapping for this subject/contact combo
        if  isfield(allmdls.(['s' SID]),elec)
        temp=dataset2cell(allmdls.(['s' SID]).(elec).freq.Coefficients(:,1));
        p=cell2mat(temp(2:end,2));
        
        end
    else %pw discrim
        %make sure that there is a mapping for this subject/contact combo
        if  isfield(allmdls.(['s' SID]),elec)
            %should I leave pw scaled to 0-100% of range, or transform back
            %to microseconds?
            %here, fitting a model to raw pw data (in us)
            abspwmdls.(['s' SID]).(elec)=LinearModel.fit(ind_match_data.(['S' SID]).(elec).data(:,1),ind_match_data.(['S' SID]).(elec).data(:,2));
        temp=dataset2cell(abspwmdls.(['s' SID]).(elec).Coefficients(:,1));
        p=cell2mat(temp(2:end,2));
        
        end
    end
    if isfield(allmdls.(['s' SID]),elec)
        alldata.(fname{i}).inddepth=p(1)+p(2).*alldata.(fname{i}).testlist;
        figure
        scatter(alldata.(fname{i}).inddepth,alldata.(fname{i}).percentage)
        xfit=[0:1:alldata.(fname{i}).inddepth(end)+100];
        xlabel('Indentation depth (um)')
        ylabel('Percentage of "test stimulus stronger" responses (%)')
        if type==1
        title(['S' SID ' M' elec 'Frequency discrimination'])
        else
            title(['S' SID ' ' elec 'PW discrimination'])
        end
    end

end

% %% Curve fitting - data transformed into indentation depths
%     
%     % Gompertz curve
%     % y(t)=a*exp(-b*exp(-ct))
%     
%     %depends on variables loaded
%     xdata=((testlist-ref)/ref)*100; %need to offset the frequencies (or PWs) by the reference frequency
%     ydata=teststrongperc; %the percetage data
%     ydata(5)=50; %just for purposes of curve fitting - will put in actual value later
%     
%     %try 10 curve fits
%     MSE=inf; %initialize to infinity
%     p=[]; %initialize
%     temp=[];
%     
%     %Specify upper and lower bounds - only useful for lsqcurvefit
%     ub=[110 200 inf 10 inf];
%     lb=[80 0 -inf -1 -inf];
%     
%     for q=1:10
%         %randomly create guesses between these bounds
%         %th1 can vary between 0 and 20
%         th1=rand()*50+100; %coefficient A
%         %th2 can vary between 50 and 100
%         th2=rand()*30; %tau
%         %th3 can vary between -20 and 20
%         th3=rand()*200-200; %t0, freq offset
%         %th4 can vary between -200 and 0
%         th4=rand()*30-15; %y offset
%         %th5 can vary between -15 and 15
%         th5=rand()*200; %coefficient B
%         %gompertz
%         thIN=[th1 th2 th3 th4 th5]; %vector of theta estimates, to put in lsqcurvefit
%         
%         % %         Optimal estimates of thetas are in thOUT
%         %         [thOUT, resnorm, residual]=lsqcurvefit(@gompertzfit,thIN,xdata,ydata,lb,ub);
%         %
%         %Use nonlinearmodel.fit from statistics toolbox - will give more
%         %data about the fit
%         %Function to fit = gompertz
%         try
%             %             F=@(p,xdata) (p(1)*exp(-p(5)*exp(-(1/p(2)*(xdata-p(3)))))).*heaviside(xdata-p(3))+p(4);
%             F=@(p,xdata) (p(1)*exp(-p(5)*exp(-(1/p(2)*(xdata-p(3))))))+p(4);
%             %         F=@(p,xdata) (100./(1 + p(1).*exp(-p(2).*(xdata-p(3))))+p(4));
%             alldata.(expname).mdl=NonLinearModel.fit(xdata,ydata,F, thIN);
%             
%             
%             if alldata.(expname).mdl.MSE < MSE
%                 temp=dataset2cell(alldata.(expname).mdl.Coefficients(:,1));
%                 p=cell2mat(temp(2:end,2));
%                 MSE=alldata.(expname).mdl.MSE;
%                 R2=alldata.(expname).mdl.Rsquared.Adjusted;
%             end
%         catch
%         end
%         
%     end
%     %Save fit data to summary structure
%     summary_data(k,6:10)=p';
%     summary_data(k,11)=MSE;
%     summary_data(k,12)=R2;
%     
%     %create and store summary metrics - jnd and pss
%     try %in case it fails because complex
%         jnd=((CDFinv(50,p')-CDFinv(25,p'))+(CDFinv(75,p')-CDFinv(50,p')))/2;
%         if isreal(jnd)==0
%             summary_data(k,13)=NaN;
%         else
%             summary_data(k,13)=jnd;
%         end
%     catch
%         summary_data(k,13)=NaN;
%     end
%     summary_data(k,14)=CDFinv(50,p');
%     summary_data(k,15)=teststrongperc(5);
%     
%     %% Plotting
%     xfit=[-100:0.1:100];
%     yfit=(p(1)*exp(-p(5)*exp(-(1/p(2).*(xfit-p(3))))))+p(4);
%     %     yfit=(100./(1 + p(1).*exp(-p(2).*(xfit-p(3))))+p(4));
%     
%     %plot individual blocks
%     figs.(['F' num2str(k)])=figure;
%     figs.(['H' num2str(k)])=axes('Parent',figs.(['F' num2str(k)]));
%     hold on
%     scatter(figs.(['H' num2str(k)]),[xdata(1:4) xdata(6:9)],[ydata(1:4) ydata(6:9)],40,[0 0 1]);
%     scatter(figs.(['H' num2str(k)]),xdata(5),teststrongperc(5),40,[1 0 0]);
%     plot(figs.(['H' num2str(k)]),xfit,yfit,'LineWidth',3)
%     hold off
%     ylabel(figs.(['H' num2str(k)]),'Percentage of "test stimulus stronger" responses (%)','FontSize', 14);
%     axis(figs.(['H' num2str(k)]),[-100 100 0 100])
%     text(figs.(['H' num2str(k)]),-80,80,['R-squared=' num2str(R2)],'FontSize',12);
%     %plot summary figures - for subject, discrimination type sets
%     if summary_data(k,4)==1 %freq discrim
%         title(figs.(['H' num2str(k)]),['S' SID ' M' elec ' Frequency discrimination, ref=' num2str(ref) ' Date:' expdate])
%         xlabel(figs.(['H' num2str(k)]),'Relative Frequency (Test-reference) Percentage (%)','FontSize',14);
%         %plot summary figs - freq discrim
%         if str2num(SID)==102
%             axes(h1)
%             hold on
%             scatter(h1,[xdata(1:4) xdata(6:9)],[ydata(1:4) ydata(6:9)],20,col(c1,:));
%             plot(h1,xfit,yfit,'LineWidth',2,'Color',col(c1,:))
%             hold off
%             leg1=cat(2,leg1,['Raw, M' elec ', ref=' num2str(ref) ', Date:' expdate]);
%             leg1=cat(2,leg1,['Fit, M' elec ', ref=' num2str(ref) ', Date:' expdate]);
%             c1=c1+1;
%         elseif str2num(SID)==104
%             axes(h3)
%             hold on
%             scatter(h3,[xdata(1:4) xdata(6:9)],[ydata(1:4) ydata(6:9)],20,col(c3,:));
%             plot(h3,xfit,yfit,'LineWidth',2,'Color',col(c3,:))
%             hold off
%             leg3=cat(2,leg3,['Raw, M' elec ', ref=' num2str(ref) ', Date:' expdate]);
%             leg3=cat(2,leg3,['Fit, M' elec ', ref=' num2str(ref) ', Date:' expdate]);
%             c3=c3+1;
%         end
%     else
%         title(figs.(['H' num2str(k)]),['S' SID ' M' elec ' PW discrimination, ref=' num2str(ref) ' Date:' expdate])
%         xlabel(figs.(['H' num2str(k)]),'Relative PW (Test-reference) Percentage (%)','FontSize',14);
%         %plot summary figs - PW discrim
%         if str2num(SID)==102
%             axes(h2)
%             hold on
%             scatter(h2,[xdata(1:4) xdata(6:9)],[ydata(1:4) ydata(6:9)],20,col(c2,:));
%             plot(h2,xfit,yfit,'LineWidth',2,'Color',col(c2,:))
%             hold off
%             leg2=cat(2,leg2,['Raw, M' elec ', ref=' num2str(ref) ', Date:' expdate]);
%             leg2=cat(2,leg2,['Fit, M' elec ', ref=' num2str(ref) ', Date:' expdate]);
%             c2=c2+1;
%         elseif str2num(SID)==104
%             axes(h4)
%             hold on
%             scatter(h4,[xdata(1:4) xdata(6:9)],[ydata(1:4) ydata(6:9)],20,col(c4,:));
%             plot(h4,xfit,yfit,'LineWidth',2,'Color',col(c4,:))
%             hold off
%             leg4=cat(2,leg4,['Raw, M' elec ', ref=' num2str(ref) ', Date:' expdate]);
%             leg4=cat(2,leg4,['Fit, M' elec ', ref=' num2str(ref) ', Date:' expdate]);
%             c4=c4+1;
%         end
%     end
% 
% % set(get(get(p1,'Annotation'),'LegendInformation'),'IconDisplayStyle',tmp)
% legend(h1,leg1,'Location','NorthWest')
% legend(h2,leg2,'Location','SouthEast')
% legend(h3,leg3,'Location','SouthEast')
% legend(h4,leg4,'Location','SouthEast')
