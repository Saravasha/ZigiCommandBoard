// app.jsx
import { useEffect, useState } from "react";
import { layoutHexPerfect } from "./layout/layoutHexPerfect";
import "./App.css";

export default function App() {
  const [commands, setCommands] = useState([]);
  const [visible, setVisible] = useState(false);

  const laidOut = layoutHexPerfect(commands, 6, 120);

  useEffect(() => {
    window.api.getCommands().then(setCommands);
  }, []);

  useEffect(() => {
    window.api.onDashboardVisible(setVisible);
  }, []);

  return (
    <div className="board">
      {laidOut.map((cmd) => (
        <div
          key={cmd.id}
          className="hex"
          style={{
            left: cmd.x,
            top: cmd.y,
          }}
        >
          <button key={cmd.id} onClick={() => window.api.runCommand(cmd.id)}>
            {cmd.name}
          </button>
        </div>
      ))}
    </div>
  );
}
