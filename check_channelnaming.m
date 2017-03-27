function  data = check_channelnaming(data)
%% function checks channel names and corrects, if names have  changed in tdms!

%% check if physical channel name was added to channel name

%fields = fieldname



fields = fieldnames(data);

% check if channelname added or not:

if strfind(fields{8},'AI') 
    AI_added = 1;
else
    AI_added = 0;
end

if AI_added == 0
    for i=7:size(fields,1)
        if size(fields{i},2)>9 && isempty(strfind(fields{i},'calced'))
          field_string = strcat(fields{i},regexprep(data.(fields{i}).Property.phyIO,'[^\w'']',''));
          field_string = strrep(field_string,'cRIO','crio_data');
          field_string = strrep(field_string,'cDAQ','cdaq_data');
          data.(field_string)=...
          data.(fields{i});
          data = rmfield(data,fields{i});
        end
    end
end

%data = get_length_of_channels(data);




% manual change!

% campaign 8:

if isfield(data,'crio_dataabsolutposiAI28')
  data.crio_dataabsolutposi1AI28 = data.crio_dataabsolutposiAI28;
 % data = rmfield(data,'crio_dataabsolutposiAI28');
end

%data.cdaq_datapress_dyn_inflowAI03.Data = data.cdaq_datapress_dyn_inflow_after_gridsAI05.Data;
if isfield(data,'cdaq_datapress_dyn_inflow_after_gridsAI05')
  data.cdaq_datapress_dyn_inflowAI03 = data.cdaq_datapress_dyn_inflow_after_gridsAI05;
  data = rmfield(data,'cdaq_datapress_dyn_inflow_after_gridsAI05');
end


% fields = fieldnames(data);
% if ~isfield(data,'cdaq_datarhokgm')
%  data.rho = 1.2;
%  data.cdaq_datarhokgm.Data(1:data.cdaq_data_numbers,1) = data.rho;
%  
% end

if isfield(data,'crio_databendflapblade3DMS01')
  data.crio_databendflapblade3DMS02 = data.crio_databendflapblade3DMS01;
  data = rmfield(data,'crio_databendflapblade3DMS01');
end

if isfield(data,'crio_dataPotiAI33')
  data.crio_dataPotiservo3AI33 = data.crio_dataPotiAI33;
  data = rmfield(data,'crio_dataPotiAI33');
end



return
end