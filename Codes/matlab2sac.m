% ======================================================================= %
% function matlab2sac                                                     %
% This function takes a vector and saves it as a sac file.                %
% Extra pairs of arguments can be given to specify header variables.      %
% These must be in the form                                               %
% 'variable name',value,....                                              %
% Header variables which aren't specified are given default (often null)  %
% values.                                                                 %
%                                                                         %
% usage                                                                   %
% matlab2sac(d,fout) writes the series d to a sac file called fout. All   %
% header variables are given their default values                         %
% matlab2sac(d,fout,'variable name',value,...) sets the specified header  %
% variables to their accompanying values                                  %
%                                                                         %
% Daniel Clarke                                                           %
% IPGP                                                                    %
% 26 March, 2009                                                          %
%                                                                         %
% ======================================================================= %

function matlab2sac(d,fout,varargin)

% ======================================================================= %
% Check the number of inputs
% ======================================================================= %

% ensure there is at least one input
if nargin < 2
    error('not enough arguments');
end

% check that there are matching pairs of variable names and values
nvarg = length(varargin);
if mod(nvarg,2) ~= 0
    error('header variables must be specified be name, then value');
end

% ======================================================================= %
% A default sac header
% ======================================================================= %

% Seventy floating-point variables
% Forty integer variables
% 23 Character variables ( 22*8 chars + 1*16 chars = 192 characters) 

% Name, position, default value
hdrdef = {
'DELTA',     1          1                          % sampling interval 
'DEPMIN',    2          min(d)                     % minimum value
'DEPMAX',    3          max(d)                     % maximum value
'SCALE',     4          1                          % amplitude scaling factor
'ODELTA',    5          -12345                     % observed increment
'B',         6          0                          % start time
'E',         7          -12345                     % end time
'O',         8          -12345                     % event origin time
'A',         9          -12345                     % arrival time (relative to reference time)
'T0',        11         -12345                     % user-defined time markers 
'T1',        12         -12345                     % "
'T2',        13         -12345                     % "
'T3',        14         -12345                     % "
'T4',        15         -12345                     % "
'T5',        16         -12345                     % "
'T6',        17         -12345                     % "
'T7',        18         -12345                     % "
'T8',        19         -12345                     % "
'T9',        20         -12345                     % "
'F',         21         -12345                     % end of event time (relative to reference time)
'RESP0',     22         -12345                     % instrument response parameters
'RESP1',     23         -12345                     % "
'RESP2',     24         -12345                     % "
'RESP3',     25         -12345                     % "
'RESP4',     26         -12345                     % "
'RESP5',     27         -12345                     % "
'RESP6',     28         -12345                     % "
'RESP7',     29         -12345                     % "
'RESP8',     30         -12345                     % "
'RESP9',     31         -12345                     % "
'STLA',      32         -12345                     % station latitude
'STLO',      33         -12345                     % station longitude
'STEL',      34         -12345                     % station elevation
'STDP',      35         -12345                     % station depth
'EVLA',      36         -12345                     % event latitude
'EVLO',      37         -12345                     % event longitude
'EVEL',      38         -12345                     % event elevation
'EVDP',      39         -12345                     % event depth
'MAG',       40         -12345                     % event magnitude
'USER0',     41         -12345                     % storage for user-defined variable
'USER1',     42         -12345                     % "
'USER2',     43         -12345                     % "
'USER3',     44         -12345                     % "
'USER4',     45         -12345                     % "
'USER5',     46         -12345                     % "
'USER6',     47         -12345                     % "
'USER7',     48         -12345                     % "
'USER8',     49         -12345                     % "
'USER9',     50         -12345                     % "
'DIST',      51         -12345                     % distance to event
'AZ',        52         -12345                     % event to station azimuth
'BAZ',       53         -12345                     % station to event azimuth
'GCARC',     54         -12345                     % great circle arc-length to event
'DEPMEN',    57         mean(d)                    % mean value
'CMPAZ',     58         -12345                     % component azimuth 
'CMPINC',    59         -12345                     % component incident angle
'XMINIMUM',  60         -12345                     % minimum for X (spectral files)
'XMAXIMUM',  61         -12345                     % maximum for X (spectral files) 
'YMINIMUM',  62         -12345                     % minimum for Y (spectral files)
'YMAXIMUM',  63         -12345                     % maximum for Y (spectral files)
'NZYEAR',    71         1983                       % reference year
'NZJDAY',    72         150                        % reference julian day
'NZHOUR',    73         0                          % reference hour
'NZMIN',     74         0                          % reference minute
'NZSEC',     75         0                          % reference second
'NZMSEC',    76         0                          % reference millisecond
'NVHDR',     77         6                          % header version number (set to 6)
'NORID',     78         0                          % origin ID
'NEVID',     79         0                          % event ID
'NPTS',      80         length(d)                  % Nnumber of points
'NWFID',     82         -12345                     % waveform ID
'NXSIZE',    83         -12345                     % spectral length (spectral files)
'NYSIZE',    84         -12345                     % spectral width (spectral files)
'IFTYPE',    86         1                          % file type (1 for time-series)
'IDEP',      87         -12345                     % dependant variable type
'IZTYPE',    88         1                          % reference time equivalent
'IINST',     90         -12345                     % instrument type
'ISTREG',    91         -12345                     % station geographic region
'IEVREG',    92         -12345                     % event geographic region
'IEVTYP',    93         -12345                     % event type
'IQUAL',     94         -12345                     % data quality
'ISYNTH',    95         -12345                     % flag for synthetic data
'IMAGTYP',   96         -12345                     % magnitude type
'IMAGSRC',   97         -12345                     % magnitude information source
'LEVEN',     106        1                          % data are evenly spaced. (true  or false)
'LPSPOL',    107        1                          % station components are positively polarised. (true of false)
'LOVROK',    108        -12345                     % this file can be overwritten.  (true  or false)
'LCALDA',    109        -12345                     % calculate dist, ez, etc. from sta and evt coords. (true  or false)
'KSTNM',     111        uint8('-12345  ')          % station name
'KEVNM',     112        uint8('-12345  -12345  ')  % event name
'KHOLE',     113        uint8('-12345  ')          % hole identification if nuclear event
'KO',        114        uint8('-12345  ')          % event origin time id
'KA',        115        uint8('-12345  ')          % first arrival time id
'KT0',       116        uint8('-12345  ')          % user defined marker id
'KT1',       117        uint8('-12345  ')          % "
'KT2',       118        uint8('-12345  ')          % "
'KT3',       119        uint8('-12345  ')          % "
'KT4',       120        uint8('-12345  ')          % "
'KT5',       121        uint8('-12345  ')          % "
'KT6',       122        uint8('-12345  ')          % "
'KT7',       123        uint8('-12345  ')          % "
'KT8',       124        uint8('-12345  ')          % "
'KT9',       125        uint8('-12345  ')          % "
'KF',        126        uint8('-12345  ')          % event end time id
'KUSER0',    127        uint8('-12345  ')          % storage for user-defined variable
'KUSER1',    128        uint8('-12345  ')          % "
'KUSER2',    129        uint8('-12345  ')          % "
'KCMPNM',    130        uint8('-12345  ')          % component name
'KNETWK',    131        uint8('-12345  ')          % name of network
'KDATRD',    132        uint8('-12345  ')          % date data was read onto computer
'KINST',     133        uint8('-12345  ')          % name of instrument
};

