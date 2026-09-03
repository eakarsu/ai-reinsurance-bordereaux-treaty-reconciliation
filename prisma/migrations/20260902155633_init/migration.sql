-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'MANAGER', 'ANALYST');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'ANALYST',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditLog" (
    "id" TEXT NOT NULL,
    "actorId" TEXT,
    "actorName" TEXT,
    "action" TEXT NOT NULL,
    "entity" TEXT NOT NULL,
    "entityId" TEXT,
    "detail" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Treaty" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "reinsurer" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "layer" TEXT NOT NULL,
    "limitUsd" DOUBLE PRECISION NOT NULL,
    "cessionPct" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Treaty_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BordereauRecord" (
    "id" TEXT NOT NULL,
    "period" TEXT NOT NULL,
    "kind" TEXT NOT NULL,
    "rowCount" INTEGER NOT NULL,
    "fileRef" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "receivedAt" TIMESTAMP(3),
    "treatyId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BordereauRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CededPremium" (
    "id" TEXT NOT NULL,
    "period" TEXT NOT NULL,
    "grossWritten" DOUBLE PRECISION NOT NULL,
    "cededAmount" DOUBLE PRECISION NOT NULL,
    "commission" DOUBLE PRECISION NOT NULL,
    "currency" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "treatyId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CededPremium_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LossRecoverable" (
    "id" TEXT NOT NULL,
    "claimRef" TEXT NOT NULL,
    "period" TEXT NOT NULL,
    "incurredLoss" DOUBLE PRECISION NOT NULL,
    "recoverable" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL,
    "recognizedAt" TIMESTAMP(3),
    "treatyId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "LossRecoverable_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CashCall" (
    "id" TEXT NOT NULL,
    "callRef" TEXT NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "currency" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "issuedAt" TIMESTAMP(3),
    "settledAt" TIMESTAMP(3),
    "treatyId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CashCall_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CollateralPosition" (
    "id" TEXT NOT NULL,
    "reinsurer" TEXT NOT NULL,
    "instrument" TEXT NOT NULL,
    "requiredAmount" DOUBLE PRECISION NOT NULL,
    "heldAmount" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL,
    "asOf" TIMESTAMP(3),
    "treatyId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CollateralPosition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CommutationReview" (
    "id" TEXT NOT NULL,
    "proposalRef" TEXT NOT NULL,
    "analyst" TEXT NOT NULL,
    "settlementAmount" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL,
    "proposedAt" TIMESTAMP(3),
    "rationale" TEXT,
    "treatyId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CommutationReview_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScheduleFEntry" (
    "id" TEXT NOT NULL,
    "naicCode" TEXT NOT NULL,
    "reinsurerName" TEXT NOT NULL,
    "part" TEXT NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL,
    "statementYear" TEXT NOT NULL,
    "treatyId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ScheduleFEntry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ReinsurerCounterparty" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "amBestRating" TEXT NOT NULL,
    "domicile" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "exposureLimit" DOUBLE PRECISION NOT NULL,
    "lastReview" TIMESTAMP(3),
    "treatyId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ReinsurerCounterparty_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DiscrepancyCase" (
    "id" TEXT NOT NULL,
    "kind" TEXT NOT NULL,
    "expectedValue" TEXT NOT NULL,
    "reportedValue" TEXT NOT NULL,
    "variance" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL,
    "owner" TEXT NOT NULL,
    "treatyId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DiscrepancyCase_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SettlementPayment" (
    "id" TEXT NOT NULL,
    "period" TEXT NOT NULL,
    "direction" TEXT NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "currency" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "dueDate" TIMESTAMP(3),
    "treatyId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SettlementPayment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TreatyTerm" (
    "id" TEXT NOT NULL,
    "clause" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "version" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "effectiveDate" TIMESTAMP(3),
    "treatyId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TreatyTerm_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- AddForeignKey
ALTER TABLE "BordereauRecord" ADD CONSTRAINT "BordereauRecord_treatyId_fkey" FOREIGN KEY ("treatyId") REFERENCES "Treaty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CededPremium" ADD CONSTRAINT "CededPremium_treatyId_fkey" FOREIGN KEY ("treatyId") REFERENCES "Treaty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LossRecoverable" ADD CONSTRAINT "LossRecoverable_treatyId_fkey" FOREIGN KEY ("treatyId") REFERENCES "Treaty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CashCall" ADD CONSTRAINT "CashCall_treatyId_fkey" FOREIGN KEY ("treatyId") REFERENCES "Treaty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CollateralPosition" ADD CONSTRAINT "CollateralPosition_treatyId_fkey" FOREIGN KEY ("treatyId") REFERENCES "Treaty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CommutationReview" ADD CONSTRAINT "CommutationReview_treatyId_fkey" FOREIGN KEY ("treatyId") REFERENCES "Treaty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScheduleFEntry" ADD CONSTRAINT "ScheduleFEntry_treatyId_fkey" FOREIGN KEY ("treatyId") REFERENCES "Treaty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReinsurerCounterparty" ADD CONSTRAINT "ReinsurerCounterparty_treatyId_fkey" FOREIGN KEY ("treatyId") REFERENCES "Treaty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DiscrepancyCase" ADD CONSTRAINT "DiscrepancyCase_treatyId_fkey" FOREIGN KEY ("treatyId") REFERENCES "Treaty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SettlementPayment" ADD CONSTRAINT "SettlementPayment_treatyId_fkey" FOREIGN KEY ("treatyId") REFERENCES "Treaty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TreatyTerm" ADD CONSTRAINT "TreatyTerm_treatyId_fkey" FOREIGN KEY ("treatyId") REFERENCES "Treaty"("id") ON DELETE SET NULL ON UPDATE CASCADE;
