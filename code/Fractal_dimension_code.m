clc, clear

% Call the function for the second image
[fractalDimension2, image2] = calculateFractalDimension('Poincaré_theory_1024x1024.png');
fprintf('Fractal Dimension of theory: %.4f\n', fractalDimension2);

[fractalDimension3, image3] = calculateFractalDimension('Pointcaré_48h_1024x1024.png');
fprintf('Fractal Dimension of experiment (48h): %.4f\n', fractalDimension3);

% Plot the images and their respective fractal dimension graphs
figure;

% Plot for the second image
subplot(2, 2, 1);
imshow(image2);
title('Pointcaré theory');

subplot(2, 2, 3);
plotFractalDimension(image2);
title('Theoretical');

% Plot for the third image
subplot(2, 2, 2);
imshow(image3);
title('Pointcaré experiment');

subplot(2, 2, 4);
plotFractalDimension(image3);
title('Experiment');


function [fractalDimension, image] = calculateFractalDimension(imageFilename)
    % Read the image
    image = imread(imageFilename);
    % Convert the image to grayscale
    image = rgb2gray(image);
    
    % Determine the threshold value using Otsu's method
    % (minimizes the intra-class variance (only black and white))
    thresholdValue = graythresh(image);
    
    % Convert the image to binary using the threshold value (1-0)
    image = imbinarize(image, thresholdValue);

    % Initialize variables for plotting the graph
    scale = zeros(1, 10);
    count = zeros(1, 10);
    [width, height, ~] = size(image);

    % Iterate over different scaling factors
    for i = 1:10 %iterate over 9 different scalingfactors
        % Calculate the scaling factor 
        sf = 2^i;  %pixelcount on image
        % Calculate the number of pieces 
        pieces = sf^2; %scalingfactor is the amount of boxes on each axis)
        % Calculate the width and height of each piece
        pieceWidth = width / sf;
        pieceHeight = height / sf;
        % Initialize variable to count black pieces
        blackPieces = 0;

        % Iterate through each piece of the image
        for pieceIndex = 0:pieces-1
            % Calculate the row and column indices of the piece
            pieceRow = idivide(int32(pieceIndex), int32(sf));
            pieceCol = rem(pieceIndex, sf);
            % Calculate the x and y coordinates of the piece
            xmin = (pieceCol * pieceWidth) + 1;
            xmax = (xmin + pieceWidth) - 1;
            ymin = (pieceRow * pieceHeight) + 1;
            ymax = (ymin + pieceHeight) - 1;
            % Extract the piece from the image
            eachPiece = image(ymin:ymax, xmin:xmax);

            % Check if the piece contains black pixels
            if (min(min(eachPiece)) == 0)
                % Increment the count of black pieces
                blackPieces = blackPieces + 1;
            end
        end

        % Store the scaling factor and count of black pieces
        scale(i) = sf;
        count(i) = blackPieces;
    end

    % Calculate the fractal dimension using the box counting method
    fractalDimension = polyfit(log10(scale(1:6)), log10(count(1:6)), 1); %we only look at the first 5 points since the graph seems to be saturated
    % Extract only the slope (fractal dimension)
    fractalDimension = fractalDimension(1);
end

function plotFractalDimension(image) %same itterations a the other function (with added plot)
    % Initialize variables for plotting the graph
    scale = zeros(1, 10);
    count = zeros(1, 10);
    [width, height, ~] = size(image);

    % Iterate over different scaling factors
    for i = 1:10
        % Calculate the scaling factor
        sf = 2^i;  
        % Calculate the number of pieces
        pieces = sf^2;
        % Calculate the width and height of each piece
        pieceWidth = width / sf;
        pieceHeight = height / sf;
        % Initialize variable to count black pieces
        blackPieces = 0;

        % Iterate through each piece of the image
        for pieceRow = 1:sf
            for pieceCol = 1:sf
                % Calculate the x and y coordinates of the piece
                xmin = (pieceCol - 1) * pieceWidth + 1;
                xmax = pieceCol * pieceWidth;
                ymin = (pieceRow - 1) * pieceHeight + 1;
                ymax = pieceRow * pieceHeight;
                % Extract the piece from the image
                eachPiece = image(ymin:ymax, xmin:xmax);

                % Check if the piece contains black pixels
                if any(eachPiece(:) == 0)
                    % Increment the count of black pieces
                    blackPieces = blackPieces + 1;
                end
            end
        end

        % Store the scaling factor and count of black pieces
        scale(i) = sf;
        count(i) = blackPieces;
        % Display the count of black pieces for each scaling factor
        fprintf('Scale: 2^%d, Black Pieces: %d, ln(Scale): %.4f, ln(Count): %.4f\n', ...
            i, blackPieces, log10(sf), log10(blackPieces)); 
    end

    % Plot the fractal dimension graph
    plot(log10(scale(1:10)), log10(count(1:10)), '.', MarkerSize=5); 
    xlabel('log(scale)');
    ylabel('log(Boxcount)');
    title('Fractal Dimension Estimation');
    grid on;
    hold on;
    
    % Plot the fractal dimension
x = log10(scale(1:6)); 
y = log10(count(1:6)); 
p = polyfit(x, y, 1); % Fit a linear regression line
y_fit = polyval(p, x); % Compute the fitted values
plot(x, y_fit, 'r--', 'LineWidth', 1);
legend('Data Points', sprintf('Linear Fit (FD: %.4f)', p(1)));
hold off;
    
end
