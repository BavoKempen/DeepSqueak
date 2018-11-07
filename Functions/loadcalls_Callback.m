% --- Executes on button press in LOAD CALLS.
function loadcalls_Callback(hObject, eventdata, handles,call_file_number,nothing)
h = waitbar(0,'Loading Calls Please wait...');
update_folders(hObject, eventdata, handles);
handles = guidata(hObject);
handles.calls = [];
handles.calls.Type = {'Real Time'};
handles.calls.Score = 1;
handles.calls.Rate = 44100;
handles.calls.Box = [.02,1,.02,10];
handles.calls.RelBox = [.02,1,.02,10];
handles.calls.Accept = 1;
handles.calls.Audio = rand(1,10000);

if nargin < 5
if nargin == 3 % if "Load Calls" button pressed
    handles.current_file_id = get(handles.popupmenuDetectionFiles,'Value');
end
handles.current_detection_file = handles.detectionfiles(handles.current_file_id).name;
tmp=load([handles.detectionfiles(handles.current_file_id).folder '\' handles.detectionfiles(handles.current_file_id).name],'Calls');%get currently selected option from menu
handles.calls=tmp.Calls;
end
handles.currentcall=1;
handles.CallTime=[];


cla(handles.axes7);
cla(handles.axes5);
cla(handles.axes1);
cla(handles.axes4);

%% Create plots for update_fig to update

% Contour
handles.ContourScatter = scatter(1:5,1:5,'LineWidth',1.5,'Parent',handles.axes7,'XDataSource','x','YDataSource','y');
set(handles.axes7,'Color',[.1 .1 .1],'YColor',[1 1 1],'XColor',[1 1 1],'Box','off');
set(handles.axes7,'YTickLabel',[]);
set(handles.axes7,'XTickLabel',[]);
set(handles.axes7,'XTick',[]);
set(handles.axes7,'YTick',[]);
handles.ContourLine = lsline(handles.axes7);

% Spectrogram
handles.spect = imagesc([],[],handles.background,'Parent', handles.axes1);
cb=colorbar(handles.axes1);
cb.Label.String = 'Power';
cb.Color = [1 1 1];
cb.FontSize = 12;
ylabel(handles.axes1,'Frequency (kHZ)','Color','w');
xlabel(handles.axes1,'Time (s)','Color','w');
handles.box=rectangle('Position',[1 1 1 1],'Curvature',0.2,'EdgeColor','g',...
    'LineWidth',3,'Parent', handles.axes1);

% Filtered image
handles.filtered_image_plot = imagesc([],'Parent', handles.axes4);
set(handles.axes4,'Color',[.1 .1 .1],'YColor',[1 1 1],'XColor',[1 1 1],'Box','off');
colormap(handles.axes4,handles.cmap);
set(handles.axes4,'YTickLabel',[]);
set(handles.axes4,'XTickLabel',[]);
set(handles.axes4,'XTick',[]);
set(handles.axes4,'YTick',[]);


% Plot Call Position
for i=1:length([handles.calls(:).Rate])
    waitbar(i/length(handles.calls),h,'Loading Calls Please wait...');
    handles.CallTime(i,1)=handles.calls(i).Box(1);
end

line([0 max(handles.CallTime(:,1))],[0 0],'LineWidth',1,'Color','w','Parent', handles.axes5);
line([0 max(handles.CallTime(:,1))],[1 1],'LineWidth',1,'Color','w','Parent', handles.axes5);
set(handles.axes5,'XLim',[0 max(handles.CallTime(:,1))]);
set(handles.axes5,'YLim',[0 1]);

set(handles.axes5,'Color',[.1 .1 .1],'YColor',[.1 .1 .1],'XColor',[.1 .1 .1],'Box','off','Clim',[0 1]);
set(handles.axes5,'YTickLabel',[]);
set(handles.axes5,'XTickLabel',[]);
set(handles.axes5,'XTick',unique(sort(handles.CallTime(:,1))));
set(handles.axes5,'YTick',[]);
handles.axes5.XAxis.Color = 'w';

% Call position
handles.CurrentCallLinePosition = line([handles.CallTime(1,1) handles.CallTime(1,1)],[0 1],'LineWidth',3,'Color','g','Parent', handles.axes5);
handles.CurrentCallLineLext= text((max(handles.CallTime(1,1))),1.2,[num2str(1,'%.1f') ' s'],'Color','W', 'HorizontalAlignment', 'center','Parent',handles.axes5);


colormap(handles.axes1,handles.cmap);
colormap(handles.axes4,handles.cmap);

close(h);
update_fig(hObject, eventdata, handles);
guidata(hObject, handles);

