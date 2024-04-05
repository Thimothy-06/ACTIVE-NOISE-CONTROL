% Create a function for the GUI
function ANC_GUI()
    % Create a figure
    fig = figure('Position', [200, 200, 1000, 600], 'MenuBar', 'none', 'Name', 'Active Noise Control');

    % Declare global variables to store audio data
    global originalAudio;
    global noiseAudio;
    global outputAudio;
    
    % Create axes for original audio waveform
    ax1 = axes('Units', 'pixels', 'Position', [50, 400, 300, 150]);
    xlabel('Time (s)');
    ylabel('Amplitude');
    title('Original Audio');

    % Create axes for noise audio waveform
    ax2 = axes('Units', 'pixels', 'Position', [400, 400, 300, 150]);
    xlabel('Time (s)');
    ylabel('Amplitude');
    title('Noise Audio');

    % Create axes for output audio waveform
    ax3 = axes('Units', 'pixels', 'Position', [750, 400, 300, 150]);
    xlabel('Time (s)');
    ylabel('Amplitude');
    title('Noise Cancellation Audio');

    % Create UI elements
    uicontrol('Style', 'pushbutton', 'String', 'Select Original Audio', 'Position', [150, 300, 150, 30], 'Callback', @selectOriginalAudio);
    uicontrol('Style', 'pushbutton', 'String', 'Select Noise Audio', 'Position', [500, 300, 150, 30], 'Callback', @selectNoiseAudio);
    uicontrol('Style', 'pushbutton', 'String', 'Apply Noise Cancellation', 'Position', [850, 300, 150, 30], 'Callback', @applyNoiseCancellation);

    % Function to select original audio file
    function selectOriginalAudio(~, ~)
        [file, path] = uigetfile('*.wav', 'Select Original Audio');
        if file
            originalAudio = audioread(fullfile(path, file));
            disp('Original audio file selected');
            % Plot original audio waveform
            plot(ax1, (1:length(originalAudio)) / 44100, originalAudio);
            axis(ax1, 'tight');
        end
    end

    % Function to select noise audio file
    function selectNoiseAudio(~, ~)
        [file, path] = uigetfile('*.wav', 'Select Noise Audio');
        if file
            noiseAudio = audioread(fullfile(path, file));
            disp('Noise audio file selected');
            % Plot noise audio waveform
            plot(ax2, (1:length(noiseAudio)) / 44100, noiseAudio);
            axis(ax2, 'tight');
        end
    end

    % Function to apply noise cancellation
    function applyNoiseCancellation(~, ~)
        if isempty(originalAudio) || isempty(noiseAudio)
            disp('Please select both original and noise audio files');
            return;
        end
        
        % Determine the length of the shorter audio file
        minLength = min(length(originalAudio), length(noiseAudio));
        
        % Pad or truncate arrays to match the length of the shorter audio file
        originalAudio = originalAudio(1:minLength);
        noiseAudio = noiseAudio(1:minLength);

        % Apply noise cancellation
        outputAudio = originalAudio - noiseAudio;

        % Plot noise cancellation audio waveform
        plot(ax3, (1:length(outputAudio)) / 44100, outputAudio);
        axis(ax3, 'tight');

        % Play the output audio
        sound(outputAudio, 44100);
    end
end
