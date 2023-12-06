             
%% MID Timing Files         
MIDfnames = filenames(fullfile(basedir,'test_bids/sub-*/ses-1/beh/3_MID*txt'));
txt = readtable(MIDfnames{1});


t = readtable("sub-50001_ses-1_task-mid_run-01_events.tsv", "FileType","text",'Delimiter', '\t');

% pull event types
antgainidx = contains(t.type,"Win $5.00") | contains(t.type,"Win $1.50");
antgainzeroidx = contains(t.type,"Win $0.00");
antlossidx = contains(t.type,"Lose $5.00") | contains(t.type,"Lose $1.50");
antlosszeroidx = contains(t.type,"Lose $0.00");

onsets{1} = t.onset(antgainidx);
durations{1} = ones(1,length(onsets)) .* 4;
names{1} = {'GainAnticipation'};

onsets{2} = t.onset(antgainzeroidx);
durations{2} = ones(1,length(onsets)) .* 4;
names{2} = {'GainAnticipationZero'};

onsets{3} = t.onset(antlossidx);
durations{3} = ones(1,length(onsets)) .* 4;
names{3} = {'LossAnticipation'};

onsets{4} = t.onset(antlosszeroidx);
durations{4} = ones(1,length(onsets)) .* 4;
names{4} = {'LossAnticipationZero'};

onsets{5} = t.onset(motor);
durations{5} = ones(1,length(onsets)) .* 2;
names{5} = {'Motor'};

%save output
temp_file_name = strcat(num2str(curr_table.PID(trial_ind1)),'_anticipation_timing.mat');
    save(fullfile(savedir, temp_file_name), 'onsets', 'names', 'durations');

% add all trial types
% need to pull motor onsets, duration will be 2. 
% save onsets durations names in file that corresponds to each sub.

                
             



%% Chatroom event.tsv files
CRfnames_txt = filenames(fullfile(basedir,'behavioral_files/sub-*/ses-1/beh/chzc*txt')); 
CRfnames_csv = filenames(fullfile(basedir,'behavioral_files/sub-*/ses-1/beh/chzc*csv'));

%create events files from PsychToolbox version of Chatroom, output is a csv
csv = readtable(CRfnames_csv{1});

%pull PID and session ID
pid = csv.subjectID(1);
ses = CRfnames_csv{1}(89:93); %RISE 89:93

%pull onset, duration, trial type , and response time variables into events.tsv file
onset = csv.trialOnset
duration = (csv.trialOffset - csv.trialOnset) %4 seconds
trial_type = cell2table(csv.trialTopic)
trial_type.Properties.VariableNames = {'trial_type'};
response_time = csv.trialRT

events = array2table([onset, duration, response_time]);
events.Properties.VariableNames = {'onset', 'duration', 'response_time'}
events_final = [events, trial_type]

%write to tsv file
curr_filename = fullfile(basedir, strcat('sub-',pid{sub},'/ses-1/func/sub-',pid{sub},'_ses-1_task-chatroom_run-01_events.tsv'));   
        writetable(final_chat,curr_filename,'delimiter','tab')

%create events files from E-Prime version of Chatroom, output is a txt
txt = readtable(CRfilepaths_txt{1});



for sub = 1:length(CRfilepaths_csv)
    csv = readtable(CRfilepaths_csv{1});
    pid{sub} = CRfilepaths_csv(60:70);
    func_dir = fullfile(basedir,strcat('sub-',pid{sub},'/ses-1/func/'));
    mkdir(func_dir);
end

cr_events = readtable("chcz.csv", "FileType", "text", 'Delimiter', ',');



%Chatroom timing files
