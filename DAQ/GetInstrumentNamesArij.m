function instrumentName = GetInstrumentNamesArij()

global mpctrl

instrumentName = [];
if isfield(mpctrl, 'instrument')
    if isstruct(mpctrl.instrument)
        % This returns a cell array containing strings
       fNames = fieldnames(mpctrl.instrument);  
       
       if(strcmp(fNames{1}, 'newinstrument_1'))
           instrumentName{1} = mpctrl.instrument.newinstrument_1.name;
       else
           instrumentName{1} = fNames{1};
       end       
    end
end