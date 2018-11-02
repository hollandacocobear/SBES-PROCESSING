close all
clear
clc

file='SBES_25092018.txt';
fout='SBES_25092018_edit.txt';
fx=dir(file);
data1=readtable(fx.name,'Format','%{MM/dd/uuuu}D%D%f%f%f','delimiter','\t');
myDate = datenum(data1.DATE + timeofday(data1.TIME));
depth=table2array(data1(:,5));
easting=table2array(data1(:,3));
northing=table2array(data1(:,4));
dataRaw=[myDate,easting,northing,depth];
dataOlah=dataRaw;%tanggal,depth,easting,northing
gambar
plot(dataRaw(:,1),dataRaw(:,4),'-r')
hold on
scatter(dataOlah(:,1),dataOlah(:,4),10,'b','filled')
hold off
axis ij
datetick('x','hh:MM','keeplimits','keepticks')

a=1;
while(~isempty(a))
    while(a~=0)
        clear tgl tgl1 b x y a x1 y1
        tgl=[];b=[];tgl1=[];
        while(isempty(tgl)||length(b)~=2)
            tgl=input('Pilih waktu awal (hh:mm) = ','s');
            b=strsplit(tgl,':');
        end
        tgl=duration(str2num(b{1}),str2num(b{2}),0);
        tgl=datenum(data1.DATE(1))+datenum(tgl);
        
        c=1;
        b=0;
        while(c==1||length(b)~=2)
   
                tgl1=input('Pilih waktu akhir (hh:mm) = ','s');
                b=strsplit(tgl1,':');
            
            tgl1=duration(str2num(b{1}),str2num(b{2}),0);
            tgl1=datenum(data1.DATE(1))+datenum(tgl1);
            if(tgl1>tgl)
                c=0;
            end
            
        end
        clear b
        
        close all
        gambar
        plot(dataRaw(:,1),dataRaw(:,4),'-r')
        hold on
        scatter(dataOlah(:,1),dataOlah(:,4),10,'b','filled')
        hold off
        axis ij
        xlim([tgl tgl1]);
        datetick('x','hh:MM','keeplimits')
        set(gca,'yminortick','on');
        grid on
        
        
        x=0;y=0;a=0;
        disp('Click point to display a data tip');
        disp('Press Return in Figure to exit')
        [x,y]=ginput(1);
        while(~isempty(x) && ~isempty(y))
            if(~isempty(x))
                a=a+1; x1(a)=x; y1(a)=y;
                hold on
                if(length(x1)==1)
                    scatter(x,y,15,'m','filled')
                else
                    scatter(x,y,15,'m','filled')
                    plot(x1,y1,'m')
                end
                hold off
            end
            [x,y]=ginput(1);
        end
        
        hold on
        plot([x1(end) x1(1)],[y1(end) y1(1)],'m')
        hold off
        pause(2)
        
        %delete point inside polygon
        in = inpolygon(dataOlah(:,1),dataOlah(:,4),x1,y1);
        idx=find(in==1);
        dataOlah(idx,:)=[];
        
        figure
        plot(dataRaw(:,1),dataRaw(:,4),'-r')
        hold on
        scatter(dataOlah(:,1),dataOlah(:,4),10,'b','filled')
        hold off
        axis ij
        xlim([tgl tgl1]);
        datetick('x','hh:MM','keeplimits')
        grid on
        
        
        pause(2);
        disp('Bersihkan lagi?Ya=1;Tidak=0')
        a=input('>');
        pause(2);
    end
    if(a==0)
    a=[];
    end
end

%save edited depth data
clear depth easting northing myDate tgl tgl1 x x1 y y1
close all
pause(2);
disp('Save data');
DATE=datestr(dataOlah(:,1),'mm/dd/yyyy');
TIME=datestr(dataOlah(:,1),'hh:MM:ss');
EASTING=dataOlah(:,2);
NORTHING=dataOlah(:,3);
DEPTH=dataOlah(:,4);
T=table(DATE,TIME,EASTING,NORTHING,DEPTH);
writetable(T,fout,'delimiter','\t');


