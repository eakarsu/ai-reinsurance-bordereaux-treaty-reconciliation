// Deterministic feature pack: search/filter, export, and offline insights over own records.
// No provider calls here; insights are labelled aiGenerated:false.
export function filterRecords(rows, { q = "", status = "", risk = "", state = "" } = {}) {
  const needle = String(q || "").trim().toLowerCase();
  const wantStatus = String(status || state || "").trim().toLowerCase();
  const wantRisk = String(risk || "").trim().toLowerCase();
  return (rows || []).filter((row) => {
    if (wantStatus && String(row.status ?? row.state ?? "").toLowerCase() !== wantStatus) return false;
    if (wantRisk && String(row.risk ?? "").toLowerCase() !== wantRisk) return false;
    if (!needle) return true;
    return JSON.stringify(row ?? {}).toLowerCase().includes(needle);
  });
}
function csvCell(v) {
  if (v === null || v === undefined) return "";
  const s = typeof v === "object" ? JSON.stringify(v) : String(v);
  return /[",\n]/.test(s) ? '"' + s.replaceAll('"', '""') + '"' : s;
}
export function recordsToCsv(rows) {
  const cols = ["id","reference","title","subject","status","state","owner","risk","due_date","amount","feature_id"];
  const lines = [cols.join(",")];
  for (const r of rows || []) lines.push(cols.map((c) => csvCell(r?.[c])).join(","));
  return lines.join("\n") + "\n";
}
export function buildInsights(rows, feature = {}) {
  const list = rows || [];
  const title = feature.title || "Records";
  const totalAmount = list.reduce((s, r) => s + (Number(r?.amount) || 0), 0);
  const open = list.filter((r) => !["Approved","Closed","closed","approved"].includes(r?.status ?? r?.state)).length;
  const highRisk = list.filter((r) => ["High","Critical"].includes(r?.risk)).length;
  const closed = list.filter((r) => ["Closed","closed"].includes(r?.status ?? r?.state)).length;
  return {
    aiGenerated: false,
    source: "deterministic-fallback",
    label: "Deterministic fallback — no AI provider was called",
    featureId: feature.id || null,
    insights: [
      { id: "volume", title: `${title} — volume and value`, summary: `${list.length} record(s) totalling ${totalAmount}.`, metrics: { recordCount: list.length, totalAmount, openCount: open } },
      { id: "risk", title: `${title} — risk concentration`, summary: highRisk ? `${highRisk} high/critical record(s) need review.` : "No high/critical records in this set.", metrics: { highRiskCount: highRisk, closedCount: closed, hasHighRisk: highRisk > 0 } },
      { id: "follow-up", title: `${title} — follow-up priorities`, summary: open ? `Prioritise the ${open} open record(s), highest risk first.` : "No open records require follow-up.", metrics: { openCount: open, nextAction: open ? "Review open records" : "" } },
    ],
  };
}
