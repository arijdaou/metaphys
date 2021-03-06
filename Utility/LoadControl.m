function [] = LoadControl(filename)
%
% LOADCONTROL Loads a file containing information to go into the control
% structure. 
%
% Only some information is allowed to be loaded: DAQ objects, instrument
% setup, and the defaults field.  Individual module structures are not
% loaded, so if they want to store persistent properties, these must be
% placed under defaults.  Note: the daq and instrument fields of the
% control structure will be completely overwritten, whereas fields under
% defaults will only be overwritten if they have a corresponding entry in
% the saved structure.
%
% LOADCONTROL(filename): loads control structure from <filename>
%
% LOADCONTROL(): attempts to load control information from 'metaphys.mcr'
% in the base directory the project. If the base directory has not been
% defined, or the file does not exist, exits with a warning.
%
% See also: INITCONTROL, SAVECONTROL
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

DEFAULT_FILE    = 'metaphys.mcf';

global mpctrl

mpctrl

if nargin == 0
    filename = [];
    if ispref('METAPHYS', 'basedir')
        DEFAULT_FILE    = fullfile(getpref('METAPHYS','basedir'),...
            DEFAULT_FILE);
        if exist(DEFAULT_FILE,'file') > 0
            filename    = DEFAULT_FILE;
        end
    end
end

%% Check if filename is valid
if isempty(filename)
    DebugPrint('No default control file found, skipping.')
    return
elseif ~(exist(filename,'file') > 0)
    error('METAPHYS:noSuchFile', 'The file %s does not exist', filename)
end

% This will throw MATLAB:load:notBinaryFile if not a valid matfile
z   = load('-mat', filename);
z.defaults.data_prefix = 'aj';
z.defaults.data_dir = 'C:\cygwin\home\adaou\data\';

%% Copy to control structure
if isfield(z, 'daq')
    daqnames    = fieldnames(z.daq);
    % re-load the initial properties on the daq
    for i = 1:length(daqnames)
        props   = GetSettableProps(z.daq.(daqnames{i}).obj);
        z.daq.(daqnames{i}).initial_props   = props;
    end
    mpctrl.daq  = z.daq;

    DebugPrint('Restored DAQ objects:%s.',...
        sprintf(' %s', daqnames{:}));
end
if isfield(z, 'instrument')       
    try         
        if strcmp(z.instrument.newinstrument_1.name,'newinstrument_1')            
            z.instrument.newinstrument_1.name = 'Voltage Clamp';
        end
    catch
        fprintf('Looks like you are on channel 2! \n');
    end
     
    mpctrl.instrument = z.instrument;    
end
if isfield(z, 'defaults')
    if ~isempty(z.defaults)
        fn  = fieldnames(z.defaults);
        for i = 1:length(fn)
            mpctrl.defaults.(fn{i}) = z.defaults.(fn{i});
        end
    end
end
DebugPrint('Loaded control information from %s.', filename);
