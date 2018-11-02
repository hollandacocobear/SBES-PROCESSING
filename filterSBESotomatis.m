%tidak bisa dilakukan karena akan banyak membuang data
clear
clc

delta=0.4;
iterasi=5;

file='SBES_KOLAKA_13-10.txt';
fx=dir(file);
data1=readtable(fx.name,'Format','%{MM/dd/uuuu}D%D%f%f%f','delimiter','\t');
myDate = datenum(data1.DATE + timeofday(data1.TIME));
depth=table2array(data1(:,5));
easting=table2array(data1(:,3));
northing=table2array(data1(:,4));
dataRaw=[myDate,easting,northing,depth];
dataOlah=dataRaw;%tanggal,depth,easting,northing

close all
gambar
plot(dataRaw(:,1),dataRaw(:,4),'-r')
hold on
scatter(dataOlah(:,1),dataOlah(:,4),10,'b','filled')
hold off
axis ij
datetick('x','hh:MM','keeplimits')

%filter min dan max kedalaman
mins=input('Kedalaman minimum = ');
maks=input('Kedalaman maksimum = ');
x=find(dataOlah(:,4)<mins);
dataOlah(x,:)=[];
x=find(dataOlah(:,4)>maks);
dataOlah(x,:)=[];
clear x

pause(2)

gambar
plot(dataRaw(:,1),dataRaw(:,4),'-r')
hold on
scatter(dataOlah(:,1),dataOlah(:,4),10,'b','filled')
hold off
axis ij
datetick('x','hh:MM','keeplimits')
%{
%filter selisih
interval=input('Selisih Kedalaman yang diterima = ');
iterasi=input('Iterasi yang ingin dilakukan = ');
for j=1:iterasi
    for i=2:length(dataOlah)
        dz(i-1)=abs(dataOlah(i,4)-dataOlah(i-1,4));
        dt(i-1)=dataOlah(i,1)-dataOlah(i-1,1);
    end
    x=find(dz>interval);
    dataOlah(x,:)=[];
    clear x dz
end
%}
%close all

%save filter data
disp('Save data');
DATE=datestr(dataOlah(:,1),'mm/dd/yyyy');
TIME=datestr(dataOlah(:,1),'hh:MM:ss');
EASTING=dataOlah(:,2);
NORTHING=dataOlah(:,3);
DEPTH=dataOlah(:,4);
T=table(DATE,TIME,EASTING,NORTHING,DEPTH);
writetable(T,[file(1:end-4),'_edit.txt'],'delimiter','\t');

