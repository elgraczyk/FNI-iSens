% Plotting of all data
close all
clear all

datafiles={};
defaultpath=pwd;
cd('C:\Users\Emily\Documents\MATLAB\JND Intensity\Indentation');
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
%         scatter(h2,temp, normdata,40,col(q2,:));
        plot(h2,xfit,yfit,'Color',col(q2,:));
         errorbar(temp,avg_data(:,2),std_data(:,2),'LineWidth',2,'Color',col(q2,:),'Marker','none','LineStyle','none')
        hold off
        leg2txt=cat(2,leg2txt,[SID ' M' elec]);
        leg2txt=cat(2,leg2txt,['Rsq=' num2str(allmdls.(['s' SID]).(['M' elec]).Rsquared.Adjusted)]);
        leg2txt=cat(2,leg2txt,' ');
        q2=q2+1;
    end
    xlabel(h1,'Frequency (Hz)','FontSize',14)
%     ylabel(h1,'Normalized Indentation Depth (um)')
    ylabel(h1,'Indentation Depth (um)','FontSize',14)
    axis(h1,[0 180 0 9000])
   
    xlabel(h2,'PW, Relative to sensory threshold (us))','FontSize',14)
%     ylabel(h2,'Normalized Indentation Depth (um)')
    ylabel(h2,'Indentation Depth (um)','FontSize',14)
    axis(h2,[0 200 0 9000]);
    
%     elseif str2num(SID)==104
%         scatter(avg_data(:,1), avg_data(:,2),40,col(q2,:));
%         q2=q2+1;
%     end
end
    
 legend(h1,leg1txt,'Location','EastOutside','FontSize',14);   
 legend(h2,leg2txt,'Location','EastOutside','FontSize',14);
 title(h1,'Matching indentation depth to stimulation frequency','FontSize',16)
 title(h2,'Matching indentation depth to stimulation PW','FontSize',16)
 
 save('all_indmatch_data.mat','allmdls','ind_match_data')