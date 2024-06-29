import { useQuery } from "@tanstack/react-query";
import { format, startOfMonth } from "date-fns";
import { useState } from "react";
import DollarAmounts from "./DollarAmounts";
import MonthFilter from "./MonthFilter";
import { Report } from "../types/Report";
import Chart from "./Chart";

function ReportPage() {
  const [month, setMonth] = useState(
    format(startOfMonth(new Date()), "yyyy-MM-dd")
  );

  const { isFetching, error, data } = useQuery<Report>({
    queryKey: [`report-${month}`],
    staleTime: 10 * 60 * 1000, // 10 minutes
    queryFn: () =>
      fetch(`${import.meta.env.VITE_BACKEND_BASE_URL}/report/${month}`).then(
        (res) => res.json()
      ),
  });

  if (error) return "Something went wrong while fetching the report."; // @TODO toast

  return (
    <>
      <MonthFilter month={month} setMonth={setMonth} />
      {isFetching || !data ? (
        <>Fetching report...</>
      ) : (
        <>
          <DollarAmounts report={data} />
          <Chart report={data} />
        </>
      )}
    </>
  );
}

export default ReportPage;
