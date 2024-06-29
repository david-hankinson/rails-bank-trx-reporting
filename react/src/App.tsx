import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import ReportPage from "./components/ReportPage";

const queryClient = new QueryClient();

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <div className="container my-5">
        <header className="mb-5">
          <h1>
            Ruby on Rails & React.js 100M bank transactions import & reporting
          </h1>
        </header>

        <section className="mb-5">
          <ReportPage />
        </section>

        <footer>
          <p>
            Created by:{" "}
            <a href="https://www.linkedin.com/in/tomastibensky/">@ttibensky</a>,
            in July, 2024
          </p>
        </footer>
      </div>
    </QueryClientProvider>
  );
}

export default App;
