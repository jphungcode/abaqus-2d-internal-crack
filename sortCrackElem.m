function elset = sortCrackElem(crackfaceset,elsetname,instancename)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
elset = {};
elid_out = [];
if isempty(crackfaceset) ==1
   return
end

if length(crackfaceset) > 10
    elset_no = ceil(length(crackfaceset)/10);
    k = 0;
    for i=1: elset_no 
        txt_elset = sprintf('*Elset,elset=%s-%d,internal,instance = %s',elsetname,i,instancename);
        if k + 10>length(crackfaceset)
            elid_out = [];
            for h=1+k:length(crackfaceset)
                elid = int2str(crackfaceset(h,1));
                elid_comma = strcat(elid,',');
                elid_out = strcat(elid_out,elid_comma);
            end
            elset = [elset;cellstr(txt_elset);elid_out];
            %elset = [elset;cellstr(txt_elset);int2str(crackfaceset(1+k:end,1)')];
            break
        else
            elid_out = [];
            for h=1+k:k+10
               elid = int2str(crackfaceset(h,1));
               elid_comma = strcat(elid,',');
               elid_out = strcat(elid_out,elid_comma);
            end
            elset = [elset;cellstr(txt_elset);elid_out];
            %elset = [elset;cellstr(txt_elset);int2str(crackfaceset(1+k:k+10,1)')];
            k = k +10 ;
        end     
    end    
else
    elset_no = 1;
    elid_out = [];
    txt_elset = sprintf('*Elset,elset=%s-%d,internal,instance = %s',elsetname,elset_no,instancename);
    for h=1:size(crackfaceset,1)
        elid = int2str(crackfaceset(h,1));
        elid_comma = strcat(elid,',');
        elid_out = strcat(elid_out,elid_comma);
    end
    elset = [cellstr(txt_elset);elid_out];
end

end

