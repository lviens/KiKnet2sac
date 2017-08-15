% L. VIENS 08/15/2017
% Function to convert KiK-net ASCII files to sac files (acceleration
% waveforms in gal)

% Input: FILENAME: path and filename

%	KiKnet2sac(FILENAME) creates a Seismic Analysis Code (SAC) file called FILENAME.sac from the Kik-net ASCII file. 
%   KiKnet2sac(FILENAME,OUTPUT_FILE) creates a Seismic Analysis Code (SAC)
%   file called OUTPUTFILE from the Kik-net data (in ASCII format).

% Requirements: import_KiKnet_header and matlab2sac functions

function KiKnet2sac(FILENAME, varargin)

if nargin < 1
	error('Not enough input argument.')
end

if ~exist(FILENAME,'file')
    disp(['!!!!!!!!!!!!!!!!' FILENAME ' does not exist !!!!!!!!!!!!!!!! '])
    return
end

if nargin == 2
    output_file = varargin{1};
    if ~ischar(output_file)
       disp(['Output file is not a character vector.'])
       return
    end
else    
    output_file = [FILENAME '.sac'];
    disp(['The output file is: ' output_file])
end

%% Import header
header = import_KiKnet_header(FILENAME);
time1 = strsplit(header{1},' ');
lat_event  = strsplit(header{2},' ');
lon_event = strsplit(header{3},' ');
depth_event = strsplit(header{4},' ');
Mag = strsplit(header{5},' ');
Sta_name = strsplit(header{6},' ');
Sta_lat = strsplit(header{7},' ');
Sta_lon = strsplit(header{8},' ');
Sta_elev = strsplit(header{9},' ');
Rec_time = strsplit(header{10},' ');
date =  strsplit(Rec_time{3},'/');
a = datetime(str2num(date{1}), str2num(date{2}), str2num(date{3}));
dy = day(a,'dayofyear');
hr =  strsplit(Rec_time{4},':');

Samp = strsplit(header{11},' ');
Samp_r = (Samp{3});
delta = 1/str2num(Samp_r(1:end-2));

cmp = strsplit(header{13},' ');
sca =  strsplit(header{14},' ');
scale = strsplit(sca{3},'(gal)/');

%% Import data
[x1,x2,x3,x4,x5,x6,x7,x8] = import_KiKnet_data(FILENAME);
x=[x1,x2,x3,x4,x5,x6,x7,x8];
k=1;
for j=1:length(x1)
    for i=1:8
        h(k,:)=x(j,i);
        k=k+1;
    end
end
%% Conversion to
h = h.*str2double(scale{1})./str2double(scale{2});

%% Save sac file
matlab2sac(h,output_file,'DELTA', delta, 'EVLA', str2num(lat_event{2}), 'EVLO',str2num(lon_event{2}), 'EVDP',str2num(depth_event{3}) ,'MAG',...
    str2num(Mag{2}),'STLA',str2num(Sta_lat{end}), 'STLO',str2num(Sta_lon{end}), 'STEL',str2num(Sta_elev{end}), ...
    'KSTNM',(Sta_name{end}) , ...
    'NZYEAR',str2num(date{1}),'NZJDAY',dy,'NZHOUR' ,str2num(hr{1}) ,'NZMIN', str2num(hr{2}), 'NZSEC',str2num(hr{3}) ,...
    'KCMPNM',cmp{2});
