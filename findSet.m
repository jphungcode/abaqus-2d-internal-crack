function setlist = findSet(file,set_name)
%Returns node numbers of element numbers for given node set/element set for
%abaqus input file
    C = file;
    set_bool = ~cellfun(@isempty,strfind(C,set_name));
    set_loc = find(set_bool==1);
    list = [];
    i= 1;

    if strcmp(set_name, '*Element')
        for k=1:length(set_loc)-1
            i = 1;
            while true
                output = C{set_loc(k)+i};
                output_split = regexp(output,',','split');
                output_num = str2double(output_split);
                if isnan(output_num)
                    break;
                end
                if length(output_num) ==4 %if triangle element, append 0 to end to allow vertcat
                   output_num = [output_num, 0]; 
                end
                list = [list; output_num];
                i = i+1;
            end
            
        end
    elseif strcmp(set_name,'*Node')
        while true
            output = C{set_loc+i};
            output_split = regexp(output,',','split');
            output_num = str2double(output_split);
            if isnan(output_num)
                break;
            end
            list = [list ;output_num];
            i = i+1;
        end
    else
        while true
            output = C{set_loc+i};
            if output(end) ==','
                output = output(1:end-1); 
            end
            output_split = regexp(output,',','split');
            output_num = str2double(output_split);
            if isnan(output_num)
                break;
            end
            list = [list ;output_num'];
            i = i+1;
        end 
    end
    setlist = list;

end

