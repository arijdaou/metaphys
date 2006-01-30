function channel    = GetInstrumentChannel(instrument, cname)
%
% GETINSTRUMENTCHANNEL Returns the channel object associated with an
% instrument channel. 
%
% If the instrument or channel have not been defined, an error is thrown.
%
% chan = GETINSTRUMENTCHANNEL(instrument, channel)
%
% CHANNEL can be a cell array, in which case multiple channels will be
% retrieved as a cell array of objects.  Due to the way the DAQ toolkit
% handles channel objects, they cannot be concatenated if they don't share
% a parent, so a cell array is used.
%
% chan = GETINSTRUMENTCHANNEL(instrument) - returns all channels
%
% See also: GETCHANNELSTRUCT
%
% $Id: GetInstrumentChannel.m,v 1.3 2006/01/30 20:04:39 meliza Exp $

chanstruct  = GetChannelStruct(instrument, cname);
channel     = CellWrap(chanstruct.obj);
