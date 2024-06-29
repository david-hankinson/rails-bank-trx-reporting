import { BaseSyntheticEvent } from "react";
import { Form, FormGroup } from "react-bootstrap";

type P = {
  allBranches: string[];
  branches: string[];
  setBranches: CallableFunction;
};

function BranchFilter({ allBranches, branches, setBranches }: P) {
  const toggleCheck = (branch: string) => {
    const tmpBranches = [...branches];

    if (tmpBranches.includes(branch)) {
      tmpBranches.splice(tmpBranches.indexOf(branch), 1);
    } else {
      tmpBranches.push(branch);
    }

    setBranches(tmpBranches);
  };

  return (
    <div className="d-flex align-items-center">
      <p className="m-0 me-2">Display comparison for:</p>
      {allBranches.map((branch: string) => (
        <FormGroup className="me-3" key={branch}>
          <Form.Label className="d-flex m-0">
            <Form.Check
              name="filterBranches"
              className="me-1"
              value={branch}
              checked={branches.includes(branch)}
              onChange={(e: BaseSyntheticEvent) => {
                toggleCheck(e.target.value);
              }}
            />
            {branch}
          </Form.Label>
        </FormGroup>
      ))}
    </div>
  );
}

export default BranchFilter;
