function decode_can_log(inCsv, outDecodedCsv)
% Reads can_log.csv and decodes signals from numeric CAN IDs

if nargin < 1, inCsv = "can_log.csv"; end
if nargin < 2, outDecodedCsv = "decoded_signals.csv"; end

T = readtable(inCsv);

ts = T.timestamp_s;
id = T.can_id;      % numeric
hex = string(T.data_hex);

packV = nan(height(T),1);
packI = nan(height(T),1);
tempC = nan(height(T),1);

for i = 1:height(T)
    bytes = hexToBytes(hex(i));

    if id(i) == hex2dec('100')        % Pack Voltage
        raw = typecast(uint8(bytes(1:2)),'uint16');
        packV(i) = double(raw) * 0.1;

    elseif id(i) == hex2dec('101')    % Pack Current
        raw = typecast(uint8(bytes(1:2)),'int16');
        packI(i) = double(raw) * 0.1;

    elseif id(i) == hex2dec('102')    % Temperature
        raw = typecast(uint8(bytes(1:2)),'int16');
        tempC(i) = double(raw) * 0.1;
    end
end

D = table(ts, id, packV, packI, tempC);
writetable(D, outDecodedCsv);

fprintf("Wrote %s\n", outDecodedCsv);
end

function bytes = hexToBytes(hexStr)
hexStr = erase(hexStr," ");
n = strlength(hexStr)/2;
bytes = zeros(1,n);
for k = 1:n
    bytes(k) = hex2dec(extractBetween(hexStr, 2*k-1, 2*k));
end
end
