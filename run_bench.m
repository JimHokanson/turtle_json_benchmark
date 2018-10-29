function run_bench

% DIR_NAMES = {'c  _json_io','c_panton','jsonlab'};
N_REPS_MAX = 8;

%If we exceed this time for a single rep, just do one
MAX_REP_PER_TIME = 60;

%Tests
%------------------------
%1) Turtle JSON
%2) Matlab jsondecode

this_path = which('run_bench');
this_root = fileparts(this_path);
data_root = fullfile(this_root,'data');

json_files = dir(fullfile(data_root,'*.json'));
%Just in case
json_files2 = dir(fullfile(data_root,'json_examples','*.json'));

json_files = [json_files json_files2];

file_names = {json_files.name};

% ff = @(x) fullfile(this_root,'progs',x);

% %Adding paths
% for i = 1:length(DIR_NAMES)
%     p = ff(DIR_NAMES{i});
%     if exist(p,'dir')
%         addpath(p);
%     end
% end

%Columns
%-------------------------
%1) Display Name
%2) Function to call, as string
%3) type
%   - 1 - filepath
%   - 2 - bytes
%   - 3 - string

info = {
    'Turtle JSON'       'json.load'         1   'turtle_json' %my code
    'Matlab''s jsondecode' 'jsondecode'     3   'Matlab'    %'builtin'
    'CP''s Matlab-JSON' 'fromjson'          3   'CPs_matlab_json' %c_panton
    'C++ JSON IO'       'json_read'         1   'cpp_json_io' %c_json_io
    'JSONLab'           'loadjson'          1   'jsonlab' %JSONLab
    };

n_progs = size(info,1);

exist_flags = true(1,n_progs);
for i = 1:n_progs
    prog_fcn_name = info{i,2};
    prog_name = info{i,1};
    if isempty(which(prog_fcn_name))
        exist_flags(i) = false;
        fprintf(2,'%s not found\n',prog_name);
    end
    
end

safe_prog_names = info(:,4);

%TODO: Exist flag not respected ''''

n_files = length(json_files);
n_progs = size(info,1);
times = NaN(n_progs,n_files,N_REPS_MAX);

for rep = 1:N_REPS_MAX
    for i = 1:n_files
        temp = json_files(i);
        cur_file_path = fullfile(temp.folder,temp.name);
        for j = 1:n_progs
            prog_name = info{j,1};
            if strcmp(prog_name,'JSONLab') && (...
                    strcmp(temp.name,'1.json') || strcmp(temp.name,'citylots.json'))
                %Too large, execution takes too long
                times(j,i,:) = 3600;
                continue
            end
            if rep == 2 && times(j,i,1) > MAX_REP_PER_TIME
                continue
            end
            fprintf('Running %s on %s, Iteration %d ...',prog_name,temp.name,rep)
            fh_str = info{j,2};
            fh = str2func(fh_str);
            switch info{j,3}
                case  1
                    fh2 = @noop;
                case 2
                    fh2 = @read_bytes;
                case 3
                    fh2 = @read_char;
            end
            
            if rep == 2 && run_time > MAX_REP_PER_TIME
                break
            end
            
            
            h_tic = tic;
            data = fh(fh2(cur_file_path));
            run_time = toc(h_tic);
            N = 0;
            if run_time < 0.01
                N = 200;
            elseif run_time < 0.1
                N = 20;
            end
            if N ~= 0
                h_tic = tic;
                for k = 1:N
                    data = fh(fh2(cur_file_path));
                end
                run_time = toc(h_tic)/N;
            end
                
            
            fprintf(' time: %0.3f\n',run_time);
            times(j,i,rep) = run_time;
            
            clear data
            pause(0.1)
        end
    end
end

save('wtf.mat','times','info','MAX_REP_PER_TIME','file_names')

keyboard

avg_times1 = nanmean(times,3);
%Ignore the first rep
avg_times2 = nanmean(times(:,:,2:end),3);
avg_times = min(avg_times1,avg_times2);

c_data = cell(n_files+1,n_progs*2);
temp = num2cell(avg_times');
c_data(2:end,2) = temp(:,1);
c_data(2:end,3:2:end) = temp(:,2:end);
 
%1 - names
%2 - TJ
%3 - Matlab
%4 - ratios
c_data(2:end,4:2:end) = num2cell(bsxfun(@rdivide,avg_times(2:end,:),avg_times(1,:))');
c_data(2:end,1) = file_names;


c = num2cell(avg_times,2);
c2 = cellfun(@(x) num2cell(x)',c,'un',0);
T = table(file_names',c2{:});
T.Properties.VariableNames = [{'file_names'};safe_prog_names];

%Save to html

% fid = fopen('times.html','w');
% 
% 
% fclose(fid);
%


% <table class="table table-bordered table-hover table-condensed">
% <thead><tr><th title="Field #1">Test</th>
% <th title="Field #2">Test1</th>
% <th title="Field #3">Test2</th>
% </tr></thead>
% <tbody><tr>
% <td align="right">2</td>
% <td align="right">3</td>
% <td align="right">4</td>
% </tr>
% </tbody></table>

tj_times = avg_times(1,:);
x0 = log10(tj_times);
x1 = min(x0);
x2 = max(x0);
y1 = -0.3;
y2 = 0.3;

m = (y2-y1)./(x2-x1);
b = y2-m*x2;
y0 = m.*x0 + b;

%4 x 25
norm_times = avg_times(2:end,:)./avg_times(1,:);

n_files = size(norm_times,2);
n_progs = size(norm_times,1);

%TODO: Get Median ...
%Break up by files that:
%1) Take less than 100 ms to parse
cla
for i = 1:n_progs
   %Make x the time it took to parse in Turtle Json
   x1 = i+y0;
   semilogy(x1,norm_times(i,:),'o','MarkerSize',16);
   if i == 1
       %Need to hold after the semilog
       hold on
   end
end
I = find(strcmp(file_names,'XJ30_NaCl500mM4uL6h_10m45x10s40s_Ea.json'));
x1 = (1:4)+y0(I);
co = get(gca,'ColorOrder');
for i = 1:4
semilogy(x1(i),norm_times(i,I),'o','MarkerEdgeColor',co(i,:),...
    'MarkerSize',16,'MarkerFaceColor',co(i,:));
end
hold off
set(gca,'xlim',[0.5 n_progs+0.5],'xtick',1:n_progs,'xticklabels',info(2:end,1),'FontSize',18,'XTickLabelRotation',30)
set(gca,'ylim',[0.1 5000],'ytick',10.^(-1:4),'YTickLabel',{'0.1','1','10','100','1000','10000'})
ylabel('normalized parse time');

%??? Speedup vs execution time of Turtle JSON

end

function out = read_bytes(file_path)
fid = fopen(file_path,'r');
out = fread(fid,'*uint8')';
fclose(fid);
end

function file_path = noop(file_path)

end

function str = read_char(file_path)
str = fileread(file_path);
end