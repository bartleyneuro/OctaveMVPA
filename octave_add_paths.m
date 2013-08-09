%delete ~/.octaverc;

%Turn off unnecessary warnings
	%warning ("off", "Octave:possible-matlab-short-circuit-operator");
	warning ("off", "all");
	filename = "~/.octaverc";
    	fid = fopen (filename, "at");
     	%fputs (fid, "warning (""off"", ""Octave:possible-matlab-short-circuit-operator"");");
     	fputs (fid, "warning (""off"", ""all"");");
     	fclose (fid); 
    cd keithcontr/spm8/src
	system('make distclean PLATFORM=octave');
	system('make PLATFORM=octave && make install PLATFORM=octave');
	%system('make toolbox-distclean PLATFORM=octave');
	%system('make toolbox PLATFORM=octave && make toolbox-install PLATFORM=octave');
	cd ../../..

addpath(genpath(make_absolute_filename('core')))
addpath(genpath(make_absolute_filename('contrib')))
addpath(genpath(make_absolute_filename('afni_matlab')))
addpath(genpath(make_absolute_filename('boosting')))
addpath(genpath(make_absolute_filename('bv2mat')))
addpath(genpath(make_absolute_filename('montage_kas')))
addpath(genpath(make_absolute_filename('netlab')))
addpath(genpath(make_absolute_filename('keithcontr')))

addpath(pwd);
savepath;

disp('SUCCESS!!!');



     
