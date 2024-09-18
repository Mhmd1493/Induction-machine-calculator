classdef project_machines_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        DrawButton                   matlab.ui.control.Button
        InputsPanel                  matlab.ui.container.Panel
        MotorconnectionButtonGroup   matlab.ui.container.ButtonGroup
        StarButton                   matlab.ui.control.RadioButton
        DeltaButton                  matlab.ui.control.RadioButton
        X0EditField                  matlab.ui.control.NumericEditField
        X0EditFieldLabel             matlab.ui.control.Label
        R0EditField                  matlab.ui.control.NumericEditField
        R0EditFieldLabel             matlab.ui.control.Label
        VLineEditField               matlab.ui.control.NumericEditField
        VLineEditFieldLabel          matlab.ui.control.Label
        X1EditField                  matlab.ui.control.NumericEditField
        X1EditFieldLabel             matlab.ui.control.Label
        startingmethodDropDown       matlab.ui.control.DropDown
        startingmethodDropDownLabel  matlab.ui.control.Label
        X2EditField                  matlab.ui.control.NumericEditField
        X2Label                      matlab.ui.control.Label
        EditField2_3                 matlab.ui.control.NumericEditField
        R2EditField                  matlab.ui.control.NumericEditField
        R2Label                      matlab.ui.control.Label
        R1EditField                  matlab.ui.control.NumericEditField
        R1EditFieldLabel             matlab.ui.control.Label
        NoofpolesEditField           matlab.ui.control.NumericEditField
        NoofpolesEditFieldLabel      matlab.ui.control.Label
        nratedEditField2_6           matlab.ui.control.NumericEditField
        nratedLabel                  matlab.ui.control.Label
        EditField2_5                 matlab.ui.control.NumericEditField
        FratedEditField              matlab.ui.control.NumericEditField
        FratedEditFieldLabel         matlab.ui.control.Label
        UIAxes2                      matlab.ui.control.UIAxes
        UIAxes                       matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: DrawButton
        function DrawButtonPushed(app, event)
            %inserting the parameters in the code 
           f_rated = app.FratedEditField.Value;
           Vph=app.VLineEditField.Value;
           
           R1=app.R1EditField.Value;
           R2=app.R2EditField.Value;
           X2=app.X2EditField.Value;
           X1=app.X1EditField.Value;
           R0=app.R0EditField.Value;
           X0=app.X0EditField.Value;
           n=app.nratedEditField2_6.Value;
           no_of_poles=app.NoofpolesEditField.Value;
           starting_method=app.startingmethodDropDown.Value;
           i=1;
          ns=60 *f_rated/(no_of_poles*.5);
          s=linspace(1,(ns-n)/ns,10000); speed=linspace(0,n,10000);
        
 switch app.startingmethodDropDown.Value
     case 'DOL' 
         if  app.StarButton.Value==1
                  Vph=Vph/sqrt(3);
         end
 
              for i=1:1:length(s)
               Td(i)=(3*Vph^2*(R2/s(i)))/((2*pi/60)*(60 *f_rated/(no_of_poles*.5)*((R1+(R2/s(i)))^2+(X1+X2)^2)));
              if app.DeltaButton.Value==1
               Irms(i)=sqrt(3)*abs((Vph/(complex((R1+R2/s(i)),(X1+X2))))+(Vph/((R0*(complex(0,X0)))/(R0+(complex(0,X0))))));
              else
                  Irms(i)=abs((Vph/(complex((R1+R2/s(i)),(X1+X2))))+(Vph/((R0*(complex(0,X0)))/(R0+(complex(0,X0))))));
              end
                             
              end 
              plot(app.UIAxes,speed,Td)
              plot(app.UIAxes2,speed,Irms,'r')
     case 'S/D'
     Z_eq=(complex((R1+R2/s(i)),(X1+X2))+((R0*(complex(0,X0)))/(R0+(complex(0,X0)))));
     transformation_speed=.7*n;   Vph_star=Vph/sqrt(3);
     for i=1:1:length(s)
         if speed(i)<transformation_speed
          
             Td(i)=(3*Vph_star^2*(R2/s(i)))/((2*pi/60)*(60 *f_rated/(no_of_poles*.5)*((R1+(R2/s(i)))^2+(X1+X2)^2)));
             Irms(i)=abs((Vph_star/(complex((R1+R2/s(i)),(X1+X2))))+(Vph_star/((R0*(complex(0,X0)))/(R0+(complex(0,X0))))));
         else
             Td(i)=(3*Vph^2*(R2/s(i)))/((2*pi/60)*(60 *f_rated/(no_of_poles*.5)*((R1+(R2/s(i)))^2+(X1+X2)^2)));
             Irms(i)=sqrt(3)*abs((Vph/(complex((R1+R2/s(i)),(X1+X2))))+(Vph/((R0*(complex(0,X0)))/(R0+(complex(0,X0))))));
         end
     end
              plot(app.UIAxes,speed,Td)
              plot(app.UIAxes2,speed,Irms,'r')
     case 'AT'
         if  app.StarButton.Value==1
                  Vph=Vph/sqrt(3);
         end
         tap1=.4; tap2=.6; tap3=.8;
         for i=1:1:length(s)
               
         if speed(i)<.3*n
             Td(i)=.4^2*(3*Vph^2*(R2/s(i)))/((2*pi/60)*(60 *f_rated/(no_of_poles*.5)*((R1+(R2/s(i)))^2+(X1+X2)^2)));
            if app.DeltaButton.Value==1
               Irms(i)=.4^2*sqrt(3)*abs((Vph/(complex((R1+R2/s(i)),(X1+X2))))+(Vph/((R0*(complex(0,X0)))/(R0+(complex(0,X0))))));
              else
                  Irms(i)=.4^2*abs((Vph/(complex((R1+R2/s(i)),(X1+X2))))+(Vph/((R0*(complex(0,X0)))/(R0+(complex(0,X0))))));
            end
         elseif speed(i)<.5*n
             Td(i)=.6^2*(3*Vph^2*(R2/s(i)))/((2*pi/60)*(60 *f_rated/(no_of_poles*.5)*((R1+(R2/s(i)))^2+(X1+X2)^2)));
            if app.DeltaButton.Value==1
               Irms(i)=.6^2*sqrt(3)*abs((Vph/(complex((R1+R2/s(i)),(X1+X2))))+(Vph/((R0*(complex(0,X0)))/(R0+(complex(0,X0))))));
              else
                  Irms(i)=.6^2*abs((Vph/(complex((R1+R2/s(i)),(X1+X2))))+(Vph/((R0*(complex(0,X0)))/(R0+(complex(0,X0))))));
            end
         elseif speed(i)<.8*n
                Td(i)=.8^2*(3*Vph^2*(R2/s(i)))/((2*pi/60)*(60 *f_rated/(no_of_poles*.5)*((R1+(R2/s(i)))^2+(X1+X2)^2)));
            if app.DeltaButton.Value==1
               Irms(i)=.8^2*sqrt(3)*abs((Vph/(complex((R1+R2/s(i)),(X1+X2))))+(Vph/((R0*(complex(0,X0)))/(R0+(complex(0,X0))))));
              else
                  Irms(i)=.8^2*abs((Vph/(complex((R1+R2/s(i)),(X1+X2))))+(Vph/((R0*(complex(0,X0)))/(R0+(complex(0,X0))))));
            end
         else 
               Td(i)=(3*Vph^2*(R2/s(i)))/((2*pi/60)*(60 *f_rated/(no_of_poles*.5)*((R1+(R2/s(i)))^2+(X1+X2)^2)));
            if app.DeltaButton.Value==1
               Irms(i)=sqrt(3)*abs((Vph/(complex((R1+R2/s(i)),(X1+X2))))+(Vph/((R0*(complex(0,X0)))/(R0+(complex(0,X0))))));
              else
                  Irms(i)=abs((Vph/(complex((R1+R2/s(i)),(X1+X2))))+(Vph/((R0*(complex(0,X0)))/(R0+(complex(0,X0))))));
            end
         end
         
         end
         
              plot(app.UIAxes,speed,Td)
              plot(app.UIAxes2,speed,Irms,'r')
         
       
 end
             
               
       
        end

        % Callback function: startingmethodDropDown, 
        % startingmethodDropDown
        function startingmethodDropDownValueChanged(app, event)
    connection=app.startingmethodDropDown.Value;
    switch connection
        case 'S/D'
            app.MotorconnectionButtonGroup.Enable='off';
        otherwise
             app.MotorconnectionButtonGroup.Enable='on';
    end
        end

        % Selection changed function: MotorconnectionButtonGroup
        function MotorconnectionButtonGroupSelectionChanged(app, event)
            selectedButton = app.MotorconnectionButtonGroup.SelectedObject;
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 869 582];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Developed torque vs speed')
            xlabel(app.UIAxes, 'Speed(rpm)')
            ylabel(app.UIAxes, 'Torque Td(N.m)')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.FontWeight = 'bold';
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [466 29 360 241];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Input current vs speed')
            xlabel(app.UIAxes2, 'Speed(rpm)')
            ylabel(app.UIAxes2, 'Irms(A)')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.FontWeight = 'bold';
            app.UIAxes2.XGrid = 'on';
            app.UIAxes2.YGrid = 'on';
            app.UIAxes2.Position = [45 29 359 241];

            % Create InputsPanel
            app.InputsPanel = uipanel(app.UIFigure);
            app.InputsPanel.Title = 'Inputs';
            app.InputsPanel.Position = [28 277 486 295];

            % Create FratedEditFieldLabel
            app.FratedEditFieldLabel = uilabel(app.InputsPanel);
            app.FratedEditFieldLabel.HorizontalAlignment = 'right';
            app.FratedEditFieldLabel.Position = [190 186 43 22];
            app.FratedEditFieldLabel.Text = 'F rated';

            % Create FratedEditField
            app.FratedEditField = uieditfield(app.InputsPanel, 'numeric');
            app.FratedEditField.Position = [248 186 100 22];

            % Create EditField2_5
            app.EditField2_5 = uieditfield(app.InputsPanel, 'numeric');
            app.EditField2_5.Position = [248 139 100 22];

            % Create nratedLabel
            app.nratedLabel = uilabel(app.InputsPanel);
            app.nratedLabel.HorizontalAlignment = 'right';
            app.nratedLabel.Position = [190 139 43 22];
            app.nratedLabel.Text = 'n rated';

            % Create nratedEditField2_6
            app.nratedEditField2_6 = uieditfield(app.InputsPanel, 'numeric');
            app.nratedEditField2_6.Position = [248 139 100 22];

            % Create NoofpolesEditFieldLabel
            app.NoofpolesEditFieldLabel = uilabel(app.InputsPanel);
            app.NoofpolesEditFieldLabel.HorizontalAlignment = 'right';
            app.NoofpolesEditFieldLabel.Position = [166 232 66 22];
            app.NoofpolesEditFieldLabel.Text = 'No.of poles';

            % Create NoofpolesEditField
            app.NoofpolesEditField = uieditfield(app.InputsPanel, 'numeric');
            app.NoofpolesEditField.Position = [247 232 100 22];

            % Create R1EditFieldLabel
            app.R1EditFieldLabel = uilabel(app.InputsPanel);
            app.R1EditFieldLabel.HorizontalAlignment = 'right';
            app.R1EditFieldLabel.Position = [4 232 25 22];
            app.R1EditFieldLabel.Text = 'R1';

            % Create R1EditField
            app.R1EditField = uieditfield(app.InputsPanel, 'numeric');
            app.R1EditField.Position = [44 232 100 22];

            % Create R2Label
            app.R2Label = uilabel(app.InputsPanel);
            app.R2Label.HorizontalAlignment = 'right';
            app.R2Label.Position = [4 186 25 22];
            app.R2Label.Text = 'R2''';

            % Create R2EditField
            app.R2EditField = uieditfield(app.InputsPanel, 'numeric');
            app.R2EditField.Position = [44 186 100 22];

            % Create EditField2_3
            app.EditField2_3 = uieditfield(app.InputsPanel, 'numeric');
            app.EditField2_3.Position = [47 97 100 22];

            % Create X2Label
            app.X2Label = uilabel(app.InputsPanel);
            app.X2Label.HorizontalAlignment = 'right';
            app.X2Label.Position = [7 97 25 22];
            app.X2Label.Text = 'X2''';

            % Create X2EditField
            app.X2EditField = uieditfield(app.InputsPanel, 'numeric');
            app.X2EditField.Position = [47 97 100 22];

            % Create startingmethodDropDownLabel
            app.startingmethodDropDownLabel = uilabel(app.InputsPanel);
            app.startingmethodDropDownLabel.HorizontalAlignment = 'right';
            app.startingmethodDropDownLabel.Position = [155 62 91 22];
            app.startingmethodDropDownLabel.Text = 'starting method ';

            % Create startingmethodDropDown
            app.startingmethodDropDown = uidropdown(app.InputsPanel);
            app.startingmethodDropDown.Items = {'DOL', 'S/D', 'AT'};
            app.startingmethodDropDown.DropDownOpeningFcn = createCallbackFcn(app, @startingmethodDropDownValueChanged, true);
            app.startingmethodDropDown.ValueChangedFcn = createCallbackFcn(app, @startingmethodDropDownValueChanged, true);
            app.startingmethodDropDown.Position = [261 62 100 22];
            app.startingmethodDropDown.Value = 'DOL';

            % Create X1EditFieldLabel
            app.X1EditFieldLabel = uilabel(app.InputsPanel);
            app.X1EditFieldLabel.HorizontalAlignment = 'right';
            app.X1EditFieldLabel.Position = [4 134 25 22];
            app.X1EditFieldLabel.Text = 'X1';

            % Create X1EditField
            app.X1EditField = uieditfield(app.InputsPanel, 'numeric');
            app.X1EditField.Position = [44 134 100 22];

            % Create VLineEditFieldLabel
            app.VLineEditFieldLabel = uilabel(app.InputsPanel);
            app.VLineEditFieldLabel.HorizontalAlignment = 'right';
            app.VLineEditFieldLabel.Position = [194 97 39 22];
            app.VLineEditFieldLabel.Text = 'V Line';

            % Create VLineEditField
            app.VLineEditField = uieditfield(app.InputsPanel, 'numeric');
            app.VLineEditField.Position = [248 97 100 22];

            % Create R0EditFieldLabel
            app.R0EditFieldLabel = uilabel(app.InputsPanel);
            app.R0EditFieldLabel.HorizontalAlignment = 'right';
            app.R0EditFieldLabel.Position = [8 59 25 22];
            app.R0EditFieldLabel.Text = 'R0';

            % Create R0EditField
            app.R0EditField = uieditfield(app.InputsPanel, 'numeric');
            app.R0EditField.Position = [48 59 100 22];

            % Create X0EditFieldLabel
            app.X0EditFieldLabel = uilabel(app.InputsPanel);
            app.X0EditFieldLabel.HorizontalAlignment = 'right';
            app.X0EditFieldLabel.Position = [7 17 25 22];
            app.X0EditFieldLabel.Text = 'X0';

            % Create X0EditField
            app.X0EditField = uieditfield(app.InputsPanel, 'numeric');
            app.X0EditField.Position = [47 17 100 22];

            % Create MotorconnectionButtonGroup
            app.MotorconnectionButtonGroup = uibuttongroup(app.InputsPanel);
            app.MotorconnectionButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @MotorconnectionButtonGroupSelectionChanged, true);
            app.MotorconnectionButtonGroup.Title = 'Motor connection';
            app.MotorconnectionButtonGroup.Position = [375 25 100 90];

            % Create DeltaButton
            app.DeltaButton = uiradiobutton(app.MotorconnectionButtonGroup);
            app.DeltaButton.Text = 'Delta';
            app.DeltaButton.Position = [11 44 58 22];
            app.DeltaButton.Value = true;

            % Create StarButton
            app.StarButton = uiradiobutton(app.MotorconnectionButtonGroup);
            app.StarButton.Text = 'Star';
            app.StarButton.Position = [12 13 65 22];

            % Create DrawButton
            app.DrawButton = uibutton(app.UIFigure, 'push');
            app.DrawButton.ButtonPushedFcn = createCallbackFcn(app, @DrawButtonPushed, true);
            app.DrawButton.Position = [563 374 192 71];
            app.DrawButton.Text = 'Draw';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = project_machines_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end