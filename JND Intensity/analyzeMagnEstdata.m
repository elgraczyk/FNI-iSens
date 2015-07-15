%analyze data generated by runMagnEst.m experiment
%Created: 7/9/15, by Graczyk

clear all
close all

%set up directories
defaultdir=cd;
datafiles={};
datadir='C:\Users\Emily\Documents\MATLAB\JND Intensity\PerceivedMagnitude';
cd(datadir)
[datafiles,pathName]=uigetfile('.mat','Please select the file containing the data you wish to analyze','Multiselect','on');
cd(pathName)

outdir=pathName(1:end-5);

%this will loop through all the data files
for k=1:length(datafiles)
    load(datafiles{k}); %load data 
    %get basic info from the file
    SID=MyData.PatientID;
    elec=cell2mat(MyData.Contact);
    expdate=datestr(datevec(MyData.DateVal),'yyyymmdd');
    expname=['Exp' datestr(datevec(datafiles{k}(11:end-4),'yyyy-mm-dd T HH.MM.SSPM'),'yyyymmddHHMMSS')];
    
    %arrange relevant data into a single matrix
    n=length(MyData.Response);
    %normalize data - normalize for each block of data
    br_pts=[0 68 135 203 270]; %trials after which a break was taken
    resp=[];
    for j=2:length(br_pts)
        if br_pts(j)<n
            setmax(j-1)=max(MyData.Response(br_pts(j-1)+1:br_pts(j)));
            resp(br_pts(j-1)+1:br_pts(j))=(MyData.Response(br_pts(j-1)+1:br_pts(j))/setmax(j-1))*100;
        elseif br_pts(j)==n
            setmax(j-1)=max(MyData.Response(br_pts(j-1)+1:n));
            resp(br_pts(j-1)+1:n)=(MyData.Response(br_pts(j-1)+1:n)/setmax(j-1))*100;
        else
        end
    end
        
    expdata=[];
    expdata=[MyData.ConditionList(1:n)' MyData.UpperFreq(1:n) MyData.UpperPW(1:n) MyData.UpperPA(1:n) MyData.Response];
    expdata=expdata(MyData.Trial(1):end,:);
    
    %save to alldata
    alldata.(expname).SID=SID;
    alldata.(expname).date=expdate;
    alldata.(expname).contact=elec;
    alldata.(expname).rawdata.header={'Condition', 'UpperFreq','UpperPW','UpperPA','Response'};
    alldata.(expname).rawdata.data=expdata;
    
    %save normalized data and overwrite the nonnormalized values in expdata
    expdata(:,5)=resp(MyData.Trial(1):end);
    alldata.(expname).normdata.setmax=setmax;
    alldata.(expname).normdata.header={'Condition', 'UpperFreq','UpperPW','UpperPA','NormalizedResponse'};
    alldata.(expname).normdata.data=expdata;
    
    
    figure
    scatter([1:1:size(expdata,1)],expdata(:,5))
%     [fits.(expname).time, gof]=fit([1:1:size(expdata,1)],expdata(:,5));
    title(['S' SID ' M' elec ' Effect of time'])
    xlabel('Trial number')
    ylabel('Perceived magnitude')
    
    sortdata=sortrows(expdata,[1 2 3]);
    
    ind_cond1=find(sortdata(:,1)==1);
    ind_cond2=find(sortdata(:,1)==2);
    ind_cond3=find(sortdata(:,1)==3);
    
    datacond1=sortdata(ind_cond1,:);
    datacond2=sortdata(ind_cond2,:);
    datacond3=sortdata(ind_cond3,:);
    
    %condition 1 - PW variable, freq constant
    [f, fits.(expname).cond1.gof]=fit(datacond1(:,3),datacond1(:,5),'poly1');
    fits.(expname).cond1.coeff.names=coeffnames(f);
    fits.(expname).cond1.coeff.coeff=coeffvalues(f);
    x=[min(datacond3(:,3)):0.01:max(datacond3(:,3))];
    y=fits.(expname).cond1.coeff.coeff(1).*x+fits.(expname).cond1.coeff.coeff(2);
    figure
    hold on
    scatter(datacond1(:,3),datacond1(:,5))
    plot(x,y)
    hold off
    title(['S' SID ' M' elec ' Condition 1 - PW variable, freq constant'])
    xlabel('PW (us)')
    ylabel('Perceived magnitude')
    
    %condition 2 - PW constant, freq variable
    [f, fits.(expname).cond2.gof]=fit(datacond2(:,2),datacond2(:,5),'poly1');
    fits.(expname).cond2.coeff.names=coeffnames(f);
    fits.(expname).cond2.coeff.coeff=coeffvalues(f);
    x=[min(datacond3(:,2)):0.01:max(datacond3(:,2))];
    y=fits.(expname).cond2.coeff.coeff(1).*x+fits.(expname).cond2.coeff.coeff(2);
    figure
    hold on
    scatter(datacond2(:,2),datacond2(:,5))
    plot(x,y)
    hold off
    title(['S' SID ' M' elec ' Condition 2 - PW constant, freq variable'])
    xlabel('Frequency (Hz)')
    ylabel('Perceived magnitude')
    
%     %condition 3 - both PW and freq variable
%     figure
%     scatter(datacond3(:,2), datacond3(:,5))
%     title('Condition 3 - Both PW and freq varying together')
%     xlabel('Frequency (Hz)')
%     ylabel('Perceived magnitude')
%     
    figure
    hold on
    [f, fits.(expname).cond3.gof]=fit(datacond3(:,3), datacond3(:,5),'poly1');
    fits.(expname).cond3.coeff.names=coeffnames(f);
    fits.(expname).cond3.coeff.coeff=coeffvalues(f);
    x=[min(datacond3(:,3)):0.01:max(datacond3(:,3))];
    y=fits.(expname).cond3.coeff.coeff(1).*x+fits.(expname).cond3.coeff.coeff(2);
    scatter(datacond3(:,3), datacond3(:,5))
    plot(x,y)
    hold off
    title(['S' SID ' M' elec ' Condition 3 - Both PW and freq varying together'])
    xlabel('PW (us)')
    ylabel('Perceived magnitude')
    
    figure
    scatter(datacond3(:,3), datacond3(:,2))
    title(['S' SID ' M' elec ' Frequency and PW for condition 3'])
    xlabel('PW (us)')
    ylabel('Frequency (Hz)')
    
    sortdata=sortrows(expdata,[1,3,2]);
    for i=2:size(sortdata,1)
        %check for cond shift
        if sortdata(i,1)
end

cd(outdir)
save(['Analysis' datestr(now) '.mat'],'fits','alldata')
cd(defaultdir)