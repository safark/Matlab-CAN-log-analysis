function generate_can_log(outCsv, duration_s, dt)
% Generates a simulated CAN log CSV: timestamp_s, can_id, dlc, data_hex
% Three message IDs:
% 0x100: pack_voltage (0.1 V per LSB, uint16 little-endian in bytes 1-2)
% 0x101: pack_current (0.1 A per LSB, int16 little-endian in bytes 1-2)
% 0x102: temp_c      (0.1 C per LSB, int16 little-endian in bytes 1-2)

if nargin < 1, outCsv = "can_log.csv"; end
if nargin < 2, duration_s = 60; end
if nargin < 3, dt = 0.1; end

t = (0:dt:duration_s)';
n = numel(t);

% Simulated signals (make them realistic)
packV = 650 + 10*sin(2*pi*t/30) + 0.5*randn(n,1);         % volts
packI = 50*sin(2*pi*t/10) + 2*randn(n,1);                 % amps
tempC = 30 + 2*sin(2*pi*t/40) + 0.2*randn(n,1);           % C

% Inject anomalies
packV(t>40 & t<42) = packV(t>40 & t<42) + 50;             % voltage spike
tempC(t>20 & t<25) = tempC(t>20 & t<25) + 15;             % overheating window

rows = strings(0,1);

for i=1:n
    % 0x100 voltage
    v_raw = uint16(max(0, round(packV(i) / 0.1)));
    bytes = zeros(1,8,'uint8');
    bytes(1:2) = typecast(v_raw,'uint8'); % little-endian
    rows(end+1,1) = fmtRow(t(i), 256, 8, bytes);

    % 0x101 current
    i_raw = int16(round(packI(i) / 0.1));
    bytes = zeros(1,8,'uint8');
    bytes(1:2) = typecast(i_raw,'uint8');
    rows(end+1,1) = fmtRow(t(i), 257, 8, bytes);

    % 0x102 temperature
    tc_raw = int16(round(tempC(i) / 0.1));
    bytes = zeros(1,8,'uint8');
    bytes(1:2) = typecast(tc_raw,'uint8');
    rows(end+1,1) = fmtRow(t(i), 258, 8, bytes);
end

% Write CSV
fid = fopen(outCsv,'w');
fprintf(fid, "timestamp_s,can_id,dlc,data_hex\n");
for k=1:numel(rows)
    fprintf(fid, "%s\n", rows(k));
end
fclose(fid);

fprintf("Wrote %s (%d frames)\n", outCsv, numel(rows));

end

function s = fmtRow(ts, canIdDec, dlc, bytes8)
hexStr = upper(join(string(dec2hex(bytes8,2)),""));
s = sprintf("%.3f,0x%03X,%d,%s", ts, canIdDec, dlc, hexStr);
end
