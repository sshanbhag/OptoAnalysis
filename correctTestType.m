function Dinf = correctTestType(Dinf)
%------------------------------------------------------------------------
% Dinf = correctTestType(Dinf)
%------------------------------------------------------------------------
% Opto Analysis
%--------------------------------------------------------------------------
% given Dinf struct, figures out test type
%
%------------------------------------------------------------------------
% Input Arguments:
% 	Dinf		data information struct (from readOptoData() )
% 
% Output Arguments:
%	ttype		test type (string)
%
%------------------------------------------------------------------------
% See Also: readOptoData, viewOptoData, opto program
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%   sshanbhag@neomed.edu
%------------------------------------------------------------------------
% Created: 11 July, 2017 (SJS)
%           - pulled out of getFilteredOptoData
%
% Revisions:
%------------------------------------------------------------------------

% try to get information from test Type
if isfield(Dinf.test, 'Type')
	% convert ascii characters from binary file
	Dinf.test.Type = char(Dinf.test.Type);
else
	% otherwise, need to find a different way
	if isfield(Dinf.test, 'optovar_name')
		Dinf.test.optovar_name = char(Dinf.test.optovar_name);
		Dinf.test.Type = Dinf.test.optovar_name;
	end
	if isfield(Dinf.test, 'audiovar_name')
		Dinf.test.audiovar_name = char(Dinf.test.audiovar_name);
		if strcmpi(Dinf.test.audiovar_name, 'WAVFILE')
			% test is WAVfile
			Dinf.test.Type = Dinf.test.audiovar_name;
		end
	end
end