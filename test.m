clc;

% x = 1:1:5;
% y = [x;rand(1,5)];
% fileID = fopen('nums4.txt','w+');
% fprintf(fileID,'%d %4.4f\n',y);
% fclose(fileID);

v = read_values("rest.txt");
s = create_cw_struct(v);

s.ed = s.Re / s.D;

h=[1 2 3];
h

function s = create_cw_struct(values)
    c = cell(1,2*length(values{1}));
    for i = 1:length(values{1})
        c{2*i - 1} = values{1}{i};
        c{2*i} = values{2}(i);
    end
    s = struct(c{:});
end


function values = read_values(file_name)
    fileID = fopen(file_name,'r');
    formatSpec = '%s %f';
    values = textscan(fileID, formatSpec);
    fclose(fileID);
end