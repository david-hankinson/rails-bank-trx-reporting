import { ReportAggregation } from "./ReportAggregation";

export type Report = {
  data: {
    agg: Record<string, ReportAggregation>;
  };
};
