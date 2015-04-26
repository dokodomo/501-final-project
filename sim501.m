function sim501
% Clear everything
close;
clear;
clc;

% Set initial values
old_l10 = 1;
old_l20 = 1;
old_l30 = 1;

l10_len = 1; l11_len = l10_len/cosd(30); l12_len = l11_len; l13_len = l11_len; 
range1 = [2/3*l10_len/cosd(30), 4/3*l10_len/cosd(30)];
l11_limit = range1;   % Min and Max of the acctuators
l12_limit = range1;
l13_limit = range1;
l11_temp = l11_len; l12_temp = l12_len;

l20_len = 1; l21_len = l20_len/cosd(30); l22_len = l21_len; l23_len = l21_len; 
range2 = [2/3*l20_len/cosd(30), 4/3*l20_len/cosd(30)];
l21_limit = range2;
l22_limit = range2;
l23_limit = range2;
l21_temp = l21_len; l22_temp = l22_len;

l30_len = 1; l31_len = l30_len/cosd(30); l32_len = l31_len; l33_len = l31_len; 
range3 = [2/3*l30_len/cosd(30), 4/3*l30_len/cosd(30)];
l31_limit = range3;
l32_limit = range3;
l33_limit = range3;
l31_temp = l31_len; l32_temp = l32_len;

% Create the figure
set(0,'Units','pixels');
dim = get(groot,'ScreenSize');
fig = figure('name','Parallel Manipulator',...
    'numbertitle','off',...
    'menubar','none',...
    'units','pixels',...%);
    'outerposition',[dim(3)*.125 dim(4)*.125 800 600]);

figsize = get(fig,'outerPosition');

% Create the GUI
%% Panels
panel1 = uipanel('title', 'Options',... 
    'units', 'pixels',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'position',[0 figsize(4)*.825 figsize(3)/3 figsize(4)*.12]);

panel2 = uipanel('title', 'ForwardKinematics',... 
    'units','pixels',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'position', [0 figsize(4)/4 figsize(3)/3 figsize(4)/1.75]);

panel3 = uipanel('title', 'InverseKinematics',... 
    'units', 'pixels',...
    'fontsize', 12,...
    'fontweight', 'bold',...
    'position',[0 0 figsize(3)/3 figsize(4)/4]);

% Get the dimensions of the panels
p1_size = get(panel1, 'Position');
p2_size = get(panel2, 'Position');
p3_size = get(panel3, 'Position');

%% Fwd Kin Panel - Sliders
% Slider for Link1
l1_slider = uicontrol('parent', panel2,...
    'style', 'slider',...
    'min', l11_limit(1),...
    'max', l11_limit(2),...
    'sliderstep', [0.01, 0.01],...
    'value', l11_len,...
    'position', [p2_size(3)*.275 p2_size(4)*.85 p2_size(3)/2.5 20],...
    'callback', @s1_callback);

% Slider for Link2
l2_slider = uicontrol('parent', panel2,...
    'style', 'slider',...
    'min', l12_limit(1),...
    'max', l12_limit(2),...
    'sliderstep', [0.01, 0.01],...
    'value', l12_len,...
    'position', [p2_size(3)*.275 p2_size(4)*.75 p2_size(3)/2.5 20],...
    'callback', @s2_callback);

% Slider for Link4 (l21)
l4_slider = uicontrol('parent', panel2,...
    'style', 'slider',...
    'min', l21_limit(1),...
    'max', l21_limit(2),...
    'sliderstep', [0.01, 0.01],...
    'value', l21_len,...
    'position', [p2_size(3)*.275 p2_size(4)*.55 p2_size(3)/2.5 20],...
    'callback', @s4_callback);

% Slider for Link5 (l22)
l5_slider = uicontrol('parent', panel2,...
    'style', 'slider',...
    'min', l22_limit(1),...
    'max', l22_limit(2),...
    'sliderstep', [0.01, 0.01],...
    'value', l22_len,...
    'position', [p2_size(3)*.275 p2_size(4)*.45 p2_size(3)/2.5 20],...
    'callback', @s5_callback);

