function protocol   = GetCurrentProtocol()
%
% GETCURRENTPROTOCOL    Returns the current protocol
%
% GETCURRENTPROTOCOL  returns the handle of the current protocol, or if
% none is loaded, an empty array.
%
% See also: SETCURRENTPROTOCOL
%
% $Id: GetCurrentProtocol.m,v 1.2 2006/01/30 20:04:34 meliza Exp $

protocol    = GetGlobal('current_protocol');