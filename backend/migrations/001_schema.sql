CREATE TABLE IF NOT EXISTS app_users(
  id BIGSERIAL PRIMARY KEY,email TEXT UNIQUE NOT NULL,name TEXT NOT NULL,role TEXT NOT NULL,password_hash TEXT NOT NULL,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS workflow_cases(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,reference TEXT UNIQUE NOT NULL,subject TEXT NOT NULL,owner TEXT NOT NULL,state TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,payload JSONB NOT NULL DEFAULT '{}'::jsonb,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS audit_events(
  id BIGSERIAL PRIMARY KEY,event_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),actor TEXT NOT NULL,action TEXT NOT NULL,object_type TEXT NOT NULL,object_reference TEXT NOT NULL,detail TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS saved_analyses(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,actor TEXT NOT NULL,analysis_type TEXT NOT NULL,inputs JSONB NOT NULL,result JSONB NOT NULL,provider TEXT NOT NULL,model TEXT,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS integration_state(
  id TEXT PRIMARY KEY,name TEXT NOT NULL,category TEXT NOT NULL,mode TEXT NOT NULL,status TEXT NOT NULL,last_tested TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_workflow ON workflow_cases(workflow_id);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_due ON workflow_cases(due_date);
CREATE INDEX IF NOT EXISTS idx_audit_events_time ON audit_events(event_time DESC);

CREATE TABLE IF NOT EXISTS "op_bordereaux"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_cedant" TEXT NOT NULL,
  "data_bordereauType" TEXT NOT NULL,
  "data_reportingPeriod" TEXT NOT NULL,
  "data_validationErrors" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_bordereaux_due ON "op_bordereaux"(due_date);

CREATE TABLE IF NOT EXISTS "op_treaty_terms"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_treaty" TEXT NOT NULL,
  "data_treatyType" TEXT NOT NULL,
  "data_limitAmount" NUMERIC(16,2) NOT NULL,
  "data_termNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_treaty_terms_due ON "op_treaty_terms"(due_date);

CREATE TABLE IF NOT EXISTS "op_premium"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_treaty" TEXT NOT NULL,
  "data_grossPremium" NUMERIC(16,2) NOT NULL,
  "data_cededPremium" NUMERIC(16,2) NOT NULL,
  "data_calculationNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_premium_due ON "op_premium"(due_date);

CREATE TABLE IF NOT EXISTS "op_recoverable"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_claim" TEXT NOT NULL,
  "data_grossLoss" NUMERIC(16,2) NOT NULL,
  "data_retention" NUMERIC(16,2) NOT NULL,
  "data_recoveryNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_recoverable_due ON "op_recoverable"(due_date);

CREATE TABLE IF NOT EXISTS "op_cash_call"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_cashCallId" TEXT NOT NULL,
  "data_treaty" TEXT NOT NULL,
  "data_requestedAmount" NUMERIC(16,2) NOT NULL,
  "data_supportNarrative" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_cash_call_due ON "op_cash_call"(due_date);

CREATE TABLE IF NOT EXISTS "op_collateral"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_reinsurer" TEXT NOT NULL,
  "data_recoverable" NUMERIC(16,2) NOT NULL,
  "data_collateralHeld" NUMERIC(16,2) NOT NULL,
  "data_collateralNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_collateral_due ON "op_collateral"(due_date);

CREATE TABLE IF NOT EXISTS "op_commutation"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_counterparty" TEXT NOT NULL,
  "data_carriedRecoverable" NUMERIC(16,2) NOT NULL,
  "data_offerAmount" NUMERIC(16,2) NOT NULL,
  "data_analysisNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_commutation_due ON "op_commutation"(due_date);

CREATE TABLE IF NOT EXISTS "op_schedule_f"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_reinsurer" TEXT NOT NULL,
  "data_naicCode" TEXT NOT NULL,
  "data_netRecoverable" NUMERIC(16,2) NOT NULL,
  "data_reconciliationNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_schedule_f_due ON "op_schedule_f"(due_date);

CREATE TABLE IF NOT EXISTS "op_treaty_register"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_treaty" TEXT NOT NULL,
  "data_section" TEXT NOT NULL,
  "data_limitAmount" NUMERIC(16,2) NOT NULL,
  "data_retention" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_treaty_register_due ON "op_treaty_register"(due_date);

CREATE TABLE IF NOT EXISTS "op_counterparty_master"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_counterparty" TEXT NOT NULL,
  "data_role" TEXT NOT NULL,
  "data_rating" TEXT NOT NULL,
  "data_domicile" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_counterparty_master_due ON "op_counterparty_master"(due_date);

CREATE TABLE IF NOT EXISTS "op_claim_register"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_claim" TEXT NOT NULL,
  "data_event" TEXT NOT NULL,
  "data_grossLoss" NUMERIC(16,2) NOT NULL,
  "data_eventDate" DATE NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_claim_register_due ON "op_claim_register"(due_date);

CREATE TABLE IF NOT EXISTS "op_currency_register"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_currency" TEXT NOT NULL,
  "data_settlementCurrency" TEXT NOT NULL,
  "data_exchangeRate" NUMERIC(16,2) NOT NULL,
  "data_settlementCycle" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_currency_register_due ON "op_currency_register"(due_date);
