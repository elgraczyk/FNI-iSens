%plotting for paper

close all
load('all_data_intensityJND_erf.mat');



%First save example figures for discriminations:

%Use S102 M3 as example:
%rows in summary-data: 6,7,8
%to plot both frequency examples together
f=figure;
h=axes('Parent',f);
for k=[1,2,11]
    ref=summary_data(k,5);
    SID=num2str(summary_data(k,1));
    elec=num2str(summary_data(k,2));
    R2=summary_data(k,12);
    expname=['Exp' num2str(summary_data(k,10))];
    if alldata.(expname).type==2
        %     xdata=(((testlist-testlist(1))-(ref-testlist(1)))/(ref-testlist(1)))*100; %need to offset the frequencies (or PWs) by the reference frequency
        xdata=(alldata.(expname).testlist-ref)/(ref)*100;
    else
        xdata=((alldata.(expname).testlist-ref)/ref)*100;
    end
    xdata=[xdata(1:4) xdata(6:9)];
    ydata=([alldata.(expname).percentage(1:4) alldata.(expname).percentage(6:9)])./100; %the percetage data
    
    p=summary_data(k,6:8);
    xfit=[-100:0.01:100];
    yfit=(p(1)*(1-erf((xfit-p(2))./(p(3)*sqrt(2)))))./100;
    %     yfit=(100./(1 + p(1).*exp(-p(2).*(xfit-p(3))))+p(4));
    
    %plot individual blocks
    figs.(['F' num2str(k)])=figure;
    figs.(['H' num2str(k)])=axes('Parent',figs.(['F' num2str(k)]));
    hold on
    scatter(figs.(['H' num2str(k)]),xdata,ydata,70,[0.11 0.56 1],'fill');
    plot(figs.(['H' num2str(k)]),xfit,yfit,'LineWidth',3, 'Color', [0.28 0.23 0.54]);
    
    %     scatter(figs.(['H' num2str(k)]),xdata(5),teststrongperc(5),70,[0.8 0 0],'fill');
    %     l1=legend(['Fit, Cumulative distribution'; ['function, Rsq = ' num2str(R2,'%1.2f') '        ']],'Raw data', ['Percentage of "second stimulus'; 'stronger" responses (%)       ']);
    %     l1=legend('Raw data',['Fit, Cumulative distribution'; ['function, Rsq = ' num2str(R2,'%1.2f') '        ']]);
    %     set(l1,'Location','SouthEast','FontSize',15,'FontName','Calibri')
    %     set(l1,'Box','off')
    
    hold off
    ylabel(figs.(['H' num2str(k)]),'P(test stimulus stronger)','FontSize', 14);
    
    if k==1 || k==11
        axes(h)
        hold on
        if k==1
            hLine=scatter(h,xdata,ydata,70,[0.11 0.56 1],'fill');
            set(get(get(hLine,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            plot(h,xfit,yfit,'LineWidth',3, 'Color', [0.28 0.23 0.54]);
        else
            hLine=scatter(h,xdata,ydata,70,[1 0.41 0.7],'fill');
            set(get(get(hLine,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            plot(h,xfit,yfit,'LineWidth',3, 'Color', [0.78 0.08 0.52]);
        end
        hold off
    end
    
    l2=legend(h,'50 Hz reference', '100 Hz reference');
    set(l2,'Location','SouthEast','FontSize',15,'FontName','Calibri')
    set(l2,'Box','off')
    xlabel(h,'Test PF (%)','FontSize',14);
    ylabel(h,'P(test stimulus stronger)','FontSize', 14);
    axis(h,[-100 100 0 1])
    %plot summary figures - for subject, discrimination type sets
    if summary_data(k,4)==1 %freq discrim
        %         title(figs.(['H' num2str(k)]),['S' SID ' M' elec ' Frequency discrimination, ref=' num2str(ref) ' Hz'],'FontSize',16)
        xlabel(figs.(['H' num2str(k)]),'Test PF (%)','FontSize',14);
        axis(figs.(['H' num2str(k)]),[-100 100 0 1])
    else
        %         title(figs.(['H' num2str(k)]),['S' SID ' M' elec ' PW discrimination, ref=' num2str(ref) ' us'],'FontSize',16)
        xlabel(figs.(['H' num2str(k)]),'Test PW (%)','FontSize',14);
        axis(figs.(['H' num2str(k)]),[-40 40 0 1])
    end
    saveas(figs.(['H' num2str(k)]),['disexmp' num2str(k) '.tif']);
end
saveas(h,'disexmp_freq.tif');


%%
%Bar plot for JND
f=figure;
h=axes('Parent',f);
col=[0 0 1; 0 1 0; 1 0 0];
hold on
for i=1:3
    x=[];
    y=[];
    t=length(bar_data(bar_data(:,i)>0));
    if rem(t,2)==0 %even num
        x=[i-(t/2)*0.05+0.025:0.05:i+0.05*(t/2)-0.025];
    else %odd num
        x=[i-floor(t/2)*0.05:0.05:i+0.05*floor(t/2)];
    end
    y=bar_data(bar_data(:,i)>0,i);
    scatter(x,y,70,col(i,:),'fill')
end
bar(avgjnd, 'FaceColor','none','EdgeColor',[0 0 1])
barlab={'','PF, 50Hz ref','','PF, 100Hz ref','','PW'};
set(gca,'XTickLabel',barlab,'FontSize',14);
errorbar(avgjnd, stdjnd,'.','Color','k','LineWidth',2);
xlabel({'';'Discrimination Condition'},'FontSize',14)
ylabel('Weber Fraction (%)', 'FontSize', 14)
% title('Sensation Intensity JND','FontSize',14)
hold off
saveas(h,'JNDscatterbar.tif')

%Indentation matching
%104 M6: rows 7 and 8 in summary_ind_data
clear all
load('all_indmatch_data.mat');
for i=7:8
    SID=num2str(summary_ind_data(i,1));
    elec=num2str(summary_ind_data(i,2));
    if summary_ind_data(i,3)==1
        type='F';
    else
        type='P';
    end
    p=summary_ind_data(i,4:5);
    xfit=[0:0.1:180];
    yfit=p(1)+p(2).*xfit;
    avg_data=ind_match_data.(['S' SID]).(['M' elec]).(type).data;
    std_data=ind_match_data.(['S' SID]).(['M' elec]).(type).std;
    f=figure
    if summary_ind_data(i,3)==1
        hold on
        scatter(avg_data(:,1), avg_data(:,2),40,[1 0.64 0],'fill');
        plot(xfit,yfit,'Color',[1 0.64 0],'LineWidth',2);
        errorbar(std_data(:,1),avg_data(:,2),std_data(:,2),'Marker','none','LineStyle','none','LineWidth',2,'Color',[1 0.64 0])
        xlabel('PF (Hz)','FontSize',14)
        ylabel('Indentation Depth (um)','FontSize',14)
        axis([0 180 0 2000])
        hold off
        saveas(f,'exmp_indmatch_freq.tif')
    else
        temp=avg_data(:,1)-min(avg_data(:,1));
        avg_data=cat(2,temp,avg_data(:,2));
        hold on
        scatter(avg_data(:,1), avg_data(:,2),40,[1 0.27 0],'fill');
        plot(xfit,yfit,'Color',[1 0.27 0],'LineWidth',2);
        errorbar(avg_data(:,1),avg_data(:,2),std_data(:,2),'Marker','none','LineStyle','none','LineWidth',2,'Color',[1 0.27 0])
        xlabel('PW (relative to perceptual threshold) (us)','FontSize',14)
        ylabel('Indentation Depth (um)','FontSize',14)
        axis([0 180 0 2000])
        hold off
        saveas(f,'exmp_indmatch_pw.tif')
    end
end

%Bar plot for y intercept
f=figure;
h=axes('Parent',f);
col=[0 0 1; 0 1 0; 1 0 0];
hold on
for i=1:2
    x=[];
    y=[];
    x=[i:0.05:i+0.05*(length(bar_yint(bar_yint(:,i)>0))-1)];
    y=bar_yint(bar_yint(:,i)>0,i);
    scatter(x,y,70,col(i,:),'fill')
end
bar(avg_yint, 'FaceColor','none','EdgeColor',[0 0 1])
barlab={'','PF','','PW'};
set(gca,'XTickLabel',barlab,'FontSize',14);
errorbar(avg_yint, std_yint,'.','Color','k','LineWidth',2);
xlabel({'';'Matching Condition'},'FontSize',14)
ylabel('Indentation Depth (um)', 'FontSize', 14)
% title('Sensation Intensity JND','FontSize',14)
hold off
saveas(h,'ind_yint_scatterbar.tif')

%slope of the fit line
f=figure;
h=axes('Parent',f);
col=[0 0 1; 0 1 0; 1 0 0];
hold on
for i=1:2
    x=[];
    y=[];
    x=[i:0.05:i+0.05*(length(bar_m(bar_m(:,i)>0))-1)];
    y=bar_m(bar_m(:,i)>0,i);
    scatter(x,y,70,col(i,:),'fill')
end
bar(avg_m, 'FaceColor','none','EdgeColor',[0 0 1])
barlab={'','PF','','PW'};
set(gca,'XTickLabel',barlab,'FontSize',14);
errorbar(avg_m, std_m,'.','Color','k','LineWidth',2);
xlabel({'';'Matching Condition'},'FontSize',14)
ylabel('Slope', 'FontSize', 14)
% title('Sensation Intensity JND','FontSize',14)
hold off
saveas(h,'ind_slope_scatterbar.tif')

%bar plot for average of SEM
f=figure;
h=axes('Parent',f);
col=[0 0 1; 0 1 0; 1 0 0];
hold on
for i=1:2
    x=[];
    y=[];
    x=[i:0.05:i+0.05*(length(bar_msem(bar_msem(:,i)>0))-1)];
    y=bar_msem(bar_msem(:,i)>0,i);
    scatter(x,y,70,col(i,:),'fill')
end
bar(avg_msem, 'FaceColor','none','EdgeColor',[0 0 1])
barlab={'','PF','','PW'};
set(gca,'XTickLabel',barlab,'FontSize',14);
errorbar(avg_msem, std_msem,'.','Color','k','LineWidth',2);
xlabel({'';'Matching Condition'},'FontSize',14)
ylabel('Standard Error of the Mean (um)', 'FontSize', 14)
% title('Sensation Intensity JND','FontSize',14)
hold off
saveas(h,'ind_avgSEM_scatterbar.tif')