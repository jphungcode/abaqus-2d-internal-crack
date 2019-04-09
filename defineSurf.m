function surf_name = defineSurf(elset_inp,ele_name)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
surf_name = {};
for i=1: length(ele_name)
    set_bool = ~cellfun(@isempty,strfind(elset_inp,ele_name(i)));
    set_loc = find(set_bool==1);
    
    for k=1:length(set_loc);
        if cell2mat(strfind(ele_name(i),'face1'))>0
            face = 'S1';
        elseif cell2mat(strfind(ele_name(i),'face2'))>0
            face = 'S2';
        elseif cell2mat(strfind(ele_name(i),'face3'))>0
            face = 'S3';
        elseif cell2mat(strfind(ele_name(i),'face4'))>0
            face = 'S4';
        end
        temp_name = sprintf('%s-%d, %s',char(ele_name(i)),k,face);
        surf_name = [surf_name ; cellstr(temp_name)];
    end
end

end

