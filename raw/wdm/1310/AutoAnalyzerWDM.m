%{

    Auto Analyser WDM
    Variation of Auto Analyser to normalize multiple channels


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

set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on')


%%%%%%%=== SET OPTIONS ===%%%%
makePDF=false;
pdfSize=[15 12];
offset=2;
%%%%%%%=== END OPTIONS ===%%%%


    load ioOffset1310; %ioOffset is the average of all direct couplers


folderData=dir;
for iii=17 %3:size(folderData,1) %skip . and ..
    if (~isempty(findstr('.fig', folderData(iii).name)) )
        filename=folderData(iii).name;
        disp(filename);
        name=strrep(folderData(iii).name, '_', '*');
        name=strrep(name, '.fig', '');
        open(filename);
        h = gcf; %current figure handle   
        axesObjs = get(h, 'Children');  %axes handles
        dataObjs = get(axesObjs, 'Children'); %handles to low-level graphics objects in axes   
        objTypes = get(dataObjs, 'Type');  %type of low-level graphics object   

        xdata = get(dataObjs, 'XData'); 
        ydata = get(dataObjs, 'YData');
        %close h;

        [numChan, ~] =size(ydata);
        figure1=figure;
        hold on;
        sizeX=length(downsample( xdata{1,:}, floor(length(xdata{1,:})/1000) ));
        y=zeros(numChan,sizeX);
        for jjj=1:numChan
            x =downsample( xdata{1,:}, floor(length(xdata{1,:})/1000) );
            y(jjj,:)=downsample( ydata{jjj,:}, floor(length(ydata{jjj,:})/1000) );
            plot(x,y(jjj,:)-ioOffset.'+offset,'displayname','Drop');
            xlabel('Wavelength [nm]','fontsize',textSizeLarge,'FontName', 'Helvetica');
            ylabel('Drop Port [dB]','fontsize',textSizeLarge,'FontName', 'Helvetica'); 
        end
        title(name);
        xlim([min(x) max(x)]);
        ylim([-54 5]);
        hold off;
        if(makePDF)
            set(gcf, 'PaperPosition', [0 0 pdfSize]); %Position plot at left hand corner with width 5 and height 5. 
            set(gcf, 'PaperSize', pdfSize); %Set the paper to have width 5 and height 5. 
            print(figure1,strrep(folderData(iii).name, '.fig', ''),'-dpdf');
        end   
    end
end

    

