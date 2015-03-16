clear all
clc

%Open the experiment data file
[filename,PathName]=uigetfile('*.mat','Select the experiment data file you wish to analyze');
load([PathName '\' filename]);

prevfile=questdlg('Should this analysis be added to another file?','Continue previous analysis?','Yes','No','No');
switch prevfile
    case 'Yes'
        [filename,PathName]=uigetfile('*.mat','Select the previous file containing the data to which you want to add');
        load(filename);
    case 'No'
        teststr=[];
        testPW=[];
        ref=str2num(cell2mat(inputdlg('Please enter reference PW')));
        rts=[0.65 0.7 0.85 0.95 1 1.05 1.15 1.3 1.35];
        testlist=round(rts*ref);
    %initialize structures
    for i=1:length(testlist)
        prop.(['test' num2str(testlist(i))])=[];
    end
    teststrongperc=[];
end
        
     
%Set subject ID
SID=MyData.PatientID;

%Apply calibration file to data to get angles, calculate trial time from clock
%output
[m,n]=size(testPW);
trial_start=str2num(cell2mat(inputdlg(['Last analysis ended on trial' num2str(n) '. Please enter the correct trial number to begin analysis.'])));

%teststr =1 for response of test>ref; =0 for response of ref>test



for j=trial_start:MyData.Trial(end)
    if MyData.Stim1PW(j)==MyData.Stim2PW(j)
        %Randomly decide whether the "test" or the "reference" was stronger
        %- since they are the same
        if rand()>0.5
            teststr(j)=0;
        else
            teststr(j)=1;
        end
        %Store the test frequency (which in this case is also the
        %reference)
        testPW(j)=MyData.Stim1PW(j);
        prop.(['test' num2str(floor(testPW(j)))])=cat(1, prop.(['test' num2str(floor(testPW(j)))]), teststr(j));
    
    else %MyData.Stim1PW(j)~=MyData.Stim2PW(j)
        %Determine which stim was the test frequency and store the freq 
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

if length(testPW)==180
    for i=1:length(testlist)
        temp=sum(prop.(['test' num2str(testlist(i))]));
        teststrongperc(i)=temp*5;
    end
    testdelta=testlist-ref;
    figure
    scatter(testdelta,teststrongperc,'LineWidth',3)
    xlabel('Relative Pulse Width (Test-reference)','FontSize',14);
    ylabel('Percentage of "test PW stronger" responses (%)','FontSize', 14);
   
end

datenow=datestr(now,'yyyymmdd T HH.MM.SS PM');
filename=['Sub' SID 'Analysis' datenow '.mat'];
save(filename,'SID','teststr','ref','testlist','prop','testPW','teststrongperc')