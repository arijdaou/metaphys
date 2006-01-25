function [] = SetGlobal(fieldname, value)
%
% SETGLOBAL Sets a global variable in the control structure
%
% The control structure has a special field, globals, which is used for
% storing variables that should be easy to access by all functions. For
% purposes of speed, values are not checked when stored here, and it is
% important for functions that use this facility to be careful about naming
% and type.
%
% SETGLOBAL(fieldname, value)
%
% $Id: SetGlobal.m,v 1.1 2006/01/25 17:49:32 meliza Exp $

global mpctrl

mpctrl.globals.(fieldname)  = value;
