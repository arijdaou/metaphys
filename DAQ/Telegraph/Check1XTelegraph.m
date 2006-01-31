function results = Check1XTelegraph(instrument, object, channels)
%
% CHECK1XTELEGRAPH Checks the telegraph values on a 1-series Axon
% amplifier. 
%
% This amplifier has a telegraph for gain; this function
% will read in the voltage value and return a structure with the
% appropriate gain.
%
% results = CHECK1XTELEGRAPH(instrument, object, channels)
%
% Returns the gain associated with the telegraph on the
% instrument. OBJECT must be a single aichannel object. CHANNELS is a
% string or cell array with the names of the channels that are referred to
% by the telegraph. With this amplifier it's nice to create two
% instrumentoutputs for the scaled output, one for v-clamp and one for
% i-clamp.
%
% The lookup table for the telegraph is:
%
% Gains: [0.5   1   2   5  10  20  50 100]
% Volts: [0.4 0.8 1.2 1.6 2.0 2.4 2.8 3.2]
%
% If the beta switch is set to 100, these values are negative.
%
% In addition, the base scaling is different in voltage and current modes.
% In voltage modes the base scaling is 10 mV/mV, in current modes this is
% controlled by the beta switch
%
% See also: UPDATETELEGRAPH, ADDINSTRUMENTTELEGRAPH,
% TELEGRAPHRESULTS_STRUCT
%
% $Id: Check1XTelegraph.m,v 1.5 2006/01/31 20:00:18 meliza Exp $

% Retrieve voltages
voltages    = CheckAnalogTelegraph(instrument, object);
if isempty(voltages)
    results = [];
    return
end

% Determining the gain depends on the current mode of the amplifier. We
% don't have access to that, so we have to use the units that the user set
% on the scaled output.
chan        = GetInstrumentChannel(instrument, channels);

% Determine instrument state for each scaled out
for i = 1:length(chan)
    units{i,:}                        = get(chan{i},'Units');
    [in out]                          = calcgain(voltages(1), units{i});
    in_gain{i,:}                      = in;
    out_gain{i,:}                     = out;
end

results = struct('instrument',instrument,...
                 'channel', channels,...
                 'out_units', units,...
                 'out_gain', out_gain,...
                 'in_units', units,...
                 'in_gain', in_gain);
             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [in_gain out_gain] = calcgain(gainVoltage, units)
% The telegraph values go up by increments of ~ 0.4
% If it's negative, add a factor of 100
% If the units are mV, add a factor of 10
V = round(abs(gainVoltage) ./ 0.4);
gains = [0.5 1 2 5 10 20 50 100];
voltages = 1:8;
ind = (voltages == V);
if ~any(ind)
    out_gain = 1;
else
    out_gain = gains(ind);
end

switch lower(units)
    case 'mv'
        out_gain = out_gain * 10;
        in_gain  = 20;
    case 'pa'
        out_gain = out_gain * 1000;
        in_gain  = 2000;
    case 'na'
        in_gain  = 2;
    otherwise
        in_gain  = 1;
end
if gainVoltage < 0
    out_gain = out_gain * 100;
end

