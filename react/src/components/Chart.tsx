import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
} from "chart.js";
import { Report } from "../types/Report";
import { Bar } from "react-chartjs-2";
import { useState } from "react";
import { Colors } from "chart.js";
import BranchFilter from "./BranchFilter";

type P = {
  report: Report;
};

function Chart({ report }: P) {
  const allBranches = Object.keys(
    report.data.days[Object.keys(report.data.days)[0]]
  );
  const [branches, setBranches] = useState(allBranches.slice(0, 2));

  ChartJS.register(
    CategoryScale,
    LinearScale,
    BarElement,
    Title,
    Tooltip,
    Legend,
    Colors
  );

  const options = {
    responsive: true,
    plugins: {
      legend: {
        position: "top" as const,
      },
      title: {
        display: true,
        text: "End-of-day balance (CAD$) per branch comparison",
      },
    },
  };

  const data = {
    labels: Object.keys(report.data.days),
    datasets: branches.map((branch: string) => ({
      label: branch,
      data: Object.keys(report.data.days).map(
        (day: string) => report.data.days[day][branch].balance
      ),
    })),
  };

  return (
    <div className="mb-5">
      <BranchFilter
        allBranches={allBranches}
        branches={branches}
        setBranches={setBranches}
      />
      <Bar options={options} data={data} />
    </div>
  );
}

export default Chart;
