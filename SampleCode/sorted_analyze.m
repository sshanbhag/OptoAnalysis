%------------------------------------------------------------------------
% sorted_analyze.m
%------------------------------------------------------------------------
% TytoLogy:OptoAnalysis
%--------------------------------------------------------------------------
% working script for analysis of sorted (Plexon) data
%------------------------------------------------------------------------
% See Also: optosort, optoproc, opto (TytoLogy:opto program)
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%   sshanbhag@neomed.edu
%------------------------------------------------------------------------
% Created: 23 September 2020 (SJS)
%	 
% Revisions:
%
%------------------------------------------------------------------------


%------------------------------------------------------------------------
%------------------------------------------------------------------------
%% define paths and data files
%------------------------------------------------------------------------
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% data locations - adjust this for your setup
%------------------------------------------------------------------------

% location of .plx file (from Plexon OfflineSorter)
plxFilePath = '/Users/sshanbhag/Work/Data/TestData/exports/1407';
% location of _nexInfo.mat file (generated by export_for_plexon)
nexInfoPath = plxFilePath;

% sorted data file name
plxFile = '1407_20200305_01_01_550_BBN-Sorted.plx';
% nexinfo file
nexInfoFile = '1407_20200305_01_01_550_BBN_nexinfo.mat';

sendmsg(sprintf('Using data from file: %s', plxFile));


%------------------------------------------------------------------------
%------------------------------------------------------------------------
%% load sorted data
%------------------------------------------------------------------------
% How to use:
% import_from_plexon(<plx file name>, <nexinfo file name>, 
%								<'continuous'/'nocontinuous'>)
%
%	will return a SpikeData object containing data from plx file:
% 	- spike times/unit information if sorted
% 	- continuous data, if saved in plx and 'continuous' is 
%		specified (default)
% 	- file stimulus info
%------------------------------------------------------------------------
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% there are two options here - if you feel that you'll want to look at the
% continuous data (recordings from electroeds), you can specify the
% 'continuous' option to load them.  otherwise, say "nocontinuous' to save
% time and memory
%------------------------------------------------------------------------
S = import_from_plexon(fullfile(plxFilePath, plxFile), ...
							fullfile(nexInfoPath, nexInfoFile), 'continuous');
						
%------------------------------------------------------------------------
%% show file, channel, unit
%------------------------------------------------------------------------
% display file, channel, unit info, store information about files, channels
% and units
[fileList, channelList, unitList] = S.printInfo;

%% Plot RLFs, raster/psth
% binsize (in milliseconds) for psth
psth_bin_size = 5;
%------------------------------------------------------------------------
% loop through channels, units
%------------------------------------------------------------------------
nChannels = length(channelList);
for cIndx = 1:nChannels
	% set current channel
	channel = channelList(cIndx);
	% and get list of units for this channel
	if ~isempty(unitList{cIndx})
		units = unitList{cIndx};
		nUnits = length(units);
	else
		units = [];
		nUnits = 0;
	end
	
	if nUnits
		
		Hwf = cell(nUnits, 1);
		for uIndx = 1:nUnits
			% specify unit:
			unit = units(uIndx);

			%-------------------------------------------------------
			% figure out file index for this test. the indexForTestName method of
			% SpikeData class allows an easy way to do this.
			%-------------------------------------------------------
			findx = S.indexForTestName('BBN');
			if isempty(findx)
				fprintf('Test %s not found in %s\n', testToPlot, plxFile);
				error('%s: bad testToPlot', mfilename);
			end

			%------------------------------------------------------------------------
			% get spikes times struct (store in st) for this test, channel and unit
			% spiketimes will be aligned to start of each sweep
			%------------------------------------------------------------------------
			fprintf('Getting data for file %d (%s), channel, %d unit %d\n', ...
											findx, S.listFiles{findx}, channel, unit);
			st = S.getSpikesByStim(findx, channel, unit);

			% plot waveforms
			plot_waveforms_from_table(st, S.Info.Fs);
			Hwf{uIndx} = gca;
		end
		
		% create new figure with subplots
		figure
		Hsub = cell(nUnits, 1);
		for uIndx = 1:nUnits
			Hsub{uIndx} = subplot(nUnits, 1, uIndx);
			copyobj(Hwf{uIndx}, Hsub{uIndx});
		end
		
	else
		fprintf('No units on channel %d\n', channel);
	end

end


