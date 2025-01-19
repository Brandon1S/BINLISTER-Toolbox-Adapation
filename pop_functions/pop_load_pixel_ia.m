function [EEG, com] = pop_load_pixel_ia(EEG)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                          Option 2:                              %            
    %         Interest Area pixel locations for each interest area    %
    %                                                                 %
    %                                                                 %
    %                                                                 %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Initialize outputs (good practice for pop functions)
    com = '';
    if nargin < 1
        EEG = eeg_emptyset;
    end
    
    txtFileList = {};

    % Creates the figure
    hFig = figure('Name','Load text IA', ...
                  'NumberTitle','off', ...
                  'MenuBar','none', ...
                  'ToolBar','none', ...
                  'Color',[0.94 0.94 0.94], ...
                  'Resize', 'off');
    
    geomhoriz = { ...
        [1 0.5]
        1
        1
        [2 1]
        [0.4 1]
        [0.4 1]
        [0.4 1]
        [0.4 1]
        [0.4 1]
        [2 1]
        [2 1]
        1
        [0.5 0.2 0.2]
    };

    
    uilist = { ...
        
        {'Style','text','String','Load text file with IA pixel boundaries:'}, ...
        {'Style','pushbutton','String','Browse','callback', @browseTxtFile}, ...
        ...
        {'Style', 'listbox', 'tag', 'datasetList', 'string', {}, 'Max', 10, 'Min', 1, 'HorizontalAlignment', 'left'}, ...
        ...
        {}, ...
        ... 
        {'Style','text','String','Number of regions:'}, ...
        {'Style','edit','String','3','tag','NumRegions'}, ...
        ...
        {'Style','text','String','Region start (left) names:' }, ...
        {'Style','edit','String','10','tag','pixelStart'}, ...
        ...
        {'Style','text','String','Region end (right) names:'}, ...
        {'Style','edit','String','10','tag','pixelEmd'}, ...
        ...
        {'Style','text','String','Region width names:'}, ...
        {'Style','edit','String','10','tag','pixelWidth'}, ...
        ...
        {'Style','text','String','Region Y top names (optional):'}, ...
        {'Style','edit','String','10','tag','pixelStartR%'}, ...
        ...
        {'Style','text','String','Region Y bottom names (optional):'}, ...
        {'Style','edit','String','10','tag','pixelStartR%'}, ...
        ...
        {'Style','text','String','Condition Column Name:'}, ...
        {'Style','edit','String','Condition','tag','edtCondName'}, ...
        ...
        {'Style','text','String','Item Column Name:'}, ...
        {'Style','edit','String','Item','tag','edtItemName'}, ...
        ...
        {}, ...
        ... 
        {}, ...
        {'Style', 'pushbutton', 'String', 'Cancel', 'callback', @(~,~) cancel_button}, ...
        {'Style', 'pushbutton', 'String', 'Confirm', 'callback', @(~,~) confirm_button}, ...
    };

    supergui('fig', hFig, 'geomhoriz', geomhoriz, 'uilist', uilist, 'title', 'Load Text IA');

     % ---------- Nested Callback Functions -----------------
    
    function browseTxtFile(~,~)
        [fname, fpath] = uigetfile({'*.txt';'*.csv'}, 'Select IA Text File');
        if isequal(fname,0)
            return; % user cancelled
        end
        filePath = fullfile(fpath,fname);

        txtFileList = { filePath };

        set(findobj(gcf, 'tag','datasetList'), 'string', txtFileList, 'value',1);
        
    end

    function cancel_button(~,~)
        close(gcf);
        disp('User selected cancel: No text file for pixel locations');
    end

    function confirm_button(~,~)
       
        % Gather parameters from GUI
        offset         = str2double(get(findobj('tag','edtOffset'), 'String'));
        pxPerChar      = str2double(get(findobj('tag','edtPxPerChar'), 'String'));
        numRegions     = str2double(get(findobj('tag','edtNumRegions'), 'String'));
        regionNames = get(findobj('tag','edtRegionNames'), 'String');
        conditionColName = get(findobj('tag','edtCondName'), 'String');
        itemColName      = get(findobj('tag','edtItemName'), 'String');
        regionNames = strtrim(strsplit(regionNames, ','));

        % Validate the user selected a file
        if isempty(txtFileList)
            errordlg('No text file selected. Please browse for a file.','File Missing');
            return;
        end

        % If only one file is expected, take the first cell
        txtFilePath = txtFileList{1};

        % Calls function to compute interest area based on text and pixel location
        EEG = compute_text_based_ia(EEG, txtFilePath, offset, pxPerChar, ...
                                 numRegions, regionNames, conditionColName, ...
                                 itemColName);

        % Command string for history
        com = sprintf('EEG = pop_loadTextIA(EEG); %% file=%s offset=%g px=%g',...
                      txtFilePath, offset, pxPerChar);

        % Close GUI, redraw EEGLAB
        close(gcf);
        eeglab('redraw');
    end
end