% Slider for Link7 (l31)
l7_slider = uicontrol('parent', panel2,...
    'style', 'slider',...
    'min', l31_limit(1),...
    'max', l31_limit(2),...
    'sliderstep', [0.01, 0.01],...
    'value', l31_len,...
    'position', [p2_size(3)*.275 p2_size(4)*.25 p2_size(3)/2.5 20],...
    'callback', @s7_callback);

% Slider for Link8 (l32)
l8_slider = uicontrol('parent', panel2,...
    'style', 'slider',...
    'min', l32_limit(1),...
    'max', l32_limit(2),...
    'sliderstep', [0.01, 0.01],...
    'value', l32_len,...
    'position', [p2_size(3)*.275 p2_size(4)*.15 p2_size(3)/2.5 20],...
    'callback', @s8_callback);
%% Fwd Kin Panel - Text
% Link1 min value
l1_min = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l11_limit(1),3),...
    'Position', [p2_size(3)*.1 p2_size(4)*.84 50 20]);

% Link1 max value
l1_max = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l11_limit(2),3),...
    'Position', [p2_size(3)*.7 p2_size(4)*.84 50 20]);

% Link2 min value
l2_min = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l12_limit(1),3),...
    'Position', [p2_size(3)*.1 p2_size(4)*.74 50 20]);

% Link2 max value
l2_max = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l12_limit(2),3),...
    'Position', [p2_size(3)*.7 p2_size(4)*.74 50 20]);

% Link3 min value
l3_min = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l13_limit(1),3),...
    'Position', [p2_size(3)*.1 p2_size(4)*.64 50 20]);

% Link3 max value
l3_max = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l13_limit(2),3),...
    'Position', [p2_size(3)*.7 p2_size(4)*.64 50 20]);

% Link4 min value
l4_min = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l21_limit(1),3),...
    'Position', [p2_size(3)*.1 p2_size(4)*.54 50 20]);

% Link4 max value
l4_max = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l21_limit(2),3),...
    'Position', [p2_size(3)*.7 p2_size(4)*.54 50 20]);

% Link5 min value
l5_min = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l22_limit(1),3),...
    'Position', [p2_size(3)*.1 p2_size(4)*.44 50 20]);

% Link5 max value
l5_max = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l22_limit(2),3),...
    'Position', [p2_size(3)*.7 p2_size(4)*.44 50 20]);

% Link6 min value
l6_min = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l23_limit(1),3),...
    'Position', [p2_size(3)*.1 p2_size(4)*.34 50 20]);

% Link6 max value
l6_max = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l23_limit(2),3),...
    'Position', [p2_size(3)*.7 p2_size(4)*.34 50 20]);

% Link7 min value
l7_min = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l31_limit(1),3),...
    'Position', [p2_size(3)*.1 p2_size(4)*.24 50 20]);

% Link7 max value
l7_max = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l31_limit(2),3),...
    'Position', [p2_size(3)*.7 p2_size(4)*.24 50 20]);

% Link8 min value
l8_min = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l32_limit(1),3),...
    'Position', [p2_size(3)*.1 p2_size(4)*.14 50 20]);

% Link8 max value
l8_max = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l32_limit(2),3),...
    'Position', [p2_size(3)*.7 p2_size(4)*.14 50 20]);

% Link9 min value
l9_min = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l33_limit(1),3),...
    'Position', [p2_size(3)*.1 p2_size(4)*.04 50 20]);

% Link9 max value
l9_max = uicontrol('parent', panel2,...
    'style', 'text',...
    'string', round(l33_limit(2),3),...
    'Position', [p2_size(3)*.7 p2_size(4)*.04 50 20]);

% Link labels (not used for anything)
l1_label = uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l1',...
    'Position', [0 p2_size(4)*.84 30 20]);

l2_label = uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l2',...
    'Position', [0 p2_size(4)*.74 30 20]);

l3_label = uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l3',...
    'Position', [0 p2_size(4)*.64 30 20]);

l4_label = uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l4',...
    'Position', [0 p2_size(4)*.54 30 20]);

l5_label = uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l5',...
    'Position', [0 p2_size(4)*.44 30 20]);

l6_label = uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l6',...
    'Position', [0 p2_size(4)*.34 30 20]);

