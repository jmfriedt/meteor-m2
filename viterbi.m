%% viterbi: Viterbi algorithm
%    PARAMETERS:
%      - Convolutional Code Generation Matrix (e.g. [1 1 1; 1 0 1])
%      - Input Sequence (Sequence to decode) (as binary [ 1 0 0 1 0 0] or string '10 01 00')
%      - 0 to not print info at the end
%
%    OUTPUT:
%      - Decoded Sequence
%      - Number of Errors between given sequence and output from coder
%
% Author: Filip Osuch
%         23-06-2015
%
function [ output, num_of_errors ] = viterbi(generation_matrix, sequence_to_decode, do_print_info)
    output = []; num_of_errors = 0;
    % validateattributes(generation_matrix, {'numeric'}, {'binary'});
    if any(any(generation_matrix ~= 1 & generation_matrix ~= 0))
        error('generation_matrix must be binary');
    end

    if isstr(sequence_to_decode)
        sequence_to_decode(sequence_to_decode~='0' & sequence_to_decode~='1') = '';
        sequence_to_decode = sequence_to_decode - '0';
    end

    if any(sequence_to_decode ~= 1 & sequence_to_decode ~= 0)
        error('sequence_to_decode must be binary');
    end

	[n, k, m, L, K]             = get_code_info(generation_matrix);

    if length(sequence_to_decode) < n
        error(sprintf('Sequence to decode must be at least equal to n = %d', n));
    end

    if mod(length(sequence_to_decode), n)
        warning('Expanding sequence with zeros');
        sequence_to_decode = [ sequence_to_decode zeros(1, n-mod(length(sequence_to_decode), n)) ];
    end

    input_length                = length(sequence_to_decode) / n;
    output_length               = length(sequence_to_decode);
    trellis                     = my_poly2trellis(m, generation_matrix);
    % trellis = struct(...
    %     'numStates', 4,...
    %     'nextStates', [0 2; 0 2; 1 3; 1 3],...
    %     'outputs', [0 3; 3 0; 2 1; 1 2]);

    num_of_states               = trellis.numStates;
    num_of_tail_bits            = log2(num_of_states);
    accumulated_error_metric    = NaN(num_of_states, input_length+1);
    error_metric                = NaN(num_of_states, num_of_states);
    survivors                   = NaN(num_of_states, input_length+1);
    state_selected              = NaN(1, input_length + 1);
    decoded_bits                = NaN(1, input_length);
    output_bits_dec             = [ reshape(bin2dec(num2str(vec2mat(sequence_to_decode, n))), 1, []) ];

    % print_info(0, accumulated_error_metric, error_metric, survivors)

    % Number of steps = length of coder input vector
    accumulated_error_metric(1, 1) = 0;
    
    for i=1:input_length

        % Calculate paths from each state
        for state=0:num_of_states-1
            
            if isnan(accumulated_error_metric(state+1, i))
                continue;
            end

            % Calculate paths for each possible incoming bits
            for bit=0:2^k-1
                next_state    = trellis.nextStates(state+1, bit+1);

                expected_bits = trellis.outputs(state+1, bit+1);
                given_bits    = output_bits_dec(i);
                distance      = hamming_dist(expected_bits, given_bits);

                % Write current metric for path to temp matrix
                error_metric(state+1, next_state+1) = distance;
            end

        end

        % Now, choose best path (given accumulated and temp metric)
        % and write metric to accumulated
        % and write prev state to survivors
        % (checking each next state, comparing paths from prev states)
        for state=0:num_of_states-1
            new_metrics = accumulated_error_metric(:, i) + error_metric(:, state+1);
            [val, ind] = min(new_metrics);

            accumulated_error_metric(state+1, i+1) = val;
            if ~isnan(val)
                survivors(state+1, i+1) = ind - 1;
            end
        end

        % print_info(i, accumulated_error_metric, error_metric, survivors)

        error_metric(:) = NaN;

    end

    % Traceback part
    % Choose min metric and state
    [num_of_errors, ind] = min(accumulated_error_metric(:,end));
    state = ind - 1;

    for i = input_length+1:-1:1
        state_selected(i) = state;
        state = survivors(state+1, i);
    end
    state_selected(i) = 0;

    state_selected(1) = 0;

    % Take output bit for given state and previous state
    for i = 1:input_length
        possible_states = trellis.nextStates(state_selected(i) + 1, :);
        next_state      = state_selected(i+1);
        bit = find( possible_states == next_state ) - 1;
        decoded_bits(i) = bit(1);
    end

    % Print info
    if do_print_info
        space = '----------------------------';
        disp(sprintf('%s', space));
        disp(sprintf('%s n=%d k=%d m=%d L=%d K=%d', 'Code params:', n, k, m, L, K));
        
        trellis

        disp(sprintf('%s', 'Sequence to decode is : '));
        disp(str2num(dec2bin(output_bits_dec))');

        disp(sprintf('%s', 'Suma metryk =  '));
        disp(accumulated_error_metric);
        disp(sprintf('%s', 'Stany =  '));
        disp(survivors);

        disp(sprintf('\n%s', 'Stany wybrane to '));
        disp(state_selected);

        disp(sprintf('\n%s (%s %d)', 'Zdekodowany ciag to ', 'liczba bledow = ', num_of_errors));
        disp(decoded_bits);

        disp(sprintf('\n%s', space));
    end

    output = decoded_bits;
end

%% get_code_info: function description
function [n, k, m, L, K] = get_code_info(generation_matrix)
	[ n, m ] = size(generation_matrix);
	% m = m - 1;
	k = 1;
    L = k*(m-1);
    K = L-1;
end

%% hamming_dist: returns hamming distance between 2 matrixes by columns
function [dist] = hamming_dist(a, b)
    a = reshape(a, 1, []);
    b = reshape(b, 1, []);
    a_bin = dec2bin(a, 8);
    b_bin = dec2bin(b, 8);
    dist = sum(a_bin ~= b_bin, 2);
    dist = reshape(dist, 1, []);
end

%% my_poly2trellis: function description
function [output] = my_poly2trellis(k, generation_matrix)
    gen_matrix = str2num(dec2base(bin2dec(num2str(generation_matrix)), 8)); % bin to oct ...
    gen_matrix = reshape(gen_matrix, 1, []);
    output     = poly2trellis([k], gen_matrix);
end

%% print_info: function description
function [] = print_info(step, a, b, c)
    disp(sprintf('\n%s%d%s', 'Krok nr ', step, ' ---------------- '));
    disp(sprintf('%s', 'Suma metryk =  '));
    disp(a);
    disp(sprintf('%s', 'Metryka dla kroku =  '));
    disp(b);
    disp(sprintf('%s', 'Stany =  '));
    disp(c);
end
