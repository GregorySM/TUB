function data = get_length_of_channels(data);
%% get length of crio data:
 fields = fieldnames(data);

  for i=7:size(fields,1)
    if size(fields{i},2)>7 && ~isempty(strfind(fields{i},'crio')) && isstruct(data.(fields{i}))
        data.crio_data_numbers = data.(fields{i}).Total_Samples;
        i = size(fields,1);
    end
 end
 
 
 %% get length of cdaq data:
 for i=7:size(fields,1)
   
     if size(fields{i},2)>7 && ~isempty(strfind(fields{i},'cdaq')) && isstruct(data.(fields{i})) && isfield(data.(fields{i}),'Total_Samples')
        data.cdaq_data_numbers = data.(fields{i}).Total_Samples;
        i = size(fields,1);
    end
 end
return
end