l7_label = uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l7',...
    'Position', [0 p2_size(4)*.24 30 20]);

l8_label = uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l8',...
    'Position', [0 p2_size(4)*.14 30 20]);

l9_label = uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l9',...
    'Position', [0 p2_size(4)*.04 30 20]);

%% Fwd Kin Panel - Edit boxes
% editable fields for the controled actuators
l1_edit = uicontrol('parent', panel2,...
    'style', 'edit',...
    'string', l11_len,...
    'position', [p2_size(3)*.85 p2_size(4)*.85 35 20],...
    'callback', @e1_callback);

l2_edit = uicontrol('parent', panel2,...
    'style', 'edit',...
    'string', l12_len,...
    'position', [p2_size(3)*.85 p2_size(4)*.75 35 20],...
    'callback', @e2_callback);

l4_edit = uicontrol('parent', panel2,...
    'style', 'edit',...
    'string', l21_len,...
    'position', [p2_size(3)*.85 p2_size(4)*.55 35 20],...
    'callback', @e4_callback);

l5_edit = uicontrol('parent', panel2,...
    'style', 'edit',...
    'string', l22_len,...
    'position', [p2_size(3)*.85 p2_size(4)*.45 35 20],...
    'callback', @e5_callback);

l7_edit = uicontrol('parent', panel2,...
    'style', 'edit',...
    'string', l31_len,...
    'position', [p2_size(3)*.85 p2_size(4)*.25 35 20],...
    'callback', @e7_callback);

l8_edit = uicontrol('parent', panel2,...
    'style', 'edit',...
    'string', l32_len,...
    'position', [p2_size(3)*.85 p2_size(4)*.15 35 20],...
    'callback', @e8_callback);

%% Inv Kin Panel - Text
% x, y, z position on golbal frame
x_pos = uicontrol('parent', panel3,...
    'style', 'text',...
    'string', 'X:',...
    'fontweight', 'bold',...
    'fontsize', 12,...
    'Position', [p3_size(3)*.1 p3_size(4)*.5 30 20]);
 
y_pos = uicontrol('parent', panel3,...
    'style', 'text',...
    'string', 'Y:',...
    'fontweight', 'bold',...
    'fontsize', 12,...
    'Position', [p3_size(3)*.4 p3_size(4)*.5 30 20]);

z_pos = uicontrol('parent', panel3,...
    'style', 'text',...
    'string', 'Z:',...
    'fontweight', 'bold',...
    'fontsize', 12,...
    'Position', [p3_size(3)*.7 p3_size(4)*.5 30 20]);

% Direction (unit vector form)
xdir = uicontrol('parent', panel3,...
    'style', 'text',...
    'string', 'X:',...
    'fontweight', 'bold',...
    'fontsize', 12,...
    'Position', [p3_size(3)*.1 p3_size(4)*.1 30 20]);
ydir = uicontrol('parent', panel3,...
    'style', 'text',...
    'string', 'Y:',...
    'fontweight', 'bold',...
    'fontsize', 12,...
    'Position', [p3_size(3)*.4 p3_size(4)*.1 30 20]);
zdir = uicontrol('parent', panel3,...
    'style', 'text',...
    'string', 'Z:',...
    'fontweight', 'bold',...
    'fontsize', 12,...
    'Position', [p3_size(3)*.7 p3_size(4)*.1 30 20]);

% Labels
ee_pos = uicontrol('parent', panel3,...
    'style', 'text',...
    'string', 'EE pos',...
    'fontweight', 'bold',...
    'fontsize', 11,...
    'Position', [0 p3_size(4)*.7 100 20]);

ee_dir = uicontrol('parent', panel3,...
    'style', 'text',...
    'string', 'EE dir (unit vector)',...
    'fontweight', 'bold',...
    'fontsize', 11,...
    'Position', [0 p3_size(4)*.3 180 20]);

%% Inv Kin Panel - Edit boxes
% X, Y, Z editable fields
x_edit = uicontrol('parent', panel3,...
    'style', 'edit',...
    'string', 0,...
    'position', [p3_size(3)*.2 p3_size(4)*.5 35 20]);

