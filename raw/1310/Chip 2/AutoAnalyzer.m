clear all;
%% Figure settings
textSizeSmall=14;
textSizeLarge=16;
set(0,'defaultFigureColor','w','defaultAxesColor','w');
set(0,'defaultAxesFontSize',textSizeSmall,'defaultAxesFontName','Helvetica');
set(0,'defaultFigurePosition',[1100,100,800,600])
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

calib=false;

if(calib)
    ioOffset=0;
    count=0;
else
    load ioOffset; %ioOffset is the average of all direct couplers
end

folderData=dir;
for iii=52:size(folderData,1) %skip . and ..
    if (folderData(iii).isdir) 
        disp(folderData(iii).name);
        insideName=dir(cat(2,folderData(iii).name,'/DryTest'));
        insideName=insideName(3).name;
        load( cat(2,folderData(iii).name,'/DryTest/',insideName,'/Scan1.mat'))
        if(1)
            figure1=figure;
            hold on;
            plot(scanResults(1).Data(:,1),scanResults(1).Data(:,2)-ioOffset,'r','displayname','Drop');
            plot(scanResults(2).Data(:,1),scanResults(2).Data(:,2)-ioOffset,'b','displayname','Thru');
            xlabel('Wavelength [nm]','fontsize',textSizeLarge,'FontName', 'Helvetica');
            ylabel('Drop Port [dB]','fontsize',textSizeLarge,'FontName', 'Helvetica');
            title(strrep(folderData(iii).name, '_', '*'));
            xlim([min(scanResults(1).Data(:,1)) max(scanResults(1).Data(:,1))]);
            ylim([-54 5]);
            hold off;
            if(calib)
                ioOffset=ioOffset+scanResults(1).Data(:,2);
                count = count+1;
            end
            %print(figure1,folderData(iii).name,'-dpdf');
        end

    end
end

if(calib)
    ioOffset=ioOffset./count;
    plot(scanResults(1).Data(:,1),scanResults(1).Data(:,2)-ioOffset,'r','displayname','Drop');
end
    

