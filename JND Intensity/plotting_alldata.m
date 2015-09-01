%plotting for paper

close all
cd('C:\Users\Emily\Documents\MATLAB\JND Intensity')
load('all_data_intensityJND_erf.mat');

%Set colors
col=[1 0.647059 0; 0.12549 0.698039 0.666667;0.690196 0.188235 0.376471];
%first - PW
%second - F50
%thrid - F100

%First save example figures for discriminations:

%Use S102 M3 as example:
%rows in summary-data: 6,7,8
%to plot both frequency examples together
fpf=figure;
h=axes('Parent',fpf);
leg={};

%make plots of individual examples
for k=[3, 7, 13] %[1,2,11]
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
    if summary_data(k,4)==1
        scatter(figs.(['H' num2str(k)]),xdata,ydata,70,[0.11 0.65 1],'fill');
        plot(figs.(['H' num2str(k)]),xfit,yfit,'LineWidth',2, 'Color', [0.28 0.23 0.54])
        text(0,0.2,['y = $\displaystyle\frac{' num2str(p(1)/100,'%1.2f') '*(1-erf(x+' num2str(abs(p(2)),'%1.1f') '))}{(' num2str(p(3),'%1.1f') '\sqrt{2} )}$'],'Interpreter','latex','FontName','Helvetica','FontSize',12);
        text(0,0.1,['R$^{2}$ = ' num2str(R2,'%1.2f')],'interpreter','latex','FontSize',12)
    else
        scatter(figs.(['H' num2str(k)]),xdata,ydata,70,[1 0.54902 0],'fill');
        plot(figs.(['H' num2str(k)]),xfit,yfit,'LineWidth',2, 'Color', col(1,:));
        text(0,0.2,['y = $\displaystyle\frac{' num2str(p(1)/100,'%1.2f') '*(1-erf(x+' num2str(abs(p(2)),'%1.1f') '))}{(' num2str(p(3),'%1.1f') '\sqrt{2} )}$)'],'Interpreter','latex','FontName','Helvetica','FontSize',12);
        text(0,0.1,['R$^{2}$ = ' num2str(R2,'%1.2f')],'interpreter','latex','FontSize',12)
    end
    
    %     scatter(figs.(['H' num2str(k)]),xdata(5),teststrongperc(5),70,[0.8 0 0],'fill');
    %     l1=legend(['Fit, Cumulative distribution'; ['function, Rsq = ' num2str(R2,'%1.2f') '        ']],'Raw data', ['Percentage of "second stimulus'; 'stronger" responses (%)       ']);
    %     l1=legend('Raw data',['Fit, Cumulative distribution'; ['function, Rsq = ' num2str(R2,'%1.2f') '        ']]);
    %     set(l1,'Location','SouthEast','FontSize',15,'FontName','Calibri')
    %     set(l1,'Box','off')
     
    
    hold off
    ylabel(figs.(['H' num2str(k)]),'P(test stimulus stronger)','FontSize', 14);
    
    if k==7 || k==13 %k==1 || k==11
        axes(h)
        hold on
        if summary_data(k,5)==50 %k==1
            hLine=scatter(h,xdata,ydata,70,[0.282353 0.819608 0.8],'fill');
            set(get(get(hLine,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            plot(h,xfit,yfit,'LineWidth',2, 'Color', col(2,:));
            leg=cat(1,leg,'50 Hz reference');
            text(5,0.55,['y$_{50}$ = $\displaystyle\frac{' num2str(p(1)/100,'%1.2f') '*(1-erf(x+' num2str(abs(p(2)),'%1.1f') '))}{(' num2str(p(3),'%1.1f') '\sqrt{ 2} )}$'],'Interpreter','latex','FontName','Helvetica','FontSize',12);
            text(5,0.45,['R$^{2}$ = ' num2str(R2,'%1.2f')],'interpreter','latex','FontSize',12)
        else
            hLine=scatter(h,xdata,ydata,70,[1 0.41 0.7],'fill');
            set(get(get(hLine,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            plot(h,xfit,yfit,'LineWidth',2, 'Color', col(3,:));
            leg=cat(1,leg,'100 Hz reference');
            text(-80,0.90,['y$_{100}$ = $\displaystyle\frac{' num2str(p(1)/100,'%1.2f') '*(1-erf(x+' num2str(abs(p(2)),'%1.1f') '))}{(' num2str(p(3),'%1.1f') '\sqrt{ 2} )}$'],'Interpreter','latex','FontName','Helvetica','FontSize',12);
            text(-80,0.8,['R$^{2}$ = ' num2str(R2,'%1.2f')],'interpreter','latex','FontSize',12)
        end
        hold off
    end
    
    l2=legend(h,leg);
    set(l2,'Location','SouthEast','FontSize',15)
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

%Create individual JND variables for each discrim type
%First, need to sort and find changes
JND.PW=[];
JND.F50=[];
JND.F100=[];
fitparams.PW=[];
fitparams.F50=[];
fitparams.F100=[];
for i=1:size(pooled_data,1)
    if pooled_data(i,4)==2
        JND.PW=[JND.PW pooled_data(i,13)];
        fitparams.PW=cat(1,fitparams.PW, pooled_data(i,6:8));
    else
        if pooled_data(i,5)==50
            JND.F50=[JND.F50 pooled_data(i,13)];
            fitparams.F50=cat(1,fitparams.F50, pooled_data(i,6:8));
        else
            JND.F100=[JND.F100 pooled_data(i,13)];
            fitparams.F100=cat(1,fitparams.F100, pooled_data(i,6:8));
        end
    end
end
avgjnd=[];

fbar=figure;
h=axes('Parent',fbar);

alljnd=[];
allsemjnd=[];
hold on
types=fieldnames(JND);
for i=1:length(types)
    avgjnd=mean(JND.(types{i})(JND.(types{i})>0))/100;
    semjnd=std(JND.(types{i})(JND.(types{i})>0)./100)/sqrt(length(JND.(types{i})(JND.(types{i})>0)));
    alljnd=[alljnd avgjnd];
    allsemjnd=[allsemjnd semjnd];
    
    x=[];
    y=[];
    t=length(JND.(types{i})(JND.(types{i})>0));
    if rem(t,2)==0 %even num
        x=[i-(t/2)*0.05+0.025:0.05:i+0.05*(t/2)-0.025];
    else %odd num
        x=[i-floor(t/2)*0.05:0.05:i+0.05*floor(t/2)];
    end
    y=JND.(types{i})(JND.(types{i})>0)./100;
    scatter(x,y,70,col(i,:),'fill')
    
    bar(i,avgjnd,'FaceColor','none','EdgeColor',col(i,:),'LineWidth',3)
end


barlab={'','PW','','PF, 50 Hz','','PF, 100 Hz'};
set(gca,'XTickLabel',barlab,'FontSize',14);
%put in errorbars
errorbar(alljnd, allsemjnd,'.','Color','k','LineWidth',3);

%draw lines for significance, and put asterisks over them
line([1 2],[0.41 0.41],'Color','k','LineWidth',3)
line([1 1],[0.4 0.41],'Color','k','LineWidth',3)
line([2 2],[0.4 0.41],'Color','k','LineWidth',3)
text(1.5,0.41,'*','FontSize',28)
line([1 3],[0.44 0.44],'Color','k','LineWidth',3)
line([1 1],[0.43 0.44],'Color','k','LineWidth',3)
line([3 3],[0.43 0.44],'Color','k','LineWidth',3)
text(2,0.44,'*','FontSize',28)

%figure labels
xlabel({'';'Discrimination Condition'},'FontSize',14)
ylabel('Weber Fraction', 'FontSize', 14)
axis([0.5 3.5 0 0.47])
% title('Sensation Intensity JND','FontSize',14)
hold off
%save
saveas(h,'JNDscatterbar.tif')

%% Plot data based on discrim type
xfit=[-100:0.01:110];
% col=[0.12549 0.698039 0.666667];
% col2=[0.690196 0.188235 0.376471];
c1=1;
avgcurves=[];
for i=1:length(types)
    %calculate average of fit params
    plin=mean(fitparams.(types{i}));
    %initialize structures for pooling yfits
    allyfit=[];
    
    %initialize
    f1=figure;
    
    hold on
    for j=1:length(fitparams.(types{i}))
        p=fitparams.(types{i})(j,:);
        yfit=(p(1)*(1-erf((xfit-p(2))./(p(3)*sqrt(2)))))./100;
        ywid=0.03;
        xwid=3;
        patch([xfit+xwid fliplr(xfit)-xwid],[yfit-ywid, fliplr(yfit)+ywid],col(c1,:),'EdgeColor','none','FaceAlpha',0.3)
        allyfit=[allyfit; yfit];
        
    end
    yfit=(plin(1)*(1-erf((xfit-plin(2))./(plin(3)*sqrt(2)))))./100;
    plot(xfit,yfit,'LineWidth',2,'Color','r')
    
    avgyfit=mean(allyfit);
    avgxfit=xfit;
        
    plot(avgxfit, avgyfit,'LineWidth',2,'Color','k')
    
    ylabel('P(test stimulus stronger)','FontName','Arial','FontSize',14)
    if strcmp('PW',types{i})
         xlabel('Test PW (%)','FontName','Arial','FontSize',14)
         axis([-40 40 0 1])
    else
        xlabel('Test PF (%)','FontName','Arial','FontSize',14)
        axis([-100 100 0 1])
    end
    hold off
    
    %plot just the avg and SEM curves
    semyfit=std(allyfit)/sqrt(size(allyfit,1));
    avgcurves.(types{i})=cat(1,avgyfit,semyfit);
    
    figs.agg.(types{i})=figure;
    hold on
    patch([avgxfit fliplr(avgxfit)],[avgyfit+semyfit fliplr(avgyfit-semyfit)],col(c1,:),'EdgeColor','none','FaceAlpha',0.8)
    plot(avgxfit, avgyfit,'LineWidth',2,'Color','k')
    ylabel('P(test stimulus stronger)','FontName','Arial','FontSize',14)
%     title([types{i} ' Average and std dev of curves'])
    if strcmp('PW',types{i})
%          text(20,0.2,['n=' num2str(size(allyfit,1))],'FontSize',14)
         xlabel('Test PW (%)','FontName','Arial','FontSize',14)
         axis([-40 40 0 1])
    else
%         text(40,0.2,['n=' num2str(size(allyfit,1))],'FontSize',14)
        xlabel('Test PF (%)','FontName','Arial','FontSize',14)
        axis([-100 100 0 1])
    end
    
    hold off
    saveas(f1,['all' types{i} 'discrim.tif']);
    saveas(figs.agg.(types{i}),['all' types{i} 'discrim_avgsem.tif']);
    c1=c1+1;
end

%try plotting F50 and F100 together in one figure
%will probably discard this later - it looks bad
f=figure;
h=axes('Parent',f);
hold on
c1=2;
for i=2:3
    avgyfit=avgcurves.(types{i})(1,:);
    semyfit=avgcurves.(types{i})(2,:);
    
    patch([xfit fliplr(xfit)],[avgyfit+semyfit fliplr(avgyfit-semyfit)],col(c1,:),'EdgeColor','none','FaceAlpha',0.8)
    plot(xfit, avgyfit,'LineWidth',2,'Color','k')
    ylabel('P(test stimulus stronger)','FontName','Arial','FontSize',14)

        xlabel('Test PF (%)','FontName','Arial','FontSize',14)
        axis([-100 100 0 1])
   c1=c1+1;
  
end
%add in the legend
    leg=legend(h,'50 Hz reference', '100 Hz reference');
    set(leg,'Location','SouthEast','FontSize',15,'FontName','Calibri')
    set(leg,'Box','off')

    
    %%
    %set up plot with subpanels
psdfig=figure;
ax=zeros(6,1);
for i=1:6
    ax(i)=subplot(3,2,i);
end
k=[7, 3,13];
types={'F100','PW','F50'};

for i=1:6
    if i==1
        figure(fpf)
    end
    if i==2
        figure(figs.(['F' num2str(k(i))]));
    end
    if i==3 || i==4 || i==5
        figure(figs.agg.(types{i-2}));
    end
    if i==6
        figure(fbar);
    end
    h=get(gcf,'Children');
    newh=copyobj(h,psdfig);
    for j=1:length(newh)
            posnewh=get(newh(j),'Position');
            possub=get(ax(i),'Position');
            set(newh(j),'Position',[possub(1) possub(2) possub(3) possub(4)])
    end
    delete(ax(i))
end
%% Indentation matching
%104 M6: rows 7 and 8 in summary_ind_data
clear all
%Set colors
col=[1 0.647059 0; 0.12549 0.698039 0.666667;0.690196 0.188235 0.376471];
%first - PW
%second - F50
%thrid - F100
load('all_indmatch_data.mat');
for i=[7 8]
    SID=num2str(summary_ind_data(i,1));
    elec=num2str(summary_ind_data(i,2));
    R2=summary_ind_data(i,7);
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
        scatter(avg_data(:,1), avg_data(:,2),40,col(2,:),'fill');
        plot(xfit,yfit,'Color',col(2,:),'LineWidth',2);
        errorbar(std_data(:,1),avg_data(:,2),std_data(:,2),'Marker','none','LineStyle','none','LineWidth',2,'Color',col(2,:))
        xlabel('PF (Hz)','FontSize',14)
        ylabel('Indentation Depth (\mum)','FontSize',14)
        axis([0 180 0 1200])
        text(70,400,['y = ' num2str(p(1),'%1.2f') ' + ' num2str(p(2),'%1.2f') '*x'],'Interpreter','latex','FontName','Helvetica','FontSize',13);
        text(70,300,['R$^{2}$ = ' num2str(R2,'%1.2f')],'interpreter','latex','FontSize',13)
        hold off
        saveas(f,'exmp_indmatch_freq.tif')
    else
        temp=avg_data(:,1);%-min(avg_data(:,1));
        avg_data=cat(2,temp,avg_data(:,2));
        hold on
        scatter(avg_data(:,1), avg_data(:,2),40,col(1,:),'fill');
        plot(xfit+avg_data(1,1),yfit,'Color',col(1,:),'LineWidth',2);
        errorbar(avg_data(:,1),avg_data(:,2),std_data(:,2),'Marker','none','LineStyle','none','LineWidth',2,'Color',col(1,:))
        xlabel('PW (\mus)','FontSize',14)
        ylabel('Indentation Depth (\mum)','FontSize',14)
        axis([avg_data(1,1)-10 avg_data(end,1)+10 0 2000])
        text(150,1600,['y = ' num2str(p(1),'%1.2f') ' + ' num2str(p(2),'%1.2f') '*x'],'Interpreter','latex','FontName','Helvetica','FontSize',13);
        text(150,1400,['R$^{2}$ = ' num2str(R2,'%1.2f')],'interpreter','latex','FontSize',13)
        hold off
        saveas(f,'exmp_indmatch_pw.tif')
    end
end

allyfitind.P=[];
allyfitind.F=[];
for i=1:size(summary_ind_data,1)
    
    p=summary_ind_data(i,4:5);
    xfit=[0:0.1:180];
    yfit=p(1)+p(2).*xfit;
    if summary_ind_data(i,3)==1
        type='F';
        
    else
        type='P';
        
    end
    allyfitind.(type)=[allyfitind.(type); yfit];
end

types={'P','F'};
c1=1;
for i=1:length(types)
    avgindcurves.(types{i})(1,:)=mean(allyfitind.(types{i}));
    avgindcurves.(types{i})(2,:)=std(allyfitind.(types{i}))/sqrt(size(allyfitind.(types{i}),1));

    figure
    hold on
    for j=1:size(allyfitind.(types{i}),1)
        patch([xfit fliplr(xfit)],[allyfitind.(types{i})(j,:)+100 fliplr(allyfitind.(types{i})(j,:)-100)],col(c1,:),'EdgeColor','none','FaceAlpha',0.8)
    end
        plot(xfit, avgindcurves.(types{i})(1,:),'LineWidth',2,'Color','k')
        ylabel('Indentation Depth (\mum)','FontSize',14)
        if strcmp(types{i},'P')
            xlabel('PW, relative to threshold (\mus)','FontSize',14)
            axis([0 180 0 12000])
        else
            xlabel('PF (Hz)','FontSize',14)
            axis([0 180 0 6000])
        end
        hold off
        
        f=figure;
        hold on
        patch([xfit fliplr(xfit)],[avgindcurves.(types{i})(1,:)+avgindcurves.(types{i})(2,:) fliplr(avgindcurves.(types{i})(1,:)-avgindcurves.(types{i})(2,:))],col(c1,:),'EdgeColor','none','FaceAlpha',0.8)
        plot(xfit, avgindcurves.(types{i})(1,:),'LineWidth',2,'Color','k')
        ylabel('Indentation Depth (\mum)','FontSize',14)
        if strcmp(types{i},'P')
            xlabel('PW, relative to threshold (\mus)','FontSize',14)
            axis([0 180 0 12000])
        else
            xlabel('PF (Hz)','FontSize',14)
            axis([0 180 0 6000])
        end
        hold off
        saveas(f,['aggregateIndMatch_' types{i} '.tif'])
        c1=c1+1;
end

% %% For indentation match data
% %Bar plot for y intercept
% f=figure;
% h=axes('Parent',f);
% col=[0 0 1; 0 1 0; 1 0 0];
% hold on
% for i=1:2
%     x=[];
%     y=[];
%     x=[i:0.05:i+0.05*(length(bar_yint(bar_yint(:,i)>0))-1)];
%     y=bar_yint(bar_yint(:,i)>0,i);
%     scatter(x,y,70,col(i,:),'fill')
% end
% bar(avg_yint, 'FaceColor','none','EdgeColor',[0 0 1])
% barlab={'','PF','','PW'};
% set(gca,'XTickLabel',barlab,'FontSize',14);
% errorbar(avg_yint, std_yint,'.','Color','k','LineWidth',2);
% xlabel({'';'Matching Condition'},'FontSize',14)
% ylabel('Indentation Depth (um)', 'FontSize', 14)
% % title('Sensation Intensity JND','FontSize',14)
% hold off
% saveas(h,'ind_yint_scatterbar.tif')
% 
% %slope of the fit line
% f=figure;
% h=axes('Parent',f);
% col=[0 0 1; 0 1 0; 1 0 0];
% hold on
% for i=1:2
%     x=[];
%     y=[];
%     x=[i:0.05:i+0.05*(length(bar_m(bar_m(:,i)>0))-1)];
%     y=bar_m(bar_m(:,i)>0,i);
%     scatter(x,y,70,col(i,:),'fill')
% end
% bar(avg_m, 'FaceColor','none','EdgeColor',[0 0 1])
% barlab={'','PF','','PW'};
% set(gca,'XTickLabel',barlab,'FontSize',14);
% errorbar(avg_m, std_m,'.','Color','k','LineWidth',2);
% xlabel({'';'Matching Condition'},'FontSize',14)
% ylabel('Slope', 'FontSize', 14)
% % title('Sensation Intensity JND','FontSize',14)
% hold off
% saveas(h,'ind_slope_scatterbar.tif')
% 
% %bar plot for average of SEM
% f=figure;
% h=axes('Parent',f);
% col=[0 0 1; 0 1 0; 1 0 0];
% hold on
% for i=1:2
%     x=[];
%     y=[];
%     x=[i:0.05:i+0.05*(length(bar_msem(bar_msem(:,i)>0))-1)];
%     y=bar_msem(bar_msem(:,i)>0,i);
%     scatter(x,y,70,col(i,:),'fill')
% end
% bar(avg_msem, 'FaceColor','none','EdgeColor',[0 0 1])
% barlab={'','PF','','PW'};
% set(gca,'XTickLabel',barlab,'FontSize',14);
% errorbar(avg_msem, std_msem,'.','Color','k','LineWidth',2);
% xlabel({'';'Matching Condition'},'FontSize',14)
% ylabel('Standard Error of the Mean (um)', 'FontSize', 14)
% % title('Sensation Intensity JND','FontSize',14)
% hold off
% saveas(h,'ind_avgSEM_scatterbar.tif')