y_edit = uicontrol('parent', panel3,...
    'style', 'edit',...
    'string', 0,...
    'position', [p3_size(3)*.5 p3_size(4)*.5 35 20]);

z_edit = uicontrol('parent', panel3,...
    'style', 'edit',...
    'string', 0,...
    'position', [p3_size(3)*.8 p3_size(4)*.5 35 20]);

%direction
% X, Y, Z
xdir_edit = uicontrol('parent', panel3,...
    'style', 'edit',...
    'string', 0,...
    'position', [p3_size(3)*.2 p3_size(4)*.1 35 20]);

ydir_edit = uicontrol('parent', panel3,...
    'style', 'edit',...
    'string', 0,...
    'position', [p3_size(3)*.5 p3_size(4)*.1 35 20]);

zdir_edit = uicontrol('parent', panel3,...
    'style', 'edit',...
    'string', 0,...
    'position', [p3_size(3)*.8 p3_size(4)*.1 35 20]);

%% Graphical display
graph = axes('title', 'a graph',...
    'units','pixels',...
    'position', [figsize(3)*.4 figsize(4)*.1 figsize(4)*.75 figsize(4)*.75]);
    
%% Options panel
l10_label = uicontrol('parent', panel1,...
    'style', 'text',...
    'string', 'l10:',...
    'fontweight', 'bold',...
    'fontsize', 10,...
    'Position', [p1_size(3)*.01 p1_size(4)*.3 25 17]);

l20_label = uicontrol('parent', panel1,...
    'style', 'text',...
    'string', 'l20:',...
    'fontweight', 'bold',...
    'fontsize', 10,...
    'Position', [p1_size(3)*.25 p1_size(4)*.3 25 17]);

l30_label = uicontrol('parent', panel1,...
    'style', 'text',...
    'string', 'l30:',...
    'fontweight', 'bold',...
    'fontsize', 10,...
    'Position', [p1_size(3)*.49 p1_size(4)*.3 25 17]);

l10_edit = uicontrol('parent', panel1,...
    'style', 'edit',...
    'string', l10_len,...
    'position', [p1_size(3)*.12 p1_size(4)*.3 25 17],...
    'callback', @l10_edit_callback);

l20_edit = uicontrol('parent', panel1,...
    'style', 'edit',...
    'string', l20_len,...
    'position', [p1_size(3)*.37 p1_size(4)*.3 25 17],...
    'callback', @l20_edit_callback);
    
l30_edit = uicontrol('parent', panel1,...
    'style', 'edit',...
    'string', l30_len,...
    'position', [p1_size(3)*.61 p1_size(4)*.3 25 17],...
    'callback', @l30_edit_callback);

pb1 = uicontrol('parent', panel1,...
    'style', 'pushbutton',...
    'fontweight', 'bold',...
    'fontsize', 10,...
    'string', 'Home',...
    'Position', [p1_size(3)*.75 p1_size(4)*.42 60 p1_size(4)*.3],...
    'callback', @home_callback);

pb2 = uicontrol('parent', panel1,...
    'style', 'pushbutton',...
    'fontweight', 'bold',...
    'fontsize', 10,...
    'string', 'Reset',...
    'Position', [p1_size(3)*.75 p1_size(4)*.1 60 p1_size(4)*.3],...
    'callback', @reset_callback);

