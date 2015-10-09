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


%%%%%%%=== SET OPTIONS ===%%%%
makePDF=true;
pdfSize=[15 12];
%%%%%%%=== END OPTIONS ===%%%%


    load ioOffset1550; %ioOffset is the average of all direct couplers


folderData=dir;
for iii=3:size(folderData,1) %skip . and ..
    if (~isempty(findstr('.fig', folderData(iii).name)) )
        filename=folderData(iii).name;
        disp(filename);
        name=strrep(folderData(iii).name, '_', '*');
        name=strrep(name, '.fig', '');
        open(filename);
        %or
        %    figure;
        %    plot(1:10)   
        %Get a handle to the current figure:
        h = gcf; %current figure handle   
        %The data that is plotted is usually a 'child' of the Axes object. The axes objects are themselves children of the figure. You can go down their hierarchy as follows:
        axesObjs = get(h, 'Children');  %axes handles
        dataObjs = get(axesObjs, 'Children'); %handles to low-level graphics objects in axes   
        %Extract values from the dataObjs of your choice. You can check their type by typing:
        objTypes = get(dataObjs, 'Type');  %type of low-level graphics object   
        %NOTE : Different objects like 'Line' and 'Surface' will store data differently. Based on the 'Type', you can search the documentation for how each type stores its data.
        %Lines of code similar to the following would be required to bring the data to MATLAB Workspace:

        xdata = get(dataObjs, 'XData');  %data from low-level grahics objects
        ydata = get(dataObjs, 'YData');
        %zdata = get(dataObjs, 'ZData');
        [numChan, ~] =size(ydata);
        figure1=figure;
        hold on;
        sizeX=length(downsample( xdata{1,:}, floor(length(xdata{1,:})/1000) ));
        y=zeros(numChan,sizeX);
        for jjj=1:numChan
            x =downsample( xdata{1,:}, floor(length(xdata{1,:})/1000) );
            y(jjj,:)=downsample( ydata{jjj,:}, floor(length(ydata{jjj,:})/1000) );
            plot(x,y(jjj,:)-ioOffset,'displayname','Drop');
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
            print(figure1,folderData(iii).name,'-dpdf');
        end   
    end
end

    

