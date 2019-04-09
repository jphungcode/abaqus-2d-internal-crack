function loc = findNameLoc(file,setname)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
set_bool = ~cellfun(@isempty,strfind(file,setname));
loc = find(set_bool==1);

end

