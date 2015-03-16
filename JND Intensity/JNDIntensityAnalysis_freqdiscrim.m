clear all
clc

%Open the experiment data file
[filename,PathName]=uigetfile('*.mat','Select the experiment data file you wish to analyze');
load(filename);

prevfile=questdlg('Should this analysis be added to another file?','Continue previous analysis?','Yes','No','No');
switch prevfile
    case 'Yes'
        [filename,PathName]=uigetfile('*.mat','Select the previous file containing the data to which you want to add');
        load(filename);
    case 'No'
        teststr=[];
        testfreq=[];
        ref=str2num(cell2mat(inputdlg('Please enter reference freq')));
        if ref==100
            testlist=[25 50 83 90 100 111 125 145 166];
        else
            testlist=[12 25 40 45 50 55 62 76 90];
        end
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
[m,n]=size(testfreq);
trial_start=str2num(cell2mat(inputdlg(['Last analysis ended on trial' num2str(n) '. Please enter the correct trial number to begin analysis.'])));

%teststr =1 for response of test>ref; =0 for response of ref>test



for j=trial_start:MyData.Trial(end)
    if MyData.StimFreq1(j)==MyData.StimFreq2(j)
        %Randomly decide whether the "test" or the "reference" was stronger
        %- since they are the same
        if rand()>0.5
            teststr(j)=0;
        else
            teststr(j)=1;
        end
        %Store the test frequency (which in this case is also the
        %reference)
        testfreq(j)=MyData.StimFreq1(j);
        prop.(['test' num2str(floor(testfreq(j)))])=cat(1, prop.(['test' num2str(floor(testfreq(j)))]), teststr(j));
    
    else %MyData.StimFreq1(j)~=MyData.StimFreq2(j)
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
        prop.(['test' num2str(floor(testfreq(j)))])=cat(1, prop.(['test' num2str(floor(testfreq(j)))]), teststr(j));
    end
    
end

if length(testfreq)==90
    for i=1:length(testlist)
        temp=sum(prop.(['test' num2str(testlist(i))]));
        teststrongperc(i)=temp*10;
    end
    teststrongperc(5)=50;
    testdelta=testlist-ref;
    figure
    plot(testdelta,teststrongperc,'LineWidth',3)
    xlabel('Relative Frequency (Test-reference)','FontSize',14);
    ylabel('Percentage of "test frequency stronger" responses (%)','FontSize', 14);
   
end

datenow=datestr(now,'yyyymmdd T HH.MM.SS PM');
filename=['Sub' SID 'Analysis' datenow '.mat'];
save(filename,'SID','teststr','ref','testlist','prop','testfreq','teststrongperc')