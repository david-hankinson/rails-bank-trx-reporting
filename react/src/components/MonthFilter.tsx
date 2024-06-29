import { addMonths, format, startOfMonth } from "date-fns";
import { BaseSyntheticEvent } from "react";
import { Form } from "react-bootstrap";

type P = { month: string; setMonth: CallableFunction };

function MonthFilter({ month, setMonth }: P) {
  const startDate = new Date("2024-01-01");
  const endDate = startOfMonth(new Date());
  const numberOfMonths =
    endDate.getFullYear() * 12 +
    endDate.getMonth() -
    (startDate.getFullYear() * 12 + startDate.getMonth()) +
    1;
  const filterMonths = [];
  let loopDate = new Date(startDate.valueOf());
  for (let index = 0; index < numberOfMonths; index++) {
    filterMonths.push(loopDate);
    loopDate = addMonths(loopDate, 1);
  }

  return (
    <Form.Group className="mb-5 d-flex flex-row align-items-center">
      <Form.Label className="m-0 me-2">Display report for:</Form.Label>
      <Form.Select
        className="w-auto"
        name="filterMonth"
        onChange={(e: BaseSyntheticEvent) => setMonth(e.target.value)}
        value={month}
        required
      >
        {filterMonths.map((month: Date) => (
          <option
            key={format(month, "yyyy-MM-dd")}
            value={format(month, "yyyy-MM-dd")}
          >
            {format(month, "MMMM yyyy")}
          </option>
        ))}
      </Form.Select>
    </Form.Group>
  );
}

export default MonthFilter;
