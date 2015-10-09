%{

    Auto Analyser
    This script creates pdf for all the data obtained for a chip using the
    automated setup, normalized to the average grating coupler response.

    1st step: Set calib to true. The script will average the devices with 
    "Align" in the name from the current folder and output a file 
    ioOffset.mat.

    2nd step: Set calib to false. The script will make figures of all the
    normalized responses. Set makePDF to true to get individual PDFs.


    Jonathan St-Yves
    Sept 2015
    jonhwoods@gmail.com


%}





clear all;
%% Figure settings
textSizeSmall=14;
textSizeLarge=16;
set(0,'defaultFigureColor','w','defaultAxesColor','w');
set(0,'defaultAxesFontSize',textSizeSmall,'defaultAxesFontName','Helvetica');
set(0,'defaultFigurePosition',[100,100,1000,800])
set(0,'defaultAxesYMinorTick','on')
set(0,'defaultAxesColorOrder',[ 0 0 0; ...
                                0.8 0 0; ...
                                0.7 0.6 0; ...
                                0 0.7 0; ...
                                0 0 0.8]);
set(0,'defaultAxesLineStyleOrder','-|--|:');
set(0,'defaultAxesBox','on'   );
set(0,'defaultLineLineWidth',2   );
set(0,'defaultTextFontName','Helvetica' );
set(0,'defaultTextFontsize',textSizeSmall );


%%%%%%%=== SET OPTIONS ===%%%%
calib=false;
makePDF=false;
downSample=false;
pdfSize=[15 12];
filterStr='g140';
%%%%%%%=== END OPTIONS ===%%%%

ioOffset=0;
if(calib)
    ioOffsetCAL=0;
    count=0;
else
    load ioOffset; %ioOffset is the average of all direct couplers
end

if(downSample)
    x =downsample(ioOffset,floor(ioOffset/1000));
end

folderData=dir;
for iii=3:size(folderData,1) %skip . and ..
    if (folderData(iii).isdir && ...
        isempty(findstr('error', folderData(iii).name)) &&...
        (~calib || ~isempty(findstr('Align', folderData(iii).name)) ) &&...
        (calib || isempty(filterStr) || ~isempty(findstr(filterStr, folderData(iii).name)) ) ) 
        disp(folderData(iii).name);
        insideName=dir(cat(2,folderData(iii).name,'/DryTest'));
        insideName=insideName(3).name;
        load( cat(2,folderData(iii).name,'/DryTest/',insideName,'/Scan1.mat'))
        if(1)
            figure1=figure;
            hold on;
            if (downSample)
                x =downsample(scanResults(1).Data(:,1),floor(length(scanResults(1).Data(:,1))/1000));
                y1=downsample(scanResults(1).Data(:,2),floor(length(scanResults(1).Data(:,2))/1000));
                y2=downsample(scanResults(2).Data(:,2),floor(length(scanResults(2).Data(:,2))/1000));
            else
                x =scanResults(1).Data(:,1);
                y1=scanResults(1).Data(:,2);
                y2=scanResults(2).Data(:,2);
            end
            plot(x,y1-ioOffset,'r','displayname','Drop');
            plot(x,y2-ioOffset,'b','displayname','Thru');
            xlabel('Wavelength [nm]','fontsize',textSizeLarge,'FontName', 'Helvetica');
            ylabel('Drop Port [dB]','fontsize',textSizeLarge,'FontName', 'Helvetica');
            title(strrep(folderData(iii).name, '_', '*'));
            xlim([min(x) max(x)]);
            ylim([-54 5]);
            hold off;
                       
        end
        if(calib)
            ioOffsetCAL=ioOffsetCAL+y1;
            count = count+1;
        end
        if(makePDF && ~calib)
            set(gcf, 'PaperPosition', [0 0 pdfSize]); %Position plot at left hand corner with width 5 and height 5. 
            set(gcf, 'PaperSize', pdfSize); %Set the paper to have width 5 and height 5. 
            print(figure1,folderData(iii).name,'-dpdf');
        end

    end
end

if(calib)
    ioOffset=ioOffsetCAL./count;
    plot(x,ioOffset,'r');
    title('ioOffset - Average of all grating couplers');
    save('ioOffset.mat','ioOffset') 
end
    

