function x = to_ms(x)

fn = fieldnames(x);
for i = 1:length(fn)
    cur_name = fn{i};
    x.(cur_name) = 1000*x.(cur_name);
end