%% Functions
%% Fwd Kin Panel Callback Functions
    % Slider callback functions
    function s1_callback(hObject, callbackdata)
        l11_len = get(hObject, 'Value');
        set(l1_edit, 'String', l11_len);
    end

    function s2_callback(hObject, callbackdata)
        l12_len = get(hObject, 'Value');
        set(l2_edit, 'String', l12_len);
    end

    function s4_callback(hObject, callbackdata)
        l21_len = get(hObject, 'Value');
        set(l4_edit, 'String', l21_len);
    end

    function s5_callback(hObject, callbackdata)
        l22_len = get(hObject, 'Value');
        set(l5_edit, 'String', l22_len);
    end

    function s7_callback(hObject, callbackdata)
        l31_len = get(hObject, 'Value');
        set(l7_edit, 'String', l31_len);
    end

    function s8_callback(hObject, callbackdata)
        l32_len = get(hObject, 'Value');
        set(l8_edit, 'String', l32_len);
    end
    
    % edit text callback
    function e1_callback(hObject, callbackdata)
        l11_len = str2double(get(hObject, 'String'));
        l11_len = valid_entry(l11_len, l11_limit, l11_temp, l1_edit);
        set(l1_slider, 'Value', l11_len);
        l11_temp = l11_len;
    end 

    function e2_callback(hObject, callbackdata)
        l12_len = str2double(get(hObject, 'String'));
        l12_len = valid_entry(l12_len, l12_limit, l12_temp, l2_edit);
        set(l2_slider, 'Value', l12_len);
        l12_temp = l12_len;
    end 

    function e4_callback(hObject, callbackdata)
        l21_len = str2double(get(hObject, 'String'));
        l21_len = valid_entry(l21_len, l21_limit, l21_temp, l4_edit);
        set(l4_slider, 'Value', l21_len);
        l21_temp = l21_len;
    end 

    function e5_callback(hObject, callbackdata)
        l22_len = str2double(get(hObject, 'String'));
        l22_len = valid_entry(l22_len, l22_limit, l22_temp, l5_edit);
        set(l5_slider, 'Value', l22_len);
        l22_temp = l22_len;
    end 

    function e7_callback(hObject, callbackdata)
        l31_len = str2double(get(hObject, 'String'));
        l31_len = valid_entry(l31_len, l31_limit, l31_temp, l7_edit);
        set(l7_slider, 'Value', l31_len);
        l31_temp = l31_len;
    end 

    function e8_callback(hObject, callbackdata)
        l32_len = str2double(get(hObject, 'String'));
        l32_len = valid_entry(l32_len, l32_limit, l32_temp, l8_edit);
        set(l8_slider, 'Value', l32_len);
        l32_temp = l32_len;
    end 

%% Options Panel Callback Functions
    function l10_edit_callback(hObject, callbackdata)
        l10_len = str2double(get(hObject, 'String'));
        l10_len = valid_link(l10_len, l10_edit);
        l11_limit = l11_limit / old_l10 * l10_len;
        l12_limit = l12_limit / old_l10 * l10_len;
        l13_limit = l13_limit / old_l10 * l10_len;
        l11_len = l11_len / old_l10 * l10_len;
        l12_len = l12_len / old_l10 * l10_len;
        %l13_len = l13_len * l10_len;
        update
    end

    function l20_edit_callback(hObject, callbackdata)
        l20_len = str2double(get(hObject, 'String'));
        l20_len = valid_link(l20_len, l20_edit);
        l21_limit = l21_limit / old_l20 * l20_len;
        l22_limit = l22_limit / old_l20 * l20_len;
        l23_limit = l23_limit / old_l20 * l20_len;
        l21_len = l21_len / old_l20 * l20_len;
        l22_len = l22_len / old_l20 * l20_len;
        update;
    end

    function l30_edit_callback(hObject, callbackdata)
        l30_len = str2double(get(hObject, 'String'));
        l30_len = valid_link(l30_len, l30_edit);
        l31_limit = l31_limit / old_l30 * l30_len;
        l32_limit = l32_limit / old_l30 * l30_len;
        l33_limit = l33_limit / old_l30 * l30_len;
        l31_len = l31_len / old_l30 * l30_len;
        l32_len = l32_len / old_l30 * l30_len;
        update;
    end

    function home_callback(hObject, callbackdata)
         home;
     end
 
    function reset_callback(hObject, callbackdata)
         reset;
    end

%% Inv Kin Panel Callback Functions
 
