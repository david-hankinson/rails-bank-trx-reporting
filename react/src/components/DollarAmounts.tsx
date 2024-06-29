import { Report } from "../types/Report";

type P = {
  report: Report;
};

function DollarAmounts({ report }: P) {
  const agg = report.data.agg;
  const numberFormatter = new Intl.NumberFormat("en-CA");
  const currencyFormatter = new Intl.NumberFormat("en-CA", {
    style: "currency",
    currency: "CAD",
  });

  return (
    <table className="table table-striped table-hover">
      <thead>
        <tr>
          <th scope="col">Branch</th>
          <th scope="col"># transactions</th>
          <th scope="col">Minimum (CAD$)</th>
          <th scope="col">Maximum (CAD$)</th>
          <th scope="col">Average (CAD$)</th>
        </tr>
      </thead>
      <tbody className="table-group-divider">
        {Object.keys(agg).map((branch: string) => (
          <tr key={branch}>
            <td>{branch}</td>
            <td>{numberFormatter.format(agg[branch].transactionCount)}</td>
            <td>{currencyFormatter.format(agg[branch].min)}</td>
            <td>{currencyFormatter.format(agg[branch].max)}</td>
            <td>{currencyFormatter.format(agg[branch].avg)}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

export default DollarAmounts;
