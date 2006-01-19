% ACQUISITION
%
% Data acquisition is handled through a subscriber model. A subscription
% essentially consists of a function handle that is called whenever a chunk
% of data is returned by the data acquisition hardware.  These data chunks
% are passed to the function in a structure that includes not only the data
% itself, but information about which channels are contained in the data,
% so that the subscribing module knows what to update.
%
% Data will be received by subscribing functions each time a DAQ object
% calls DATAHANDLER. This occurs under the following three conditions: (1)
% the device records a predetermined number of samples, (2) the device is
% stopped programmatically, and (3) the device stops due to an error.
%
% Because inputs and outputs are logically organized according to
% instruments, each subscription is associated with a specific instrument.
% When data is returned for the subscription, it will contain data for all
% the channels described for the instrument, as well as information about
% the reason for the data packet being sent (e.g., if an error occurred)
%
% NB: When multiple DAQ devices are being used, DATAHANDLER will be called
% whenever any of these devices fulfills one of the above conditions. If an
% instrument's channels are all confined to a single DAQ, then the
% subscriber will receive one packet of data; if the channels are spread
% across DAQs, multiple packets will be received. This is important to
% realize if the subscriber is going to initiate another sweep after
% receiving data.
%
% Files
%
%   GetSubscriberNames - Returns a list of the current subscribers
%   AddSubscriber      - Adds a subscriber to the acquisition system.
%   DataHandler        - Handles dispersing data to subscribers
%   DeleteSubscriber   - Unregisters a subscriber from the acquisition system.
%
% $Id: Contents.m,v 1.2 2006/01/19 03:14:51 meliza Exp $