%% General Functions
    % Update all values and figures
    function update
        %set all values so they will be reflected in the GUI
        set(l1_edit, 'String', l11_len);
        set(l2_edit, 'String', l12_len);
        set(l4_edit, 'String', l21_len);
        set(l5_edit, 'String', l22_len);
        set(l7_edit, 'String', l31_len);
        set(l8_edit, 'String', l32_len);
        set(l1_slider, 'Min',  l11_limit(1), 'Max', l11_limit(2),...
            'Value', l11_len);
        set(l2_slider, 'Min',  l12_limit(1), 'Max', l12_limit(2),...
            'Value', l12_len);
        set(l4_slider, 'Min',  l21_limit(1), 'Max', l21_limit(2),...
            'Value', l21_len);
        set(l5_slider, 'Min',  l22_limit(1), 'Max', l22_limit(2),...
            'Value', l22_len);
        set(l7_slider, 'Min',  l31_limit(1), 'Max', l31_limit(2),...
            'Value', l31_len);
        set(l8_slider, 'Min',  l32_limit(1), 'Max', l32_limit(2),...
            'Value', l32_len);
        set(l1_min, 'String', round(l11_limit(1),3));
        set(l1_max, 'String', round(l11_limit(2),3));
        set(l2_min, 'String', round(l12_limit(1),3));
        set(l2_max, 'String', round(l12_limit(2),3));
        set(l3_min, 'String', round(l13_limit(1),3));
        set(l3_max, 'String', round(l13_limit(2),3));
        set(l4_min, 'String', round(l21_limit(1),3));
        set(l4_max, 'String', round(l21_limit(2),3));
        set(l5_min, 'String', round(l22_limit(1),3));
        set(l5_max, 'String', round(l22_limit(2),3));
        set(l6_min, 'String', round(l23_limit(1),3));
        set(l6_max, 'String', round(l23_limit(2),3));
        set(l7_min, 'String', round(l31_limit(1),3));
        set(l7_max, 'String', round(l31_limit(2),3));
        set(l8_min, 'String', round(l32_limit(1),3));
        set(l8_max, 'String', round(l32_limit(2),3));
        set(l9_min, 'String', round(l33_limit(1),3));
        set(l9_max, 'String', round(l33_limit(2),3));
        old_l10 = l10_len;
        old_l20 = l20_len;
        old_l30 = l30_len;
        refresh;
    end
    % Return to initial position (vertically straight)
    function home
        % reseting all lengths to initial position
        l11_len = l10_len/cosd(30); l12_len = l11_len; l13_len = l11_len;
        range1 = [2/3*l10_len/cosd(30), 4/3*l10_len/cosd(30)];
        l11_limit = range1;   % Min and Max of the acctuators
        l12_limit = range1;
        l13_limit = range1;
        
        l21_len = l20_len/cosd(30); l22_len = l21_len; l23_len = l21_len; 
        range2 = [2/3*l20_len/cosd(30), 4/3*l20_len/cosd(30)];
        l21_limit = range2;   % Min and Max of the acctuators
        l22_limit = range2;
        l23_limit = range2;
        
        l31_len = l30_len/cosd(30); l32_len = l31_len; l33_len = l31_len; 
        range3 = [2/3*l30_len/cosd(30), 4/3*l30_len/cosd(30)];
        l31_limit = range3;   % Min and Max of the acctuators
        l32_limit = range3;
        l33_limit = range3;
        update;
    end
    % Retrun to initial position with initial values
    function reset
        % Set the links to default link lengths before returning to home
        % position
        l10_len = 1;
        l20_len = 1;
        l30_len = 1;
        set(l10_edit, 'String', l10_len);
        set(l20_edit, 'String', l20_len);
        set(l30_edit, 'String', l30_len);
        home;
    end
    % Checks if fwd kin input is valid and corrects it if not
    function value = valid_entry(entered, limit, default, editbox)
        if isnan(entered) % not a number
            errordlg('Enter a numeric value.')
            value = default;
        else
            if entered > limit(2)
                errordlg('Entry to large, defaulting to max')
                value = limit(2);
            elseif entered < limit(1)
                errordlg('Entry to small, defaulting to min')
                value = limit(1);
            else
                value =  entered;
            end;
 
        end
        set(editbox, 'String', value);
    end
    % Checks if link 0 (center link) inputs are valid
    function value = valid_link(entered, editbox)
        default_length = 1;
        if isnan(entered) % not a number
           errordlg('Enter a numeric value, defaulting to 1.')
           value = default_length;
        elseif entered < 0
            errordlg('Entry must me positive, defaulting to 1')
            value = default_length;
        else
            value = entered
        end
        set(editbox, 'String', value);
    end

end