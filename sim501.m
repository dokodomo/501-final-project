function sim501
% Clear everything
clc
clear
close all

% Set initial values
xpos = 0.0; ypos = 0.0; zpos = 3.0;
old_x = xpos; old_y = ypos; old_z = zpos;
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

% Link labels
% link 1 label
uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l1',...
    'Position', [0 p2_size(4)*.84 30 20]);
% link 2 label
uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l2',...
    'Position', [0 p2_size(4)*.74 30 20]);
% link 3 label
uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l3',...
    'Position', [0 p2_size(4)*.64 30 20]);
% link 4 label
uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l4',...
    'Position', [0 p2_size(4)*.54 30 20]);
% link 5 label
uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l5',...
    'Position', [0 p2_size(4)*.44 30 20]);
% link 6 label
uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l6',...
    'Position', [0 p2_size(4)*.34 30 20]);
% link 7 label
uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l7',...
    'Position', [0 p2_size(4)*.24 30 20]);
% link 8 label
uicontrol('parent', panel2,...
    'style', 'text',...
    'fontweight', 'bold',...
    'string', 'l8',...
    'Position', [0 p2_size(4)*.14 30 20]);
% link 9 label
uicontrol('parent', panel2,...
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
% x pos label
uicontrol('parent', panel3,...
    'style', 'text',...
    'string', 'X:',...
    'fontweight', 'bold',...
    'fontsize', 12,...
    'Position', [p3_size(3)*.1 p3_size(4)*.5 30 20]);
% y pos label 
uicontrol('parent', panel3,...
    'style', 'text',...
    'string', 'Y:',...
    'fontweight', 'bold',...
    'fontsize', 12,...
    'Position', [p3_size(3)*.4 p3_size(4)*.5 30 20]);
% z pos label
uicontrol('parent', panel3,...
    'style', 'text',...
    'string', 'Z:',...
    'fontweight', 'bold',...
    'fontsize', 12,...
    'Position', [p3_size(3)*.7 p3_size(4)*.5 30 20]);

pb_start = uicontrol('parent', panel3,...
    'style', 'pushbutton',...
    'fontweight', 'bold',...
    'fontsize', 10,...
    'string', 'Start',...
    'Position', [p3_size(3)*.30 p3_size(4)*0.1 120 p3_size(4)*.3],...
    'callback', @start_callback);
% Direction (unit vector form)
% x dir label
% uicontrol('parent', panel3,...
%     'style', 'text',...
%     'string', 'X:',...
%     'fontweight', 'bold',...
%     'fontsize', 12,...
%     'Position', [p3_size(3)*.1 p3_size(4)*.1 30 20]);
% % y dir label
% uicontrol('parent', panel3,...
%     'style', 'text',...
%     'string', 'Y:',...
%     'fontweight', 'bold',...
%     'fontsize', 12,...
%     'Position', [p3_size(3)*.4 p3_size(4)*.1 30 20]);
% % z dir label
% uicontrol('parent', panel3,...
%     'style', 'text',...
%     'string', 'Z:',...
%     'fontweight', 'bold',...
%     'fontsize', 12,...
%     'Position', [p3_size(3)*.7 p3_size(4)*.1 30 20]);
% EE pos label
uicontrol('parent', panel3,...
    'style', 'text',...
    'string', 'EE pos',...
    'fontweight', 'bold',...
    'fontsize', 11,...
    'Position', [0 p3_size(4)*.7 100 20]);
% EE dir label
% uicontrol('parent', panel3,...
%     'style', 'text',...
%     'string', 'EE dir (unit vector)',...
%     'fontweight', 'bold',...
%     'fontsize', 11,...
%     'Position', [0 p3_size(4)*.3 180 20]);

%% Inv Kin Panel - Edit boxes
% X, Y, Z position editable fields
x_edit = uicontrol('parent', panel3,...
    'style', 'edit',...
    'string', xpos,...
    'position', [p3_size(3)*.2 p3_size(4)*.5 35 20],...
    'callback', @xpos_callback);

y_edit = uicontrol('parent', panel3,...
    'style', 'edit',...
    'string', ypos,...
    'position', [p3_size(3)*.5 p3_size(4)*.5 35 20],...
    'callback', @ypos_callback);

z_edit = uicontrol('parent', panel3,...
    'style', 'edit',...
    'string', zpos,...
    'position', [p3_size(3)*.8 p3_size(4)*.5 35 20],...
    'callback', @zpos_callback);

%direction
% X, Y, Z
% xdir_edit = uicontrol('parent', panel3,...
%     'style', 'edit',...
%     'string', 0,...
%     'position', [p3_size(3)*.2 p3_size(4)*.1 35 20],...
%     'callback', @xdir_callback);
% 
% ydir_edit = uicontrol('parent', panel3,...
%     'style', 'edit',...
%     'string', 0,...
%     'position', [p3_size(3)*.5 p3_size(4)*.1 35 20],...
%     'callback', @ydir_callback);
% 
% zdir_edit = uicontrol('parent', panel3,...
%     'style', 'edit',...
%     'string', 0,...
%     'position', [p3_size(3)*.8 p3_size(4)*.1 35 20],...
%     'callback', @zdir_callback);

%% Graphical display
agraph = axes('title', 'a graph',...
    'units','pixels',...
    'position', [figsize(3)*.45 figsize(4)*.2 figsize(4)*.65 figsize(4)*.65]);
    
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
% Plot something after everything is generated
FK;

%% Functions
%% Fwd Kin Panel Callback Functions
    % Slider callback functions
    function s1_callback(hObject, callbackdata)
        l11_len = get(hObject, 'Value');
        set(l1_edit, 'String', l11_len);
        FK;
        l11_temp = l11_len;
        update;
    end

    function s2_callback(hObject, callbackdata)
        l12_len = get(hObject, 'Value');
        set(l2_edit, 'String', l12_len);
        FK;
        l12_temp = l12_len;
        update;
    end

    function s4_callback(hObject, callbackdata)
        l21_len = get(hObject, 'Value');
        set(l4_edit, 'String', l21_len);
        FK;
        l21_temp = l21_len;
        update;
    end

    function s5_callback(hObject, callbackdata)
        l22_len = get(hObject, 'Value');
        set(l5_edit, 'String', l22_len);
        FK;
        l22_temp = l22_len;
        update;
    end

    function s7_callback(hObject, callbackdata)
        l31_len = get(hObject, 'Value');
        set(l7_edit, 'String', l31_len);
        FK;
        l31_temp = l31_len;
        update;
    end

    function s8_callback(hObject, callbackdata)
        l32_len = get(hObject, 'Value');
        set(l8_edit, 'String', l32_len);
        FK;
        l32_temp = l32_len;
        update;
    end
    
    % edit text callback
    function e1_callback(hObject, callbackdata)
        l11_len = str2double(get(hObject, 'String'));
        l11_len = valid_entry(l11_len, l11_limit, l11_temp, l1_edit);
        set(l1_slider, 'Value', l11_len);
        FK_over_time(1, l11_len, l11_temp);
        l11_temp = l11_len;
        update;
    end 

    function e2_callback(hObject, callbackdata)
        l12_len = str2double(get(hObject, 'String'));
        l12_len = valid_entry(l12_len, l12_limit, l12_temp, l2_edit);
        set(l2_slider, 'Value', l12_len);
        FK_over_time(2, l12_len, l12_temp);
        l12_temp = l12_len;
        update;
    end 

    function e4_callback(hObject, callbackdata)
        l21_len = str2double(get(hObject, 'String'));
        l21_len = valid_entry(l21_len, l21_limit, l21_temp, l4_edit);
        set(l4_slider, 'Value', l21_len);
        FK_over_time(4, l21_len, l21_temp);
        l21_temp = l21_len;
        update;
    end 

    function e5_callback(hObject, callbackdata)
        l22_len = str2double(get(hObject, 'String'));
        l22_len = valid_entry(l22_len, l22_limit, l22_temp, l5_edit);
        set(l5_slider, 'Value', l22_len);
        FK_over_time(5, l22_len, l22_temp);
        l22_temp = l22_len;
        update;
    end 

    function e7_callback(hObject, callbackdata)
        l31_len = str2double(get(hObject, 'String'));
        l31_len = valid_entry(l31_len, l31_limit, l31_temp, l7_edit);
        set(l7_slider, 'Value', l31_len);
        FK_over_time(7, l31_len, l31_temp);
        l31_temp = l31_len;
        update;
    end 

    function e8_callback(hObject, callbackdata)
        l32_len = str2double(get(hObject, 'String'));
        l32_len = valid_entry(l32_len, l32_limit, l32_temp, l8_edit);
        set(l8_slider, 'Value', l32_len);
        FK_over_time(8, l32_len, l32_temp);
        l32_temp = l32_len;
        update;
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
        FK;
        update;
    end

    function l20_edit_callback(hObject, callbackdata)
        l20_len = str2double(get(hObject, 'String'));
        l20_len = valid_link(l20_len, l20_edit);
        l21_limit = l21_limit / old_l20 * l20_len;
        l22_limit = l22_limit / old_l20 * l20_len;
        l23_limit = l23_limit / old_l20 * l20_len;
        l21_len = l21_len / old_l20 * l20_len;
        l22_len = l22_len / old_l20 * l20_len;
        FK;
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
        FK;
        update;
    end

    function home_callback(hObject, callbackdata)
         home;
         FK;
     end
 
    function reset_callback(hObject, callbackdata)
         reset;
         FK;
    end

%% Inv Kin Panel Callback Functions
    function xpos_callback(hObject, callbackdata)
        xpos = str2double(get(hObject, 'String'));
    end
    function ypos_callback(hObject, callbackdata)
        ypos = str2double(get(hObject, 'String'));
    end
    function zpos_callback(hObject, callbackdata)
        zpos = str2double(get(hObject, 'String'));
    end
    function start_callback(hObject, callbackdata)
        %IK([xpos, ypos, zpos], [0,pi/3,-pi/6]);
        N = 40;
        IK([2.5:3.5/N:6, -2, 6], [0,pi/3,-pi/6]);
        old_x = xpos;
        old_y = ypos;
        old_z = zpos;
    end
%     function xdir_callback(hObject, callbackdata)
%     end
%     function ydir_callback(hObject, callbackdata)
%     end
%     function zdir_callback(hObject, callbackdata)
%     end
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
        set(z_edit, 'string', zpos);
        if zpos == l10_len + l20_len + l30_len
            xpos = 0
            ypos = 0
        end
        set(x_edit, 'string', xpos);
        set(y_edit, 'string', ypos);
        old_l10 = l10_len; old_l20 = l20_len; old_l30 = l30_len;
        old_x = xpos; old_y = ypos; old_z = zpos;
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
        
        xpos = 0; ypos = 0; zpos = l10_len + l20_len + l30_len;
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
            %errordlg('Enter a numeric value.')
            value = default;
        else
            if entered > limit(2)
                %errordlg('Entry to large, defaulting to max')
                value = limit(2);
            elseif entered < limit(1)
                %errordlg('Entry to small, defaulting to min')
                value = round(limit(1),3);
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
            value = entered;
        end
        set(editbox, 'String', value);
    end

    % Forward Kinematic Function
    function FK
        cla
    %% Defining parameters
        l01 = l10_len;             % L0-from the base of the frame to the tip
        l02 = l20_len;             % L0-from the base of the frame to the tip
        l03 = l30_len;             % L0-from the base of the frame to the tip
        l_11_0 = l01/cosd(30);  % L1- when the L1=L2=L3
        l_12_0 = l02/cosd(30);  % L2- when the L1=L2=L3
        l_13_0 = l03/cosd(30);  % L3- when the L1=L2=L3
        a1 = l_11_0*sind(30);   % the distance from the base of the actuator to base
        a2 = l_12_0*sind(30);
        a3 = l_13_0*sind(30);
        
        %% Plotting the base of the parallel manipulator
        line([a1 -a1*cosd(60) -a1*cosd(60) a1],[0 -a1*sind(60) a1*sind(60) 0],[0 0 0 0],...
            'Color',[0 0 1], 'LineWidth', 2, 'parent', agraph);

        %% Forward Position Kinematics 
        x1=(l10_len^2+a1^2-l11_len^2)/(2*a1);        
        y1=(-l12_len^2+l10_len^2+a1^2+2*a1*cosd(60)*x1)/(2*a1*sind(60));
        z1=abs((l10_len^2-x1^2-y1^2)^0.5);

        x2=(l20_len^2+a2^2-l21_len^2)/(2*a2);        
        y2=(-l22_len^2+l20_len^2+a2^2+2*a2*cosd(60)*x2)/(2*a2*sind(60));
        z2=abs((l20_len^2-x2^2-y2^2)^0.5);

        x3=(l30_len^2+a3^2-l31_len^2)/(2*a3);        
        y3=(-l32_len^2+l30_len^2+a3^2+2*a3*cosd(60)*x3)/(2*a3*sind(60));
        z3=abs((l30_len^2-x3^2-y3^2)^0.5);

        theta_z_1=atan2(y1,x1);
        theta_y_1=atan2((x1^2+y1^2)^1/2,z1);
        theta_z_2=atan2(y2,x2);
        theta_y_2=atan2((x2^2+y2^2)^1/2,z2);
        theta_z_3=atan2(y3,x3);
        theta_y_3=atan2((x3^2+y3^2)^1/2,z3);
        T_01=[cos(theta_z_1)*cos(theta_y_1) -sin(theta_z_1) cos(theta_z_1)*sin(theta_y_1) x1;
            sin(theta_z_1)*cos(theta_y_1) cos(theta_z_1) sin(theta_z_1)*sin(theta_y_1) y1;
            -sin(theta_y_1) 0 cos(theta_y_1) z1;
            0 0 0 1];
        T_12=[cos(theta_z_2)*cos(theta_y_2) -sin(theta_z_2) cos(theta_z_2)*sin(theta_y_2) x2;
            sin(theta_z_2)*cos(theta_y_2) cos(theta_z_2) sin(theta_z_2)*sin(theta_y_2) y2;
            -sin(theta_y_2) 0 cos(theta_y_2) z2;
            0 0 0 1];
        T_23=[cos(theta_z_3)*cos(theta_y_3) -sin(theta_z_3) cos(theta_z_3)*sin(theta_y_3) x3;
            sin(theta_z_3)*cos(theta_y_3) cos(theta_z_3) sin(theta_z_3)*sin(theta_y_3) y3;
            -sin(theta_y_3) 0 cos(theta_y_3) z3;
            0 0 0 1];
        T_02=T_01*T_12;
        T_03=T_01*T_12*T_23;

        tri1_1=T_01*[a2 0 0 1]';
        tri1_2=T_01*[-a2*cosd(60) a2*sind(60) 0 1]';
        tri1_3=T_01*[-a2*cosd(60) -a2*sind(60) 0 1]';

        tri2_1=T_02*[a3 0 0 1]';
        tri2_2=T_02*[-a3*cosd(60) a3*sind(60) 0 1]';
        tri2_3=T_02*[-a3*cosd(60) -a3*sind(60) 0 1]';
        %% Confirming that L0 is not out of bounds
        q=abs((x1^2+y1^2+z1^2)^0.5);

        if q < l01+0.1
            %% Plotting the manipulator
            L1=line([a1 x1],[0 y1],[0 z1],'Color',[0 1 0],'LineWidth', 3, 'parent', agraph);
            L2=line([-a1*cosd(60) x1],[a1*sind(60) y1],[0 z1],'Color',[1 0 0],'LineWidth', 3, 'parent', agraph);
            L3=line([-a1*cosd(60) x1],[-a1*sind(60) y1],[0 z1],'LineWidth', 3, 'parent', agraph);
            L4=line([0 x1],[0 y1],[0 z1], 'parent', agraph);
            L5=line([T_01(1,4) T_02(1,4)],[T_01(2,4) T_02(2,4)],[T_01(3,4) T_02(3,4)], 'parent', agraph);
            L6=line([T_02(1,4) T_03(1,4)],[T_02(2,4) T_03(2,4)],[T_02(3,4) T_03(3,4)], 'parent', agraph);
            L7=line([tri1_1(1) tri1_2(1) tri1_3(1) tri1_1(1)],[tri1_1(2)...
                tri1_2(2) tri1_3(2) tri1_1(2)],[tri1_1(3) tri1_2(3) tri1_3(3)...
                tri1_1(3)], 'Color',[0 0 1], 'LineWidth', 2, 'parent', agraph);
            L8=line([tri2_1(1) tri2_2(1) tri2_3(1) tri2_1(1)],[tri2_1(2)...
                tri2_2(2) tri2_3(2) tri2_1(2)],[tri2_1(3) tri2_2(3) tri2_3(3)...
                tri2_1(3)], 'Color',[0 0 1], 'LineWidth', 2, 'parent', agraph);
            L9=line([tri1_1(1) T_02(1,4) ],[tri1_1(2) T_02(2,4)],[tri1_1(3) T_02(3,4)],'Color',[0 1 0],'LineWidth', 3, 'parent', agraph);
            L10=line([tri1_2(1) T_02(1,4) ],[tri1_2(2) T_02(2,4)],[tri1_2(3) T_02(3,4)],'Color',[1 0 0],'LineWidth', 3, 'parent', agraph);
            L11=line([tri1_3(1) T_02(1,4) ],[tri1_3(2) T_02(2,4)],[tri1_3(3) T_02(3,4)],'LineWidth', 3, 'parent', agraph);
            L12=line([tri2_1(1) T_03(1,4)],[tri2_1(2) T_03(2,4)],[tri2_1(3) T_03(3,4)],'Color',[0 1 0],'LineWidth', 3, 'parent', agraph);
            L13=line([tri2_2(1) T_03(1,4)],[tri2_2(2) T_03(2,4)],[tri2_2(3) T_03(3,4)],'Color',[1 0 0],'LineWidth', 3, 'parent', agraph);
            L14=line([tri2_3(1) T_03(1,4)],[tri2_3(2) T_03(2,4)],[tri2_3(3) T_03(3,4)],'LineWidth', 3, 'parent', agraph);

        end
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        grid('on')
        axis([-2.5 2.5 -2.5 2.5 0 5])
        %axis vis3d
        az = 15;
        el = 15;
        view(az, el);
        xpos = T_03(1,4); ypos = T_03(2,4); zpos = T_03(3,4);
    end
    % preforms FK over a period of time, used for  when input is not the 
    % next adjacent value (in the edit fields), index is the links number 
    % so no 3, 6 or 9. There has to be a nicer way of doing this ._.
    function FK_over_time(index, input, old_input)
        res = 0.01;
        if input < old_input
            res = -res;
        end
        switch index
            case 1
                temp = l11_len;       
                for l11_len = l11_temp:res:temp
                    FK;
                    pause(0.1);
                end
            case 2
                temp = l12_len;
                for l12_len = l12_temp:0.01:temp
                    FK;
                    pause(0.1);
                end
            case 4
                temp = l21_len;
                for l21_len = l21_temp:0.01:temp
                    FK;
                    pause(0.1);
                end
            case 5
                temp = l22_len;
                for l22_len = l22_temp:0.01:temp
                    FK;
                    pause(0.1);
                end
            case 7
                temp = l31_len;
                for l31_len = l31_temp:0.01:temp
                    FK;
                    pause(0.1);
                end
            case 8
                temp = l32_len;
                for l32_len = l32_temp:0.01:temp
                    FK;
                    pause(0.1);
                end
        end

    end

    % Inverse Kinematic Function
    function [ P1,P2 ] = fun_tri_IK( P3,Phi3,L0 )
        %FUN_TRI_IK Summary of this function goes here
        %   Detailed explanation goes here
        x3=P3(1);y3=P3(2);z3=P3(3);
        tx=Phi3(1);ty=Phi3(2);tz=Phi3(3);
        eps=1e-6;

        %% solve P2
        Rz=[cos(tz) -sin(tz) 0;
            sin(tz) cos(tz) 0;
            0 0 1;];

        Ry=[cos(ty) 0 sin(ty);
            0 1 0;
            -sin(ty) 0 cos(ty);];

        Rx=[1 0 0;
            0 cos(tx) -sin(tx);
            0 sin(tx) cos(tx);];

        R03=Rz*Ry*Rx;

        T=[R03,[x3,y3,z3].';0 0 0 1];

        P2=T*[0,0,-L0,1].';
        P2=P2(1:3);
        x2=P2(1);y2=P2(2);z2=P2(3);

        %% solve P1
        x1=(x2*y2^2 + x2*z2^2 + x2^3 - 2*x2*z2*(z2/2 + (-((x2^2 + y2^2)*(- 4*L0^2 + x2^2 + y2^2 + z2^2))/(x2^2 + y2^2 + z2^2+eps))^(1/2)/2))/(2*x2^2 + 2*y2^2+eps);
        y1=(x2^2*y2 + y2*z2^2 + y2^3 - 2*y2*z2*(z2/2 + (-((x2^2 + y2^2)*(- 4*L0^2 + x2^2 + y2^2 + z2^2))/(x2^2 + y2^2 + z2^2+eps))^(1/2)/2))/(2*x2^2 + 2*y2^2+eps);
        z1=z2/2 + (-((x2^2 + y2^2)*(- 4*L0^2 + x2^2 + y2^2 + z2^2))/(x2^2 + y2^2 + z2^2+eps))^(1/2)/2;
      
        P1=[x1;y1;z1];

    end
    % Plots the InvKin
    function IK(Pos, Ang)
        cla
        %xe = old_x:0.1:Pos(1); ye = Pos(2); ze = Pos(3);
        xe = Pos(1); ye = Pos(2); ze = Pos(3);
        tx = Ang(1); ty = Ang(2); tz = Ang(3);
        L0 = 3;
        T=@(theta,phi) [ cos(phi)*cos(theta), -sin(theta), cos(theta)*sin(phi), L0*cos(theta)*sin(phi)
        cos(phi)*sin(theta),  cos(theta), sin(phi)*sin(theta), L0*sin(phi)*sin(theta)
            -sin(phi),            0,             cos(phi),             L0*cos(phi)
                     0,            0,                     0,              1          ];
        for i=1:length(xe)
            P3=[xe(i);ye;ze];
            Phi3=[tx;ty;tz];
            [P1,P2]=fun_tri_IK(P3,Phi3,L0);

            tz1=atan(P1(2)/P1(1));
            ty1=atan(P1(1)/P1(3)/cos(tz1));

            T1=T(tz1,ty1);

            R1=T1(1:3,1:3);
            PP2=R1.'*(P2-P1);
            tz2=atan(PP2(2)/PP2(1));
            ty2=atan(PP2(1)/cos(tz2)/PP2(3));

            T2=T1*T(tz2,ty2);

          % draw the base triangle   
            a=1;
            A=[a,0,0]';
            B=[a*cosd(120),a*sind(120),0]';
            C=[a*cosd(240),a*sind(240),0]';

            A2=T1*[A;1];A2=A2(1:3);
            B2=T1*[B;1];B2=B2(1:3);
            C2=T1*[C;1];C2=C2(1:3);

            A3=T2*[A;1];A3=A3(1:3);
            B3=T2*[B;1];B3=B3(1:3);
            C3=T2*[C;1];C3=C3(1:3); 

            xa=A(1);ya=A(2);za=A(3);
            xb=B(1);yb=B(2);zb=B(3);
            xc=C(1);yc=C(2);zc=C(3);

            x2a=A2(1);y2a=A2(2);z2a=A2(3);
            x2b=B2(1);y2b=B2(2);z2b=B2(3);
            x2c=C2(1);y2c=C2(2);z2c=C2(3);

            x3a=A3(1);y3a=A3(2);z3a=A3(3);
            x3b=B3(1);y3b=B3(2);z3b=B3(3);
            x3c=C3(1);y3c=C3(2);z3c=C3(3);

            hold off
                line([xa,xa;xb,xc],[ya,ya;yb,yc],[za,za;zb,zc])
            hold on
                line([x2a,x2a;x2b,x2c],[y2a,y2a;y2b,y2c],[z2a,z2a;z2b,z2c])
                line([x3a,x3a;x3b,x3c],[y3a,y3a;y3b,y3c],[z3a,z3a;z3b,z3c])

            %draw link L1,L2,L3    
            plot3([xa,P1(1)],[ya,P1(2)],[za,P1(3)],'b-','linewidth',3);    
            plot3([xb,P1(1)],[yb,P1(2)],[zb,P1(3)],'b-','linewidth',3);
            plot3([xc,P1(1)],[yc,P1(2)],[zc,P1(3)],'b-','linewidth',3);

            plot3([x2a,P2(1)],[y2a,P2(2)],[z2a,P2(3)],'b-','linewidth',3);    
            plot3([x2b,P2(1)],[y2b,P2(2)],[z2b,P2(3)],'b-','linewidth',3);
            plot3([x2c,P2(1)],[y2c,P2(2)],[z2c,P2(3)],'b-','linewidth',3);    

            plot3([x3a,P3(1)],[y3a,P3(2)],[z3a,P3(3)],'b-','linewidth',3);    
            plot3([x3b,P3(1)],[y3b,P3(2)],[z3b,P3(3)],'b-','linewidth',3);
            plot3([x3c,P3(1)],[y3c,P3(2)],[z3c,P3(3)],'b-','linewidth',3);    
            %draw link L0
            plot3([0,P1(1),P2(1),P3(1)],[0,P1(2),P2(2),P3(2)],[0,P1(3),P2(3),P3(3)],'r-*','linewidth',3);

            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            grid('on')
            axis([-2.5 2.5 -2.5 2.5 0 5])
            %axis vis3d
            az = 15;
            el = 15;
            view(az, el);
            pause(0.1)
        end
    end
end