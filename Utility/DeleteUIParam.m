function [] = DeleteUIParam(module, tag)
%
% DELETEUIPARAM Removes an uiparam from control and deletes its handle
% object
%
% [] = DELETEPARAM(module, tag)
%
% <tag> can be a cell array of strings or a single string
%
%
% See also: INITUICONTROL, INITUIOBJECT
%
% Copyright 2006-2011 dmeliza@uchicago.edu; see LICENSE

global mpctrl

module  = lower(module);
tag     = CellWrap(tag);

%% Check tag for empties, get handle(s)
empty   = strmatch('',tag,'exact');
tag     = tag(setdiff(1:length(tag), empty));

h       = GetUIHandle(module, tag);

%% Delete objects
if ~isempty(h)
    delete(h(ishandle(h)));
end

%% Delete fields
mpctrl.(module).handles = rmfield(mpctrl.(module).handles, tag);

%% Check for empty structure
if length(fieldnames(mpctrl.(module).handles)) < 1
    mpctrl.(module).handles = [];
end

deleted = sprintf(' %s', tag{:});
DebugPrint('Deleted uiparam from %s:%s.', module, deleted)
