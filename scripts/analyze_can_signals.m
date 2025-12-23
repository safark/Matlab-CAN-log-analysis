function analyze_can_signals(decodedCsv)
if nargin < 1, decodedCsv = "decoded_signals.csv"; end
D = readtable(decodedCsv, 'TextType','string');

% Collapse into time-series per signal
tv = D.ts(~isnan(D.packV));  v = D.packV(~isnan(D.packV));
ti = D.ts(~isnan(D.packI));  I = D.packI(~isnan(D.packI));
tt = D.ts(~isnan(D.tempC));  T = D.tempC(~isnan(D.tempC));

% Simple anomaly rules (tune if you want)
v_hi = 720; v_lo = 580;
t_hi = 45;
i_abs = 150;

anomV = (v > v_hi) | (v < v_lo);
anomT = (T > t_hi);
anomI = abs(I) > i_abs;

% Stats
summary = {
    "Pack Voltage (V): mean=" + mean(v,"omitnan") + ", min=" + min(v) + ", max=" + max(v) + ", anomalies=" + nnz(anomV)
    "Pack Current (A): mean=" + mean(I,"omitnan") + ", min=" + min(I) + ", max=" + max(I) + ", anomalies=" + nnz(anomI)
    "Temperature (C): mean=" + mean(T,"omitnan") + ", min=" + min(T) + ", max=" + max(T) + ", anomalies=" + nnz(anomT)
};

fid = fopen("summary.txt","w");
for k=1:numel(summary)
    fprintf(fid, "%s\n", summary{k});
end
fclose(fid);

% Plots
figure; plot(tv, v); xlabel("time (s)"); ylabel("pack voltage (V)"); title("Pack Voltage vs Time");
saveas(gcf,"pack_voltage.png");

figure; plot(ti, I); xlabel("time (s)"); ylabel("pack current (A)"); title("Pack Current vs Time");
saveas(gcf,"pack_current.png");

figure; plot(tt, T); xlabel("time (s)"); ylabel("temperature (C)"); title("Temperature vs Time");
saveas(gcf,"temperature.png");

fprintf("Wrote summary.txt and plots (PNG)\n");
end
