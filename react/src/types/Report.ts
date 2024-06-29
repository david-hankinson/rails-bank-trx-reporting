import { ReportAggregation } from "./ReportAggregation";
import { ReportBranchAmounts } from "./ReportBranchAmounts";

export type Report = {
  data: {
    agg: Record<string, ReportAggregation>;
    days: Record<string, Record<string, ReportBranchAmounts>>;
  };
};
