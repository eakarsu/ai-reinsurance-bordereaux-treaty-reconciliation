// Seed script — creates demo users and realistic domain records.
import { PrismaClient, Role } from "@prisma/client";
import bcrypt from "bcryptjs";

const prisma = new PrismaClient();

const phones = ["(415) 555-0132", "(212) 555-0187", "(312) 555-0149", "(617) 555-0110"];
const cities = ["Chicago, IL", "Austin, TX", "Boston, MA", "Denver, CO", "Seattle, WA"];

function pick<T>(arr: T[], i: number): T { return arr[i % arr.length]; }
function amount(i: number, base = 1000): number { return Math.round((base + ((i * 7919) % 900) * base) * 100) / 100; }
function daysAgo(i: number, spread = 180): Date { return new Date(Date.now() - ((i * 37) % spread) * 86400000); }

async function main() {
  const database = new URL(process.env.DATABASE_URL || "").pathname.slice(1);
  if (process.env.NODE_ENV === "production" || process.env.ALLOW_DEMO_SEED !== "true" || !/^(demo_|inspection_test_)/.test(database)) throw new Error("Demo seeding requires ALLOW_DEMO_SEED=true and a dedicated demo_ or inspection_test_ database");
  if (!process.env.DEMO_PASSWORD || process.env.DEMO_PASSWORD.length < 16) throw new Error("Set DEMO_PASSWORD to at least 16 characters");
  const passwordHash = await bcrypt.hash(process.env.DEMO_PASSWORD!, 12);
  const demoUsers: Array<[string, string, Role]> = [
    ["admin@ai-reinsurance-bordereaux-treaty-reconciliation.local", "Demo Admin", "ADMIN"],
    ["manager@ai-reinsurance-bordereaux-treaty-reconciliation.local", "Demo Manager", "MANAGER"],
    ["analyst@ai-reinsurance-bordereaux-treaty-reconciliation.local", "Demo Analyst", "ANALYST"],
  ];
  for (const [email, name, role] of demoUsers) {
    await prisma.user.upsert({ where: { email }, update: {}, create: { email, name, role, passwordHash } });
  }

  const STATUSES_Treaty = ["DRAFT", "BOUND", "ACTIVE", "EXPIRED"];
  await prisma.treaty.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.treaty.create({
      data: {
      name: `Name ${String(i + 1).padStart(3, "0")}`,
      reinsurer: `Reinsurer ${String(i + 1).padStart(3, "0")}`,
      type: `Type ${String(i + 1).padStart(3, "0")}`,
      layer: `Layer ${String(i + 1).padStart(3, "0")}`,
      limitUsd: amount(i, 250),
      cessionPct: amount(i, 250),
      status: pick(STATUSES_Treaty, i)
      },
    });
  }

  const treatyRefs = await prisma.treaty.findMany({ select: { id: true } });

  const STATUSES_BordereauRecord = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.bordereauRecord.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.bordereauRecord.create({
      data: {
      period: `Period ${String(i + 1).padStart(3, "0")}`,
      kind: `Kind ${String(i + 1).padStart(3, "0")}`,
      rowCount: 5 + ((i * 13) % 95),
      fileRef: `FileRef ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_BordereauRecord, i),
      receivedAt: daysAgo(i),
      treaty: { connect: { id: treatyRefs[i % treatyRefs.length].id } }
      },
    });
  }

  const STATUSES_CededPremium = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.cededPremium.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.cededPremium.create({
      data: {
      period: `Period ${String(i + 1).padStart(3, "0")}`,
      grossWritten: amount(i, 250),
      cededAmount: amount(i, 250),
      commission: amount(i, 250),
      currency: `Currency ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_CededPremium, i),
      treaty: { connect: { id: treatyRefs[i % treatyRefs.length].id } }
      },
    });
  }

  const STATUSES_LossRecoverable = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.lossRecoverable.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.lossRecoverable.create({
      data: {
      claimRef: `ClaimRef ${String(i + 1).padStart(3, "0")}`,
      period: `Period ${String(i + 1).padStart(3, "0")}`,
      incurredLoss: amount(i, 250),
      recoverable: amount(i, 250),
      status: pick(STATUSES_LossRecoverable, i),
      recognizedAt: daysAgo(i),
      treaty: { connect: { id: treatyRefs[i % treatyRefs.length].id } }
      },
    });
  }

  const STATUSES_CashCall = ["DRAFT", "SENT", "COLLECTED", "DISPUTED"];
  await prisma.cashCall.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.cashCall.create({
      data: {
      callRef: `CallRef ${String(i + 1).padStart(3, "0")}`,
      amount: amount(i, 250),
      currency: `Currency ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_CashCall, i),
      issuedAt: daysAgo(i),
      settledAt: daysAgo(i),
      treaty: { connect: { id: treatyRefs[i % treatyRefs.length].id } }
      },
    });
  }

  const STATUSES_CollateralPosition = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.collateralPosition.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.collateralPosition.create({
      data: {
      reinsurer: `Reinsurer ${String(i + 1).padStart(3, "0")}`,
      instrument: `Instrument ${String(i + 1).padStart(3, "0")}`,
      requiredAmount: amount(i, 250),
      heldAmount: amount(i, 250),
      status: pick(STATUSES_CollateralPosition, i),
      asOf: daysAgo(i),
      treaty: { connect: { id: treatyRefs[i % treatyRefs.length].id } }
      },
    });
  }

  const STATUSES_CommutationReview = ["PROPOSED", "NEGOTIATING", "AGREED", "CLOSED"];
  await prisma.commutationReview.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.commutationReview.create({
      data: {
      proposalRef: `ProposalRef ${String(i + 1).padStart(3, "0")}`,
      analyst: `Analyst ${String(i + 1).padStart(3, "0")}`,
      settlementAmount: amount(i, 250),
      status: pick(STATUSES_CommutationReview, i),
      proposedAt: daysAgo(i),
      rationale: `Rationale ${String(i + 1).padStart(3, "0")}`,
      treaty: { connect: { id: treatyRefs[i % treatyRefs.length].id } }
      },
    });
  }

  const STATUSES_ScheduleFEntry = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.scheduleFEntry.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.scheduleFEntry.create({
      data: {
      naicCode: `NaicCode ${String(i + 1).padStart(3, "0")}`,
      reinsurerName: `ReinsurerName ${String(i + 1).padStart(3, "0")}`,
      part: `Part ${String(i + 1).padStart(3, "0")}`,
      amount: amount(i, 250),
      status: pick(STATUSES_ScheduleFEntry, i),
      statementYear: `StatementYear ${String(i + 1).padStart(3, "0")}`,
      treaty: { connect: { id: treatyRefs[i % treatyRefs.length].id } }
      },
    });
  }

  const STATUSES_ReinsurerCounterparty = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.reinsurerCounterparty.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.reinsurerCounterparty.create({
      data: {
      name: `Name ${String(i + 1).padStart(3, "0")}`,
      amBestRating: `AmBestRating ${String(i + 1).padStart(3, "0")}`,
      domicile: `Domicile ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_ReinsurerCounterparty, i),
      exposureLimit: amount(i, 250),
      lastReview: daysAgo(i),
      treaty: { connect: { id: treatyRefs[i % treatyRefs.length].id } }
      },
    });
  }

  const STATUSES_DiscrepancyCase = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.discrepancyCase.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.discrepancyCase.create({
      data: {
      kind: `Kind ${String(i + 1).padStart(3, "0")}`,
      expectedValue: `ExpectedValue ${String(i + 1).padStart(3, "0")}`,
      reportedValue: `ReportedValue ${String(i + 1).padStart(3, "0")}`,
      variance: amount(i, 250),
      status: pick(STATUSES_DiscrepancyCase, i),
      owner: `Owner ${String(i + 1).padStart(3, "0")}`,
      treaty: { connect: { id: treatyRefs[i % treatyRefs.length].id } }
      },
    });
  }

  const STATUSES_SettlementPayment = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.settlementPayment.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.settlementPayment.create({
      data: {
      period: `Period ${String(i + 1).padStart(3, "0")}`,
      direction: `Direction ${String(i + 1).padStart(3, "0")}`,
      amount: amount(i, 250),
      currency: `Currency ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_SettlementPayment, i),
      dueDate: daysAgo(i),
      treaty: { connect: { id: treatyRefs[i % treatyRefs.length].id } }
      },
    });
  }

  const STATUSES_TreatyTerm = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.treatyTerm.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.treatyTerm.create({
      data: {
      clause: `Clause ${String(i + 1).padStart(3, "0")}`,
      category: `Category ${String(i + 1).padStart(3, "0")}`,
      text: `Text ${String(i + 1).padStart(3, "0")}`,
      version: `Version ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_TreatyTerm, i),
      effectiveDate: daysAgo(i),
      treaty: { connect: { id: treatyRefs[i % treatyRefs.length].id } }
      },
    });
  }

  await prisma.auditLog.create({ data: { actorName: "Seeder", action: "SEED", entity: "system", detail: "Demo dataset created" } });

  console.log("Seeded demo users and domain records.");
}

main().catch((e) => { console.error(e); process.exit(1); }).finally(async () => { await prisma.$disconnect(); });