% initialize the header
hdr = cell(133,1);
for i=1:1:110
   hdr{i} = -12345; 
end
for i=111:1:133
   hdr{i} = uint8('-12345  ');
end
hdr{112} = uint8('-12345  -12345  ');

% assign defaults to the header
ndef = size(hdrdef,1);
for i=1:1:ndef
    hdr{hdrdef{i,2}} = hdrdef{i,3}; 
end

% ======================================================================= %
% Assign given values to variables
% ======================================================================= %

np = nvarg/2;
for i=1:1:np
    
    % found?
    ifound = 0;
    
    % take the appropriate input arguments
    nm = varargin{2*i-1};
    vl = varargin{2*i};
    
    % check that the variable name is a character array
    if (~ischar(nm))
        warning(strcat('variable name must be a string'));
        continue
    end
    
    % look for the matching header variable
    for j=1:1:ndef
        if strcmpi(hdrdef{j,1},nm)
            
            % numeric header variables
            if hdrdef{j,2} < 111
                
                % ensure the value is numeric
                if ~isnumeric(vl)
                    warning(strcat(['expected a numeric value for variable ',hdrdef{j,1}]));
                
                % ensure the value is real
                elseif ~isreal(vl)
                    warning(strcat(['expected a real value for variable ',hdrdef{j,1}]));
                
                % ensure the value is a scalar 
                elseif ~isscalar(vl)
                    warning(strcat(['expected a scalar value for variable ',hdrdef{j,1}]));
                
                % assign the value!
                else
                    hdr{hdrdef{j,2}} = vl;
                end

            end

            % character header variables
            if hdrdef{j,2} > 110
                
                % ensure the value is a character array
                if ~ischar(vl)
                    warning(strcat(['expected a character array for variable ',hdrdef{j,1}]));
                
                % make sure the character array is the correct length
                else
                    
                    % length of the string
                    lch = length(vl);
                    
                    % pad with zeros
                    if lch < 16
                        vl((lch+1):16) = ' ';
                    end
                    
                    % assign! special case for KEVNM
                    if hdrdef{j,2} == 112
                        hdr{hdrdef{j,2}} = uint8(vl(1:16));
                    else
                        hdr{hdrdef{j,2}} = uint8(vl(1:8));
                    end
                    
                end
                
            end
                
            % found!
            ifound = 1;
            
            % no need to look further
            break
            
        end
    end

    % warn if this variable hasn't been matched
    if ~ifound
        warning(strcat(['variable ',nm,' isnt supported']));
    end
    
end

% ======================================================================= %
% Write the sac file
% ======================================================================= %

% open the file
fid = fopen(fout,'w','l');

% write the header
for i=1:1:70
    fwrite(fid,hdr{i},'float');
end
for i=71:1:110
    fwrite(fid,hdr{i},'long');
end
for i=111:1:133
    fwrite(fid,hdr{i},'uchar');
end

% write the data series
fwrite(fid,d,'float');

% close the file
fclose(fid);

% end of function matlab2sac
end

