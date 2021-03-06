function [] = StartDAQ(daqs, varargin)
%
% STARTDAQ Initiates data acquisition.
%
% STARTDAQ(daqobjs) - Starts all the device objects
%
% STARTDAQ(daqobjs, userdata) - Starts devices; writes a file to disk with
% the contents of <userdata> (which must be a structure). The filename is
% <sweepnum>-data.mat
%
% Handles starting and triggering (if needed) of devices.
% Throws an error if any of the daq devices is running.
%
% See Also: STOPDAQ
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE


% check for running objects
isrun   = daqs.Running;
if ~isempty(strmatch('On',isrun))
    error('METAPHYS:startsweep:deviceAlreadyRunning',...
        'One or more DAQ devices is currently running.')
end

% check to see which devices need started and triggered
do_start    = ones(size(daqs));
% do_trigger  = ones(size(daqs));
types   = CellWrap(lower(daqs.Type));

% set callbacks
err_cb   = @EventHandler;

for i = 1:length(types)
    switch types{i}
        case 'digital io'
            do_start(i)     = 0;
        case 'analog output'
            if daqs(i).SamplesAvailable < 1 || ...
                    isempty(daqs(i).Channel)
                do_start(i) = 0;
            end
            set(daqs(i),...
                    'SamplesOutputFcn', [],...
                    'StartFcn', err_cb,...
                    'TimerFcn', [],...
                    'TriggerFcn', err_cb,...
                    'RuntimeErrorFcn', err_cb,...
                    'StopFcn', err_cb)
        case 'analog input'
            if isempty(daqs(i).Channel)
                do_start(i) = 0;
            end
            set(daqs(i),...
                    'StartFcn', [],...
                    'TimerFcn', [],...
                    'TriggerFcn', err_cb,...
                    'DataMissedFcn', err_cb,...
                    'RuntimeErrorFcn', err_cb,...
                    'StopFcn', err_cb)
    end
end
            
if ~any(do_start)
    DebugPrint('No DAQ devices to start!');
else
    UpdateTelegraph;
    IncrementSweepCounter
    WriteSweepData(varargin{:})
    daqs    = daqs(find(do_start));
    start(daqs)
    TriggerDAQ(daqs)
    SetStatus('protocol running')
end
