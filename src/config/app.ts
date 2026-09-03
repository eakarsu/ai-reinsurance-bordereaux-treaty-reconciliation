export interface PageConfig {
  label: string;
  href: string;
  description: string;
  entities: string[];
  workflows: string[];
}

export interface EntityConfig {
  name: string;
  label: string;
  fields: Array<{ name: string; kind: "string" | "number" | "boolean" | "date" }>;
}

export interface WorkflowConfig {
  slug: string;
  title: string;
  description: string;
  prompt: string;
  fields: string[];
}

export const appConfig = {
  slug: "ai-reinsurance-bordereaux-treaty-reconciliation",
  title: "TreatyLedger Reinsurance Operations",
  tagline: "Treaty bordereaux validation and ceded reconciliation",
  accent: "amber",
};

export const pages: PageConfig[] = [
  {
    label: "Treaties",
    href: "/treaties",
    description: "Treaty book structure and counterparties.",
    entities: ["Treaty", "TreatyTerm", "ReinsurerCounterparty"],
    workflows: [],
  },
  {
    label: "Bordereaux",
    href: "/bordereaux",
    description: "Bordereaux validation and discrepancy resolution.",
    entities: ["BordereauRecord", "DiscrepancyCase"],
    workflows: ["bordereau-validate"],
  },
  {
    label: "Ceded & Cash",
    href: "/ceded",
    description: "Ceded premium, recoverables, settlements, cash calls.",
    entities: ["CededPremium", "LossRecoverable", "SettlementPayment", "CashCall"],
    workflows: ["recoverable-calc"],
  },
  {
    label: "Credit & Reporting",
    href: "/credit",
    description: "Collateral, commutations, Schedule F reporting.",
    entities: ["CollateralPosition", "CommutationReview", "ScheduleFEntry"],
    workflows: ["collateral-gap"],
  },
];

export const entities: Record<string, EntityConfig> = {
  Treaty: {
    name: "Treaty",
    label: "Treaty",
    fields: [{ name: "name", kind: "string" }, { name: "reinsurer", kind: "string" }, { name: "type", kind: "string" }, { name: "layer", kind: "string" }, { name: "limitUsd", kind: "number" }, { name: "cessionPct", kind: "number" }, { name: "status", kind: "string" }],
  },
  BordereauRecord: {
    name: "BordereauRecord",
    label: "Bordereau Record",
    fields: [{ name: "period", kind: "string" }, { name: "kind", kind: "string" }, { name: "rowCount", kind: "number" }, { name: "fileRef", kind: "string" }, { name: "status", kind: "string" }, { name: "receivedAt", kind: "date" }],
  },
  CededPremium: {
    name: "CededPremium",
    label: "Ceded Premium",
    fields: [{ name: "period", kind: "string" }, { name: "grossWritten", kind: "number" }, { name: "cededAmount", kind: "number" }, { name: "commission", kind: "number" }, { name: "currency", kind: "string" }, { name: "status", kind: "string" }],
  },
  LossRecoverable: {
    name: "LossRecoverable",
    label: "Loss Recoverable",
    fields: [{ name: "claimRef", kind: "string" }, { name: "period", kind: "string" }, { name: "incurredLoss", kind: "number" }, { name: "recoverable", kind: "number" }, { name: "status", kind: "string" }, { name: "recognizedAt", kind: "date" }],
  },
  CashCall: {
    name: "CashCall",
    label: "Cash Call",
    fields: [{ name: "callRef", kind: "string" }, { name: "amount", kind: "number" }, { name: "currency", kind: "string" }, { name: "status", kind: "string" }, { name: "issuedAt", kind: "date" }, { name: "settledAt", kind: "date" }],
  },
  CollateralPosition: {
    name: "CollateralPosition",
    label: "Collateral Position",
    fields: [{ name: "reinsurer", kind: "string" }, { name: "instrument", kind: "string" }, { name: "requiredAmount", kind: "number" }, { name: "heldAmount", kind: "number" }, { name: "status", kind: "string" }, { name: "asOf", kind: "date" }],
  },
  CommutationReview: {
    name: "CommutationReview",
    label: "Commutation Review",
    fields: [{ name: "proposalRef", kind: "string" }, { name: "analyst", kind: "string" }, { name: "settlementAmount", kind: "number" }, { name: "status", kind: "string" }, { name: "proposedAt", kind: "date" }, { name: "rationale", kind: "string" }],
  },
  ScheduleFEntry: {
    name: "ScheduleFEntry",
    label: "Schedule F Entry",
    fields: [{ name: "naicCode", kind: "string" }, { name: "reinsurerName", kind: "string" }, { name: "part", kind: "string" }, { name: "amount", kind: "number" }, { name: "status", kind: "string" }, { name: "statementYear", kind: "string" }],
  },
  ReinsurerCounterparty: {
    name: "ReinsurerCounterparty",
    label: "Counterparty",
    fields: [{ name: "name", kind: "string" }, { name: "amBestRating", kind: "string" }, { name: "domicile", kind: "string" }, { name: "status", kind: "string" }, { name: "exposureLimit", kind: "number" }, { name: "lastReview", kind: "date" }],
  },
  DiscrepancyCase: {
    name: "DiscrepancyCase",
    label: "Discrepancy",
    fields: [{ name: "kind", kind: "string" }, { name: "expectedValue", kind: "string" }, { name: "reportedValue", kind: "string" }, { name: "variance", kind: "number" }, { name: "status", kind: "string" }, { name: "owner", kind: "string" }],
  },
  SettlementPayment: {
    name: "SettlementPayment",
    label: "Settlement Payment",
    fields: [{ name: "period", kind: "string" }, { name: "direction", kind: "string" }, { name: "amount", kind: "number" }, { name: "currency", kind: "string" }, { name: "status", kind: "string" }, { name: "dueDate", kind: "date" }],
  },
  TreatyTerm: {
    name: "TreatyTerm",
    label: "Treaty Term",
    fields: [{ name: "clause", kind: "string" }, { name: "category", kind: "string" }, { name: "text", kind: "string" }, { name: "version", kind: "string" }, { name: "status", kind: "string" }, { name: "effectiveDate", kind: "date" }],
  },
};

export const workflows: WorkflowConfig[] = [
  {
    slug: "bordereau-validate",
    title: "Bordereau Validator",
    description: "Validate a bordereau against treaty terms.",
    prompt: "You are a reinsurance operations analyst. Validate the described bordereau against treaty scope: line of business, layer, period, exclusions; list exceptions.",
    fields: ["treaty", "period", "rowCount", "observedIssues"],
  },
  {
    slug: "recoverable-calc",
    title: "Loss Recoverable Calculator",
    description: "Compute treaty recoverable for an incurred loss.",
    prompt: "You are a reinsurance accountant. Compute the treaty recoverable given attachment, limit, cession percentage and reinstatement terms.",
    fields: ["incurredLoss", "attachment", "limit", "cessionPct"],
  },
  {
    slug: "collateral-gap",
    title: "Collateral Gap Monitor",
    description: "Find reinsurer collateral sufficiency gaps.",
    prompt: "You are a reinsurance credit analyst. Assess collateral sufficiency versus ceded reserves and unauthorized reinsurance exposure for Schedule F.",
    fields: ["reinsurer", "ceedLiabilities", "heldCollateral", "rating"],
  },
];

export function findPage(href: string): PageConfig | undefined {
  return pages.find((p) => p.href === href);
}
